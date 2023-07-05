import Foundation
import XCTest
import MQTTClientGJ
@testable import CourierCore
@testable import CourierMQTT

class MQTTClientFrameworkConnectionTests: XCTestCase {
    
    var sut: MQTTClientFrameworkConnection!
    var mockConnectRetryTimePolicy: MockConnectRetryTimePolicy!
    var mockEventHandler: MockCourierEventHandler!
    var mockAuthFailureHandler: MockAuthFailureHandler!
    var mockConnectTimeoutPolicy: MockConnectTimeoutPolicy!
    var mockMessageReceiveListener: MockMessageReceiveListener!
    var mockClientFactory: MockMQTTClientFrameworkFactory!
    var mockKeepAliveFailureHandler: MockKeepAliveFailureHandler!
    var mockSessionManager: MockMQTTClientFrameworkSessionManager!
    var mockPersistence: MockMQTTPersistence!
    
    override func setUp() {
        mockConnectRetryTimePolicy = MockConnectRetryTimePolicy()
        mockEventHandler = MockCourierEventHandler()
        mockAuthFailureHandler = MockAuthFailureHandler()
        mockConnectTimeoutPolicy = MockConnectTimeoutPolicy()
        mockMessageReceiveListener = MockMessageReceiveListener()
        mockSessionManager = MockMQTTClientFrameworkSessionManager()
        mockKeepAliveFailureHandler = MockKeepAliveFailureHandler()
        mockPersistence = MockMQTTPersistence()

        mockClientFactory = MockMQTTClientFrameworkFactory()
        mockClientFactory.stubbedMakeSessionManagerResult = mockSessionManager
        
        let mockPersistenceFactory = MockMQTTPersistenceFactory()
        mockPersistenceFactory.stubbedMakePersistenceResult = mockPersistence
        
        sut = MQTTClientFrameworkConnection(
            connectionConfig: ConnectionConfig(
                connectRetryTimePolicy: mockConnectRetryTimePolicy,
                eventHandler: mockEventHandler,
                authFailureHandler: mockAuthFailureHandler,
                connectTimeoutPolicy: mockConnectTimeoutPolicy,
                idleActivityTimeoutPolicy: IdleActivityTimeoutPolicy(),
                isPersistent: true
            ),
            clientFactory: mockClientFactory,
            persistenceFactory: mockPersistenceFactory
        )
    }
    
    func testInit() {
        XCTAssertTrue(mockClientFactory.invokedMakeSessionManager)
        XCTAssertEqual(mockClientFactory.invokedMakeSessionManagerParameters?.connectRetryTimePolicy.autoReconnectInterval, mockConnectRetryTimePolicy.autoReconnectInterval)
        XCTAssertEqual(mockClientFactory.invokedMakeSessionManagerParameters?.connectRetryTimePolicy.maxAutoReconnectInterval, mockConnectRetryTimePolicy.maxAutoReconnectInterval)
        XCTAssertEqual(mockClientFactory.invokedMakeSessionManagerParameters?.connectRetryTimePolicy.enableAutoReconnect, mockConnectRetryTimePolicy.enableAutoReconnect)
        XCTAssertEqual(mockClientFactory.invokedMakeSessionManagerParameters?.dispatchQueue.label, "com.courier.mqtt.connection")
        XCTAssertTrue(mockClientFactory.invokedMakeSessionManagerParameters?.delegate === sut)
        XCTAssertNotNil(sut.sessionManager)
    }
    
    func testConnectWithConnectOptionsSuccess() {
        
        sut.connect(
            connectOptions: stubConnectOptions,
            messageReceiveListener: mockMessageReceiveListener
        )
        
        XCTAssertNotNil(sut.messageReceiveListener)
        XCTAssertNotNil(sut.connectOptions)
        XCTAssertTrue(mockSessionManager.invokedConnect)
        XCTAssertEqual(mockSessionManager.invokedConnectParameters?.host, stubConnectOptions.host)
        XCTAssertEqual(mockSessionManager.invokedConnectParameters?.host, stubConnectOptions.host)
        XCTAssertEqual(mockSessionManager.invokedConnectParameters?.port, Int(stubConnectOptions.port))
        XCTAssertEqual(mockSessionManager.invokedConnectParameters?.keepAlive, Int(stubConnectOptions.keepAlive))
        XCTAssertEqual(mockSessionManager.invokedConnectParameters?.isCleanSession, stubConnectOptions.isCleanSession)
        XCTAssertEqual(mockSessionManager.invokedConnectParameters?.isAuth, true)
        XCTAssertEqual(mockSessionManager.invokedConnectParameters?.clientId, stubConnectOptions.clientId)
        XCTAssertEqual(mockSessionManager.invokedConnectParameters?.username, stubConnectOptions.username)
        XCTAssertEqual(mockSessionManager.invokedConnectParameters?.password, stubConnectOptions.password)
        XCTAssertEqual(mockSessionManager.invokedConnectParameters?.lastWill, false)
        XCTAssertEqual(mockSessionManager.invokedConnectParameters?.lastWillTopic, nil)
        XCTAssertEqual(mockSessionManager.invokedConnectParameters?.lastWillMessage, nil)
        XCTAssertEqual(mockSessionManager.invokedConnectParameters?.lastWillQoS, nil)
        XCTAssertEqual(mockSessionManager.invokedConnectParameters?.lastWillRetainFlag, false)
        
        let securityPolicy = mockSessionManager.invokedConnectParameters!.securityPolicy!
        XCTAssertEqual(securityPolicy.allowInvalidCertificates, true)
        XCTAssertNil(mockSessionManager.invokedConnectParameters?.certificates)
        XCTAssertEqual(mockSessionManager.invokedConnectParameters?.protocolLevel, .version311)
        XCTAssertNil(mockSessionManager.invokedConnectParameters?.connectHandler)
    }
    
    func testConnectWithConnectOptionsFailure() {
        sut.connect(
            connectOptions: stubConnectOptions,
            messageReceiveListener: mockMessageReceiveListener
        )
    }
    
    func testServerURI() {
        connectWithDefaultOptions()
        XCTAssertEqual(sut.serverUri, "\(stubConnectOptions.host):\(stubConnectOptions.port)")
    }
    
    func testServerURIWithoutOptions() {
        XCTAssertNil(sut.serverUri)
    }
    
    func testIsConnectedState() {
        connectWithDefaultOptions()
        mockSessionManager.stubbedState = .connected
        XCTAssertTrue(sut.isConnected)
    }
    
    func testIsConnectingState() {
        connectWithDefaultOptions()
        mockSessionManager.stubbedState = .connecting
        XCTAssertTrue(sut.isConnecting)
    }
    
    func testIsDisConnectingState() {
        connectWithDefaultOptions()
        mockSessionManager.stubbedState = .closing
        XCTAssertTrue(sut.isDisconnecting)
    }
    
    func testIsDisConnectedState() {
        connectWithDefaultOptions()
        mockSessionManager.stubbedState = .closed
        XCTAssertTrue(sut.isDisconnected)
    }
    
    func testHasExistingSession() {
        mockSessionManager.stubbedSession = MQTTSession()
        XCTAssertTrue(sut.hasExistingSession)
    }
    
    func testDisconnect() {
        sut.disconnect()
        XCTAssertTrue(mockSessionManager.invokedDisconnect)
    }
    
    
    func testSubscribeTopics() {
        connectWithDefaultOptions()
        sut.subscribe([("fbon", .zero), ("fbon2", .two)])
        XCTAssertTrue(mockSessionManager.invokedSubscribe)
        XCTAssertTrue(((mockSessionManager.invokedSubscribeParameters?.topics.contains(where: { $0.0 == "fbon" && $0.1 == .zero })) != nil))
        XCTAssertTrue(((mockSessionManager.invokedSubscribeParameters?.topics.contains(where: { $0.0 == "fbon2" && $0.1 == .two })) != nil))
    }
    
    func testSubscribeTopic() {
        connectWithDefaultOptions()
        sut.subscribe([("fbon", .one)])
        XCTAssertTrue(mockSessionManager.invokedSubscribe)
        XCTAssertEqual(mockSessionManager.invokedSubscribeParameters?.topics.first?.topic, "fbon")
        XCTAssertEqual(mockSessionManager.invokedSubscribeParameters?.topics.first?.qos, .one)
    }
    
    func testSubscribeTopicWithoutConnected() {
        sut.subscribe([("fbon", .one)])
        XCTAssertFalse(mockSessionManager.invokedSubscribe)
    }
    
    func testSubscribeTopicsWithoutConnected() {
        sut.subscribe([("x", .one)])
        XCTAssertFalse(mockSessionManager.invokedSubscribe)
    }
    
    func testUnsubscribeTopics() {
        connectWithDefaultOptions()
        sut.unsubscribe(["test", "test2"])
        XCTAssertTrue(mockSessionManager.invokedUnsubscribe)
        XCTAssertEqual(mockSessionManager.invokedUnsubscribeParameters?.topics[0], "test")
        XCTAssertEqual(mockSessionManager.invokedUnsubscribeParameters?.topics[1], "test2")
    }
    
    
    func testUnsubscribeTopicWithoutConnected() {
        sut.unsubscribe(["test"])
        XCTAssertFalse(mockSessionManager.invokedUnsubscribe)
    }
    
    func testUnsubscribeTopic() {
        connectWithDefaultOptions()
        sut.unsubscribe(["test"])
        XCTAssertTrue(mockSessionManager.invokedUnsubscribe)
        XCTAssertEqual(mockSessionManager.invokedUnsubscribeParameters?.topics[0], "test")
    }
    
    func testPublishPacket() {
        connectWithDefaultOptions()
        sut.publish(packet: MQTTPacket(data: "hello".data(using: .utf8)!, topic: "fbon", qos: .one))
        XCTAssertTrue(mockSessionManager.invokedPublish)
        XCTAssertEqual(mockSessionManager.invokedPublishParameters?.packet.qos, .one)
        XCTAssertEqual(mockSessionManager.invokedPublishParameters?.packet.data, "hello".data(using: .utf8))
        XCTAssertEqual(mockSessionManager.invokedPublishParameters?.packet.topic, "fbon")
    }
    
    func testSetKeepAliveFailureHandler() {
        sut.setKeepAliveFailureHandler(handler: mockKeepAliveFailureHandler)
        XCTAssertNotNil(sut.keepAliveFailureHandler)
    }
    
    // MARK: - MQTTClientFrameworkSessionManager Delegate
    
    func testSessionManagerDidChangeStateToStarting() {
        sut.sessionManager(mockSessionManager, didChangeState: .starting)
    }
    
    func testSessionManagerDidChangeStateToConnecting() {
        sut.sessionManager(mockSessionManager, didChangeState: .connecting)
        if case .connectionAttempt = self.mockEventHandler.invokedOnEventParametersList[0]?.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }
    
    func testSessionManagerDidChangeStateToConnected() {
        sut.sessionManager(mockSessionManager, didChangeState: .connected)
        if case .connectionSuccess = self.mockEventHandler.invokedOnEventParametersList[0]?.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }
    
    func testSessionManagerDidChangeStateToError() {
        let error = NSError(domain: "", code: 5, userInfo: [:])
        mockSessionManager.stubbedLastError = error
        sut.sessionManager(mockSessionManager, didChangeState: .error)
        if case let .connectionFailure(timeTaken, error) = self.mockEventHandler.invokedOnEventParametersList[0]?.event.type {
            XCTAssertEqual((error! as NSError).code, 5)
        } else {
            XCTAssert(false)
        }
        XCTAssertTrue(mockAuthFailureHandler.invokedHandleAuthFailure)
    }
    
    func testSessionManagerDidChangeStateToClosing() {
        sut.sessionManager(mockSessionManager, didChangeState: .closing)
    }
    
    func testSessionManagerDidChangeStateToClosed() {
        sut.sessionManager(mockSessionManager, didChangeState: .closed)
        if case .connectionLost = self.mockEventHandler.invokedOnEventParametersList[0]?.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }
    
    func testSessionManageridPing() {
        sut.sessionManagerDidPing(mockSessionManager)
        if case .ping = self.mockEventHandler.invokedOnEventParametersList[0]?.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
        XCTAssertNotNil(sut.lastPing)
    }
    
    func testSessionManagerDidPingWithoutPong() {
        sut.setKeepAliveFailureHandler(handler: mockKeepAliveFailureHandler)
        sut.sessionManagerDidPing(mockSessionManager)
        sut.sessionManagerDidPing(mockSessionManager)
        if case .pingFailure = self.mockEventHandler.invokedOnEventParameters?.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
        XCTAssertTrue(mockKeepAliveFailureHandler.invokedHandleKeepAliveFailure)
    }
    
    func testSessionManagerDidReceivePong() {
        sut.sessionManagerDidPing(mockSessionManager)
        sut.sessionManagerDidReceivePong(mockSessionManager)
        XCTAssertNotNil(sut.lastPong)
        if case .pongReceived = self.mockEventHandler.invokedOnEventParameters?.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
        XCTAssertNil(sut.lastPing)
    }
 
    func testSessionManagerDidReceiveMessage() {
        connectWithDefaultOptions()
        sut.sessionManager(mockSessionManager, didReceiveMessageData: "Hello".data(using: .utf8)!, onTopic: "fbon", qos: .atMostOnce, retained: false, mid: 1)
        
        if case .messageReceive = self.mockEventHandler.invokedOnEventParameters?.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
        XCTAssertTrue(mockMessageReceiveListener.invokedMessageArrived)
        XCTAssertEqual(mockMessageReceiveListener.invokedMessageArrivedParameters?.topic, "fbon")
    }
    
    func testSessionManagerDidPublishMessage() {
        sut.sessionManager(mockSessionManager, didDeliverMessageID: 1, topic: "fbon", data: "hello".data(using: .utf8)!, qos: .exactlyOnce, retainFlag: false)
        if case .messageSendSuccess = self.mockEventHandler.invokedOnEventParametersList[0]?.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }
    
    func testSessionManagerDidSendConnectPacket() {
        sut.sessionManagerDidSendConnectPacket(mockSessionManager)
        if case .connectedPacketSent = self.mockEventHandler.invokedOnEventParametersList[0]?.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }
    
    func testDeleteAllPersistedMessage() {
        sut.deleteAllPersistedMessages()
    
        let expectation_ = expectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            expectation_.fulfill()
        }
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertTrue(self.mockSessionManager.invokedDeleteAllPersistedMessages)
        }
    }
}

extension MQTTClientFrameworkConnectionTests {
    
    func connectWithDefaultOptions() {
        mockSessionManager.stubbedState = .connected
        sut.connect(
            connectOptions: stubConnectOptions,
            messageReceiveListener: mockMessageReceiveListener
        )
    }
    
    var stubConnectOptions: ConnectOptions {
        ConnectOptions(
            host: "broker.com",
            port: 443,
            keepAlive: 30,
            clientId: "1234",
            username: "hello",
            password: "word",
            isCleanSession: true,
            scheme: "tls"
        )
    }
    
    var stubbedError: NSError {
        NSError(domain: "x", code: -1, userInfo: [:])
    }
}

