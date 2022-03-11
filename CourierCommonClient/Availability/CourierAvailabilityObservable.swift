import CourierCore
import CourierMQTT
import Foundation

struct CourierAvailabilityObservable {
    let currentValueSubject: CurrentValueSubject<AvailabilityEvent?, Never>
    let policies: [CourierAvailabilityPolicy]
    let dispatchQueue: DispatchQueue
    private let courierEventManager: CourierEventManager?

    init(courierEventManager: CourierEventManager,
         availabilityPoliciesFactory: IAvailabilityPoliciesFactory,
         initialAvailabilityEvent: AvailabilityEvent? = nil,
         dispatchQueue: DispatchQueue) {
        currentValueSubject = CurrentValueSubject(initialAvailabilityEvent)
        self.courierEventManager = courierEventManager
        self.dispatchQueue = dispatchQueue
        policies = availabilityPoliciesFactory.createPolicies(dispatchQueue: dispatchQueue)
        policies.forEach { policy in
            policy.setAvailabilityListener(self)
            courierEventManager.addEventHandler(policy)
        }
    }

    func clearAvailabilityTask() {
        policies.forEach { $0.availabilityHandler.task?.cancel() }
    }

    func destroy() {
        clearAvailabilityTask()
        policies.forEach {
            courierEventManager?.removeEventHandler($0)
        }
    }
}

extension CourierAvailabilityObservable: CourierAvailabilityListener {
    func courierConnected() {
        printDebug("MQTT - COURIER: Availability - Courier Connected")
        updateCurrentValueSubject { currentValueSubject.send(.courierConnected) }
    }

    func courierDisconnected() {
        printDebug("MQTT - COURIER: Availability - Courier Disconnected")
        updateCurrentValueSubject { currentValueSubject.send(.courierDisconnected) }
    }

    func courierAvailable() {
        printDebug("MQTT - COURIER: Availability - Courier Available")
        updateCurrentValueSubject { currentValueSubject.send(.courierAvailable) }
    }

    func courierUnavailable() {
        printDebug("MQTT - COURIER: Availability - Courier Unavailable")
        updateCurrentValueSubject { currentValueSubject.send(.courierUnavailable) }
    }

    func connectionServiceAvailable() {
        printDebug("MQTT - COURIER: Availability - Connection Service Available")
        updateCurrentValueSubject { currentValueSubject.send(.connectionServiceAvailable) }
    }

    func connectionServiceUnavailable() {
        printDebug("MQTT - COURIER: Availability - Connection Service Unavailable")
        updateCurrentValueSubject { currentValueSubject.send(.connectionServiceUnavailable) }
    }

    func courierIdle() {
        printDebug("MQTT - COURIER: Availability - Courier Idle")
        updateCurrentValueSubject { currentValueSubject.send(.courierIdle) }
    }

    func courierNotIdle() {
        printDebug("MQTT - COURIER: Availability - Courier Not Idle")
        updateCurrentValueSubject { currentValueSubject.send(.courierNotIdle) }
    }

    func courierCustomAvailability(event: AnyHashable) {
        printDebug("MQTT - COURIER: Availability - \(event)")
        updateCurrentValueSubject { currentValueSubject.send(.custom(event)) }
    }

    private func updateCurrentValueSubject(handler: @escaping () -> Void) {
        dispatchQueue.async { handler() }
    }

}
