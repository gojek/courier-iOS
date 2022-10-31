import Foundation
@testable import CourierCore
@testable import CourierMQTT

class MockMessageAdapter: MessageAdapter {

    var invokedContentTypeGetter = false
    var invokedContentTypeGetterCount = 0
    var stubbedContentType: String! = ""

    var contentType: String {
        invokedContentTypeGetter = true
        invokedContentTypeGetterCount += 1
        return stubbedContentType
    }

    var invokedFromMessage = false
    var invokedFromMessageCount = 0
    var invokedFromMessageParameters: (message: Data, topic: String)?
    var invokedFromMessageParametersList = [(message: Data, topic: String)]()
    var stubbedFromMessageError: Error?
    var stubbedFromMessageResult: Any!

    func fromMessage<T>(_ message: Data, topic: String) throws -> T {
        invokedFromMessage = true
        invokedFromMessageCount += 1
        invokedFromMessageParameters = (message, topic)
        invokedFromMessageParametersList.append((message, topic))
        if let error = stubbedFromMessageError {
            throw error
        }
        return stubbedFromMessageResult as! T
    }

    var invokedToMessage = false
    var invokedToMessageCount = 0
    var invokedToMessageParameters: (data: Any, topic: String)?
    var invokedToMessageParametersList = [(data: Any, topic: String)]()
    var stubbedToMessageError: Error?
    var stubbedToMessageResult: Data!

    func toMessage<T>(data: T, topic: String) throws -> Data {
        invokedToMessage = true
        invokedToMessageCount += 1
        invokedToMessageParameters = (data, topic)
        invokedToMessageParametersList.append((data, topic))
        if let error = stubbedToMessageError {
            throw error
        }
        return stubbedToMessageResult
    }
}
