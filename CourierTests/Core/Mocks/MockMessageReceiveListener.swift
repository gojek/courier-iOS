import Foundation
@testable import CourierCore
@testable import CourierMQTT
class MockMessageReceiveListener: IMessageReceiveListener {

    var invokedMessageArrived = false
    var invokedMessageArrivedCount = 0
    var invokedMessageArrivedParameters: (data: Data, topic: String, qos: QoS)?
    var invokedMessageArrivedParametersList = [(data: Data, topic: String, qos: QoS)]()

    func messageArrived(data: Data, topic: String, qos: QoS) {
        invokedMessageArrived = true
        invokedMessageArrivedCount += 1
        invokedMessageArrivedParameters = (data, topic, qos)
        invokedMessageArrivedParametersList.append((data, topic, qos))
    }
    
    var invokedAddPublisherDict = false
    var invokedAddPublisherDictCount = 0
    var invokedAddPublisherDictParameters: (topic: String, Void)?
    var invokedAddPublisherDictParametersList = [(topic: String, Void)]()

    func addPublisherDict(topic: String) {
        invokedAddPublisherDict = true
        invokedAddPublisherDictCount += 1
        invokedAddPublisherDictParameters = (topic, ())
        invokedAddPublisherDictParametersList.append((topic, ()))
    }

    var invokedRemovePublisherDict = false
    var invokedRemovePublisherDictCount = 0
    var invokedRemovePublisherDictParameters: (topic: String, Void)?
    var invokedRemovePublisherDictParametersList = [(topic: String, Void)]()

    func removePublisherDict(topic: String) {
        invokedRemovePublisherDict = true
        invokedRemovePublisherDictCount += 1
        invokedRemovePublisherDictParameters = (topic, ())
        invokedRemovePublisherDictParametersList.append((topic, ()))
    }

    var invokedHandlePersistedMessages = false
    var invokedHandlePersistedMessagesCount = 0

    func handlePersistedMessages() {
        invokedHandlePersistedMessages = true
        invokedHandlePersistedMessagesCount += 1
    }

    var invokedClearPersistedMessages = false
    var invokedClearPersistedMessagesCount = 0

    func clearPersistedMessages() {
        invokedClearPersistedMessages = true
        invokedClearPersistedMessagesCount += 1
    }

}
