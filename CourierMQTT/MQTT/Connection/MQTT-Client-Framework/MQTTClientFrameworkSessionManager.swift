import CourierCore
import Foundation
import MQTTClientGJ

protocol MQTTClientFrameworkSessionManagerDelegate: AnyObject {
    func sessionManager(_ sessionManager: IMQTTClientFrameworkSessionManager, didChangeState newState: MQTTSessionManagerState)
    func sessionManager(_ sessionManager: IMQTTClientFrameworkSessionManager, didDeliverMessageID msgID: UInt16, topic: String, data: Data, qos: MQTTQosLevel, retainFlag: Bool)
    func sessionManager(_ sessionManager: IMQTTClientFrameworkSessionManager, didReceiveMessageData data: Data, onTopic topic: String, qos: MQTTQosLevel, retained: Bool, mid: UInt32)
    func sessionManager(_ sessionManager: IMQTTClientFrameworkSessionManager, didSubscribeTopics topics: [String])
    func sessionManager(_ sessionManager: IMQTTClientFrameworkSessionManager, didFailToSubscribeTopics topics: [String], error: Error)
    func sessionManager(_ sessionManager: IMQTTClientFrameworkSessionManager, didUnsubscribeTopics topics: [String])
    func sessionManager(_ sessionManager: IMQTTClientFrameworkSessionManager, didFailToUnsubscribeTopics topics: [String], error: Error)
    func sessionManagerDidPing(_ sessionManager: IMQTTClientFrameworkSessionManager)
    func sessionManagerDidReceivePong(_ sessionManager: IMQTTClientFrameworkSessionManager)
    func sessionManagerDidSendConnectPacket(_ sessionManager: IMQTTClientFrameworkSessionManager)
}

protocol IMQTTClientFrameworkSessionManager {
    var session: IMQTTSession? { get }
    var lastError: NSError? { get }
    var state: MQTTSessionManagerState? { get }

    func connect(
        to host: String,
        port: Int,
        keepAlive: Int,
        isCleanSession: Bool,
        isAuth: Bool,
        clientId: String,
        username: String,
        password: String,
        lastWill: Bool,
        lastWillTopic: String?,
        lastWillMessage: Data?,
        lastWillQoS: MQTTQosLevel?,
        lastWillRetainFlag: Bool,
        securityPolicy: MQTTSSLSecurityPolicy?,
        certificates: [Any]?,
        protocolLevel: MQTTProtocolVersion,
        userProperties: [String: String]?,
        connectHandler: MQTTConnectHandler?)

    func disconnect(with disconnectHandler: MQTTDisconnectHandler?)
    func publish(packet: MQTTPacket)

    func subscribe(_ topics: [(topic: String, qos: QoS)])
    func unsubscribe(_ topics: [String])
}

class MQTTClientFrameworkSessionManager: NSObject, IMQTTClientFrameworkSessionManager {
    private(set) var session: IMQTTSession?
    private(set) var host: String?
    private(set) var port: UInt32?
    weak var delegate: MQTTClientFrameworkSessionManagerDelegate?
    private let mqttSessionFactory: IMQTTSessionFactory
    private let mqttPersistenceFactory: IMQTTPersistenceFactory

    private let _state = Atomic<MQTTSessionManagerState?>(nil)
    private(set) var state: MQTTSessionManagerState? {
        get { _state.value }
        set {
            _state.mutate { $0 = newValue }
        }
    }
    private(set) var lastError: NSError?

    private var reconnectTimer: ReconnectTimer?
    private var reconnectFlag = false
    private var tls = false
    private var keepAlive: Int?
    private var cleanSession = false
    private var auth = false
    private var will = false
    private var willTopic: String?
    private var willMessage: Data?
    private var willQoS: Int?
    private var willRetainFlag = false
    private var username: String?
    private var password: String?
    private var clientId: String?
    private var queue: DispatchQueue
    private var securityPolicy: MQTTSSLSecurityPolicy?
    private var certificates: [Any]?
    private var protocolLevel: MQTTProtocolVersion?

    private var persistent = false
    private var maxWindowSize: Int
    private var maxSize: Int
    private var maxMessages: Int
    private var streamSSLLevel: String

    private var connectTimeoutPolicy: IConnectTimeoutPolicy
    private var idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol

    var requiresTeardown: Bool {
        state != .closed && state != .starting
    }

    init(persistence: Bool = false,
         maxWindowSize: Int = 16,
         maxMessages: Int = 5000,
         maxSize: Int = 128 * 1024 * 1024,
         retryInterval: TimeInterval = 10.0,
         maxRetryInterval: TimeInterval = 12.0,
         streamSSLLevel: String = kCFStreamSocketSecurityLevelNegotiatedSSL as String,
         queue: DispatchQueue = .main,
         mqttSessionFactory: IMQTTSessionFactory = MQTTSessionFactory(),
         mqttPersistenceFactory: IMQTTPersistenceFactory = MQTTPersistenceFactory(),
         connectTimeoutPolicy: IConnectTimeoutPolicy,
         idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol
    ) {
        self.streamSSLLevel = streamSSLLevel
        self.queue = queue
        self.persistent = persistence
        self.maxWindowSize = maxWindowSize
        self.maxSize = maxSize
        self.maxMessages = maxMessages
        self.mqttSessionFactory = mqttSessionFactory
        self.mqttPersistenceFactory = mqttPersistenceFactory
        self.connectTimeoutPolicy = connectTimeoutPolicy
        self.idleActivityTimeoutPolicy = idleActivityTimeoutPolicy

        super.init()

        self.updateState(to: .starting)
        self.reconnectTimer = ReconnectTimer(retryInterval: retryInterval, maxRetryInterval: maxRetryInterval, queue: queue, reconnect: { [weak self] in
            self?.reconnect()
        })
    }

    func connect(
        to host: String,
        port: Int,
        keepAlive: Int,
        isCleanSession: Bool,
        isAuth: Bool = true,
        clientId: String,
        username: String,
        password: String,
        lastWill: Bool = false,
        lastWillTopic: String? = nil,
        lastWillMessage: Data? = nil,
        lastWillQoS: MQTTQosLevel? = nil,
        lastWillRetainFlag: Bool = false,
        securityPolicy: MQTTSSLSecurityPolicy? = nil,
        certificates: [Any]? = nil,
        protocolLevel: MQTTProtocolVersion = .version311,
        userProperties: [String: String]? = nil,
        connectHandler: MQTTConnectHandler? = nil) {
        printDebug("MQTT - COURIER: Client Session Manager connect to: \(host)")
        let shouldReconnect = self.session != nil
        let isTls = port == 443

        if (self.session == nil || host != self.host) ||
            port != self.port ?? 0 ||
            isTls != self.tls ||
            keepAlive != self.keepAlive ||
            isCleanSession != self.cleanSession ||
            isAuth != self.auth ||
            username != self.username ||
            password != self.password ||
            lastWillTopic != self.willTopic ||
            lastWillMessage != self.willMessage ||
            Int(lastWillQoS?.rawValue ?? 0) != self.willQoS ||
            lastWillRetainFlag != self.willRetainFlag ||
            clientId != self.clientId ||
            securityPolicy != self.securityPolicy {
            self.host = host
            self.port = UInt32(port)
            self.tls = isTls
            self.keepAlive = keepAlive
            self.cleanSession = isCleanSession
            self.auth = isAuth
            self.clientId = clientId
            self.username = isAuth ? username : nil
            self.password = isAuth ? password : nil
            self.will = lastWill
            self.willTopic = lastWillTopic
            self.willMessage = lastWillMessage
            self.willRetainFlag = lastWillRetainFlag
            self.willQoS = Int(lastWillQoS?.rawValue ?? MQTTQosLevel.atMostOnce.rawValue)
            self.securityPolicy = securityPolicy
            self.certificates = certificates
            self.protocolLevel = protocolLevel

            self.session = mqttSessionFactory.makeSession()
            session?.clientId = clientId
            session?.userName = username
            session?.password = password
            session?.keepAliveInterval = UInt16(keepAlive)
            session?.cleanSessionFlag = isCleanSession
            session?.willFlag = lastWill
            session?.willTopic = lastWillTopic
            session?.willMsg = lastWillMessage
            session?.willQoS = lastWillQoS ?? .atMostOnce
            session?.willRetainFlag = lastWillRetainFlag
            session?.protocolLevel = protocolLevel
            session?.queue = queue
            session?.certificates = certificates
            session?.streamSSLLevel = self.streamSSLLevel

            session?.shouldEnableConnectCheckTimeout = self.connectTimeoutPolicy.isEnabled
            session?.connectTimeoutCheckTimerInterval = self.connectTimeoutPolicy.timerInterval
            session?.connectTimeout = self.connectTimeoutPolicy.timeout

            session?.shouldEnableActivityCheckTimeout = self.idleActivityTimeoutPolicy.isEnabled
            session?.activityCheckTimerInterval = self.idleActivityTimeoutPolicy.timerInterval
            session?.inactivityTimeout = self.idleActivityTimeoutPolicy.inactivityTimeout
            session?.readTimeout = self.idleActivityTimeoutPolicy.readTimeout

            let persistence = mqttPersistenceFactory.makePersistence()
            persistence.persistent = self.persistent
            persistence.maxWindowSize = UInt(self.maxWindowSize)
            persistence.maxSize = UInt(self.maxSize)
            persistence.maxMessages = UInt(self.maxMessages)
            session?.persistence = persistence

            session?.delegate = self
            session?.userProperty = userProperties
            self.reconnectFlag = false
        }

        if shouldReconnect {
            printDebug("MQTT - COURIER: MQTTSessionManager reconnecting")
            self.disconnect()
            self.reconnect(connectHandler: connectHandler)
        } else {
            printDebug("MQTT - COURIER: MQTTSessionManager connecting")
            self.connectToInternal(connectHandler: connectHandler)
        }
    }

    @discardableResult
    private func sendData(_ data: Data, topic: String, qos: MQTTQosLevel, retainFlag: Bool) -> UInt16 {
        let msgId = session?.publishData(data, onTopic: topic, retain: retainFlag, qos: qos, publishHandler: nil) ?? 0
        return msgId
    }

    func disconnect(with disconnectHandler: MQTTDisconnectHandler? = nil) {
        printDebug("MQTT - COURIER: MQTTSessionManager Disconnect")
        self.updateState(to: .closing)
        self.session?.close(disconnectHandler: disconnectHandler)
        self.reconnectTimer?.stop()
    }

    private func updateState(to newState: MQTTSessionManagerState) {
        self.state = newState
        self.delegate?.sessionManager(self, didChangeState: newState)
    }

    private func reconnect(connectHandler: MQTTConnectHandler? = nil) {
        printDebug("MQTT - COURIER: MQTTSessionManager Reconnect")
        self.updateState(to: .starting)
        self.connectToInternal(connectHandler: connectHandler)
    }

    func connectToInternal(connectHandler: MQTTConnectHandler? = nil) {
        guard
            let session = self.session,
            let port = self.port,
            let host = self.host,
            self.state == .starting else
        { return }
        printDebug("MQTT - COURIER: MQTTSessionManager Connect to internal")

        self.updateState(to: .connecting)
        let transport: MQTTCFSocketTransport
        if let securityPolicy = self.securityPolicy {
            let securityTransport = MQTTSSLSecurityPolicyTransport()
            securityTransport.securityPolicy = securityPolicy
            transport = securityTransport
        } else {
            transport = MQTTCFSocketTransport()
        }
        transport.host = host
        transport.port = port
        transport.tls = self.tls
        transport.certificates = self.certificates
        transport.voip = session.voip
        transport.queue = self.queue
        transport.streamSSLLevel = self.streamSSLLevel
        self.session?.transport = transport
        self.lastError = nil
        self.session?.connect(connectHandler: connectHandler)
    }

    func connectToLast(with connectHandler: MQTTConnectHandler? = nil) {
        if self.state == .connected {
            return
        }
        printDebug("MQTT - COURIER: MQTTSessionManager Connect to last")
        self.reconnectTimer?.resetRetryInterval()
        self.reconnect(connectHandler: connectHandler)
    }

    private func triggerDelayedReconnect() {
        self.reconnectTimer?.schedule()
    }

    func subscribe(_ topics: [(topic: String, qos: QoS)]) {
        var topicsDict = [String: NSNumber]()
        topics.forEach { topicQoS in
            topicsDict[topicQoS.topic] = NSNumber(value: topicQoS.qos.rawValue)
        }

        session?.subscribe(toTopics: topicsDict, subscribeHandler: { [weak self] (error, _) in
            guard let self = self else { return }
            let topicsArray = topics.map { $0.topic }
            if let error = error {
                self.delegate?.sessionManager(self, didFailToSubscribeTopics: topicsArray, error: error)
            } else {
                self.delegate?.sessionManager(self, didSubscribeTopics: topicsArray)
            }
        })
    }

    func unsubscribe(_ topics: [String]) {
        session?.unsubscribeTopics(topics, unsubscribeHandler: { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.sessionManager(self, didFailToUnsubscribeTopics: topics, error: error)
            } else {
                self.delegate?.sessionManager(self, didUnsubscribeTopics: topics)
            }
        })
    }

    func publish(packet: MQTTPacket) {
        sendData(packet.data, topic: packet.topic, qos: MQTTQosLevel(qos: packet.qos), retainFlag: false)
    }
}

extension MQTTClientFrameworkSessionManager: MQTTSessionDelegate {

    func handleEvent(_ session: MQTTSession!, event eventCode: MQTTSessionEvent, error: Error!) {
        printDebug("MQTT - COURIER: MQTTSessionManager handle eventcode: \(eventCode.debugDescription)\(error != nil ? " error: \(error!.localizedDescription)" : "")")

        switch eventCode {
        case .connected:
            self.updateState(to: .connected)
            self.reconnectTimer?.resetRetryInterval()

        case .connectionClosed:
            self.updateState(to: .closed)

        case .connectionClosedByBroker:
            if self.state != .closing {
                self.triggerDelayedReconnect()
            }
            self.updateState(to: .closed)

        case .protocolError,
             .connectionRefused,
             .connectionError:
            self.triggerDelayedReconnect()
            self.lastError = error as NSError?
            self.updateState(to: .error)

        default:
            break
        }
    }

    func connected(_ session: MQTTSession!, sessionPresent: Bool) {
        self.reconnectFlag = true
    }

    func newMessage(_ session: MQTTSession!, data: Data!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
        delegate?.sessionManager(self, didReceiveMessageData: data, onTopic: topic, qos: qos, retained: retained, mid: mid)
    }

    func messageDelivered(_ session: MQTTSession!, msgID: UInt16, topic: String!, data: Data!, qos: MQTTQosLevel, retainFlag: Bool) {
        delegate?.sessionManager(self, didDeliverMessageID: msgID, topic: topic, data: data, qos: qos, retainFlag: retainFlag)
    }

    func sending(_ session: MQTTSession!, type: MQTTCommandType, qos: MQTTQosLevel, retained: Bool, duped: Bool, mid: UInt16, data: Data!) {
        printDebug("MQTT - COURIER: Sending MQTT Command \(type.debugDescription)")
        switch type {
        case .connect:
            delegate?.sessionManagerDidSendConnectPacket(self)
        case .pingreq:
            delegate?.sessionManagerDidPing(self)
        default:
            break
        }
    }

    func received(_ session: MQTTSession!, type: MQTTCommandType, qos: MQTTQosLevel, retained: Bool, duped: Bool, mid: UInt16, data: Data!) {
        printDebug("MQTT - COURIER: Received MQTT Command \(type.debugDescription)")
        switch type {
        case .pingresp:
            delegate?.sessionManagerDidReceivePong(self)
        default:
            break
        }
    }
}
