import Foundation

class MQTTUnsubscribeSuccessEvent: IAnalyticsEvent {
    var name = EventName.mqttUnsubscribeSuccess
    var properties = [String: String]()

    init(topic: String, networkType: String? = nil, timeTaken: Int? = nil) {
        properties[EventProperty.topic] = topic
        properties[EventProperty.networkType] = networkType ?? NetworkType.unknown.trackingId
        if let timeTaken = timeTaken {
            properties[EventProperty.timeTaken] = String(timeTaken)
        }
    }
}

extension ICourierAnalyticsManager {
    func sendMQTTUnsubscribeSuccessEvent(topic: String, networkType: String? = nil, timeTaken: Int? = nil, trackingSource: CourierAnalyticsService.Source) {
        let event = MQTTUnsubscribeSuccessEvent(topic: topic, networkType: networkType, timeTaken: timeTaken)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
