import CourierCore
import Foundation

struct MQTTPacket {
    let id: String
    var data: Data
    var topic: String
    var qos: QoS
    var timestamp: Date
    var guid: String
    
    init(id: String = UUID().uuidString, data: Data, topic: String, qos: QoS, timestamp: Date = Date(), guid: String = "") {
        self.id = id
        self.data = data
        self.topic = topic
        self.qos = qos
        self.timestamp = timestamp
        self.guid = guid
    }
}

