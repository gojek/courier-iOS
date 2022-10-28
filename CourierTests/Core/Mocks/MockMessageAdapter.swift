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
    var invokedFromMessageParameters: (message: Data, Void)?
    var invokedFromMessageParametersList = [(message: Data, Void)]()
    var stubbedFromMessageError: Error?
    var stubbedFromMessageResult: Any!

    func fromMessage<T>(_ message: Data) throws -> T {
        invokedFromMessage = true
        invokedFromMessageCount += 1
        invokedFromMessageParameters = (message, ())
        invokedFromMessageParametersList.append((message, ()))
        if let error = stubbedFromMessageError {
            throw error
        }
        return stubbedFromMessageResult as! T
    }

    var invokedToMessage = false
    var invokedToMessageCount = 0
    var invokedToMessageParameters: (data: Any, Void)?
    var invokedToMessageParametersList = [(data: Any, Void)]()
    var stubbedToMessageError: Error?
    var stubbedToMessageResult: Data!

    func toMessage<T>(data: T) throws -> Data {
        invokedToMessage = true
        invokedToMessageCount += 1
        invokedToMessageParameters = (data, ())
        invokedToMessageParametersList.append((data, ()))
        if let error = stubbedToMessageError {
            throw error
        }
        return stubbedToMessageResult
    }
}
