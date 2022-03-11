import CourierCore
import Foundation

class InMemorySubscriptionStore: ISubscriptionStore {

    private var _subscriptions: Atomic<[String: QoS]>
    private(set) var subscriptions: [String: QoS] {
        get { _subscriptions.value }
        set { _subscriptions.mutate { $0 = newValue }}
    }

    private var _pendingUnsubscriptions: Atomic<Set<String>>
    private(set) var pendingUnsubscriptions: Set<String> {
        get { _pendingUnsubscriptions.value }
        set { _pendingUnsubscriptions.mutate { $0 = newValue }}
    }

    init(topics: [String: QoS] = [:]) {
        _subscriptions = Atomic(topics)
        _pendingUnsubscriptions = Atomic(Set())
    }

    func subscribe(_ topics: [(topic: String, qos: QoS)]) {
        internalSubscribe(topics)
    }

    func unsubscribe(_ topics: [String]) {
        internalUnsubscribe(topics)
    }

    func unsubscribeAcked(_ topics: [String]) {
        topics.forEach { topic in
            pendingUnsubscriptions.remove(topic)
        }
    }

    func isCurrentlyPendingUnsubscribe(topic: String) -> Bool {
        pendingUnsubscriptions.contains(topic)
    }

    func clearAllSubscriptions() {
        subscriptions.removeAll()
        pendingUnsubscriptions.removeAll()
    }

    private func internalSubscribe(_ topicFilters: [(String, QoS)]) {
        topicFilters.forEach { topicFilter in
            let (topic, qos) = topicFilter
            pendingUnsubscriptions.remove(topic)
            subscriptions[topic] = qos
        }
    }

    private func internalUnsubscribe(_ topics: [String]) {
        topics.forEach { topic in
            pendingUnsubscriptions.insert(topic)
            subscriptions[topic] = nil
        }
    }

}
