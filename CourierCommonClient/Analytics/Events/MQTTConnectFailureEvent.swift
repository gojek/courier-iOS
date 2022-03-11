import Foundation

class MQTTConnectFailureEvent: IAnalyticsEvent {
    var name = EventName.mqttConnectFailure
    var properties = [String: String]()

    init(error: Error?, networkType: String? = nil, timeTaken: Int? = nil) {
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
    func sendMQTTConnectFailureEvent(error: Error?, networkType: String? = nil, timeTaken: Int? = nil, trackingSource: CourierAnalyticsService.Source) {
        let event = MQTTConnectFailureEvent(error: error, networkType: networkType, timeTaken: timeTaken)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
