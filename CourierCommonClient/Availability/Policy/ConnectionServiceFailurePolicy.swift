import CourierCore
import Foundation

class ConnectionServiceFailurePolicy: CourierAvailabilityPolicy {
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

extension ConnectionServiceFailurePolicy {

    func onEvent(_ event: CourierEvent) {
        switch event {
        case .connectionAttempt:
            onConnectAttempt()
        case .connectionServiceAuthStart:
            onConnectionServiceAuthStart()
        default: break
        }
    }

    private func onConnectAttempt() {
        availabilityHandler.task?.cancel()
        availabilityHandler.task = nil

        if !policyConfig.isShadowMode {
            courierAvailabilityListener?.connectionServiceAvailable()
        }
    }

    private func onConnectionServiceAuthStart() {
        if let task = availabilityHandler.task, !task.isCancelled {
            return
        }
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self, let task = self.availabilityHandler.task, !task.isCancelled else { return }
            if !self.policyConfig.isShadowMode {
                self.courierAvailabilityListener?.connectionServiceUnavailable()
            }
            self.availabilityHandler.task = nil
        }
        availabilityHandler.task = workItem
        dispatchQueue.asyncAfter(deadline: .now() + TimeInterval(policyConfig.fallbackDelaySeconds), execute: workItem)
    }
}
