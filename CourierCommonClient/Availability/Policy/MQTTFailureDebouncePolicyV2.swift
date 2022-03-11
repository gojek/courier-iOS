import CourierCore
import Foundation

class MQTTFailureDebouncePolicyV2: CourierAvailabilityPolicy {
    let policyConfig: CourierAvailabilityPolicyConfig
    private(set) var courierAvailabilityListener: CourierAvailabilityListener?
    var availabilityHandler: TaskWorkItemHandler
    private let dispatchQueue: DispatchQueue
    private var subscribeAssertion: ((String) -> Bool)

    init(policyConfig: CourierAvailabilityPolicyConfig,
         availabilityHandler: TaskWorkItemHandler = .init(),
         subscribeAssertion: @escaping (String) -> Bool = { _ in true },
         dispatchQueue: DispatchQueue = .main) {
        self.policyConfig = policyConfig
        self.availabilityHandler = availabilityHandler
        self.dispatchQueue = dispatchQueue
        self.subscribeAssertion = subscribeAssertion
    }

    func setAvailabilityListener(_ listener: CourierAvailabilityListener) {
        courierAvailabilityListener = listener
    }

    deinit {
        availabilityHandler.task?.cancel()
        availabilityHandler.task = nil
    }
}

extension MQTTFailureDebouncePolicyV2 {

    func onEvent(_ event: CourierEvent) {
        switch event {
        case .connectionAttempt:
            schedulePolicy()

        case .connectionDisconnect:
            cancelPolicy()

        case .unsubscribeAttempt(let topic),
             .subscribeAttempt(let topic):
            if subscribeAssertion(topic) {
                cancelPolicy()
            }

        default: break
        }
    }

    private func cancelPolicy() {
        availabilityHandler.task?.cancel()
        availabilityHandler.task = nil

        if !policyConfig.isShadowMode {
            courierAvailabilityListener?.courierAvailable()
        }
    }

    private func schedulePolicy() {
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
