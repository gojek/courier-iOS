import Foundation

public struct CourierAvailabilityPolicyConfig: Decodable {

    public let policyEnabled: Bool

    public let isShadowMode: Bool

    public let fallbackDelaySeconds: Int

    enum CodingKeys: String, CodingKey {
        case policyEnabled = "enabled"
        case fallbackDelaySeconds = "fallback_delay_seconds"
        case isShadowMode = "shadow_mode"
    }

    public init(policyEnabled: Bool = false,
                fallbackDelaySeconds: Int = 60,
                isShadowMode: Bool = false) {
        self.policyEnabled = policyEnabled
        self.fallbackDelaySeconds = fallbackDelaySeconds
        self.isShadowMode = isShadowMode
    }
}
