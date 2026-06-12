import CocoaMQTT
import Foundation
import XCTest
@testable import CourierCore
@testable import CourierMQTT

class CocoaMQTTConnectionTests: XCTestCase {

    var sut: CocoaMQTTConnection!
    var mockConnectRetryTimePolicy: MockConnectRetryTimePolicy!
    var mockEventHandler: MockCourierEventHandler!
    var mockAuthFailureHandler: MockAuthFailureHandler!
    var mockConnectTimeoutPolicy: MockConnectTimeoutPolicy!
    var mockMessageReceiveListener: MockMessageReceiveListener!
    var mockKeepAliveFailureHandler: MockKeepAliveFailureHandler!
    var mockClient: MockCocoaMQTTClient!
    var mockClientFactory: MockCocoaMQTTClientFactory!

    /// A real instance used only to satisfy the `CocoaMQTT5` argument of delegate
    /// callbacks. It never connects; the connection uses its own stored client.
    var dummyMQTT5: CocoaMQTT5!

    override func setUp() {
        super.setUp()
        mockConnectRetryTimePolicy = MockConnectRetryTimePolicy()
        mockEventHandler = MockCourierEventHandler()
        mockAuthFailureHandler = MockAuthFailureHandler()
        mockConnectTimeoutPolicy = MockConnectTimeoutPolicy()
        mockMessageReceiveListener = MockMessageReceiveListener()
        mockKeepAliveFailureHandler = MockKeepAliveFailureHandler()
        mockClient = MockCocoaMQTTClient()
        mockClientFactory = MockCocoaMQTTClientFactory(stubbedClient: mockClient)
        dummyMQTT5 = CocoaMQTT5(clientID: "dummy", host: "localhost", port: 1883)

        sut = CocoaMQTTConnection(
            connectionConfig: ConnectionConfig(
                connectRetryTimePolicy: mockConnectRetryTimePolicy,
                eventHandler: mockEventHandler,
                authFailureHandler: mockAuthFailureHandler,
                connectTimeoutPolicy: mockConnectTimeoutPolicy,
                idleActivityTimeoutPolicy: IdleActivityTimeoutPolicy(),
                isDatabasePersistent: false,
                inMemoryPersistent: false,
                fixCxxDestructCrash: false
            ),
            clientFactory: mockClientFactory
        )
    }

    override func tearDown() {
        sut = nil
        dummyMQTT5 = nil
        super.tearDown()
    }

    // MARK: - Connect

    func testConnectConfiguresClient() {
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)

        XCTAssertTrue(mockClientFactory.invokedMakeClient)
        XCTAssertEqual(mockClientFactory.invokedMakeClientParameters?.clientId, stubConnectOptions.clientId)
        XCTAssertEqual(mockClientFactory.invokedMakeClientParameters?.host, stubConnectOptions.host)
        XCTAssertEqual(mockClientFactory.invokedMakeClientParameters?.port, stubConnectOptions.port)

        XCTAssertEqual(mockClient.username, stubConnectOptions.username)
        XCTAssertEqual(mockClient.password, stubConnectOptions.password)
        XCTAssertEqual(mockClient.keepAlive, stubConnectOptions.keepAlive)
        XCTAssertEqual(mockClient.cleanSession, stubConnectOptions.isCleanSession)
        XCTAssertFalse(mockClient.autoReconnect)
        XCTAssertTrue(mockClient.delegate === sut)
        XCTAssertTrue(mockClient.invokedConnect)

        XCTAssertNotNil(sut.connectOptions)
        XCTAssertNotNil(sut.messageReceiveListener)
    }

    func testConnectWithSecureTransportEnablesSSL() {
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)

        XCTAssertTrue(mockClient.enableSSL)
        XCTAssertTrue(mockClient.allowUntrustCACertificate)
    }

    func testConnectMapsUserProperties() {
        let options = ConnectOptions(
            host: "broker.com", port: 443, keepAlive: 60, clientId: "id",
            username: "u", password: "p", isCleanSession: true,
            userProperties: ["k": "v"], alpn: nil, scheme: "tls"
        )
        sut.connect(connectOptions: options, messageReceiveListener: mockMessageReceiveListener)

        XCTAssertEqual(mockClient.connectProperties?.userProperties?["k"], "v")
    }

    // MARK: - ALPN

    func testConnectWithALPNSetsSSLSettings() {
        let options = ConnectOptions(
            host: "broker.com", port: 443, keepAlive: 60, clientId: "id",
            username: "u", password: "p", isCleanSession: true,
            userProperties: nil, alpn: ["mqtt"], scheme: "tls"
        )
        sut.connect(connectOptions: options, messageReceiveListener: mockMessageReceiveListener)

        let alpn = mockClient.sslSettings?["MGCDAsyncSocketSSLALPN"] as? [String]
        XCTAssertEqual(alpn, ["mqtt"])
    }

    func testConnectWithoutALPNDoesNotSetSSLSettings() {
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)
        XCTAssertNil(mockClient.sslSettings?["MGCDAsyncSocketSSLALPN"])
    }

    // MARK: - Custom QoS 3/4

    func testPublishQoS3MapsToWireQoS1() {
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)
        sut.publish(packet: MQTTPacket(data: Data("x".utf8), topic: "t", qos: .oneWithoutPersistenceAndNoRetry))
        XCTAssertEqual(mockClient.invokedPublishParameters?.message.qos, .qos1)
    }

    func testPublishQoS4MapsToWireQoS1() {
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)
        sut.publish(packet: MQTTPacket(data: Data("x".utf8), topic: "t", qos: .oneWithoutPersistenceAndRetry))
        XCTAssertEqual(mockClient.invokedPublishParameters?.message.qos, .qos1)
    }

    // MARK: - Connect timeout watchdog

    func testConnectTimeoutForcesReconnect() {
        mockConnectTimeoutPolicy.stubbedIsEnabled = true
        mockConnectTimeoutPolicy.stubbedTimerInterval = 100
        mockConnectTimeoutPolicy.stubbedTimeout = 0

        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)
        mockClient.connState = .connecting

        let makeCountBefore = mockClientFactory.invokedMakeClientCount
        sut.checkConnectActivity()

        XCTAssertGreaterThan(mockClientFactory.invokedMakeClientCount, makeCountBefore)
        let events = mockEventHandler.invokedOnEventParametersList.compactMap { $0?.event.type }
        XCTAssertTrue(events.contains { if case .connectionLost = $0 { return true } else { return false } })
    }

    func testConnectTimeoutIgnoredWhenNotConnecting() {
        mockConnectTimeoutPolicy.stubbedIsEnabled = true
        mockConnectTimeoutPolicy.stubbedTimerInterval = 100
        mockConnectTimeoutPolicy.stubbedTimeout = 0

        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)
        mockClient.connState = .connected

        let makeCountBefore = mockClientFactory.invokedMakeClientCount
        sut.checkConnectActivity()

        XCTAssertEqual(mockClientFactory.invokedMakeClientCount, makeCountBefore)
    }

    // MARK: - Activity / read timeout watchdog

    func testReadTimeoutForcesReconnect() {
        sut = makeSUT(idlePolicy: IdleActivityTimeoutPolicy(isEnabled: true, timerInterval: 100, inactivityTimeout: 100, readTimeout: 0))
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)
        mockClient.connState = .connected
        // No outbound packet awaiting a response: total inbound silence path.
        sut.fastReconnect = nil
        sut.lastInboundActivity = Date(timeIntervalSince1970: 0)

        let makeCountBefore = mockClientFactory.invokedMakeClientCount
        sut.checkActivity()

        XCTAssertGreaterThan(mockClientFactory.invokedMakeClientCount, makeCountBefore)
        let events = mockEventHandler.invokedOnEventParametersList.compactMap { $0?.event.type }
        XCTAssertTrue(events.contains { if case .connectionLost = $0 { return true } else { return false } })
    }

    func testInactivityTimeoutForcesReconnectAfterOutboundSend() {
        sut = makeSUT(idlePolicy: IdleActivityTimeoutPolicy(isEnabled: true, timerInterval: 100, inactivityTimeout: 0, readTimeout: 100))
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)
        mockClient.connState = .connected
        sut.lastInboundActivity = Date()
        // Outbound packet expecting a response arms the fast-reconnect watchdog.
        sut.recordOutboundActivity(armsFastReconnect: true)

        let makeCountBefore = mockClientFactory.invokedMakeClientCount
        sut.checkActivity()

        XCTAssertGreaterThan(mockClientFactory.invokedMakeClientCount, makeCountBefore)
    }

    func testActivityCheckIgnoredWhenNotConnected() {
        sut = makeSUT(idlePolicy: IdleActivityTimeoutPolicy(isEnabled: true, timerInterval: 100, inactivityTimeout: 0, readTimeout: 0))
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)
        mockClient.connState = .disconnected

        let makeCountBefore = mockClientFactory.invokedMakeClientCount
        sut.checkActivity()

        XCTAssertEqual(mockClientFactory.invokedMakeClientCount, makeCountBefore)
    }

    private func makeSUT(idlePolicy: IdleActivityTimeoutPolicyProtocol) -> CocoaMQTTConnection {
        CocoaMQTTConnection(
            connectionConfig: ConnectionConfig(
                connectRetryTimePolicy: mockConnectRetryTimePolicy,
                eventHandler: mockEventHandler,
                authFailureHandler: mockAuthFailureHandler,
                connectTimeoutPolicy: mockConnectTimeoutPolicy,
                idleActivityTimeoutPolicy: idlePolicy,
                isDatabasePersistent: false,
                inMemoryPersistent: false,
                fixCxxDestructCrash: false
            ),
            clientFactory: mockClientFactory
        )
    }

    func testConnectEmitsConnectionAttemptAndConnectedPacketSent() {
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)

        let events = mockEventHandler.invokedOnEventParametersList.compactMap { $0?.event.type }
        XCTAssertTrue(events.contains { if case .connectionAttempt = $0 { return true } else { return false } })
        XCTAssertTrue(events.contains { if case .connectedPacketSent = $0 { return true } else { return false } })
    }

    func testConnectFailureToStartEmitsConnectionFailure() {
        mockClient.stubbedConnectResult = false
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)

        let events = mockEventHandler.invokedOnEventParametersList.compactMap { $0?.event.type }
        XCTAssertTrue(events.contains { if case .connectionFailure = $0 { return true } else { return false } })
    }

    // MARK: - State

    func testStateReflectsClientConnState() {
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)

        mockClient.connState = .connected
        XCTAssertTrue(sut.isConnected)
        XCTAssertFalse(sut.isConnecting)
        XCTAssertFalse(sut.isDisconnected)

        mockClient.connState = .connecting
        XCTAssertTrue(sut.isConnecting)

        mockClient.connState = .disconnected
        XCTAssertTrue(sut.isDisconnected)
    }

    // MARK: - Publish

    func testPublishSendsMessageAndEmitsEvent() {
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)

        let payload = "hello".data(using: .utf8)!
        sut.publish(packet: MQTTPacket(data: payload, topic: "topic/a", qos: .one))

        XCTAssertTrue(mockClient.invokedPublish)
        XCTAssertEqual(mockClient.invokedPublishParameters?.message.topic, "topic/a")
        XCTAssertEqual(mockClient.invokedPublishParameters?.message.qos, .qos1)
        XCTAssertEqual(Data(mockClient.invokedPublishParameters?.message.payload ?? []), payload)

        let events = mockEventHandler.invokedOnEventParametersList.compactMap { $0?.event.type }
        XCTAssertTrue(events.contains { if case .messageSend = $0 { return true } else { return false } })
    }

    // MARK: - Disconnect

    func testDisconnectClosesClient() {
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)
        sut.disconnect()
        XCTAssertTrue(mockClient.invokedDisconnect)
        XCTAssertTrue(sut.isDisconnecting)
    }

    // MARK: - Delegate: Connect Ack

    func testDidConnectAckSuccessEmitsConnectionSuccess() {
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)
        sut.mqtt5(dummyMQTT5, didConnectAck: .success, connAckData: nil)

        let events = mockEventHandler.invokedOnEventParametersList.compactMap { $0?.event.type }
        XCTAssertTrue(events.contains { if case .connectionSuccess = $0 { return true } else { return false } })
    }

    func testDidConnectAckNotAuthorizedTriggersAuthFailure() {
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)
        sut.mqtt5(dummyMQTT5, didConnectAck: .notAuthorized, connAckData: nil)

        XCTAssertTrue(mockAuthFailureHandler.invokedHandleAuthFailure)
        let events = mockEventHandler.invokedOnEventParametersList.compactMap { $0?.event.type }
        XCTAssertTrue(events.contains { if case .connectionFailure = $0 { return true } else { return false } })
    }

    func testDidConnectAckBadCredentialsTriggersAuthFailure() {
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)
        sut.mqtt5(dummyMQTT5, didConnectAck: .badUsernameOrPassword, connAckData: nil)

        XCTAssertTrue(mockAuthFailureHandler.invokedHandleAuthFailure)
    }

    func testDidConnectAckServerBusyDoesNotTriggerAuthFailure() {
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)
        sut.mqtt5(dummyMQTT5, didConnectAck: .serverBusy, connAckData: nil)

        XCTAssertFalse(mockAuthFailureHandler.invokedHandleAuthFailure)
    }

    // MARK: - Delegate: Messages

    func testDidReceiveMessageForwardsToListener() {
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)

        let payload = "incoming".data(using: .utf8)!
        let message = CocoaMQTT5Message(topic: "topic/in", payload: [UInt8](payload), qos: .qos1)
        sut.mqtt5(dummyMQTT5, didReceiveMessage: message, id: 1, publishData: nil)

        XCTAssertTrue(mockMessageReceiveListener.invokedMessageArrived)
        XCTAssertEqual(mockMessageReceiveListener.invokedMessageArrivedParameters?.topic, "topic/in")
        XCTAssertEqual(mockMessageReceiveListener.invokedMessageArrivedParameters?.data, payload)
        XCTAssertEqual(mockMessageReceiveListener.invokedMessageArrivedParameters?.qos, .one)
    }

    func testDidPublishMessageEmitsSendSuccess() {
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)

        let message = CocoaMQTT5Message(topic: "topic/out", payload: [UInt8]("x".utf8), qos: .qos1)
        sut.mqtt5(dummyMQTT5, didPublishMessage: message, id: 1)

        let events = mockEventHandler.invokedOnEventParametersList.compactMap { $0?.event.type }
        XCTAssertTrue(events.contains { if case .messageSendSuccess = $0 { return true } else { return false } })
    }

    // MARK: - Delegate: Keep Alive

    func testPingWithoutPongTriggersKeepAliveFailure() {
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)
        sut.setKeepAliveFailureHandler(handler: mockKeepAliveFailureHandler)

        // First ping records lastPing; second ping (no pong in-between) is a failure.
        sut.mqtt5DidPing(dummyMQTT5)
        sut.mqtt5DidPing(dummyMQTT5)

        XCTAssertTrue(mockKeepAliveFailureHandler.invokedHandleKeepAliveFailure)
    }

    func testPongAfterPingDoesNotTriggerKeepAliveFailure() {
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)
        sut.setKeepAliveFailureHandler(handler: mockKeepAliveFailureHandler)

        sut.mqtt5DidPing(dummyMQTT5)
        sut.mqtt5DidReceivePong(dummyMQTT5)
        sut.mqtt5DidPing(dummyMQTT5)

        XCTAssertFalse(mockKeepAliveFailureHandler.invokedHandleKeepAliveFailure)
    }

    // MARK: - Delegate: Disconnect

    func testDidDisconnectEmitsConnectionLost() {
        sut.connect(connectOptions: stubConnectOptions, messageReceiveListener: mockMessageReceiveListener)
        sut.mqtt5DidDisconnect(dummyMQTT5, withError: nil)

        let events = mockEventHandler.invokedOnEventParametersList.compactMap { $0?.event.type }
        XCTAssertTrue(events.contains { if case .connectionLost = $0 { return true } else { return false } })
    }

    var stubConnectOptions: ConnectOptions {
        ConnectOptions(
            host: "broker.com",
            port: 443,
            keepAlive: 60,
            clientId: "clientId",
            username: "username",
            password: "password",
            isCleanSession: true,
            userProperties: nil,
            alpn: nil,
            scheme: "tls"
        )
    }
}
