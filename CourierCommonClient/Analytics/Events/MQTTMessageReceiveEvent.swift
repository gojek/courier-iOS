import Foundation

class MQTTMessageReceiveEvent: IAnalyticsEvent {
    var name = EventName.mqttMessageReceive
    var properties = [String: String]()

    init(networkType: String? = nil, topic: String, sizeBytes: Int) {
        properties[EventProperty.networkType] = networkType ?? NetworkType.unknown.trackingId
        properties[EventProperty.topic] = topic
        properties[EventProperty.sizeBytes] = String(sizeBytes)
    }
}

extension ICourierAnalyticsManager {
    func sendMQTTMessageReceiveEvent(networkType: String? = nil, topic: String, sizeBytes: Int, trackingSource: CourierAnalyticsService.Source) {
        let event = MQTTMessageReceiveEvent(networkType: networkType, topic: topic, sizeBytes: sizeBytes)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
