import CourierCore
import Foundation

class CourierConnectStatusPolicy: CourierAvailabilityPolicy {
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

extension CourierConnectStatusPolicy {

    func onEvent(_ event: CourierEvent) {
        switch event {
        case .connectionUnavailable:
            onConnectionUnavailable()

        case .connectionAvailable:
            onConnectionAvailable()

        case .connectionSuccess:
            onConnectSuccess()

        case let .connectionFailure(error):
            onConnectFailure(error: error)

        case let .connectionLost(error, _, _):
            onConnectionLost(error: error)

        default: break
        }
    }

    private func onConnectionUnavailable() {
        handleUnavailableEvent()
    }

    private func onConnectionAvailable() {
        availabilityHandler.task?.cancel()
        availabilityHandler.task = nil

        if !policyConfig.isShadowMode {
            courierAvailabilityListener?.courierConnected()
        }
    }

    private func onConnectSuccess() {
        availabilityHandler.task?.cancel()
        availabilityHandler.task = nil

        if !policyConfig.isShadowMode {
            courierAvailabilityListener?.courierConnected()
        }
    }

    private func onConnectFailure(error _: Error?) {
        handleUnavailableEvent()
    }

    private func onConnectionLost(error _: Error?) {
        handleUnavailableEvent()
    }

    private func handleUnavailableEvent() {
        if let task = availabilityHandler.task, !task.isCancelled {
            return
        }
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self, let task = self.availabilityHandler.task, !task.isCancelled else { return }
            if !self.policyConfig.isShadowMode {
                self.courierAvailabilityListener?.courierDisconnected()
            }
            self.availabilityHandler.task = nil
        }
        availabilityHandler.task = workItem
        dispatchQueue.asyncAfter(deadline: .now() + TimeInterval(policyConfig.fallbackDelaySeconds), execute: workItem)
    }
}
