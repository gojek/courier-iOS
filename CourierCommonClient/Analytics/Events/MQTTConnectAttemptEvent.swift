import Foundation

class MQTTConnectAttemptEvent: IAnalyticsEvent {
    var name = EventName.mqttConnectAttempt
    var properties = [String: String]()

    init(networkType: String? = nil) {
        properties[EventProperty.networkType] = networkType ?? NetworkType.unknown.trackingId
    }
}

extension ICourierAnalyticsManager {
    func sendMQTTConnectAttemptEvent(networkType: String? = nil, trackingSource: CourierAnalyticsService.Source) {
        let event = MQTTConnectAttemptEvent(networkType: networkType)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
