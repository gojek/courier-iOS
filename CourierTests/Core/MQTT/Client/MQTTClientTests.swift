import XCTest
@testable import CourierCore
@testable import CourierMQTT

class MQTTClientTests: XCTestCase {

    var sut: MQTTClient!
    var mockConnectRetryTimePolicy: MockConnectRetryTimePolicy!
    var mockEventHandler: MockCourierEventHandler!
    var mockAuthFailureHandler: MockAuthFailureHandler!
    var mockConnectTimeoutPolicy: MockConnectTimeoutPolicy!
    var mockMessageReceiveListenerFactory: MockMessageReceiveListenerFactory!
    var mockMessageReceiveListener: MockMessageReceiveListener!
    var mockConnection: MockMQTTConnection!
    var mockConnectionFactory: MockMQTTConnectionFactory!
    var mockSessionManager: MockMQTTClientFrameworkSessionManager!
    var mockClientFactory: MockMQTTClientFrameworkFactory!
    var mockReachability: MockReachability!
    var mockNotificationCenter: MockNotificationCenter!
    var dispatchQueue: DispatchQueue!

    override func setUp() {
        mockConnectRetryTimePolicy = MockConnectRetryTimePolicy()
        mockEventHandler = MockCourierEventHandler()
        mockAuthFailureHandler = MockAuthFailureHandler()
        mockConnectTimeoutPolicy = MockConnectTimeoutPolicy()

        mockMessageReceiveListener = MockMessageReceiveListener()
        mockMessageReceiveListenerFactory = MockMessageReceiveListenerFactory()
        mockMessageReceiveListenerFactory.stubbedMakeListenerResult = mockMessageReceiveListener

        mockConnection = MockMQTTConnection()
        mockConnectionFactory = MockMQTTConnectionFactory()
        mockConnectionFactory.stubbedMakeConnectionResult = mockConnection

        mockSessionManager = MockMQTTClientFrameworkSessionManager()
        mockClientFactory = MockMQTTClientFrameworkFactory()
        mockClientFactory.stubbedMakeSessionManagerResult = mockSessionManager

        mockReachability = try! MockReachability()
        mockNotificationCenter = MockNotificationCenter()
        dispatchQueue = .main

        sut = MQTTClient(
            configuration: stubbedConfiguration,
            messageReceiveListenerFactory: mockMessageReceiveListenerFactory,
            mqttConnectionFactory: mockConnectionFactory,
            reachability: mockReachability,
            notificationCenter: mockNotificationCenter,
            dispatchQueue: dispatchQueue
        )
    }

    func testConnectWithConnectOptions() {
        sut.connect(connectOptions: stubConnectOptions)
        XCTAssertNotNil(sut.connectOptions)
        XCTAssertTrue(sut.isInitialized)
        XCTAssertTrue(mockConnection.invokedConnect)
        XCTAssertEqual(mockConnection.invokedConnectParameters?.connectOptions, stubConnectOptions)
    }

    func testReconnectWithOptions() {
        sut.connect(connectOptions: stubConnectOptions)
        sut.reconnect()
        
        if case .reconnect = self.mockEventHandler.invokedOnEventParametersList.first!!.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
        XCTAssertTrue(mockConnection.invokedConnect)
    }

    func testReconnectWithOptionsNil() {
        sut.reconnect()
        
        if case .reconnect = self.mockEventHandler.invokedOnEventParameters?.event.type {
            XCTAssert(false)
        }
        XCTAssertFalse(mockConnection.invokedConnect)
    }

    func testSendPacket() {
        let stubbedData = "hello".data(using: .utf8)!
        sut.send(packet: MQTTPacket(data: stubbedData, topic: "fbon", qos: .two))
        XCTAssertTrue(mockConnection.invokedPublish)
        XCTAssertEqual(mockConnection.invokedPublishParameters?.packet.data, stubbedData)
        XCTAssertEqual(mockConnection.invokedPublishParameters?.packet.topic, "fbon")
        XCTAssertEqual(mockConnection.invokedPublishParameters?.packet.qos, .two)
    }

    func testSubscribeTopics() {
        sut.subscribe([("fbon", .zero), ("fbon2", .two)])
        XCTAssertTrue(mockConnection.invokedSubscribe)
        XCTAssertTrue(((mockConnection.invokedSubscribeParameters?.topics.contains(where: { $0.0 == "fbon" && $0.1 == .zero })) != nil))
        XCTAssertTrue(((mockConnection.invokedSubscribeParameters?.topics.contains(where: { $0.0 == "fbon2" && $0.1 == .two })) != nil))
    }

    func testSubscribeTopic() {
        sut.subscribe([("fbon", .two)])
        XCTAssertTrue(mockConnection.invokedSubscribe)
        XCTAssertEqual(mockConnection.invokedSubscribeParameters?.topics.first?.topic, "fbon")
        XCTAssertEqual(mockConnection.invokedSubscribeParameters?.topics.first?.qos, .two)
    }

    func testUnsubscribeTopics() {
        sut.unsubscribe(["fbon", "fbon2"])
        XCTAssertTrue(mockConnection.invokedUnsubscribe)
        XCTAssertEqual(mockConnection.invokedUnsubscribeParameters?.topics, ["fbon", "fbon2"])
    }

    func testUnsubscribeTopic() {
        sut.unsubscribe(["fbon"])
        XCTAssertTrue(mockConnection.invokedUnsubscribe)
        XCTAssertEqual(mockConnection.invokedUnsubscribeParameters?.topics.first, "fbon")
    }

    func testDisconnect() {
        mockConnection.stubbedIsConnected = true
        sut.disconnect()

        if case .connectionDisconnect = self.mockEventHandler.invokedOnEventParametersList.first!!.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }

        XCTAssertFalse(sut.isInitialized)
        XCTAssertTrue(mockConnection.invokedDisconnect)
    }

    func testDestroyWithActiveNotifications() {
        sut = MQTTClient(
            configuration: stubbedConfiguration,
            messageReceiveListenerFactory: mockMessageReceiveListenerFactory,
            mqttConnectionFactory: mockConnectionFactory,
            reachability: mockReachability,
            notificationCenter: mockNotificationCenter,
            useAppDidEnterBGAndWillEnterFGNotification: false,
            dispatchQueue: dispatchQueue
        )

        mockConnection.stubbedIsConnected = true
        sut.destroy()

        XCTAssertFalse(sut.isInitialized)
        XCTAssertTrue(mockConnection.invokedDisconnect)

        XCTAssertNil(sut.connectOptions)
        XCTAssertEqual(mockNotificationCenter.invokedRemoveObserverWithNameParametersList[0].name, UIApplication.willResignActiveNotification)
        XCTAssertEqual(mockNotificationCenter.invokedRemoveObserverWithNameParametersList[1].name, UIApplication.didBecomeActiveNotification)
        XCTAssertFalse(mockReachability.notifierRunning)
    }

    func testDestroyWithoutActiveNotifications() {
        sut = MQTTClient(
            configuration: stubbedConfiguration,
            messageReceiveListenerFactory: mockMessageReceiveListenerFactory,
            mqttConnectionFactory: mockConnectionFactory,
            reachability: mockReachability,
            notificationCenter: mockNotificationCenter,
            useAppDidEnterBGAndWillEnterFGNotification: true,
            dispatchQueue: dispatchQueue
        )

        mockConnection.stubbedIsConnected = true
        sut.destroy()

        XCTAssertFalse(sut.isInitialized)
        XCTAssertTrue(mockConnection.invokedDisconnect)

        XCTAssertNil(sut.connectOptions)
        XCTAssertEqual(mockNotificationCenter.invokedRemoveObserverWithNameParametersList[0].name, UIApplication.didEnterBackgroundNotification)
        XCTAssertEqual(mockNotificationCenter.invokedRemoveObserverWithNameParametersList[1].name, UIApplication.willEnterForegroundNotification)
        XCTAssertFalse(mockReachability.notifierRunning)
    }

    func testSetKeepAliveFailureHandler() {
        sut.setKeepAliveFailureHandler(handler: MockKeepAliveFailureHandler())
        XCTAssertTrue(mockConnection.invokedSetKeepAliveFailureHandler)
    }

    func testHandleKeepAliveFailure() {
        sut.connect(connectOptions: stubConnectOptions)
        sut.setKeepAliveFailureHandler(handler: MockKeepAliveFailureHandler())
        sut.handleKeepAliveFailure()
        XCTAssertTrue(mockConnection.invokedDisconnect)
        XCTAssertTrue(mockConnection.invokedConnect)
    }

    func testResetWithActiveNotifications() {
        sut = MQTTClient(
            configuration: stubbedConfiguration,
            messageReceiveListenerFactory: mockMessageReceiveListenerFactory,
            mqttConnectionFactory: mockConnectionFactory,
            reachability: mockReachability,
            notificationCenter: mockNotificationCenter,
            useAppDidEnterBGAndWillEnterFGNotification: false,
            dispatchQueue: dispatchQueue
        )

        mockReachability.stubbedConnection = .unavailable
        mockReachability.stubbedNotificationCenter = mockNotificationCenter
        sut.reset()
        XCTAssertEqual(mockNotificationCenter.invokedRemoveObserverWithNameParametersList[0].name, UIApplication.willResignActiveNotification)
        XCTAssertEqual(mockNotificationCenter.invokedRemoveObserverWithNameParametersList[1].name, UIApplication.didBecomeActiveNotification)
        XCTAssertFalse(mockReachability.notifierRunning)

        XCTAssertEqual(mockNotificationCenter.invokedAddObserverParametersList[0].name, UIApplication.willResignActiveNotification)
        XCTAssertEqual(mockNotificationCenter.invokedAddObserverParametersList[1].name, UIApplication.didBecomeActiveNotification)
        XCTAssertTrue(mockConnection.invokedResetParams)

        XCTAssertTrue(mockReachability.invokedWhenReachableSetter)
        XCTAssertTrue(mockReachability.invokedWhenUnreachableSetter)
        XCTAssertTrue(mockReachability.invokedNotifierRunningGetter)
    }

    func testResetWithoutActiveNotifications() {
        sut = MQTTClient(
            configuration: stubbedConfiguration,
            messageReceiveListenerFactory: mockMessageReceiveListenerFactory,
            mqttConnectionFactory: mockConnectionFactory,
            reachability: mockReachability,
            notificationCenter: mockNotificationCenter,
            useAppDidEnterBGAndWillEnterFGNotification: true,
            dispatchQueue: dispatchQueue
        )

        mockReachability.stubbedConnection = .unavailable
        mockReachability.stubbedNotificationCenter = mockNotificationCenter
        sut.reset()
        XCTAssertEqual(mockNotificationCenter.invokedRemoveObserverWithNameParametersList[0].name, UIApplication.didEnterBackgroundNotification)
        XCTAssertEqual(mockNotificationCenter.invokedRemoveObserverWithNameParametersList[1].name, UIApplication.willEnterForegroundNotification)
        XCTAssertFalse(mockReachability.notifierRunning)

        XCTAssertEqual(mockNotificationCenter.invokedAddObserverParametersList[0].name, UIApplication.didEnterBackgroundNotification)
        XCTAssertEqual(mockNotificationCenter.invokedAddObserverParametersList[1].name, UIApplication.willEnterForegroundNotification)
        XCTAssertTrue(mockConnection.invokedResetParams)

        XCTAssertTrue(mockReachability.invokedWhenReachableSetter)
        XCTAssertTrue(mockReachability.invokedWhenUnreachableSetter)
        XCTAssertTrue(mockReachability.invokedNotifierRunningGetter)
    }

    func testOnForegroundConnectionAvailable() {
        sut.onForeground()
        if case .appForeground = self.mockEventHandler.invokedOnEventParameters?.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }

    func testOnBackground() {
        mockReachability.stubbedConnection = .wifi
        sut.onBackground()
        if case .appBackground = self.mockEventHandler.invokedOnEventParameters?.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }

    func testHandleConnectionChangeWhenConnectionAvailable() {
        mockReachability.stubbedConnection = .wifi
        sut.handleConnectionChange()
        if case .connectionAvailable = self.mockEventHandler.invokedOnEventParameters?.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }

    func testHandleConnectionChangeWhenConnectionUnavailable() {
        mockReachability.stubbedConnection = .unavailable
        sut.handleConnectionChange()
        if case .connectionUnavailable = self.mockEventHandler.invokedOnEventParameters?.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }

    func testDeleteAllPersistedMessages() {
        sut.deleteAllPersistedMessages()
        XCTAssertTrue(mockConnection.invokedDeleteAllPersistedMessages)
    }

}

extension MQTTClientTests {

    var stubbedConfiguration: IMQTTConfiguration {
        MQTTConfiguration(
            connectRetryTimePolicy: mockConnectRetryTimePolicy, authFailureHandler: mockAuthFailureHandler, eventHandler: mockEventHandler, isMQTTPersistentEnabled: true, shouldInitializeCoreDataPersistenceContext: true)
    }

    var stubConnectOptions: ConnectOptions {
        ConnectOptions(
            host: "broker.com",
            port: 900,
            keepAlive: 30,
            clientId: "1234",
            username: "hello",
            password: "word",
            isCleanSession: true
        )
    }

    var stubbedError: NSError {
        NSError(domain: "x", code: -1, userInfo: [:])
    }
}
