import Foundation
@testable import CourierCore
@testable import CourierMQTT
@testable import CourierCommonClient

class MockCourierAvailabilityListener: CourierAvailabilityListener {

    var invokedCourierAvailable = false
    var invokedCourierAvailableCount = 0

    func courierAvailable() {
        invokedCourierAvailable = true
        invokedCourierAvailableCount += 1
    }

    var invokedCourierUnavailable = false
    var invokedCourierUnavailableCount = 0

    func courierUnavailable() {
        invokedCourierUnavailable = true
        invokedCourierUnavailableCount += 1
    }

    var invokedConnectionServiceUnavailable = false
    var invokedConnectionServiceUnavailableCount = 0

    func connectionServiceUnavailable() {
        invokedConnectionServiceUnavailable = true
        invokedConnectionServiceUnavailableCount += 1
    }

    var invokedConnectionServiceAvailable = false
    var invokedConnectionServiceAvailableCount = 0

    func connectionServiceAvailable() {
        invokedConnectionServiceAvailable = true
        invokedConnectionServiceAvailableCount += 1
    }

    var invokedCourierConnected = false
    var invokedCourierConnectedCount = 0

    func courierConnected() {
        invokedCourierConnected = true
        invokedCourierConnectedCount += 1
    }

    var invokedCourierDisconnected = false
    var invokedCourierDisconnectedCount = 0

    func courierDisconnected() {
        invokedCourierDisconnected = true
        invokedCourierDisconnectedCount += 1
    }

    var invokedCourierIdle = false
    var invokedCourierIdleCount = 0

    func courierIdle() {
        invokedCourierIdle = true
        invokedCourierIdleCount += 1
    }

    var invokedCourierNotIdle = false
    var invokedCourierNotIdleCount = 0

    func courierNotIdle() {
        invokedCourierNotIdle = true
        invokedCourierNotIdleCount += 1
    }

    var invokedCourierCustomAvailability = false
    var invokedCourierCustomAvailabilityCount = 0
    var invokedCourierCustomAvailabilityParameters: (event: AnyHashable, Void)?
    var invokedCourierCustomAvailabilityParametersList = [(event: AnyHashable, Void)]()

    func courierCustomAvailability(event: AnyHashable) {
        invokedCourierCustomAvailability = true
        invokedCourierCustomAvailabilityCount += 1
        invokedCourierCustomAvailabilityParameters = (event, ())
        invokedCourierCustomAvailabilityParametersList.append((event, ()))
    }
}
