import Foundation

class MQTTSubscribeFailureEvent: IAnalyticsEvent {
    var name = EventName.mqttSubscribeFailure
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
    func sendMQTTSubscribeFailureEvent(topic: String, error: Error?, networkType: String? = nil, timeTaken: Int? = nil, trackingSource: CourierAnalyticsService.Source) {
        let event = MQTTSubscribeFailureEvent(topic: topic, error: error, networkType: networkType, timeTaken: timeTaken)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
