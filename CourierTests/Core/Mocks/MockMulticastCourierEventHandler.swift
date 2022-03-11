import Foundation
@testable import CourierCore
@testable import CourierMQTT
class MockMulticastCourierEventHandler: IMulticastCourierEventHandler {

    var invokedAddEventHandler = false
    var invokedAddEventHandlerCount = 0
    var invokedAddEventHandlerParameters: (handler: ICourierEventHandler, Void)?
    var invokedAddEventHandlerParametersList = [(handler: ICourierEventHandler, Void)]()

    func addEventHandler(_ handler: ICourierEventHandler) {
        invokedAddEventHandler = true
        invokedAddEventHandlerCount += 1
        invokedAddEventHandlerParameters = (handler, ())
        invokedAddEventHandlerParametersList.append((handler, ()))
    }

    var invokedRemoveEventHandler = false
    var invokedRemoveEventHandlerCount = 0
    var invokedRemoveEventHandlerParameters: (handler: ICourierEventHandler, Void)?
    var invokedRemoveEventHandlerParametersList = [(handler: ICourierEventHandler, Void)]()

    func removeEventHandler(_ handler: ICourierEventHandler) {
        invokedRemoveEventHandler = true
        invokedRemoveEventHandlerCount += 1
        invokedRemoveEventHandlerParameters = (handler, ())
        invokedRemoveEventHandlerParametersList.append((handler, ()))
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

    var invokedReset = false
    var invokedResetCount = 0

    func reset() {
        invokedReset = true
        invokedResetCount += 1
    }
}
