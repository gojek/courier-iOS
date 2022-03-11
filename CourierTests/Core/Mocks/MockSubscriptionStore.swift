import Foundation
@testable import CourierCore
@testable import CourierMQTT
class MockSubscriptionStore: ISubscriptionStore {

    var invokedSubscriptionsGetter = false
    var invokedSubscriptionsGetterCount = 0
    var stubbedSubscriptions: [String: QoS]! = [:]

    var subscriptions: [String: QoS] {
        invokedSubscriptionsGetter = true
        invokedSubscriptionsGetterCount += 1
        return stubbedSubscriptions
    }

    var invokedPendingUnsubscriptionsGetter = false
    var invokedPendingUnsubscriptionsGetterCount = 0
    var stubbedPendingUnsubscriptions: Set<String>! = []

    var pendingUnsubscriptions: Set<String> {
        invokedPendingUnsubscriptionsGetter = true
        invokedPendingUnsubscriptionsGetterCount += 1
        return stubbedPendingUnsubscriptions
    }

    var invokedSubscribe = false
    var invokedSubscribeCount = 0
    var invokedSubscribeParameters: (topics: [(topic: String, qos: QoS)], Void)?
    var invokedSubscribeParametersList = [(topics: [(topic: String, qos: QoS)], Void)]()

    func subscribe(_ topics: [(topic: String, qos: QoS)]) {
        invokedSubscribe = true
        invokedSubscribeCount += 1
        invokedSubscribeParameters = (topics, ())
        invokedSubscribeParametersList.append((topics, ()))
    }

    var invokedUnsubscribe = false
    var invokedUnsubscribeCount = 0
    var invokedUnsubscribeParameters: (topics: [String], Void)?
    var invokedUnsubscribeParametersList = [(topics: [String], Void)]()

    func unsubscribe(_ topics: [String]) {
        invokedUnsubscribe = true
        invokedUnsubscribeCount += 1
        invokedUnsubscribeParameters = (topics, ())
        invokedUnsubscribeParametersList.append((topics, ()))
    }

    var invokedUnsubscribeAcked = false
    var invokedUnsubscribeAckedCount = 0
    var invokedUnsubscribeAckedParameters: (topics: [String], Void)?
    var invokedUnsubscribeAckedParametersList = [(topics: [String], Void)]()

    func unsubscribeAcked(_ topics: [String]) {
        invokedUnsubscribeAcked = true
        invokedUnsubscribeAckedCount += 1
        invokedUnsubscribeAckedParameters = (topics, ())
        invokedUnsubscribeAckedParametersList.append((topics, ()))
    }

    var invokedIsCurrentlyPendingUnsubscribe = false
    var invokedIsCurrentlyPendingUnsubscribeCount = 0
    var invokedIsCurrentlyPendingUnsubscribeParameters: (topic: String, Void)?
    var invokedIsCurrentlyPendingUnsubscribeParametersList = [(topic: String, Void)]()
    var stubbedIsCurrentlyPendingUnsubscribeResult: Bool! = false

    func isCurrentlyPendingUnsubscribe(topic: String) -> Bool {
        invokedIsCurrentlyPendingUnsubscribe = true
        invokedIsCurrentlyPendingUnsubscribeCount += 1
        invokedIsCurrentlyPendingUnsubscribeParameters = (topic, ())
        invokedIsCurrentlyPendingUnsubscribeParametersList.append((topic, ()))
        return stubbedIsCurrentlyPendingUnsubscribeResult
    }

    var invokedClearAllSubscriptions = false
    var invokedClearAllSubscriptionsCount = 0

    func clearAllSubscriptions() {
        invokedClearAllSubscriptions = true
        invokedClearAllSubscriptionsCount += 1
    }
}
