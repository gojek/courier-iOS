import XCTest
@testable import CourierCore
@testable import CourierMQTT
class MQTTMessageReceiveListenerTests: XCTestCase {

    var sut: MqttMessageReceiverListener!
    var publishSubject: PublishSubject<MQTTPacket>!
    var dispatchQueue: DispatchQueue!
    var mockMessagePersistence: MockIncomingMessagePersistence!
    private let disposeBag = DisposeBag()
    
    override func setUp() {
        publishSubject = PublishSubject<MQTTPacket>()
        dispatchQueue = .main
        mockMessagePersistence = MockIncomingMessagePersistence()
        
        sut = MqttMessageReceiverListener(publishSubject: publishSubject, publishSubjectDispatchQueue: dispatchQueue)
    }
    
    func testOnMessageArrived() {
        let exp = expectation(description: "messageArrived")
        let data = "hello".data(using: .utf8)!
        
        publishSubject
            .asObservable()
            .subscribe { event in
                let packet = event.element!
                XCTAssertEqual(String(data: packet.data, encoding: .utf8), "hello")
                XCTAssertEqual(packet.topic, "fbon")
                XCTAssertEqual(packet.qos, .two)
                exp.fulfill()
            }
            .disposed(by: disposeBag)
        
        sut.messageArrived(data: data, topic: "fbon", qos: .two)
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testAddPublisherDict() {
        let exp = expectation(description: "messageArrivedIncomingMessagePersistence")
        let data = "hello".data(using: .utf8)!

        sut = MqttMessageReceiverListener(publishSubject: publishSubject, publishSubjectDispatchQueue: dispatchQueue, incomingMessagePersistence: mockMessagePersistence, messagePersistenceTTLSeconds: 30, messageCleanupInterval: 10)
        mockMessagePersistence.stubbedGetAllMessagesResult = [MQTTPacket(data: data, topic: "fbon", qos: .two)]
        sut.addPublisherDict(topic: "fbon")
        XCTAssertEqual(sut.publisherTopicDict["fbon"], 1)
                
        publishSubject
            .asObservable()
            .subscribe { event in
                XCTAssertTrue(self.mockMessagePersistence.invokedGetAllMessages)
                let packet = event.element!
                XCTAssertEqual(String(data: packet.data, encoding: .utf8), "hello")
                XCTAssertEqual(packet.topic, "fbon")
                XCTAssertEqual(packet.qos, .two)
                exp.fulfill()
            }
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 3, handler: nil)

    }
    
    func testRemovePublisherDict() {
        sut = MqttMessageReceiverListener(publishSubject: publishSubject, publishSubjectDispatchQueue: dispatchQueue, incomingMessagePersistence: mockMessagePersistence, messagePersistenceTTLSeconds: 30, messageCleanupInterval: 10)
        
        sut.addPublisherDict(topic: "Courier")
        XCTAssertEqual(sut.publisherTopicDict["Courier"], 1)
        
        sut.removePublisherDict(topic: "Courier")
        XCTAssertEqual(sut.publisherTopicDict["Courier"], 0)
    }
    
    func testClearPersistedMessages() {
        sut = MqttMessageReceiverListener(publishSubject: publishSubject, publishSubjectDispatchQueue: dispatchQueue, incomingMessagePersistence: mockMessagePersistence, messagePersistenceTTLSeconds: 30, messageCleanupInterval: 10)
        
        sut.clearPersistedMessages()
        XCTAssertTrue(mockMessagePersistence.invokedDeleteAllMessages)
    }
    
    
    func testOnMessageArrivedWithIncomingMessagePersistenceEnabled() {
        let exp = expectation(description: "messageArrivedIncomingMessagePersistence")
        let exp2 = expectation(description: "messageArrivedIncomingMessagePersistence2")

        let data = "hello".data(using: .utf8)!

        sut = MqttMessageReceiverListener(publishSubject: publishSubject, publishSubjectDispatchQueue: dispatchQueue, incomingMessagePersistence: mockMessagePersistence, messagePersistenceTTLSeconds: 30, messageCleanupInterval: 0.5)
        mockMessagePersistence.stubbedGetAllMessagesResult = [MQTTPacket(data: data, topic: "fbon", qos: .two)]
        sut.messagePublisherDict.mutate { dict in
            dict["fbon", default: 0] += 1
        }
                
        publishSubject
            .asObservable()
            .subscribe { event in
                XCTAssertTrue(self.mockMessagePersistence.invokedGetAllMessages)
                let packet = event.element!
                XCTAssertEqual(String(data: packet.data, encoding: .utf8), "hello")
                XCTAssertEqual(packet.topic, "fbon")
                XCTAssertEqual(packet.qos, .two)
                exp.fulfill()
            }
            .disposed(by: disposeBag)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockMessagePersistence.invokedDeleteMessages)
            XCTAssertTrue(self.mockMessagePersistence.invokedDeleteMessagesWithOlderTimestamp)
            XCTAssertTrue(self.mockMessagePersistence.invokedDeleteMessagesWithOlderTimestampParameters!.timestamp < Date().addingTimeInterval(-30))
            exp2.fulfill()
        }
        
        sut.messageArrived(data: data, topic: "fbon", qos: .two)
        waitForExpectations(timeout: 3, handler: nil)
    }
    
}

