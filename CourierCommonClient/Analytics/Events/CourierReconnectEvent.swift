import Foundation

class CourierReconnectEvent: IAnalyticsEvent {
    var name = EventName.courierReconnect
    var properties = [String: String]()

    init(networkType: String? = nil) {
        properties[EventProperty.networkType] = networkType ?? NetworkType.unknown.trackingId
    }
}

extension ICourierAnalyticsManager {
    func sendCourierReconnectEvent(networkType: String? = nil, trackingSource: CourierAnalyticsService.Source) {
        let event = CourierReconnectEvent(networkType: networkType)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
