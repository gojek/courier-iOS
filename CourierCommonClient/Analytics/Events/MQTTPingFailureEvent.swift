import Foundation

class MQTTPingFailureEvent: IAnalyticsEvent {
    var name = EventName.mqttPingFailure
    var properties = [String: String]()

    init(timeTaken: Int, error: Error?, networkType: String? = nil) {
        properties[EventProperty.timeTaken] = String(timeTaken)
        if let error = error {
            properties[EventProperty.reasonMessage] = error.localizedDescription
            properties[EventProperty.reason] = String((error as NSError).code)
        }
        properties[EventProperty.networkType] = networkType ?? NetworkType.unknown.trackingId
    }
}

extension ICourierAnalyticsManager {
    func sendMQTTPingFailureEvent(timeTaken: Int, error: Error?, networkType: String? = nil, trackingSource: CourierAnalyticsService.Source) {
        let event = MQTTPingFailureEvent(timeTaken: timeTaken, error: error, networkType: networkType)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
