import Foundation
@testable import CourierCore
@testable import CourierMQTT
class MockAuthRetryPolicy: IAuthRetryPolicy {

    var invokedShouldRetry = false
    var invokedShouldRetryCount = 0
    var invokedShouldRetryParameters: (error: Error, Void)?
    var invokedShouldRetryParametersList = [(error: Error, Void)]()
    var stubbedShouldRetryResult: Bool! = false

    func shouldRetry(error: Error) -> Bool {
        invokedShouldRetry = true
        invokedShouldRetryCount += 1
        invokedShouldRetryParameters = (error, ())
        invokedShouldRetryParametersList.append((error, ()))
        return stubbedShouldRetryResult
    }

    var invokedGetRetryTime = false
    var invokedGetRetryTimeCount = 0
    var stubbedGetRetryTimeResult: TimeInterval!

    func getRetryTime() -> TimeInterval {
        invokedGetRetryTime = true
        invokedGetRetryTimeCount += 1
        return stubbedGetRetryTimeResult
    }

    var invokedResetParams = false
    var invokedResetParamsCount = 0

    func resetParams() {
        invokedResetParams = true
        invokedResetParamsCount += 1
    }
}
