import CourierCore
import Foundation

protocol IMessageReceiveListener {
    func messageArrived(data: Data, topic: String, qos: QoS)
}
