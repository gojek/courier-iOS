import Foundation

class MQTTUnsubscribeAttemptEvent: IAnalyticsEvent {
    var name = EventName.mqttUnsubscribeAttempt
    var properties = [String: String]()

    init(topic: String, networkType: String? = nil) {
        properties[EventProperty.topic] = topic
        properties[EventProperty.networkType] = networkType ?? NetworkType.unknown.trackingId
    }
}

extension ICourierAnalyticsManager {
    func sendMQTTUnsubscribeAttemptEvent(topic: String, networkType: String? = nil, trackingSource: CourierAnalyticsService.Source) {
        let event = MQTTUnsubscribeAttemptEvent(topic: topic, networkType: networkType)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
