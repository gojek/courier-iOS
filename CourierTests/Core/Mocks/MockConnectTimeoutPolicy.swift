import Foundation
@testable import CourierCore
@testable import CourierMQTT

class MockConnectTimeoutPolicy: IConnectTimeoutPolicy {

    var invokedIsEnabledGetter = false
    var invokedIsEnabledGetterCount = 0
    var stubbedIsEnabled: Bool! = false

    var isEnabled: Bool {
        invokedIsEnabledGetter = true
        invokedIsEnabledGetterCount += 1
        return stubbedIsEnabled
    }

    var invokedTimerIntervalGetter = false
    var invokedTimerIntervalGetterCount = 0
    var stubbedTimerInterval: TimeInterval!

    var timerInterval: TimeInterval {
        invokedTimerIntervalGetter = true
        invokedTimerIntervalGetterCount += 1
        return stubbedTimerInterval
    }

    var invokedTimeoutGetter = false
    var invokedTimeoutGetterCount = 0
    var stubbedTimeout: TimeInterval!

    var timeout: TimeInterval {
        invokedTimeoutGetter = true
        invokedTimeoutGetterCount += 1
        return stubbedTimeout
    }
}
