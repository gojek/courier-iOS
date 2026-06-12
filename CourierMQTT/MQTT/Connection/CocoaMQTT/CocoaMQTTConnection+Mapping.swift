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
    /// CONNACK was not received within the configured connect timeout.
    /// Code mirrors the v3 framework's `MQTTSessionErrorConnectTimeout`.
    case connectTimeout
    /// No inbound activity received after an outbound packet that expected a
    /// response, within the configured inactivity window. Mirrors v3
    /// `MQTTSessionErrorInactivityTimeout`.
    case inactivityTimeout
    /// No inbound activity at all within the configured read-timeout window.
    /// Mirrors v3 `MQTTSessionErrorReadTimeout`.
    case readTimeout

    var code: Int {
        switch self {
        case .socketConnectFailed:
            return -1
        case let .connectionRefused(reasonCode):
            return Int(reasonCode.rawValue)
        case .connectTimeout:
            return 101
        case .inactivityTimeout:
            return 102
        case .readTimeout:
            return 103
        }
    }

    var message: String {
        switch self {
        case .socketConnectFailed:
            return "Failed to initiate socket connection to the MQTT broker"
        case let .connectionRefused(reasonCode):
            return "MQTT broker refused the connection with CONNACK reason code \(reasonCode.rawValue)"
        case .connectTimeout:
            return "MQTT Session Connect Timeout"
        case .inactivityTimeout:
            return "MQTT Session Inactivity Timeout"
        case .readTimeout:
            return "MQTT Session Read Timeout"
        }
    }

    var asNSError: NSError {
        NSError(domain: Self.errorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}

extension QoS {
    /// Whether an outbound PUBLISH of this QoS expects an inbound acknowledgement
    /// (PUBACK/PUBREC) and should therefore arm the fast-reconnect watchdog.
    ///
    /// Mirrors the v3 framework's `shouldLogForFastReconnectTimestampIfValid`:
    /// QoS0 and the "retry without persistence" variant do not arm it.
    var armsFastReconnect: Bool {
        switch self {
        case .zero, .oneWithoutPersistenceAndRetry:
            return false
        case .one, .two, .oneWithoutPersistenceAndNoRetry:
            return true
        }
    }
}

/// ALPN protocol negotiation key understood by the underlying
/// `MqttCocoaAsyncSocket` (`MGCDAsyncSocketSSLALPN`). Declared as a literal so the
/// v5 connection does not need to import the socket module directly.
let cocoaMQTTSSLALPNSettingKey = "MGCDAsyncSocketSSLALPN"
