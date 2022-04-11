import Foundation

@testable import CourierCore
@testable import CourierMQTT
@testable import CourierCommonClient

class MockCourierConfig: ICourierConfig {

    var invokedBaseURLStringGetter = false
    var invokedBaseURLStringGetterCount = 0
    var stubbedBaseURLString: String! = ""

    var baseURLString: String {
        invokedBaseURLStringGetter = true
        invokedBaseURLStringGetterCount += 1
        return stubbedBaseURLString
    }

    var invokedUserIdProviderGetter = false
    var invokedUserIdProviderGetterCount = 0
    var stubbedUserIdProvider: (() -> String)! = { return "" }

    var userIdProvider: () -> String {
        invokedUserIdProviderGetter = true
        invokedUserIdProviderGetterCount += 1
        return stubbedUserIdProvider
    }

    var invokedRegionCodeProviderGetter = false
    var invokedRegionCodeProviderGetterCount = 0
    var stubbedRegionCodeProvider: (() -> String)! = { return "" }

    var regionCodeProvider: () -> String {
        invokedRegionCodeProviderGetter = true
        invokedRegionCodeProviderGetterCount += 1
        return stubbedRegionCodeProvider
    }

    var invokedPingIntervalGetter = false
    var invokedPingIntervalGetterCount = 0
    var stubbedPingInterval: Int! = 0

    var pingInterval: Int {
        invokedPingIntervalGetter = true
        invokedPingIntervalGetterCount += 1
        return stubbedPingInterval
    }

    var invokedIsCleanSessionEnabledGetter = false
    var invokedIsCleanSessionEnabledGetterCount = 0
    var stubbedIsCleanSessionEnabled: Bool! = false

    var isCleanSessionEnabled: Bool {
        invokedIsCleanSessionEnabledGetter = true
        invokedIsCleanSessionEnabledGetterCount += 1
        return stubbedIsCleanSessionEnabled
    }

    var invokedEventProbabilityGetter = false
    var invokedEventProbabilityGetterCount = 0
    var stubbedEventProbability: Int! = 0

    var eventProbability: Int {
        invokedEventProbabilityGetter = true
        invokedEventProbabilityGetterCount += 1
        return stubbedEventProbability
    }

    var invokedIsSubscriptionPersistenceEnabledGetter = false
    var invokedIsSubscriptionPersistenceEnabledGetterCount = 0
    var stubbedIsSubscriptionPersistenceEnabled: Bool! = false

    var isSubscriptionPersistenceEnabled: Bool {
        invokedIsSubscriptionPersistenceEnabledGetter = true
        invokedIsSubscriptionPersistenceEnabledGetterCount += 1
        return stubbedIsSubscriptionPersistenceEnabled
    }

    var invokedIsDiskPersistenceEnabledGetter = false
    var invokedIsDiskPersistenceEnabledGetterCount = 0
    var stubbedIsDiskPersistenceEnabled: Bool! = false

    var isDiskPersistenceEnabled: Bool {
        invokedIsDiskPersistenceEnabledGetter = true
        invokedIsDiskPersistenceEnabledGetterCount += 1
        return stubbedIsDiskPersistenceEnabled
    }

    var invokedIsExtendedUsernameEnabledGetter = false
    var invokedIsExtendedUsernameEnabledGetterCount = 0
    var stubbedIsExtendedUsernameEnabled: Bool! = false

    var isExtendedUsernameEnabled: Bool {
        invokedIsExtendedUsernameEnabledGetter = true
        invokedIsExtendedUsernameEnabledGetterCount += 1
        return stubbedIsExtendedUsernameEnabled
    }

    var invokedGetMqttClientConfig = false
    var invokedGetMqttClientConfigCount = 0
    var invokedGetMqttClientConfigParameters: (courierTokenCachingMechanismRawValue: Int, autoReconnectInterval: Int, maxAutoReconnectInterval: Int, disableMQTTReconnectOnAuthFailure: Bool, useAppDidEnterBGAndWillEnterFGNotification: Bool, disableDisconnectOnConnectionUnavailable: Bool, enableAuthenticationTimeout: Bool, authenticationTimeoutInterval: TimeInterval, connectTimeoutPolicy: IConnectTimeoutPolicy, idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol, connectionServiceURLProvider: ConnectionServiceURLProvider)?
    var invokedGetMqttClientConfigParametersList = [(courierTokenCachingMechanismRawValue: Int, autoReconnectInterval: Int, maxAutoReconnectInterval: Int, disableMQTTReconnectOnAuthFailure: Bool, useAppDidEnterBGAndWillEnterFGNotification: Bool, disableDisconnectOnConnectionUnavailable: Bool, enableAuthenticationTimeout: Bool, authenticationTimeoutInterval: TimeInterval, connectTimeoutPolicy: IConnectTimeoutPolicy, idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol, connectionServiceURLProvider: ConnectionServiceURLProvider)]()
    var shouldInvokeGetMqttClientConfigJsonDateFormatterProvider = false
    var shouldInvokeGetMqttClientConfigBundleIDProvider = false
    var stubbedGetMqttClientConfigResult: MQTTClientConfig!

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
        connectionServiceURLProvider: @escaping ConnectionServiceURLProvider) -> MQTTClientConfig {
        invokedGetMqttClientConfig = true
        invokedGetMqttClientConfigCount += 1
        invokedGetMqttClientConfigParameters = (courierTokenCachingMechanismRawValue, autoReconnectInterval, maxAutoReconnectInterval, disableMQTTReconnectOnAuthFailure, useAppDidEnterBGAndWillEnterFGNotification, disableDisconnectOnConnectionUnavailable, enableAuthenticationTimeout, authenticationTimeoutInterval, connectTimeoutPolicy, idleActivityTimeoutPolicy, connectionServiceURLProvider)
        invokedGetMqttClientConfigParametersList.append((courierTokenCachingMechanismRawValue, autoReconnectInterval, maxAutoReconnectInterval, disableMQTTReconnectOnAuthFailure, useAppDidEnterBGAndWillEnterFGNotification, disableDisconnectOnConnectionUnavailable, enableAuthenticationTimeout, authenticationTimeoutInterval, connectTimeoutPolicy, idleActivityTimeoutPolicy, connectionServiceURLProvider))
        if shouldInvokeGetMqttClientConfigJsonDateFormatterProvider {
            _ = jsonDateFormatterProvider()
        }
        if shouldInvokeGetMqttClientConfigBundleIDProvider {
            _ = bundleIDProvider?()
        }
        return stubbedGetMqttClientConfigResult
    }
}
