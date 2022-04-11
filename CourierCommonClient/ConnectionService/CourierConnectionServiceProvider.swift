import CourierCore
import Foundation
import UIKit

enum AuthResponseCachingType: Int {
    case noop = 0
    case inMemory = 1
    case disk = 2
}

final class CourierConnectionServiceProvider: IConnectionServiceProvider {

    private let cachingType: AuthResponseCachingType
    private let userDefaults: UserDefaults
    private let userDefaultsKey: String

    private let deviceIdProvider: () -> String
    private let userIdProvider: () -> String
    private let fetchURLProvider: ConnectionServiceURLProvider
    private let courierConfig: ICourierConfig

    private var _cachedAuthResponse: Atomic<AuthResponse?>
    private(set) var cachedAuthResponse: AuthResponse? {
        get { _cachedAuthResponse.value }
        set {
            _cachedAuthResponse.mutate { $0 = newValue }

            guard cachingType == .disk else { return }
            if let newValue = newValue, let data = try? JSONEncoder().encode(newValue) {
                userDefaults.set(data, forKey: userDefaultsKey)
            } else {
                userDefaults.removeObject(forKey: userDefaultsKey)
            }
        }
    }

    var extraIdProvider: (() -> String?)?
    let bundleIDProvider: (() -> String?)?

    var clientId: String {
        var id = "\(deviceId):\(userId)"
        if let extraId = extraIdProvider?(), !extraId.isEmpty {
            printDebug("COURIER - Auth Service: ClientID ExtraID: \(extraId)")
            id += ":\(extraId)"
        }

        if let bundleID = bundleIDProvider?() {
            id += ":\(bundleID)"
        }
        printDebug("COURIER - Auth Service: Connecting with clientID: \(id)")
        return id
    }

    public private(set) var existingConnectOptions: ConnectOptions?

    private var deviceId: String {
        let deviceID = deviceIdProvider()
        printDebug("COURIER - Auth Service: ClientID DeviceID: \(deviceID)")
        return deviceID
    }

    private var userId: String {
        let userID = userIdProvider()
        printDebug("COURIER - Auth Service: ClientID UserID: \(userID)")
        return userID
    }

    private var endpoint: String { "customer/v1/token" }

    init(
        deviceIdProvider: @escaping () -> String = { UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString },
        userIdProvider: @escaping () -> String,
        connectionServiceURLProvider: @escaping ConnectionServiceURLProvider,
        courierConfig: ICourierConfig,
        tokenCachingMechanismRawValue: Int = AuthResponseCachingType.noop.rawValue,
        userDefaults: UserDefaults = .standard,
        userDefaultsKey: String = "Courier.ConnectionServiceResponse",
        extraIdProvider: (() -> String?)? = nil,
        bundleIDProvider: (() -> String?)? = nil
    ) {
        self.deviceIdProvider = deviceIdProvider
        self.userIdProvider = userIdProvider
        self.fetchURLProvider = connectionServiceURLProvider
        self.courierConfig = courierConfig
        self.cachingType = AuthResponseCachingType(rawValue: tokenCachingMechanismRawValue) ?? .noop
        self.userDefaults = userDefaults
        self.userDefaultsKey = userDefaultsKey
        self.extraIdProvider = extraIdProvider
        self.bundleIDProvider = bundleIDProvider

        if cachingType == .disk, let data = userDefaults.data(forKey: userDefaultsKey),
           let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) {
            self._cachedAuthResponse = Atomic(authResponse)
        } else {
            userDefaults.removeObject(forKey: userDefaultsKey)
            self._cachedAuthResponse = Atomic(nil)
        }
    }

    func getConnectOptions(completion: @escaping (Result<ConnectOptions, AuthError>) -> Void) {
        executeRequest { [weak self] (response: AuthResponse, isCache: Bool) in
            guard let connectOptions = self?.getConnectOptions(with: response, isCache: isCache) else {
                completion(.failure(.otherError(CourierError.connectOptionsNilError.asNSError)))
                return
            }
            self?.existingConnectOptions = connectOptions
            completion(.success(connectOptions))
        } failure: { [weak self] response, _, error in
            self?.existingConnectOptions = nil
            if let statusCode = response?.statusCode {
                completion(.failure(.httpError(statusCode: statusCode)))
            } else {
                completion(.failure(.otherError(error)))
            }
        }
    }

    func clearCachedAuthResponse() {
        printDebug("COURIER: Invalidate Auth Response Cache")
        self.cachedAuthResponse = nil
    }

    private func getConnectOptions(with response: AuthResponse, isCache: Bool) -> ConnectOptions {
        ConnectOptions(
            host: response.broker.host,
            port: UInt16(response.broker.port),
            keepAlive: UInt16(courierConfig.pingInterval),
            clientId: clientId,
            username: userId,
            password: response.token,
            isCleanSession: courierConfig.isCleanSessionEnabled,
            isCache: isCache
        )
    }

    private func executeRequest(success: @escaping (AuthResponse, Bool) -> Void, failure: @escaping (HTTPURLResponse?, Any?, NSError) -> Void) {
        if cachingType != .noop, let cachedAuthResponse = self.cachedAuthResponse {
            printDebug("COURIER: Auth response from cache")
            success(cachedAuthResponse, true)
            return
        }

        fetchURLProvider(courierConfig.baseURLString + endpoint, { [weak self] (_, response, object) in
            guard let statusCode = response?.statusCode, statusCode >= 200, statusCode <= 299 else {
                failure(response, object, NSError(domain: "CourierConnectionServiceProvider", code: -1, userInfo: nil))
                return
            }

            guard let data = object as? Data, let result = try? JSONDecoder().decode(AuthResponse.self, from: data) else {
                failure(response, object, NSError(domain: "CourierConnectionServiceProvider", code: -1, userInfo: nil))
                return
            }

            if let self = self, self.cachingType != .noop {
                self.cachedAuthResponse = result
            }

            success(result, false)
        }, { (response, object, error) -> Void in
            failure(response, object, error)
        })
    }
}

struct AuthResponse: Codable {
    let token: String
    let broker: Broker
    let expiryInSec: TimeInterval
    let timestamp: Date = .init()

    enum CodingKeys: String, CodingKey {
        case token
        case broker
        case expiryInSec = "expiry_in_sec"
    }

    init(token: String, broker: AuthResponse.Broker, expiryInSec: TimeInterval) {
        self.token = token
        self.broker = broker
        self.expiryInSec = expiryInSec
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decodeIfPresent(String.self, forKey: .token) ?? ""
        broker = try values.decodeIfPresent(Broker.self, forKey: .broker) ?? .init(host: "", port: 0)
        expiryInSec = try values.decodeIfPresent(TimeInterval.self, forKey: .expiryInSec) ?? 0
    }

    struct Broker: Codable {
        let host: String
        let port: Int

        enum CodingKeys: String, CodingKey {
            case host
            case port
        }

        init(host: String, port: Int) {
            self.host = host
            self.port = port
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            host = try values.decodeIfPresent(String.self, forKey: .host) ?? ""
            port = try values.decodeIfPresent(Int.self, forKey: .port) ?? 0
        }
    }
}
