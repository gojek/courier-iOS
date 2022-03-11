import Foundation

class MQTTConnectionDisconnectEvent: IAnalyticsEvent {
    var properties: [String: String] = [:]
    var name = EventName.mqttConnectionDisconnect
}

extension ICourierAnalyticsManager {
    func sendMQTTConnectionDisconnectEvent(trackingSource: CourierAnalyticsService.Source) {
        let event = MQTTConnectionDisconnectEvent()
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
