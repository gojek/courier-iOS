import XCTest
@testable import CourierCore
@testable import CourierMQTT
import Combine

class MQTTMessageReceiveListenerTests: XCTestCase {

    var sut: MqttMessageReceiverListener!
    var publishSubject: PassthroughSubject<MQTTPacket, Never>!
    var dispatchQueue: DispatchQueue!
    var mockMessagePersistence: MockIncomingMessagePersistence!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        publishSubject = PassthroughSubject<MQTTPacket, Never>()
        dispatchQueue = .main
        mockMessagePersistence = MockIncomingMessagePersistence()
        
        sut = MqttMessageReceiverListener(publishSubject: publishSubject, publishSubjectDispatchQueue: dispatchQueue)
    }
    
    func testOnMessageArrived() async throws {
        let exp = expectation(description: "messageArrived")
        let data = "hello".data(using: .utf8)!
        
        publishSubject
            .sink { packet in
                XCTAssertEqual(String(data: packet.data, encoding: .utf8), "hello")
                XCTAssertEqual(packet.topic, "fbon")
                XCTAssertEqual(packet.qos, .two)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.messageArrived(data: data, topic: "fbon", qos: .two)
        await fulfillment(of: [exp], timeout: 0.1)
    }
    
    func testAddPublisherDict() async throws {
        let exp = expectation(description: "messageArrivedIncomingMessagePersistence")
        let data = "hello".data(using: .utf8)!

        sut = MqttMessageReceiverListener(publishSubject: publishSubject, publishSubjectDispatchQueue: dispatchQueue, incomingMessagePersistence: mockMessagePersistence, messagePersistenceTTLSeconds: 30, messageCleanupInterval: 10)
        mockMessagePersistence.stubbedGetAllMessagesResult = [MQTTPacket(data: data, topic: "fbon", qos: .two)]
        sut.addPublisherDict(topic: "fbon")
        XCTAssertEqual(sut.publisherTopicDict["fbon"], 1)
                
        publishSubject
            .sink { packet in
                XCTAssertTrue(self.mockMessagePersistence.invokedGetAllMessages)
                XCTAssertEqual(String(data: packet.data, encoding: .utf8), "hello")
                XCTAssertEqual(packet.topic, "fbon")
                XCTAssertEqual(packet.qos, .two)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [exp], timeout: 3)
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
    
    @MainActor
    func testOnMessageArrivedWithIncomingMessagePersistenceEnabled() async throws {
        let exp = expectation(description: "messageArrivedIncomingMessagePersistence")
        let exp2 = expectation(description: "messageArrivedIncomingMessagePersistence2")
        
        let data = "hello".data(using: .utf8)!
        
        sut = MqttMessageReceiverListener(publishSubject: publishSubject, publishSubjectDispatchQueue: dispatchQueue, incomingMessagePersistence: mockMessagePersistence, messagePersistenceTTLSeconds: 30, messageCleanupInterval: 0.5)
        mockMessagePersistence.stubbedGetAllMessagesResult = [MQTTPacket(data: data, topic: "fbon", qos: .two)]
        sut.messagePublisherDict["fbon", default: 0] += 1
        
        publishSubject
            .sink { packet in
                XCTAssertTrue(self.mockMessagePersistence.invokedGetAllMessages)
                XCTAssertEqual(String(data: packet.data, encoding: .utf8), "hello")
                XCTAssertEqual(packet.topic, "fbon")
                XCTAssertEqual(packet.qos, .two)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockMessagePersistence.invokedDeleteMessages)
            XCTAssertTrue(self.mockMessagePersistence.invokedDeleteMessagesWithOlderTimestamp)
            XCTAssertTrue(self.mockMessagePersistence.invokedDeleteMessagesWithOlderTimestampParameters!.timestamp < Date().addingTimeInterval(-30))
            exp2.fulfill()
        }
        
        sut.messageArrived(data: data, topic: "fbon", qos: .two)
        await fulfillment(of: [exp, exp2], timeout: 3)
    }
    
}
