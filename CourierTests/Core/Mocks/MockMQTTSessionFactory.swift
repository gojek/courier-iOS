import Foundation
@testable import CourierCore
@testable import CourierMQTT
class MockMQTTSessionFactory: IMQTTSessionFactory {

    var invokedMakeSession = false
    var invokedMakeSessionCount = 0
    var stubbedMakeSessionResult: IMQTTSession!

    func makeSession() -> IMQTTSession {
        invokedMakeSession = true
        invokedMakeSessionCount += 1
        return stubbedMakeSessionResult
    }
}
