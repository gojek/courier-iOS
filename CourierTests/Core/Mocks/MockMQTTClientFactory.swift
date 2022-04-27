import Foundation
import Reachability
@testable import CourierCore
@testable import CourierMQTT

class MockMQTTClientFactory: IMQTTClientFactory {

    var invokedMakeClient = false
    var invokedMakeClientCount = 0
    var invokedMakeClientParameters: (configuration: IMQTTConfiguration, reachability: Reachability?, dispatchQueue: DispatchQueue)?
    var invokedMakeClientParametersList = [(configuration: IMQTTConfiguration, reachability: Reachability?, dispatchQueue: DispatchQueue)]()
    var stubbedMakeClientResult: IMQTTClient!

    func makeClient(configuration: IMQTTConfiguration, reachability: Reachability?, dispatchQueue: DispatchQueue) -> IMQTTClient {
        invokedMakeClient = true
        invokedMakeClientCount += 1
        invokedMakeClientParameters = (configuration, reachability, dispatchQueue)
        invokedMakeClientParametersList.append((configuration, reachability, dispatchQueue))
        return stubbedMakeClientResult
    }
}
