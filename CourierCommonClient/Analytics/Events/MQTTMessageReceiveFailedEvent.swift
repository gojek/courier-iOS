import Foundation

class MQTTMessageReceiveFailedEvent: IAnalyticsEvent {
    var name = EventName.mqttMessageReceiveFailed
    var properties = [String: String]()

    init(networkType: String? = nil, error: Error?, topic: String, sizeBytes: Int) {
        if let error = error {
            properties[EventProperty.reasonMessage] = error.localizedDescription
            properties[EventProperty.reason] = String((error as NSError).code)
        }
        properties[EventProperty.networkType] = networkType ?? NetworkType.unknown.trackingId
        properties[EventProperty.topic] = topic
        properties[EventProperty.sizeBytes] = String(sizeBytes)
    }
}

extension ICourierAnalyticsManager {
    func sendMQTTMessageReceiveFailedEvent(networkType: String? = nil, error: Error?, topic: String, sizeBytes: Int, trackingSource: CourierAnalyticsService.Source) {
        let event = MQTTMessageReceiveFailedEvent(networkType: networkType, error: error, topic: topic, sizeBytes: sizeBytes)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
