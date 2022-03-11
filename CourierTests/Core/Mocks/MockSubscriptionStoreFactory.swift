import Foundation
@testable import CourierCore
@testable import CourierMQTT

class MockSubscriptionStoreFactory: ISubscriptionStoreFactory {

    var invokedMakeStore = false
    var invokedMakeStoreCount = 0
    var invokedMakeStoreParameters: (topics: [String: QoS], isDiskPersistenceEnabled: Bool)?
    var invokedMakeStoreParametersList = [(topics: [String: QoS], isDiskPersistenceEnabled: Bool)]()
    var stubbedMakeStoreResult: ISubscriptionStore!

    func makeStore(topics: [String: QoS], isDiskPersistenceEnabled: Bool) -> ISubscriptionStore {
        invokedMakeStore = true
        invokedMakeStoreCount += 1
        invokedMakeStoreParameters = (topics, isDiskPersistenceEnabled)
        invokedMakeStoreParametersList.append((topics, isDiskPersistenceEnabled))
        return stubbedMakeStoreResult
    }
}
