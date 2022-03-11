import Foundation
@testable import CourierCore
@testable import CourierMQTT
class MockAuthFailureHandler: IAuthFailureHandler {

    var invokedHandleAuthFailure = false
    var invokedHandleAuthFailureCount = 0

    func handleAuthFailure() {
        invokedHandleAuthFailure = true
        invokedHandleAuthFailureCount += 1
    }
}
