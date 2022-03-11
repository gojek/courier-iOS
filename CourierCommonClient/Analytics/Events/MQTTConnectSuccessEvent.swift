import Foundation

class MQTTConnectSuccessEvent: IAnalyticsEvent {
    var name = EventName.mqttConnectSuccess
    var properties = [String: String]()

    init(networkType: String? = nil, timeTaken: Int? = nil) {
        properties[EventProperty.networkType] = networkType ?? NetworkType.unknown.trackingId
        if let timeTaken = timeTaken {
            properties[EventProperty.timeTaken] = String(timeTaken)
        }
    }
}

extension ICourierAnalyticsManager {
    func sendMQTTConnectSuccessEvent(networkType: String? = nil, timeTaken: Int? = nil, trackingSource: CourierAnalyticsService.Source) {
        let event = MQTTConnectSuccessEvent(networkType: networkType, timeTaken: timeTaken)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
