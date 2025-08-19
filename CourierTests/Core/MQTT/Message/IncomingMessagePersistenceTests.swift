import XCTest
import CoreData
@testable import CourierMQTT

class IncomingMessagePersistenceTests: XCTestCase {
    
    var sut: IncomingMessagePersistence!
    
    override func setUp() {
        sut = IncomingMessagePersistence()
        sut.deleteAllMessages()
    }

    func testSaveMessage() {
        let data = stubData
        let message = stub
        XCTAssertNoThrow(try sut.saveMessage(message))
        
        let result = sut.getAllMessages(["fbon1"])[0]
        XCTAssertEqual(result.id, message.id)
        XCTAssertEqual(result.timestamp, message.timestamp)
        XCTAssertEqual(result.topic, message.topic)
        XCTAssertEqual(result.qos, message.qos)
        XCTAssertEqual(result.data, data)
    }
    
    func testGetAllMessagesWithTopicsSortedByTimestampAscending() throws {
        let data = stubData
        let messages = stubs
        
        XCTAssertNoThrow(try messages.forEach {
            XCTAssertNoThrow(try sut.saveMessage($0))
        })
        
        let results = sut.getAllMessages(["fbon1", "fbon2", "fbon3"])
        results.enumerated().forEach {
            XCTAssertEqual($1.id, messages[$0].id)
            XCTAssertEqual($1.timestamp, messages[$0].timestamp)
            XCTAssertEqual($1.topic, messages[$0].topic)
            XCTAssertEqual($1.qos, messages[$0].qos)
            XCTAssertEqual($1.data, data)
        }
    }
    
    func testDeleteMessagesWithIDs() {
        let messages = stubs
        XCTAssertNoThrow(try messages.forEach {
            XCTAssertNoThrow(try sut.saveMessage($0))
        })
        
        let id1 = messages[0].id
        let id2 = messages[1].id
        let id3 = messages[2].id
        
        sut.deleteMessages([id1, id2, id3])
        
        let results = sut.getAllMessages(["fbon1", "fbon2", "fbon3"])
        XCTAssertEqual(results.count, messages.count - 3)
    }
    
    func testDeleteMessageWithOlderTimestamp() {
        let message = MQTTPacket(data: stubData, topic: "fbon1", qos: .zero, timestamp: Date().addingTimeInterval(-5))
        XCTAssertNoThrow(try sut.saveMessage(message))
        
        let results = sut.getAllMessages([message.topic])
        XCTAssertEqual(results.count, 1)
        
        sut.deleteMessagesWithOlderTimestamp(Date())
        
        let results2 = sut.getAllMessages([message.topic])
        XCTAssertEqual(results2.count, 0)
    }
    
    func testDeleteMessageWithOlderTimestampShouldFailedIfTimestampInFuture() {
        let message = MQTTPacket(data: stubData, topic: "fbon1", qos: .zero, timestamp: Date().addingTimeInterval(10))
        XCTAssertNoThrow(try sut.saveMessage(message))
        
        let results = sut.getAllMessages([message.topic])
        XCTAssertEqual(results.count, 1)
        
        sut.deleteMessagesWithOlderTimestamp(Date())
        
        let results2 = sut.getAllMessages([message.topic])
        XCTAssertEqual(results2.count, 1)
    }
    
    func testDeleteAllMessages() {
        let messages = stubs
        XCTAssertNoThrow(try messages.forEach {
            XCTAssertNoThrow(try sut.saveMessage($0))
        })
        let results = sut.getAllMessages(["fbon1", "fbon2", "fbon3"])
        XCTAssertEqual(results.count, messages.count)
        
        sut.deleteAllMessages()
        let results2 = sut.getAllMessages(["fbon1", "fbon2", "fbon3"])
        XCTAssertEqual(results2.count, 0)
    }
}

extension IncomingMessagePersistenceTests {
    
    var stubData: Data {
        "test".data(using: .utf8)!
    }
    
    var stubs: [MQTTPacket] {
        [
            MQTTPacket(data: stubData, topic: "fbon1", qos: .zero),
            MQTTPacket(data: stubData, topic: "fbon1", qos: .one),
            MQTTPacket(data: stubData, topic: "fbon2", qos: .one),
            MQTTPacket(data: stubData, topic: "fbon2", qos: .two),
            MQTTPacket(data: stubData, topic: "fbon3", qos: .two),
            MQTTPacket(data: stubData, topic: "fbon3", qos: .zero)
        ]
    }
    
    var stub: MQTTPacket {
        stubs[0]
    }
}

