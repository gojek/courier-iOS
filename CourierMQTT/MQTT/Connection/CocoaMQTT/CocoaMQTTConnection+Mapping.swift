import CocoaMQTT
import CourierCore
import Foundation

extension QoS {
    var cocoaMQTTQoS: CocoaMQTTQoS {
        switch self {
        case .zero:
            return .qos0
        case .one, .oneWithoutPersistenceAndNoRetry, .oneWithoutPersistenceAndRetry:
            return .qos1
        case .two:
            return .qos2
        }
    }
}

extension CocoaMQTTQoS {
    var courierQoS: QoS {
        switch self {
        case .qos0:
            return .zero
        case .qos1:
            return .one
        case .qos2:
            return .two
        @unknown default:
            return .zero
        }
    }
}

extension CocoaMQTTCONNACKReasonCode {
    /// CONNACK reason codes that map to an authentication failure, mirroring the
    /// v3 handling of `connackBadUsernameOrPassword` / `connackNotAuthorized`.
    var isAuthenticationFailure: Bool {
        switch self {
        case .badUsernameOrPassword, .notAuthorized, .badAuthenticationMethod:
            return true
        default:
            return false
        }
    }
}

enum CocoaMQTTConnectionError: Error {
    static let errorDomain = "CocoaMQTTConnectionErrorDomain"

    /// The underlying socket failed to start connecting.
    case socketConnectFailed
    /// The broker rejected the CONNECT with a non-success CONNACK reason code.
    case connectionRefused(CocoaMQTTCONNACKReasonCode)

    var code: Int {
        switch self {
        case .socketConnectFailed:
            return -1
        case let .connectionRefused(reasonCode):
            return Int(reasonCode.rawValue)
        }
    }

    var message: String {
        switch self {
        case .socketConnectFailed:
            return "Failed to initiate socket connection to the MQTT broker"
        case let .connectionRefused(reasonCode):
            return "MQTT broker refused the connection with CONNACK reason code \(reasonCode.rawValue)"
        }
    }

    var asNSError: NSError {
        NSError(domain: Self.errorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
