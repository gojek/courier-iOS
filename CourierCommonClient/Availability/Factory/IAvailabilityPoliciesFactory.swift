import Foundation

public protocol IAvailabilityPoliciesFactory {
    func createPolicies(
        dispatchQueue: DispatchQueue
    ) -> [CourierAvailabilityPolicy]
}

public struct AvailabilityPoliciesFactory: IAvailabilityPoliciesFactory {
    let connectionServiceFallbackPolicyConfig: CourierAvailabilityPolicyConfig?
    let courierFallbackPolicyConfig: CourierAvailabilityPolicyConfig?
    let connectionStatusPolicyConfig: CourierAvailabilityPolicyConfig?
    let customPolicies: [CourierAvailabilityPolicy]
    let useCourierFallbackPolicyConfigV2: Bool
    let courierFallbackPolicyConfigV2SubscribeAssertion: ((String) -> Bool)?

    public init(connectionServiceFallbackPolicyConfig: CourierAvailabilityPolicyConfig?,
                courierFallbackPolicyConfig: CourierAvailabilityPolicyConfig?,
                connectionStatusPolicyConfig: CourierAvailabilityPolicyConfig?,
                useCourierFallbackPolicyConfigV2: Bool = false,
                courierFallbackPolicyConfigV2SubscribeAssertion: ((String) -> Bool)? = nil,
                customPolicies: [CourierAvailabilityPolicy] = []) {
        self.connectionServiceFallbackPolicyConfig = connectionServiceFallbackPolicyConfig
        self.courierFallbackPolicyConfig = courierFallbackPolicyConfig
        self.connectionStatusPolicyConfig = connectionStatusPolicyConfig
        self.customPolicies = customPolicies
        self.useCourierFallbackPolicyConfigV2 = useCourierFallbackPolicyConfigV2
        self.courierFallbackPolicyConfigV2SubscribeAssertion = courierFallbackPolicyConfigV2SubscribeAssertion
    }

    public func createPolicies(
        dispatchQueue: DispatchQueue
    ) -> [CourierAvailabilityPolicy] {
        var policies = [CourierAvailabilityPolicy]()
        if let courierFallbackPolicyConfig = courierFallbackPolicyConfig, courierFallbackPolicyConfig.policyEnabled {
            if useCourierFallbackPolicyConfigV2 {
                policies.append(
                    MQTTFailureDebouncePolicyV2(
                        policyConfig: courierFallbackPolicyConfig,
                        subscribeAssertion: { courierFallbackPolicyConfigV2SubscribeAssertion?($0) ?? true },
                        dispatchQueue: dispatchQueue)
                )
            } else {
                policies.append(
                    MQTTFailureDebouncePolicy(
                        policyConfig: courierFallbackPolicyConfig,
                        dispatchQueue: dispatchQueue
                    )
                )
            }
        }

        if let connectionServiceFallbackPolicyConfig = connectionServiceFallbackPolicyConfig, connectionServiceFallbackPolicyConfig.policyEnabled {
            policies.append(
                ConnectionServiceFailurePolicy(
                    policyConfig: connectionServiceFallbackPolicyConfig,
                    dispatchQueue: dispatchQueue
                )
            )
        }

        if let connectionStatusPolicyConfig = connectionStatusPolicyConfig, connectionStatusPolicyConfig.policyEnabled {
            policies.append(
                CourierConnectStatusPolicy(
                    policyConfig: connectionStatusPolicyConfig,
                    dispatchQueue: dispatchQueue
                )
            )
        }
        return policies + customPolicies
    }
}
