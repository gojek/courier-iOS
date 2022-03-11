import Foundation
import Reachability
@testable import CourierCore
@testable import CourierMQTT

class MockMQTTClientFactory: IMQTTClientFactory {

    var invokedMakeClient = false
    var invokedMakeClientCount = 0
    var invokedMakeClientParameters: (configuration: IMQTTConfiguration, reachability: Reachability?, useAppDidEnterBGAndWillEnterFGNotification: Bool, dispatchQueue: DispatchQueue)?
    var invokedMakeClientParametersList = [(configuration: IMQTTConfiguration, reachability: Reachability?, useAppDidEnterBGAndWillEnterFGNotification: Bool, dispatchQueue: DispatchQueue)]()
    var stubbedMakeClientResult: IMQTTClient!

    func makeClient(configuration: IMQTTConfiguration, reachability: Reachability?, useAppDidEnterBGAndWillEnterFGNotification: Bool, dispatchQueue: DispatchQueue) -> IMQTTClient {
        invokedMakeClient = true
        invokedMakeClientCount += 1
        invokedMakeClientParameters = (configuration, reachability, useAppDidEnterBGAndWillEnterFGNotification, dispatchQueue)
        invokedMakeClientParametersList.append((configuration, reachability, useAppDidEnterBGAndWillEnterFGNotification, dispatchQueue))
        return stubbedMakeClientResult
    }
}
