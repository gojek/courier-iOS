import Foundation

class MQTTPingSuccessEvent: IAnalyticsEvent {
    var name = EventName.mqttPingSuccess
    var properties = [String: String]()

    init(timeTaken: Int, networkType: String? = nil) {
        properties[EventProperty.timeTaken] = String(timeTaken)
        properties[EventProperty.networkType] = networkType ?? NetworkType.unknown.trackingId
    }
}

extension ICourierAnalyticsManager {
    func sendMQTTPingSuccessEvent(timeTaken: Int, networkType: String? = nil, trackingSource: CourierAnalyticsService.Source) {
        let event = MQTTPingSuccessEvent(timeTaken: timeTaken, networkType: networkType)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
