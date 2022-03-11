import Foundation
import MQTTClientGJ
@testable import CourierCore
@testable import CourierMQTT
class MockMQTTPersistenceFactory: IMQTTPersistenceFactory {

    var invokedMakePersistence = false
    var invokedMakePersistenceCount = 0
    var stubbedMakePersistenceResult: MQTTPersistence!

    func makePersistence() -> MQTTPersistence {
        invokedMakePersistence = true
        invokedMakePersistenceCount += 1
        return stubbedMakePersistenceResult
    }
}
