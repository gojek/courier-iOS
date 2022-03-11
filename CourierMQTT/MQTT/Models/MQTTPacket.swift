import CourierCore
import Foundation

struct MQTTPacket {
    var data: Data
    var topic: String
    var qos: QoS

    init(data: Data, topic: String, qos: QoS) {
        self.data = data
        self.topic = topic
        self.qos = qos
    }
}
