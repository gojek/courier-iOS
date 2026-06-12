import CocoaMQTT
import CourierCore
import Foundation
import MQTTClientGJ

/// MQTT 5 connection backed by `CocoaMQTT5`. It is a drop-in alternative to
/// `MQTTClientFrameworkConnection` (the v3 / MQTTClientGJ implementation) behind
/// the shared `IMQTTConnection` seam, selected at runtime via the `useMQTTV5` flag.
///
/// Marked `@unchecked Sendable` because the mutable shared state is guarded by
/// `@Atomic` wrappers and the serial `mqttDispatchQueue` (which is also the
/// CocoaMQTT delegate queue), so the manual conformance is safe here.
final class CocoaMQTTConnection: NSObject, IMQTTConnection, @unchecked Sendable {

    private let connectionConfig: ConnectionConfig
    private let clientFactory: ICocoaMQTTClientFactory
    private let mqttDispatchQueue = DispatchQueue(label: "com.courier.mqtt.cocoa.connection")

    @Atomic<ICocoaMQTTClient?>(nil) private var mqtt
    private var reconnectTimer: ReconnectTimer?

    /// Watchdog timer for the adaptive activity / read-timeout "fast reconnect"
    /// feature (parity with the v3 framework's `checkActivity`). Only scheduled
    /// while connected and when `idleActivityTimeoutPolicy.isEnabled` is true.
    private var activityCheckTimer: DispatchSourceTimer?
    /// Watchdog timer that forces a reconnect when CONNACK is not received within
    /// the configured connect timeout (parity with v3 `checkConnectActivity`).
    private var connectCheckTimer: DispatchSourceTimer?

    @Atomic<ConnectOptions?>(nil) var connectOptions
    @Atomic<Date>(Date()) var connectionAttemptTimestamp
    @Atomic<Date?>(nil) var lastPing
    @Atomic<Date?>(nil) var lastPong
    @Atomic<Date?>(nil) var lastInboundActivity
    @Atomic<Date?>(nil) var lastOutboundActivity
    /// Timestamp of the most recent outbound packet that expects an inbound
    /// response. Drives the inactivity-timeout branch of the activity watchdog.
    @Atomic<Date?>(nil) var fastReconnect
    @Atomic<Bool>(false) private var isClosing

    private(set) var lastError: NSError?
    private(set) var messageReceiveListener: IMessageReceiveListener?
    private(set) var keepAliveFailureHandler: KeepAliveFailureHandler?

    /// Accessed only on `mqttDispatchQueue` (subscribe/unsubscribe + their SUBACK/UNSUBACK delegate callbacks).
    private var subscribeAttempts = [String: (qos: QoS, timestamp: Date)]()
    private var unsubscribeAttempts = [String: Date]()

    private var eventHandler: ICourierEventHandler { connectionConfig.eventHandler }
    private var connectRetryTimePolicy: IConnectRetryTimePolicy { connectionConfig.connectRetryTimePolicy }
    private var connectTimeoutPolicy: IConnectTimeoutPolicy { connectionConfig.connectTimeoutPolicy }
    private var idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol { connectionConfig.idleActivityTimeoutPolicy }

    var isConnected: Bool { mqtt?.connState == .connected }
    var isConnecting: Bool { mqtt?.connState == .connecting }
    var isDisconnecting: Bool { isClosing }
    var isDisconnected: Bool {
        guard let state = mqtt?.connState else { return true }
        return state == .disconnected
    }

    var hasExistingSession: Bool { mqtt != nil }

    var serverUri: String? {
        guard let options = connectOptions else { return nil }
        return options.host + ":" + String(options.port)
    }

    init(connectionConfig: ConnectionConfig,
         clientFactory: ICocoaMQTTClientFactory = CocoaMQTTClientFactory()) {
        self.connectionConfig = connectionConfig
        self.clientFactory = clientFactory
        super.init()

        let retryInterval = TimeInterval(connectRetryTimePolicy.autoReconnectInterval)
        let maxRetryInterval = TimeInterval(connectRetryTimePolicy.maxAutoReconnectInterval)
        self.reconnectTimer = ReconnectTimer(retryInterval: retryInterval, maxRetryInterval: maxRetryInterval, queue: mqttDispatchQueue) { [weak self] in
            self?.reconnect()
        }
    }

    func connect(connectOptions: ConnectOptions, messageReceiveListener: IMessageReceiveListener) {
        if let currentOptions = self.connectOptions,
           currentOptions == connectOptions,
           isConnected || isConnecting {
            return
        }

        self.messageReceiveListener = messageReceiveListener
        self.connectOptions = connectOptions
        self.isClosing = false
        resetParams()

        if let existing = self.mqtt {
            existing.delegate = nil
            existing.disconnectFromBroker()
        }

        buildAndAssignClient(for: connectOptions)
        self.lastError = nil

        startConnecting()
    }

    /// Builds a fresh `ICocoaMQTTClient` for the given options, applies all
    /// transport/auth/property configuration, and stores it in `mqtt`. Shared by
    /// the initial connect and the watchdog-driven forced reconnect.
    private func buildAndAssignClient(for connectOptions: ConnectOptions) {
        let client = clientFactory.makeClient(
            clientId: connectOptions.clientId,
            host: connectOptions.host,
            port: connectOptions.port
        )
        client.username = connectOptions.username
        client.password = connectOptions.password
        client.keepAlive = connectOptions.keepAlive
        client.cleanSession = connectOptions.isCleanSession
        // Reconnection is driven by `reconnectTimer` (parity with the v3 session
        // manager), so CocoaMQTT's own auto-reconnect is disabled.
        client.autoReconnect = false
        client.delegateQueue = mqttDispatchQueue

        if connectOptions.shouldUseSecureTransportLayer {
            client.enableSSL = true
            client.allowUntrustCACertificate = true

            // ALPN parity with the v3 transport (`transport.alpn`). Applied via
            // the underlying socket's SSL settings so TLS negotiates the
            // requested application protocols.
            if let alpn = connectOptions.alpn, !alpn.isEmpty {
                var settings = client.sslSettings ?? [:]
                settings[cocoaMQTTSSLALPNSettingKey] = alpn as NSObject
                client.sslSettings = settings
            }
        }

        let connectProperties = MqttConnectProperties()
        if let userProperties = connectOptions.userProperties {
            connectProperties.userProperties = userProperties
        }
        client.connectProperties = connectProperties
        client.delegate = self

        self.mqtt = client
    }

    private func startConnecting() {
        guard let mqtt = self.mqtt, let connectOptions = self.connectOptions else { return }
        connectionAttemptTimestamp = Date()
        eventHandler.onEvent(.init(connectionInfo: connectOptions, event: .connectionAttempt))

        let didStart = mqtt.connectToBroker()
        if didStart {
            eventHandler.onEvent(.init(connectionInfo: connectOptions, event: .connectedPacketSent))
            recordOutboundActivity(armsFastReconnect: true)
            logToMQTTChuck(sending: true, type: .connect, mid: 0)
            scheduleConnectCheckTimer()
        } else {
            let error = CocoaMQTTConnectionError.socketConnectFailed.asNSError
            self.lastError = error
            eventHandler.onEvent(.init(connectionInfo: connectOptions, event: .connectionFailure(timeTaken: connectionAttemptTimestamp.timeTaken, error: error)))
            triggerDelayedReconnect()
        }
    }

    private func reconnect() {
        guard !isClosing, self.mqtt != nil else { return }
        printDebug("MQTT - COURIER: CocoaMQTT Reconnect")
        startConnecting()
    }

    private func triggerDelayedReconnect() {
        guard connectRetryTimePolicy.enableAutoReconnect else { return }
        // `schedule()` overwrites the pending timer; stopping first guarantees a single in-flight timer.
        reconnectTimer?.stop()
        reconnectTimer?.schedule()
    }

    func disconnect() {
        isClosing = true
        reconnectTimer?.stop()
        stopActivityCheckTimer()
        stopConnectCheckTimer()
        logToMQTTChuck(sending: true, type: .disconnect, mid: 0)
        mqtt?.disconnectFromBroker()
        resetParams()
    }

    func publish(packet: MQTTPacket) {
        eventHandler.onEvent(.init(connectionInfo: connectOptions, event: .messageSend(topic: packet.topic, qos: packet.qos, sizeBytes: packet.data.count)))
        // QoS 3/4 (oneWithoutPersistenceAndNoRetry / AndRetry) are mapped to wire
        // QoS1 (see `cocoaMQTTQoS`). CocoaMQTT keeps in-flight state in memory only
        // in this configuration, so the "without persistence" semantic holds; the
        // single-attempt "no retry" nuance of QoS3 is documented as a residual gap.
        let message = CocoaMQTT5Message(
            topic: packet.topic,
            payload: [UInt8](packet.data),
            qos: packet.qos.cocoaMQTTQoS,
            retained: false
        )
        mqtt?.publishMessage(message, properties: MqttPublishProperties())
        recordOutboundActivity(armsFastReconnect: packet.qos.armsFastReconnect)
        logToMQTTChuck(sending: true, type: .publish, qos: packet.qos, mid: 0, data: packet.data)
    }

    func deleteAllPersistedMessages() {
        // CocoaMQTT manages its own in-flight (QoS1/QoS2) message storage internally,
        // so there is no external persistence store to clear on the v5 path.
    }

    func subscribe(_ topics: [(topic: String, qos: QoS)]) {
        guard isConnected, !topics.isEmpty else { return }
        printDebug("MQTT - COURIER: Starting to request subscribe \(topics.map { "\($0.0):\($0.1)" })")
        mqttDispatchQueue.async { [weak self] in
            guard let self else { return }
            let connectOptions = self.connectOptions
            let now = Date()
            self.eventHandler.onEvent(.init(connectionInfo: connectOptions, event: .subscribeAttempt(topics: topics.map { $0.topic })))
            topics.forEach { self.subscribeAttempts[$0.topic] = (qos: $0.qos, timestamp: now) }
            let subscriptions = topics.map { MqttSubscription(topic: $0.topic, qos: $0.qos.cocoaMQTTQoS) }
            self.mqtt?.subscribeTopics(subscriptions)
            self.recordOutboundActivity(armsFastReconnect: true)
            self.logToMQTTChuck(sending: true, type: .subscribe, mid: 0)
        }
    }

    func unsubscribe(_ topics: [String]) {
        guard isConnected, !topics.isEmpty else { return }
        printDebug("MQTT - COURIER: Starting to request unsubscribe \(topics)")
        mqttDispatchQueue.async { [weak self] in
            guard let self else { return }
            let connectOptions = self.connectOptions
            let now = Date()
            self.eventHandler.onEvent(.init(connectionInfo: connectOptions, event: .unsubscribeAttempt(topics: topics)))
            topics.forEach { self.unsubscribeAttempts[$0] = now }
            self.mqtt?.unsubscribeTopics(topics)
            self.recordOutboundActivity(armsFastReconnect: true)
            self.logToMQTTChuck(sending: true, type: .unsubscribe, mid: 0)
        }
    }

    func setKeepAliveFailureHandler(handler: KeepAliveFailureHandler) {
        self.keepAliveFailureHandler = handler
    }

    func resetParams() {
        lastPing = nil
        lastPong = nil
        fastReconnect = nil
    }

    private func getLastInboundDiff() -> Int? {
        guard let lastInbound = lastInboundActivity else { return nil }
        return Int((Date().timeIntervalSince1970 - lastInbound.timeIntervalSince1970) * 1000)
    }

    private func getLastOutboundDiff() -> Int? {
        guard let lastOutbound = lastOutboundActivity else { return nil }
        return Int((Date().timeIntervalSince1970 - lastOutbound.timeIntervalSince1970) * 1000)
    }

    // MARK: - Activity tracking & fast reconnect

    /// Records an outbound packet. When the packet expects an inbound response,
    /// arms the fast-reconnect watchdog by advancing `fastReconnect` (parity with
    /// the v3 `checkAndSetFastReconnectTimestamp`).
    func recordOutboundActivity(armsFastReconnect: Bool) {
        let now = Date()
        lastOutboundActivity = now
        guard armsFastReconnect, idleActivityTimeoutPolicy.isEnabled else { return }
        let lastInbound = lastInboundActivity ?? .distantPast
        if (fastReconnect ?? .distantPast) <= lastInbound {
            fastReconnect = now
        }
    }

    // MARK: - Connect timeout watchdog

    private func scheduleConnectCheckTimer() {
        guard connectTimeoutPolicy.isEnabled else { return }
        stopConnectCheckTimer()
        let timer = DispatchSource.makeTimerSource(queue: mqttDispatchQueue)
        timer.schedule(deadline: .now() + connectTimeoutPolicy.timerInterval, repeating: connectTimeoutPolicy.timerInterval)
        timer.setEventHandler { [weak self] in self?.checkConnectActivity() }
        connectCheckTimer = timer
        timer.resume()
    }

    private func stopConnectCheckTimer() {
        connectCheckTimer?.cancel()
        connectCheckTimer = nil
    }

    func checkConnectActivity() {
        guard isConnecting else {
            stopConnectCheckTimer()
            return
        }
        if Date().timeIntervalSince(connectionAttemptTimestamp) >= connectTimeoutPolicy.timeout {
            printDebug("MQTT - COURIER: CocoaMQTT Connect Timeout")
            forceReconnect(dueTo: CocoaMQTTConnectionError.connectTimeout.asNSError)
        }
    }

    // MARK: - Activity / read timeout watchdog

    private func scheduleActivityCheckTimer() {
        guard idleActivityTimeoutPolicy.isEnabled else { return }
        stopActivityCheckTimer()
        let timer = DispatchSource.makeTimerSource(queue: mqttDispatchQueue)
        timer.schedule(deadline: .now() + idleActivityTimeoutPolicy.timerInterval, repeating: idleActivityTimeoutPolicy.timerInterval)
        timer.setEventHandler { [weak self] in self?.checkActivity() }
        activityCheckTimer = timer
        timer.resume()
    }

    private func stopActivityCheckTimer() {
        activityCheckTimer?.cancel()
        activityCheckTimer = nil
    }

    /// Forces a reconnect when the broker has gone silent. Mirrors the v3
    /// framework's `checkActivity`: if there is an outstanding outbound packet
    /// awaiting a response, fail after `inactivityTimeout`; otherwise fail after
    /// `readTimeout` of total inbound silence.
    func checkActivity() {
        guard isConnected else {
            stopActivityCheckTimer()
            return
        }
        let now = Date()
        let lastInbound = lastInboundActivity ?? .distantPast

        if let fastReconnect = fastReconnect, fastReconnect > lastInbound {
            if now.timeIntervalSince(fastReconnect) >= idleActivityTimeoutPolicy.inactivityTimeout {
                printDebug("MQTT - COURIER: CocoaMQTT Inactivity Timeout")
                forceReconnect(dueTo: CocoaMQTTConnectionError.inactivityTimeout.asNSError)
            }
        } else if now.timeIntervalSince(lastInbound) > idleActivityTimeoutPolicy.readTimeout {
            printDebug("MQTT - COURIER: CocoaMQTT Read Timeout")
            forceReconnect(dueTo: CocoaMQTTConnectionError.readTimeout.asNSError)
        }
    }

    /// Tears down the current client and immediately re-establishes the
    /// connection. Used by the connect/activity watchdogs to recover faster than
    /// waiting for keepalive. Emits `connectionLost` for parity with the v3
    /// `connectionError` -> reconnect path.
    private func forceReconnect(dueTo error: NSError) {
        guard !isClosing else { return }
        stopConnectCheckTimer()
        stopActivityCheckTimer()
        self.lastError = error
        eventHandler.onEvent(.init(connectionInfo: connectOptions, event: .connectionLost(
            timeTaken: connectionAttemptTimestamp.timeTaken,
            error: error,
            diffLastInbound: getLastInboundDiff(),
            diffLastOutbound: getLastOutboundDiff())))

        if let existing = self.mqtt {
            existing.delegate = nil
            existing.disconnectFromBroker()
        }

        guard let connectOptions = self.connectOptions else { return }
        resetParams()
        buildAndAssignClient(for: connectOptions)
        reconnectTimer?.resetRetryInterval()
        startConnecting()
    }
}

extension CocoaMQTTConnection: CocoaMQTT5Delegate {

    func mqtt5(_ mqtt5: CocoaMQTT5, didConnectAck ack: CocoaMQTTCONNACKReasonCode, connAckData: MqttDecodeConnAck?) {
        lastInboundActivity = Date()
        stopConnectCheckTimer()
        logToMQTTChuck(sending: false, type: .connack, mid: 0)
        if ack == .success {
            printDebug("MQTT - COURIER: CocoaMQTT Connected")
            eventHandler.onEvent(.init(connectionInfo: connectOptions, event: .connectionSuccess(timeTaken: connectionAttemptTimestamp.timeTaken)))
            reconnectTimer?.resetRetryInterval()
            scheduleActivityCheckTimer()
        } else {
            let error = CocoaMQTTConnectionError.connectionRefused(ack).asNSError
            self.lastError = error
            printDebug("MQTT - COURIER: CocoaMQTT Connection refused \(ack.rawValue)")
            eventHandler.onEvent(.init(connectionInfo: connectOptions, event: .connectionFailure(timeTaken: connectionAttemptTimestamp.timeTaken, error: error)))
            triggerDelayedReconnect()
            if ack.isAuthenticationFailure {
                printDebug("MQTT - COURIER: CocoaMQTT Auth Failure \(ack.rawValue)")
                connectionConfig.authFailureHandler.handleAuthFailure()
            }
        }
    }

    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishMessage message: CocoaMQTT5Message, id: UInt16) {
        lastOutboundActivity = Date()
        let data = Data(message.payload)
        #if DEBUG
        printDebug("MQTT - COURIER: Message Delivered topic: \(message.topic), qos: \(message.qos), payload: \(message.string ?? "")")
        #endif
        eventHandler.onEvent(.init(connectionInfo: connectOptions, event: .messageSendSuccess(topic: message.topic, qos: message.qos.courierQoS, sizeBytes: data.count, data: data)))
    }

    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishAck id: UInt16, pubAckData: MqttDecodePubAck?) {
        lastInboundActivity = Date()
        logToMQTTChuck(sending: false, type: .puback, mid: id)
    }

    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishRec id: UInt16, pubRecData: MqttDecodePubRec?) {
        lastInboundActivity = Date()
    }

    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveMessage message: CocoaMQTT5Message, id: UInt16, publishData: MqttDecodePublish?) {
        lastInboundActivity = Date()
        let data = Data(message.payload)
        #if DEBUG
        if let string = message.string {
            printDebug("MQTT - COURIER: Receive message from topic: \(message.topic) with payload: \(string)")
        }
        #endif
        eventHandler.onEvent(.init(connectionInfo: connectOptions, event: .messageReceive(topic: message.topic, sizeBytes: data.count)))
        logToMQTTChuck(sending: false, type: .publish, qos: message.qos.courierQoS, mid: id, data: data)
        messageReceiveListener?.messageArrived(
            data: data,
            topic: message.topic,
            qos: message.qos.courierQoS
        )
    }

    func mqtt5(_ mqtt5: CocoaMQTT5, didSubscribeTopics success: NSDictionary, failed: [String], subAckData: MqttDecodeSubAck?) {
        lastInboundActivity = Date()
        logToMQTTChuck(sending: false, type: .suback, mid: 0)
        let connectOptions = self.connectOptions
        let successTopics = (success.allKeys as? [String]) ?? []
        for topic in successTopics {
            guard let info = subscribeAttempts.removeValue(forKey: topic) else { continue }
            printDebug("MQTT - COURIER: Subscribed to \(topic)")
            eventHandler.onEvent(.init(connectionInfo: connectOptions, event: .subscribeSuccess(topics: [(topic, info.qos)], timeTaken: info.timestamp.timeTaken)))
        }
        for topic in failed {
            let info = subscribeAttempts.removeValue(forKey: topic)
            printDebug("MQTT - COURIER: Subscribe failed topic: \(topic)")
            eventHandler.onEvent(.init(connectionInfo: connectOptions, event: .subscribeFailure(topics: [(topic, info?.qos ?? .zero)], timeTaken: info?.timestamp.timeTaken ?? 0, error: CourierError.subackFail128)))
        }
    }

    func mqtt5(_ mqtt5: CocoaMQTT5, didUnsubscribeTopics topics: [String], unsubAckData: MqttDecodeUnsubAck?) {
        lastInboundActivity = Date()
        logToMQTTChuck(sending: false, type: .unsuback, mid: 0)
        let connectOptions = self.connectOptions
        var timeTaken = 0
        for topic in topics {
            if let date = unsubscribeAttempts.removeValue(forKey: topic) {
                timeTaken = date.timeTaken
            }
        }
        printDebug("MQTT - COURIER: Unsubscribed from \(topics)")
        eventHandler.onEvent(.init(connectionInfo: connectOptions, event: .unsubscribeSuccess(topics: topics, timeTaken: timeTaken)))
    }

    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveDisconnectReasonCode reasonCode: CocoaMQTTDISCONNECTReasonCode) {
        printDebug("MQTT - COURIER: CocoaMQTT received DISCONNECT reason code \(reasonCode.rawValue)")
    }

    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveAuthReasonCode reasonCode: CocoaMQTTAUTHReasonCode) {
        printDebug("MQTT - COURIER: CocoaMQTT received AUTH reason code \(reasonCode.rawValue)")
    }

    func mqtt5DidPing(_ mqtt5: CocoaMQTT5) {
        printDebug("MQTT - COURIER: Ping at \(Date())")
        recordOutboundActivity(armsFastReconnect: true)
        logToMQTTChuck(sending: true, type: .pingreq, mid: 0)
        eventHandler.onEvent(.init(connectionInfo: connectOptions, event: .ping(url: serverUri ?? "")))
        if let lastPing = lastPing {
            if (lastPong != nil && lastPing > lastPong!) || lastPong == nil {
                printDebug("MQTT - COURIER: Ping Failure at \(Date()), didn't receive pong since \(lastPing)")
                eventHandler.onEvent(.init(connectionInfo: connectOptions, event: .pingFailure(timeTaken: Int(Date().timeIntervalSince1970 - lastPing.timeIntervalSince1970) * 1000, error: nil)))
                keepAliveFailureHandler?.handleKeepAliveFailure()
                return
            }
        }
        lastPing = Date()
    }

    func mqtt5DidReceivePong(_ mqtt5: CocoaMQTT5) {
        lastPong = Date()
        lastInboundActivity = Date()
        logToMQTTChuck(sending: false, type: .pingresp, mid: 0)
        if let lastPing = self.lastPing {
            printDebug("MQTT - COURIER: Pong received at \(Date()), last ping: \(lastPing)")
            eventHandler.onEvent(.init(connectionInfo: connectOptions, event: .pongReceived(timeTaken: lastPing.timeTaken)))
        }
        lastPing = nil
    }

    func mqtt5DidDisconnect(_ mqtt5: CocoaMQTT5, withError err: Error?) {
        printDebug("MQTT - COURIER: CocoaMQTT Disconnected \(err?.localizedDescription ?? "")")
        stopConnectCheckTimer()
        stopActivityCheckTimer()
        if let err = err {
            self.lastError = err as NSError
        }
        eventHandler.onEvent(.init(connectionInfo: connectOptions, event: .connectionLost(
            timeTaken: connectionAttemptTimestamp.timeTaken,
            error: self.lastError,
            diffLastInbound: getLastInboundDiff(),
            diffLastOutbound: getLastOutboundDiff())))

        if isClosing {
            reconnectTimer?.stop()
        } else {
            triggerDelayedReconnect()
        }
    }

    func mqtt5(_ mqtt5: CocoaMQTT5, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        // Parity with the v3 transport which sets `allowInvalidCertificates = true`
        // when a secure transport is requested.
        completionHandler(true)
    }
}
