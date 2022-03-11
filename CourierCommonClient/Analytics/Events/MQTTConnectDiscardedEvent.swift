import Foundation

class MQTTConnectDiscardedEvent: IAnalyticsEvent {
    var name = EventName.mqttConnectDiscarded
    var properties = [String: String]()

    init(reason: String, networkType: String? = nil) {
        properties[EventProperty.reason] = reason
        properties[EventProperty.networkType] = networkType ?? NetworkType.unknown.trackingId
    }
}

extension ICourierAnalyticsManager {
    func sendMQTTConnectDiscardedEvent(reason: String, networkType: String? = nil, trackingSource: CourierAnalyticsService.Source) {
        let event = MQTTConnectDiscardedEvent(reason: reason, networkType: networkType)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
