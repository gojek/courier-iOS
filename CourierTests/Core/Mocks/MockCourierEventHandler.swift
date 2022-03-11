import Foundation
@testable import CourierCore
@testable import CourierMQTT
class MockCourierEventHandler: ICourierEventHandler {

    var invokedReset = false
    var invokedResetCount = 0

    func reset() {
        invokedReset = true
        invokedResetCount += 1
    }

    var invokedOnEvent = false
    var invokedOnEventCount = 0
    var invokedOnEventParameters: (event: CourierEvent, Void)?
    var invokedOnEventParametersList = [(event: CourierEvent, Void)?]()

    func onEvent(_ event: CourierEvent) {
        invokedOnEvent = true
        invokedOnEventCount += 1
        invokedOnEventParameters = (event, ())
        invokedOnEventParametersList.append((event, ()))
    }
}
