import Foundation
@testable import CourierCore
@testable import CourierMQTT

class MockSubscriptionStoreFactory: ISubscriptionStoreFactory {

    var invokedMakeStore = false
    var invokedMakeStoreCount = 0
    var invokedMakeStoreParameters: (topics: [String: QoS], ())?
    var invokedMakeStoreParametersList = [(topics: [String: QoS], Void)]()
    var stubbedMakeStoreResult: ISubscriptionStore!

    func makeStore(topics: [String: QoS]) -> ISubscriptionStore {
        invokedMakeStore = true
        invokedMakeStoreCount += 1
        invokedMakeStoreParameters = (topics, ())
        invokedMakeStoreParametersList.append((topics, ()))
        return stubbedMakeStoreResult
    }
}
