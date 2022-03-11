import Foundation
@testable import CourierCore
@testable import CourierMQTT
class MockConnectRetryTimePolicy: IConnectRetryTimePolicy {

    var invokedEnableAutoReconnectGetter = false
    var invokedEnableAutoReconnectGetterCount = 0
    var stubbedEnableAutoReconnect: Bool! = false

    var enableAutoReconnect: Bool {
        invokedEnableAutoReconnectGetter = true
        invokedEnableAutoReconnectGetterCount += 1
        return stubbedEnableAutoReconnect
    }

    var invokedAutoReconnectIntervalGetter = false
    var invokedAutoReconnectIntervalGetterCount = 0
    var stubbedAutoReconnectInterval: UInt16! = 0

    var autoReconnectInterval: UInt16 {
        invokedAutoReconnectIntervalGetter = true
        invokedAutoReconnectIntervalGetterCount += 1
        return stubbedAutoReconnectInterval
    }

    var invokedMaxAutoReconnectIntervalGetter = false
    var invokedMaxAutoReconnectIntervalGetterCount = 0
    var stubbedMaxAutoReconnectInterval: UInt16! = 0

    var maxAutoReconnectInterval: UInt16 {
        invokedMaxAutoReconnectIntervalGetter = true
        invokedMaxAutoReconnectIntervalGetterCount += 1
        return stubbedMaxAutoReconnectInterval
    }
}
