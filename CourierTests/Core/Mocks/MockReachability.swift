import Foundation
@testable import Reachability

class MockReachability: Reachability {

    var invokedWhenReachableSetter = false
    var invokedWhenReachableSetterCount = 0
    var invokedWhenReachable: NetworkReachable?
    var invokedWhenReachableList = [NetworkReachable?]()
    var invokedWhenReachableGetter = false
    var invokedWhenReachableGetterCount = 0
    var stubbedWhenReachable: NetworkReachable!

    override var whenReachable: NetworkReachable? {
        set {
            invokedWhenReachableSetter = true
            invokedWhenReachableSetterCount += 1
            invokedWhenReachable = newValue
            invokedWhenReachableList.append(newValue)
        }
        get {
            invokedWhenReachableGetter = true
            invokedWhenReachableGetterCount += 1
            return stubbedWhenReachable
        }
    }

    var invokedWhenUnreachableSetter = false
    var invokedWhenUnreachableSetterCount = 0
    var invokedWhenUnreachable: NetworkUnreachable?
    var invokedWhenUnreachableList = [NetworkUnreachable?]()
    var invokedWhenUnreachableGetter = false
    var invokedWhenUnreachableGetterCount = 0
    var stubbedWhenUnreachable: NetworkUnreachable!

    override var whenUnreachable: NetworkUnreachable? {
        set {
            invokedWhenUnreachableSetter = true
            invokedWhenUnreachableSetterCount += 1
            invokedWhenUnreachable = newValue
            invokedWhenUnreachableList.append(newValue)
        }
        get {
            invokedWhenUnreachableGetter = true
            invokedWhenUnreachableGetterCount += 1
            return stubbedWhenUnreachable
        }
    }

    var invokedAllowsCellularConnectionSetter = false
    var invokedAllowsCellularConnectionSetterCount = 0
    var invokedAllowsCellularConnection: Bool?
    var invokedAllowsCellularConnectionList = [Bool]()
    var invokedAllowsCellularConnectionGetter = false
    var invokedAllowsCellularConnectionGetterCount = 0
    var stubbedAllowsCellularConnection: Bool! = false

    override var allowsCellularConnection: Bool {
        set {
            invokedAllowsCellularConnectionSetter = true
            invokedAllowsCellularConnectionSetterCount += 1
            invokedAllowsCellularConnection = newValue
            invokedAllowsCellularConnectionList.append(newValue)
        }
        get {
            invokedAllowsCellularConnectionGetter = true
            invokedAllowsCellularConnectionGetterCount += 1
            return stubbedAllowsCellularConnection
        }
    }

    var invokedNotificationCenterSetter = false
    var invokedNotificationCenterSetterCount = 0
    var invokedNotificationCenter: NotificationCenter?
    var invokedNotificationCenterList = [NotificationCenter]()
    var invokedNotificationCenterGetter = false
    var invokedNotificationCenterGetterCount = 0
    var stubbedNotificationCenter: NotificationCenter!

    override var notificationCenter: NotificationCenter {
        set {
            invokedNotificationCenterSetter = true
            invokedNotificationCenterSetterCount += 1
            invokedNotificationCenter = newValue
            invokedNotificationCenterList.append(newValue)
        }
        get {
            invokedNotificationCenterGetter = true
            invokedNotificationCenterGetterCount += 1
            return stubbedNotificationCenter
        }
    }

    var invokedCurrentReachabilityStringGetter = false
    var invokedCurrentReachabilityStringGetterCount = 0
    var stubbedCurrentReachabilityString: String! = ""

    override var currentReachabilityString: String {
        invokedCurrentReachabilityStringGetter = true
        invokedCurrentReachabilityStringGetterCount += 1
        return stubbedCurrentReachabilityString
    }

    var invokedConnectionGetter = false
    var invokedConnectionGetterCount = 0
    var stubbedConnection: Connection!

    override var connection: Connection {
        invokedConnectionGetter = true
        invokedConnectionGetterCount += 1
        return stubbedConnection
    }

    var invokedNotifierRunningGetter = false
    var invokedNotifierRunningGetterCount = 0
    var stubbedNotifierRunning: Bool! = false

    override var notifierRunning: Bool {
        invokedNotifierRunningGetter = true
        invokedNotifierRunningGetterCount += 1
        return stubbedNotifierRunning
    }

}
