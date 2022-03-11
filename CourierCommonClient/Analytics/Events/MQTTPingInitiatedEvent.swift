import Foundation

class MQTTPingInitiatedEvent: IAnalyticsEvent {
    var name = EventName.mqttPingInitiated
    var properties = [String: String]()

    init(serverUri: String?, networkType: String? = nil) {
        if let serverUri = serverUri {
            properties[EventProperty.serverURI] = serverUri
        }
        properties[EventProperty.networkType] = networkType ?? NetworkType.unknown.trackingId
    }
}

extension ICourierAnalyticsManager {
    func sendMQTTPingInitiatedEvent(serverUri: String?, networkType: String? = nil, trackingSource: CourierAnalyticsService.Source) {
        let event = MQTTPingInitiatedEvent(serverUri: serverUri, networkType: networkType)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
