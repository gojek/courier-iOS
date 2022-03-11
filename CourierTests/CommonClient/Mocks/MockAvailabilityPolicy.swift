import Foundation
@testable import CourierCore
@testable import CourierMQTT
@testable import CourierCommonClient

class MockAvailabilityPolicy: CourierAvailabilityPolicy {

    var invokedAvailabilityHandlerGetter = false
    var invokedAvailabilityHandlerGetterCount = 0
    var stubbedAvailabilityHandler: TaskWorkItemHandler!

    var availabilityHandler: TaskWorkItemHandler {
        invokedAvailabilityHandlerGetter = true
        invokedAvailabilityHandlerGetterCount += 1
        return stubbedAvailabilityHandler
    }

    var invokedSetAvailabilityListener = false
    var invokedSetAvailabilityListenerCount = 0
    var invokedSetAvailabilityListenerParameters: (listener: CourierAvailabilityListener, Void)?
    var invokedSetAvailabilityListenerParametersList = [(listener: CourierAvailabilityListener, Void)]()

    func setAvailabilityListener(_ listener: CourierAvailabilityListener) {
        invokedSetAvailabilityListener = true
        invokedSetAvailabilityListenerCount += 1
        invokedSetAvailabilityListenerParameters = (listener, ())
        invokedSetAvailabilityListenerParametersList.append((listener, ()))
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
