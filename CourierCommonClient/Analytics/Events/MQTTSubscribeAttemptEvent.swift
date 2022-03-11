import Foundation

class MQTTSubscribeAttemptEvent: IAnalyticsEvent {
    var name = EventName.mqttSubscribeAttempt
    var properties = [String: String]()

    init(topic: String, networkType: String? = nil) {
        properties[EventProperty.topic] = topic
        properties[EventProperty.networkType] = networkType ?? NetworkType.unknown.trackingId
    }
}

extension ICourierAnalyticsManager {
    func sendMQTTSubscribeAttemptEvent(topic: String, networkType: String? = nil, trackingSource: CourierAnalyticsService.Source) {
        let event = MQTTSubscribeAttemptEvent(topic: topic, networkType: networkType)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
