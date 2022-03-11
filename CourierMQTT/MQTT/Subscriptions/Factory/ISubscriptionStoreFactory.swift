import CourierCore
import Foundation

protocol ISubscriptionStoreFactory {
    func makeStore(topics: [String: QoS], isDiskPersistenceEnabled: Bool) -> ISubscriptionStore
}

struct SubscriptionStoreFactory: ISubscriptionStoreFactory {
    func makeStore(topics: [String: QoS], isDiskPersistenceEnabled: Bool) -> ISubscriptionStore {
        if isDiskPersistenceEnabled {
            return DiskSubscriptionStore(topics: topics)
        } else {
            return InMemorySubscriptionStore(topics: topics)
        }
    }
}
