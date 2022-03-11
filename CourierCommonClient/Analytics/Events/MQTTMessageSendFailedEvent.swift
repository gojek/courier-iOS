import Foundation
import CourierCore

class MQTTMessageSendFailedEvent: IAnalyticsEvent {
    var name = EventName.mqttMessageSendFailed
    var properties = [String: String]()

    init(error: Error?, qos: QoS, networkType: String? = nil, topic: String, sizeBytes: Int) {
        if let error = error {
            properties[EventProperty.reasonMessage] = error.localizedDescription
            properties[EventProperty.reason] = String((error as NSError).code)
        }
        properties[EventProperty.networkType] = networkType ?? NetworkType.unknown.trackingId
        properties[EventProperty.topic] = topic
        properties[EventProperty.qos] = String(qos.rawValue)
        properties[EventProperty.sizeBytes] = String(sizeBytes)
    }
}

extension ICourierAnalyticsManager {
    func sendMQTTMessageSendFailedEvent(error: Error?, qos: QoS, networkType: String? = nil, topic: String, sizeBytes: Int, trackingSource: CourierAnalyticsService.Source) {
        let event = MQTTMessageSendFailedEvent(error: error, qos: qos, networkType: networkType, topic: topic, sizeBytes: sizeBytes)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
