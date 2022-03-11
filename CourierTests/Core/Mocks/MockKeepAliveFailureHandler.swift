import Foundation
@testable import CourierCore
@testable import CourierMQTT
class MockKeepAliveFailureHandler: KeepAliveFailureHandler {

    var invokedHandleKeepAliveFailure = false
    var invokedHandleKeepAliveFailureCount = 0

    func handleKeepAliveFailure() {
        invokedHandleKeepAliveFailure = true
        invokedHandleKeepAliveFailureCount += 1
    }
}
