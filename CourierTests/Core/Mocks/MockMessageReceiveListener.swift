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
}
