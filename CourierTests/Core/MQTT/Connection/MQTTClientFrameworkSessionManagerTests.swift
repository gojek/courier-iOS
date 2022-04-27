import Foundation
import XCTest
import MQTTClientGJ
@testable import CourierCore
@testable import CourierMQTT
class MQTTClientFrameworkSessionManagerTests: XCTestCase {

    var sut: MQTTClientFrameworkSessionManager!
    var mockSession: MockMQTTSession!
    var mockPersistence: MockMQTTPersistence!
    var mockDelegate: MockMQTTClientFrameworkSessionManagerDelegate!

    override func setUp() {
        mockSession = MockMQTTSession()
        let sessionFactory = MockMQTTSessionFactory()
        sessionFactory.stubbedMakeSessionResult = mockSession

        mockPersistence = MockMQTTPersistence()
        let persistenceFactory = MockMQTTPersistenceFactory()
        persistenceFactory.stubbedMakePersistenceResult = mockPersistence

        mockDelegate = MockMQTTClientFrameworkSessionManagerDelegate()

        sut = MQTTClientFrameworkSessionManager(
            persistence: true,
            maxWindowSize: 100,
            maxMessages: 100,
            maxSize: 100,
            retryInterval: 10,
            maxRetryInterval: 15,
            streamSSLLevel: "9999",
            queue: .main,
            mqttSessionFactory: sessionFactory,
            mqttPersistenceFactory: persistenceFactory,
            connectTimeoutPolicy: ConnectTimeoutPolicy(),
            idleActivityTimeoutPolicy: IdleActivityTimeoutPolicy()
        )

        sut.delegate = mockDelegate
    }

    func testInit() {
        XCTAssertEqual(sut.state, .starting)
    }

    func testConnectWithoutExistingSession() {
        let securityPolicy = MQTTSSLSecurityPolicy()
        setupSession(securityPolicy: securityPolicy)

        XCTAssertTrue(sut.session === mockSession)
        XCTAssertEqual(mockSession.invokedClientId, "clientid")
        XCTAssertEqual(mockSession.invokedUserName, "username")
        XCTAssertEqual(mockSession.invokedPassword, "password")
        XCTAssertEqual(mockSession.invokedKeepAliveInterval, UInt16(240))
        XCTAssertEqual(mockSession.invokedCleanSessionFlag, true)
        XCTAssertEqual(mockSession.invokedWillFlag!, false)
        XCTAssertEqual(mockSession.invokedWillTopic, nil)
        XCTAssertEqual(mockSession.invokedWillMsg, nil)
        XCTAssertEqual(mockSession.invokedWillQoS, .atMostOnce)
        XCTAssertEqual(mockSession.invokedWillRetainFlag!, false)
        XCTAssertEqual(mockSession.invokedProtocolLevel, .version311)
        XCTAssertEqual(mockSession.invokedQueue, .main)
        XCTAssertNil(mockSession.invokedCertificates)
        XCTAssertEqual(mockSession.invokedStreamSSLLevel, "9999")
        XCTAssertTrue(mockSession.invokedPersistence === mockPersistence)
        XCTAssertTrue(mockPersistence.invokedPersistent!)
        XCTAssertEqual(mockPersistence.invokedMaxWindowSize, UInt(100))
        XCTAssertEqual(mockPersistence.invokedMaxSize, UInt(100))
        XCTAssertEqual(mockPersistence.invokedMaxMessages, UInt(100))
        XCTAssertTrue(mockSession.invokedDelegate === sut)
        XCTAssertFalse(mockSession.invokedClose)
        XCTAssertEqual(sut.state, .connecting)
        let sslTransport = self.mockSession.invokedTransport as! MQTTSSLSecurityPolicyTransport
        XCTAssertTrue(sslTransport.securityPolicy == securityPolicy)
        XCTAssertEqual(sslTransport.host, "host")
        XCTAssertEqual(sslTransport.port, 443)
        XCTAssertEqual(sslTransport.tls, true)
        XCTAssertEqual(sslTransport.queue, .main)
        XCTAssertEqual(sslTransport.streamSSLLevel, "9999")
        XCTAssertTrue(mockSession.invokedConnect)

        XCTAssertTrue(mockDelegate.invokedSessionManagerDidChangeState)
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidChangeStateParameters?.newState, .connecting)
    }

    func testConnectWithExistingSessionShouldReconnect() {
        setupSession()
        XCTAssertEqual(mockSession.invokedCloseCount, 0)
        setupSession()
        XCTAssertEqual(mockSession.invokedCloseCount, 1)
    }

    func testDisconnect() {
        setupSession()
        sut.disconnect()
        XCTAssertEqual(sut.state, .closing)
        XCTAssertTrue(mockSession.invokedClose)
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidChangeStateParameters?.newState, .closing)
    }

    func testConnectToLast() {
        sut.handleEvent(MQTTSession(), event: .connected, error: nil)
        sut.connectToLast()
    }

    func testSubscribeTopics() {
        setupSession()
        sut.subscribe([("fbon", .one)])
        XCTAssertTrue(mockSession.invokedSubscribe)
        XCTAssertEqual(mockSession.invokedSubscribeParameters?.topics, ["fbon": NSNumber(value: 1)])
        XCTAssertNotNil(mockSession.invokedSubscribeParameters?.subscribeHandler)
    }

    func testUnsubscribeTopics() {
        setupSession()
        sut.unsubscribe(["fbon"])
        XCTAssertTrue(mockSession.invokedUnsubscribeTopics)
        XCTAssertEqual(mockSession.invokedUnsubscribeTopicsParameters?.topics?.first, "fbon")
        XCTAssertNotNil(mockSession.invokedUnsubscribeTopicsParameters?.unsubscribeHandler)
    }

    func testPublishPacket() {
        setupSession()
        sut.publish(packet: MQTTPacket(data: "Hello".data(using: .utf8)!, topic: "xxx", qos: .one))
        XCTAssertTrue(mockSession.invokedPublishData)
        XCTAssertEqual(mockSession.invokedPublishDataParameters?.data, "Hello".data(using: .utf8))
        XCTAssertEqual(mockSession.invokedPublishDataParameters?.topic, "xxx")
        XCTAssertEqual(mockSession.invokedPublishDataParameters?.retainFlag, false)
    }

    func testHandleEventConnected() {
        sut.handleEvent(MQTTSession(), event: .connected, error: nil)
        XCTAssertEqual(sut.state, .connected)
    }

    func testHandleEventConnectionClosed() {
        sut.handleEvent(MQTTSession(), event: .connectionClosed, error: nil)
        XCTAssertEqual(sut.state, .closed)
    }

    func testHandleEventConnectionClosedByBroker() {
        sut.handleEvent(MQTTSession(), event: .connectionClosedByBroker, error: nil)
        XCTAssertEqual(sut.state, .closed)
    }

    func testHandleEventProtocolErrorConnectionRefusedConnectionError() {
        sut.handleEvent(MQTTSession(), event: .protocolError, error: nil)
        XCTAssertEqual(sut.state, .error)
    }

    func testHandleSessionConnected() {
        sut.connected(MQTTSession(), sessionPresent: false)
    }

    func testHandleSessionNewMessage() {
        sut.newMessage(MQTTSession(), data: "Hello".data(using: .utf8), onTopic: "xxx", qos: .atLeastOnce, retained: false, mid: 1)
        XCTAssertTrue(mockDelegate.invokedSessionManagerDidReceiveMessageData)
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidReceiveMessageDataParameters?.mid, 1)
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidReceiveMessageDataParameters?.qos, .atLeastOnce)

        XCTAssertEqual(mockDelegate.invokedSessionManagerDidReceiveMessageDataParameters?.topic, "xxx")
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidReceiveMessageDataParameters?.data, "Hello".data(using: .utf8))
    }

    func testHandleSessionMessageDelivered() {
        sut.messageDelivered(MQTTSession(), msgID: 1, topic: "xxx", data: "Hello".data(using: .utf8), qos: .atLeastOnce, retainFlag: false)
        XCTAssertTrue(mockDelegate.invokedSessionManagerDidDeliverMessageID)
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidDeliverMessageIDParameters?.msgID, 1)
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidDeliverMessageIDParameters?.topic, "xxx")
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidDeliverMessageIDParameters?.data, "Hello".data(using: .utf8)!)
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidDeliverMessageIDParameters?.qos, .atLeastOnce)
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidDeliverMessageIDParameters?.retainFlag, false)
    }

    func testHandleSessionSendingMQTTCommandConnect() {
        sut.sending(MQTTSession(), type: .connect, qos: .atLeastOnce, retained: false, duped: false, mid: 1, data: nil)
        XCTAssertTrue(mockDelegate.invokedSessionManagerDidSendConnectPacket)
    }

    func testHandleSessionSendingMQTTCommandPingReq() {
        sut.sending(MQTTSession(), type: .pingreq, qos: .atLeastOnce, retained: false, duped: false, mid: 1, data: nil)
        XCTAssertTrue(mockDelegate.invokedSessionManagerDidPing)
    }

    func testHandleSessionReceivedMQTTCommandPingResp() {
        sut.received(MQTTSession(), type: .pingresp, qos: .atLeastOnce, retained: false, duped: false, mid: 1, data: nil)
        XCTAssertTrue(mockDelegate.invokedSessionManagerDidReceivePong)
    }
}

extension MQTTClientFrameworkSessionManagerTests {

    func setupSession(securityPolicy: MQTTSSLSecurityPolicy = .init()) {
        sut.connect(to: "host", port: 443, keepAlive: 240, isCleanSession: true, isAuth: true, clientId: "clientid", username: "username", password: "password", lastWill: false, lastWillTopic: nil, lastWillMessage: nil, lastWillQoS: nil, lastWillRetainFlag: false, securityPolicy: securityPolicy, certificates: nil, protocolLevel: .version311, connectHandler: nil)

    }

}
