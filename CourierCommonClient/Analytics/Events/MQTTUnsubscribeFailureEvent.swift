import Foundation

class MQTTUnsubscribeFailureEvent: IAnalyticsEvent {
    var name = EventName.mqttUnsubscribeFailure
    var properties = [String: String]()

    init(topic: String, error: Error?, networkType: String? = nil, timeTaken: Int? = nil) {
        properties[EventProperty.topic] = topic
        if let error = error {
            properties[EventProperty.reasonMessage] = error.localizedDescription
            properties[EventProperty.reason] = String((error as NSError).code)
        }
        if let timeTaken = timeTaken {
            properties[EventProperty.timeTaken] = String(timeTaken)
        }
        properties[EventProperty.networkType] = networkType ?? NetworkType.unknown.trackingId
    }
}

extension ICourierAnalyticsManager {
    func sendMQTTUnsubscribeFailureEvent(topic: String, error: Error?, networkType: String? = nil, timeTaken: Int? = nil, trackingSource: CourierAnalyticsService.Source) {
        let event = MQTTUnsubscribeFailureEvent(topic: topic, error: error, networkType: networkType, timeTaken: timeTaken)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
