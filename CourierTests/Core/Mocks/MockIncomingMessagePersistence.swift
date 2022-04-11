import XCTest
@testable import CourierMQTT

class MockIncomingMessagePersistence: IncomingMessagePersistenceProtocol {

    var invokedSaveMessage = false
    var invokedSaveMessageCount = 0
    var invokedSaveMessageParameters: (message: MQTTPacket, Void)?
    var invokedSaveMessageParametersList = [(message: MQTTPacket, Void)]()
    var stubbedSaveMessageError: Error?

    func saveMessage(_ message: MQTTPacket) throws {
        invokedSaveMessage = true
        invokedSaveMessageCount += 1
        invokedSaveMessageParameters = (message, ())
        invokedSaveMessageParametersList.append((message, ()))
        if let error = stubbedSaveMessageError {
            throw error
        }
    }

    var invokedGetAllMessages = false
    var invokedGetAllMessagesCount = 0
    var invokedGetAllMessagesParameters: (topics: [String], Void)?
    var invokedGetAllMessagesParametersList = [(topics: [String], Void)]()
    var stubbedGetAllMessagesResult: [MQTTPacket]! = []

    func getAllMessages(_ topics: [String]) -> [MQTTPacket] {
        invokedGetAllMessages = true
        invokedGetAllMessagesCount += 1
        invokedGetAllMessagesParameters = (topics, ())
        invokedGetAllMessagesParametersList.append((topics, ()))
        return stubbedGetAllMessagesResult
    }

    var invokedDeleteAllMessages = false
    var invokedDeleteAllMessagesCount = 0

    func deleteAllMessages() {
        invokedDeleteAllMessages = true
        invokedDeleteAllMessagesCount += 1
    }

    var invokedDeleteMessages = false
    var invokedDeleteMessagesCount = 0
    var invokedDeleteMessagesParameters: (ids: [String], Void)?
    var invokedDeleteMessagesParametersList = [(ids: [String], Void)]()

    func deleteMessages(_ ids: [String]) {
        invokedDeleteMessages = true
        invokedDeleteMessagesCount += 1
        invokedDeleteMessagesParameters = (ids, ())
        invokedDeleteMessagesParametersList.append((ids, ()))
    }

    var invokedDeleteMessagesWithOlderTimestamp = false
    var invokedDeleteMessagesWithOlderTimestampCount = 0
    var invokedDeleteMessagesWithOlderTimestampParameters: (timestamp: Date, Void)?
    var invokedDeleteMessagesWithOlderTimestampParametersList = [(timestamp: Date, Void)]()

    func deleteMessagesWithOlderTimestamp(_ timestamp: Date) {
        invokedDeleteMessagesWithOlderTimestamp = true
        invokedDeleteMessagesWithOlderTimestampCount += 1
        invokedDeleteMessagesWithOlderTimestampParameters = (timestamp, ())
        invokedDeleteMessagesWithOlderTimestampParametersList.append((timestamp, ()))
    }
}

