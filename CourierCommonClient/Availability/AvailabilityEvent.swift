import Foundation

public enum AvailabilityEvent {
    case courierAvailable
    case courierUnavailable
    case connectionServiceUnavailable
    case connectionServiceAvailable
    case courierConnected
    case courierDisconnected
    case courierIdle
    case courierNotIdle
    case custom(AnyHashable)
}

extension AvailabilityEvent: Equatable {

    public static func == (lhs: AvailabilityEvent, rhs: AvailabilityEvent) -> Bool {
        switch (lhs, rhs) {
        case (.courierAvailable, .courierAvailable): return true
        case (.courierUnavailable, .courierUnavailable): return true
        case (.courierConnected, .courierConnected): return true
        case (.connectionServiceAvailable, .connectionServiceAvailable): return true
        case (.connectionServiceUnavailable, .connectionServiceUnavailable): return true
        case (.courierDisconnected, .courierDisconnected): return true
        case (.courierIdle, .courierIdle): return true
        case (.courierNotIdle, .courierNotIdle): return true
        case (.custom(let a), .custom(let b)): return a == b
        default: return false
        }
    }

}
