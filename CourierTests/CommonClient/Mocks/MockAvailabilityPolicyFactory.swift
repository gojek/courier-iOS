import Foundation
@testable import CourierCore
@testable import CourierMQTT
@testable import CourierCommonClient

class MockAvailabilityPoliciesFactory: IAvailabilityPoliciesFactory {

    var invokedCreatePolicies = false
    var invokedCreatePoliciesCount = 0
    var invokedCreatePoliciesParameters: (dispatchQueue: DispatchQueue, Void)?
    var invokedCreatePoliciesParametersList = [(dispatchQueue: DispatchQueue, Void)]()
    var stubbedCreatePoliciesResult: [CourierAvailabilityPolicy]! = []

    func createPolicies(
        dispatchQueue: DispatchQueue
    ) -> [CourierAvailabilityPolicy] {
        invokedCreatePolicies = true
        invokedCreatePoliciesCount += 1
        invokedCreatePoliciesParameters = (dispatchQueue, ())
        invokedCreatePoliciesParametersList.append((dispatchQueue, ()))
        return stubbedCreatePoliciesResult
    }
}
