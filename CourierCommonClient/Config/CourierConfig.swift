import CourierMQTT
import Foundation

public typealias ConnectionServiceURLProvider = (_ urlString: String, _ success: @escaping (URLRequest, HTTPURLResponse?, Any?) -> Void, _ failure: @escaping (HTTPURLResponse?, Any?, NSError) -> Void) -> Void

public protocol ICourierConfig {

    var baseURLString: String { get }

    var userIdProvider: () -> String { get }

    var regionCodeProvider: () -> String { get }

    var pingInterval: Int { get }

    var isCleanSessionEnabled: Bool { get }

    var eventProbability: Int { get }

    var isSubscriptionPersistenceEnabled: Bool { get }

    var isDiskPersistenceEnabled: Bool { get }

    var isExtendedUsernameEnabled: Bool { get }

    func getMqttClientConfig(
        jsonDateFormatterProvider: () -> DateFormatter,
        courierTokenCachingMechanismRawValue: Int,
        autoReconnectInterval: Int,
        maxAutoReconnectInterval: Int,
        disableMQTTReconnectOnAuthFailure: Bool,
        useAppDidEnterBGAndWillEnterFGNotification: Bool,
        disableDisconnectOnConnectionUnavailable: Bool,
        enableAuthenticationTimeout: Bool,
        authenticationTimeoutInterval: TimeInterval,
        connectTimeoutPolicy: IConnectTimeoutPolicy,
        idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol,
        bundleIDProvider: (() -> String?)?,
        messagePersistenceTTLSeconds: TimeInterval,
        messageCleanupInterval: TimeInterval,
        connectionServiceURLProvider: @escaping ConnectionServiceURLProvider) -> MQTTClientConfig
}

public struct CourierConfig: ICourierConfig {

    public let baseURLString: String
    public let userIdProvider: () -> String
    public let regionCodeProvider: () -> String

    public let pingInterval: Int
    public let isCleanSessionEnabled: Bool
    public let eventProbability: Int
    public let isSubscriptionPersistenceEnabled: Bool
    public let isDiskPersistenceEnabled: Bool
    public let isExtendedUsernameEnabled: Bool

    public init(
        baseURLString: String,
        userIdProvider: @escaping () -> String,
        regionCodeProvider: @escaping () -> String,
        pingInterval: Int = 240,
        isCleanSessionEnabled: Bool = false,
        eventProbability: Int = 100,
        isSubscriptionPersistenceEnabled: Bool = false,
        isDiskPersistenceEnabled: Bool = false,
        isExtendedUsernameEnabled: Bool = false) {
        self.baseURLString = baseURLString
        self.userIdProvider = userIdProvider
        self.regionCodeProvider = regionCodeProvider
        self.pingInterval = pingInterval
        self.isCleanSessionEnabled = isCleanSessionEnabled
        self.eventProbability = eventProbability
        self.isSubscriptionPersistenceEnabled = isSubscriptionPersistenceEnabled
        self.isDiskPersistenceEnabled = isDiskPersistenceEnabled
        self.isExtendedUsernameEnabled = isExtendedUsernameEnabled
    }

    public func getMqttClientConfig(
        jsonDateFormatterProvider: () -> DateFormatter,
        courierTokenCachingMechanismRawValue: Int,
        autoReconnectInterval: Int = 1,
        maxAutoReconnectInterval: Int = 30,
        disableMQTTReconnectOnAuthFailure: Bool = false,
        useAppDidEnterBGAndWillEnterFGNotification: Bool = true,
        disableDisconnectOnConnectionUnavailable: Bool = false,
        enableAuthenticationTimeout: Bool = false,
        authenticationTimeoutInterval: TimeInterval = 30,
        connectTimeoutPolicy: IConnectTimeoutPolicy = ConnectTimeoutPolicy(),
        idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol = IdleActivityTimeoutPolicy(),
        bundleIDProvider: (() -> String?)?,
        messagePersistenceTTLSeconds: TimeInterval = 0,
        messageCleanupInterval: TimeInterval = 10,
        connectionServiceURLProvider: @escaping ConnectionServiceURLProvider) -> MQTTClientConfig {
        let formatter = jsonDateFormatterProvider()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)

        return MQTTClientConfig(
            authService: CourierConnectionServiceProvider(
                userIdProvider: userIdProvider,
                connectionServiceURLProvider: connectionServiceURLProvider,
                courierConfig: self,
                tokenCachingMechanismRawValue: courierTokenCachingMechanismRawValue,
                bundleIDProvider: bundleIDProvider),
            messageAdapters: [JSONMessageAdapter(jsonDecoder: decoder), DataMessageAdapter()],
            isSubscriptionStoreDiskPersistenceEnabled: isSubscriptionPersistenceEnabled,
            isMessagePersistenceEnabled: isDiskPersistenceEnabled,
            isUsernameModificationEnabled: isExtendedUsernameEnabled,
            autoReconnectInterval: UInt16(autoReconnectInterval),
            maxAutoReconnectInterval: UInt16(maxAutoReconnectInterval),
            disableMQTTReconnectOnAuthFailure: disableMQTTReconnectOnAuthFailure,
            useAppDidEnterBGAndWillEnterFGNotification: useAppDidEnterBGAndWillEnterFGNotification,
            disableDisconnectOnConnectionUnavailable: disableDisconnectOnConnectionUnavailable,
            enableAuthenticationTimeout: enableAuthenticationTimeout,
            authenticationTimeoutInterval: authenticationTimeoutInterval,
            connectTimeoutPolicy: connectTimeoutPolicy,
            idleActivityTimeoutPolicy: idleActivityTimeoutPolicy,
            countryCodeProvider: regionCodeProvider,
            messagePersistenceTTLSeconds: messagePersistenceTTLSeconds,
            messageCleanupInterval: messageCleanupInterval
        )
    }
}

public struct CourierConnectRetryConfig: Decodable {

    public let fixedTimeSecs: Int
    public let maxTimeSecs: Int

    public init(fixedTimeSecs: Int = 1, maxTimeSecs: Int = 30) {
        self.fixedTimeSecs = fixedTimeSecs
        self.maxTimeSecs = maxTimeSecs
    }

    enum CodingKeys: String, CodingKey {
        case fixedTimeSecs = "fixed_time_secs"
        case maxTimeSecs = "max_time_secs"
    }

}
