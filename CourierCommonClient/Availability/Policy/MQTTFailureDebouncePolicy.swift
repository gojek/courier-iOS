import CourierCore
import Foundation

class MQTTFailureDebouncePolicy: CourierAvailabilityPolicy {
    let policyConfig: CourierAvailabilityPolicyConfig
    private(set) var courierAvailabilityListener: CourierAvailabilityListener?
    var availabilityHandler: TaskWorkItemHandler
    private let dispatchQueue: DispatchQueue

    init(policyConfig: CourierAvailabilityPolicyConfig,
         availabilityHandler: TaskWorkItemHandler = .init(),
         dispatchQueue: DispatchQueue = .main) {
        self.policyConfig = policyConfig
        self.availabilityHandler = availabilityHandler
        self.dispatchQueue = dispatchQueue
    }

    func setAvailabilityListener(_ listener: CourierAvailabilityListener) {
        courierAvailabilityListener = listener
    }

    deinit {
        availabilityHandler.task?.cancel()
        availabilityHandler.task = nil
    }
}

extension MQTTFailureDebouncePolicy {

    func onEvent(_ event: CourierEvent) {
        switch event {
        case .connectionSuccess:
            onConnectSuccess()

        case .connectionAttempt:
            onConnectAttempt()

        case let .connectionLost(error, _, _):
            onConnectionLost(error: error)

        case let .connectionFailure(error):
            onConnectFailure(error: error)

        default: break
        }
    }

    private func onConnectSuccess() {
        availabilityHandler.task?.cancel()
        availabilityHandler.task = nil

        if !policyConfig.isShadowMode {
            courierAvailabilityListener?.courierAvailable()
        }
    }

    private func onConnectAttempt() {
        handleUnavailableEvent(error: nil)
    }

    private func onConnectionLost(error: Error?) {
        handleUnavailableEvent(error: error)
    }

    private func onConnectFailure(error: Error?) {
        handleUnavailableEvent(error: error)
    }

    private func handleUnavailableEvent(error _: Error?) {
        if let task = availabilityHandler.task, !task.isCancelled {
            return
        }
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self, let task = self.availabilityHandler.task, !task.isCancelled else { return }
            if !self.policyConfig.isShadowMode {
                self.courierAvailabilityListener?.courierUnavailable()
            }
            self.availabilityHandler.task = nil
        }
        availabilityHandler.task = workItem
        dispatchQueue.asyncAfter(deadline: .now() + TimeInterval(policyConfig.fallbackDelaySeconds), execute: workItem)
    }
}
