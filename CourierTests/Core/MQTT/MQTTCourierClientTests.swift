@testable import CourierCore
@testable import CourierMQTT
import XCTest
import Combine

class MQTTCourierClientTests: XCTestCase {
    var sut: MQTTCourierClient!
    var mockConnectionServiceProvider: MockConnectionServiceProvider!
    var mockSubscriptionStore: MockSubscriptionStore!
    var mockEventHandler: MockMulticastCourierEventHandler!
    var mockAuthRetryPolicy: MockAuthRetryPolicy!
    var mockMessageAdapter: MockMessageAdapter!
    var mockClient: MockMQTTClient!
    var mockMessageListener: MockMessageReceiveListener!
    var cancellables = Set<AnyCancellable>()
    let pingInterval = 30

    struct Person: Codable {
        let name: String
    }

    struct PersonError: Decodable {}

    override func setUp() {
        mockConnectionServiceProvider = MockConnectionServiceProvider()
        mockSubscriptionStore = MockSubscriptionStore()
        mockEventHandler = MockMulticastCourierEventHandler()
        mockAuthRetryPolicy = MockAuthRetryPolicy()
        mockMessageAdapter = MockMessageAdapter()
        mockClient = MockMQTTClient()
        mockMessageListener = MockMessageReceiveListener()
        
        mockClient.stubbedMessageReceiverListener = mockMessageListener

        let subscriptionStoreFactory = MockSubscriptionStoreFactory()
        subscriptionStoreFactory.stubbedMakeStoreResult = mockSubscriptionStore

        let multicastEventHandlerFactory = MockMulticastCourierEventHandlerFactory()
        multicastEventHandlerFactory.stubbedMakeHandlerResult = mockEventHandler

        let mqttClientFactory = MockMQTTClientFactory()
        mqttClientFactory.stubbedMakeClientResult = mockClient
        
        let clientConfig = MQTTClientConfig(
            topics: stubbedTopicsDict,
            authService: mockConnectionServiceProvider,
            messageAdapters: [mockMessageAdapter]
        )
        
        sut = MQTTCourierClient(
            config: clientConfig,
            subscriptionStoreFactory: subscriptionStoreFactory,
            multicastEventHandlerFactory: multicastEventHandlerFactory,
            mqttClientFactory: mqttClientFactory,
            authRetryPolicy: mockAuthRetryPolicy
        )
    }

    func testInitializationAddAsCourierEventHandler() {
        XCTAssertEqual(mockEventHandler.invokedAddEventHandlerCount, 1)
        XCTAssertTrue(mockEventHandler.invokedAddEventHandlerParametersList.last!.handler === sut)
    }

    func testConnectWhenAlreadyConnected() {
        mockClient.stubbedIsConnected = true
        sut.connect()
        if case .connectionServiceAuthStart = self.mockEventHandler.invokedOnEventParameters?.event.type {
            XCTAssert(false)
        }
        
        XCTAssertFalse(mockConnectionServiceProvider.invokedGetConnectOptions)
    }

    func testConnect() {
        sut.connect()
//        XCTAssertTrue(mockEventHandler.invokedReset)
        if case .connectionServiceAuthStart = self.mockEventHandler.invokedOnEventParameters?.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
        XCTAssertTrue(mockConnectionServiceProvider.invokedGetConnectOptions)
    }

    func testConnectAlreadyConnected() {
        mockClient.stubbedIsConnected = true
        XCTAssertFalse(mockEventHandler.invokedReset)
        
        if case .connectionServiceAuthStart = self.mockEventHandler.invokedOnEventParameters?.event.type {
            XCTAssert(false)
        }
        XCTAssertFalse(mockConnectionServiceProvider.invokedGetConnectOptions)
    }

    func testConnectWithSuccessCredentials() async throws {
        mockConnectionServiceProvider.stubbedGetConnectOptionsCompletionResult = (.success(stubConnectOptions), ())
        sut.connect()
        let expectation_ = expectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            expectation_.fulfill()
        }
        
        await fulfillment(of: [expectation_], timeout: 1.0)
        
        if case .connectionServiceAuthSuccess = self.mockEventHandler.invokedOnEventParameters?.event.type {
        } else {
            XCTAssert(false)
        }
        XCTAssertTrue(self.mockAuthRetryPolicy.invokedResetParams)
        XCTAssertTrue(self.mockClient.invokedReset)
        XCTAssertTrue(self.mockClient.invokedConnect)
        
        XCTAssertEqual(self.mockClient.invokedConnectParameters?.connectOptions.host, self.stubConnectOptions.host)
        
        XCTAssertEqual(self.mockClient.invokedConnectParameters?.connectOptions.port, UInt16(self.stubConnectOptions.port))
        XCTAssertEqual(self.mockClient.invokedConnectParameters?.connectOptions.keepAlive, UInt16(self.pingInterval))
        XCTAssertEqual(self.mockClient.invokedConnectParameters?.connectOptions.clientId, self.stubConnectOptions.clientId)
        XCTAssertEqual(self.mockClient.invokedConnectParameters?.connectOptions.username, self.stubConnectOptions.username)
        XCTAssertEqual(self.mockClient.invokedConnectParameters?.connectOptions.password, self.stubConnectOptions.password)
    }
        
        
     
    func testConnectWithFailureCredentials() async throws {
        mockConnectionServiceProvider.stubbedGetConnectOptionsCompletionResult = (.failure(stubbedError), ())
        mockAuthRetryPolicy.stubbedGetRetryTimeResult = 0.1
        
        sut.connect()
        let expectation_ = expectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            expectation_.fulfill()
        }
        
        await fulfillment(of: [expectation_], timeout: 1.0)

        if case .connectionServiceAuthFailure = self.mockEventHandler.invokedOnEventParametersList[1]?.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
        
        if case .connectionUnavailable = self.mockEventHandler.invokedOnEventParametersList[2]?.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
        XCTAssertTrue(self.mockAuthRetryPolicy.invokedShouldRetry)
        
    }

    func testSubscribeTopics() {
        sut.subscribe(stubbedTopics)
        XCTAssertTrue(mockSubscriptionStore.invokedSubscribe)
        XCTAssertTrue(mockClient.invokedSubscribe)
    }

    func testSubscribeTopic() {
        sut.subscribe(("fbon", qos: .zero))
        XCTAssertTrue(mockSubscriptionStore.invokedSubscribe)
        XCTAssertTrue(mockClient.invokedSubscribe)
    }

    func testPublishMessage() {
        let person = Person(name: "gojek")
        let data = try! JSONEncoder().encode(person)
        mockMessageAdapter.stubbedToMessageResult = data
        mockClient.stubbedHasExistingSession = true
        XCTAssertNoThrow(try sut.publishMessage(person, topic: "fbon", qos: .two))
        XCTAssert(mockClient.invokedSend)
        XCTAssertTrue(mockMessageAdapter.invokedToMessage)
        XCTAssertEqual(mockClient.invokedSendParameters?.packet.qos, .two)
        XCTAssertEqual(mockClient.invokedSendParameters?.packet.topic, "fbon")
        XCTAssertEqual(mockClient.invokedSendParameters?.packet.data, data)
    }
    
    func testPublishMessageWithoutExistingSession() {
        let person = Person(name: "gojek")
        let data = try! JSONEncoder().encode(person)
        mockMessageAdapter.stubbedToMessageResult = data
        mockClient.stubbedHasExistingSession = false
        XCTAssertThrowsError(try sut.publishMessage(person, topic: "fbon", qos: .two))
        XCTAssertFalse(mockClient.invokedSend)
        XCTAssertFalse(mockMessageAdapter.invokedToMessage)
    }

    func testExistingUnsubscribeTopics() {
        sut.unsubscribe(["fbon5"])
        XCTAssertTrue(mockSubscriptionStore.invokedUnsubscribe)
        XCTAssertTrue(mockClient.invokedUnsubscribe)
        mockSubscriptionStore.stubbedIsCurrentlyPendingUnsubscribeResult = true
        sut.unsubscribe(["fbon5"])
        XCTAssertEqual(mockSubscriptionStore.invokedUnsubscribeCount, 1)
        XCTAssertEqual(mockClient.invokedUnsubscribeCount, 1)
    }

    func testExistingUnsubscribeTopic() {
        sut.unsubscribe("fbon5")
        XCTAssertTrue(mockSubscriptionStore.invokedUnsubscribe)
        XCTAssertTrue(mockClient.invokedUnsubscribe)
        mockSubscriptionStore.stubbedIsCurrentlyPendingUnsubscribeResult = true
        sut.unsubscribe("fbon5")
        XCTAssertEqual(mockClient.invokedUnsubscribeCount, 1)
    }

    func testAddEventHandler() {
        sut.addEventHandler(mockEventHandler)
        XCTAssertTrue(mockEventHandler.invokedAddEventHandler)
    }

    func testRemoveEventHandler() {
        sut.removeEventHandler(mockEventHandler)
        XCTAssertTrue(mockEventHandler.invokedRemoveEventHandler)
    }

    func testDestroy() {
        sut.destroy()
        XCTAssertTrue(mockSubscriptionStore.invokedClearAllSubscriptions)
        XCTAssertTrue(mockClient.invokedDeleteAllPersistedMessages)
        XCTAssertTrue(mockClient.invokedDestroy)
        XCTAssertTrue(mockClient.invokedMessageReceiverListenerGetter)
    }

    func testHandleAuthFailure() {
        sut.handleAuthFailure()
        XCTAssertTrue(mockClient.invokedDisconnectParameters!.isInternal)
        if case .connectionServiceAuthStart = self.mockEventHandler.invokedOnEventParameters?.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
        XCTAssertTrue(mockConnectionServiceProvider.invokedGetConnectOptions)
    }

    func testOnAppForegroundConnect() async throws {
        sut.onEvent(.init(connectionInfo: nil, event: .appForeground))
        let expectation_ = expectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            expectation_.fulfill()
        }
        await fulfillment(of: [expectation_], timeout: 1.0)
        if case .connectionServiceAuthStart = self.mockEventHandler.invokedOnEventParameters?.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
        XCTAssertTrue(self.mockConnectionServiceProvider.invokedGetConnectOptions)
    }

    func testOnConnectionAvailableConnect() async throws {
        mockSubscriptionStore.stubbedSubscriptions = stubbedTopicsDict
        sut.onEvent(.init(connectionInfo: nil, event: .connectionAvailable))
        let expectation_ = expectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            expectation_.fulfill()
        }
        await fulfillment(of: [expectation_], timeout: 1.0)
        if case .connectionServiceAuthStart = self.mockEventHandler.invokedOnEventParameters?.event.type {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
        XCTAssertTrue(self.mockConnectionServiceProvider.invokedGetConnectOptions)
    }

    func testMessageReceiveStream() {
        let subject = PassthroughSubject<MQTTPacket, Never>()
        mockClient.stubbedSubscribedMessageStream = subject.eraseToAnyPublisher()
        sut.messagePublisher(topic: "test")
            .sink { (_: Person) in }
            .store(in: &cancellables)
        XCTAssertTrue(mockClient.invokedSubscribedMessageStreamGetter)
    }

    func testMessageReceiveStreamWithErrorDecodeHandler() {
        let subject = PassthroughSubject<MQTTPacket, Never>()
        mockClient.stubbedSubscribedMessageStream = subject.eraseToAnyPublisher()
        sut.messagePublisher(topic: "test") { (_: PersonError) -> Error in
            NSError(domain: "x", code: 1, userInfo: [:])
        }
        .sink { (_: Result<Person, NSError>) in
        }.store(in: &cancellables)

        XCTAssertTrue(mockClient.invokedSubscribedMessageStreamGetter)
    }
    
    func testConnectSource() {
        sut.connect(source: "Gojek")
        XCTAssertEqual(sut.connectSource, "Gojek")
    }
    
}

extension MQTTCourierClientTests {

    var stubbedTopicsDict: [String: QoS] {
        [
            "fbon": .zero,
            "fbon2": .two
        ]
    }
    
    var stubbedTopics: [(String, QoS)] {
        [
            ("fbon", .zero),
            ("fbon2", .two)
        ]
    }
    
    var stubConnectOptions: ConnectOptions {
        ConnectOptions(
            host: "hyz",
            port: 999,
            keepAlive: 30,
            clientId: "xyz",
            username: "abc",
            password: "token",
            isCleanSession: true
        )
    }
    
    var stubbedError: AuthError {
        .otherError(NSError(domain: NSURLErrorDomain, code: NSURLErrorNetworkConnectionLost, userInfo: [:]))
    }
}


