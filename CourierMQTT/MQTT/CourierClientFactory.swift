import CourierCore
import Foundation

public struct CourierClientFactory {

    public init() {}

    /**
     Creates an instance of CourierClient that uses MQTT as its bi-directional communication protocol
     - Parameter config: MQTTClientConfig

     - Returns: CourierClient
     */
    public func makeMQTTClient(config: MQTTClientConfig) -> CourierClient {
        MQTTCourierClient(config: config)
    }
}

public struct MQTTClientConfig {

    public let topics: [String: QoS]

    public let authService: IConnectionServiceProvider

    public let messageAdapters: [MessageAdapter]

    public let isSubscriptionStoreDiskPersistenceEnabled: Bool

    public let isMessagePersistenceEnabled: Bool

    public let isUsernameModificationEnabled: Bool

    public let countryCodeProvider: () -> String

    public let autoReconnectInterval: UInt16

    public let maxAutoReconnectInterval: UInt16

    public let disableMQTTReconnectOnAuthFailure: Bool

    public let useAppDidEnterBGAndWillEnterFGNotification: Bool

    public let disableDisconnectOnConnectionUnavailable: Bool

    public let connectTimeoutPolicy: IConnectTimeoutPolicy

    public let idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol

    public let enableAuthenticationTimeout: Bool

    public let authenticationTimeoutInterval: TimeInterval

    public init(
        topics: [String: QoS] = [:],
        authService: IConnectionServiceProvider,
        messageAdapters: [MessageAdapter] = [JSONMessageAdapter()],
        isSubscriptionStoreDiskPersistenceEnabled: Bool = false,
        isMessagePersistenceEnabled: Bool = false,
        isUsernameModificationEnabled: Bool = false,
        autoReconnectInterval: UInt16 = 5,
        maxAutoReconnectInterval: UInt16 = 10,
        disableMQTTReconnectOnAuthFailure: Bool = false,
        useAppDidEnterBGAndWillEnterFGNotification: Bool = true,
        disableDisconnectOnConnectionUnavailable: Bool = false,
        enableAuthenticationTimeout: Bool = false,
        authenticationTimeoutInterval: TimeInterval = 30,
        connectTimeoutPolicy: IConnectTimeoutPolicy = ConnectTimeoutPolicy(),
        idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol = IdleActivityTimeoutPolicy(),
        countryCodeProvider: @escaping () -> String = { "ID" }
    ) {
        self.topics = topics
        self.authService = authService
        self.messageAdapters = messageAdapters
        self.isSubscriptionStoreDiskPersistenceEnabled = isSubscriptionStoreDiskPersistenceEnabled
        self.isMessagePersistenceEnabled = isMessagePersistenceEnabled
        self.isUsernameModificationEnabled = isUsernameModificationEnabled
        self.autoReconnectInterval = autoReconnectInterval
        self.maxAutoReconnectInterval = maxAutoReconnectInterval
        self.disableMQTTReconnectOnAuthFailure = disableMQTTReconnectOnAuthFailure
        self.useAppDidEnterBGAndWillEnterFGNotification = useAppDidEnterBGAndWillEnterFGNotification
        self.disableDisconnectOnConnectionUnavailable = disableDisconnectOnConnectionUnavailable
        self.enableAuthenticationTimeout = enableAuthenticationTimeout
        self.authenticationTimeoutInterval = authenticationTimeoutInterval
        self.connectTimeoutPolicy = connectTimeoutPolicy
        self.idleActivityTimeoutPolicy = idleActivityTimeoutPolicy
        self.countryCodeProvider = countryCodeProvider
    }

}
