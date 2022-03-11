import Foundation

class CourierConnectStartedEvent: IAnalyticsEvent {
    var name = EventName.courierConnectStarted
    var properties = [String: String]()

    init(source: String? = nil, networkType: String? = nil) {
        if let source = source, !source.isEmpty {
            properties[EventProperty.source] = source
        }
        properties[EventProperty.networkType] = networkType ?? NetworkType.unknown.trackingId
    }
}

extension ICourierAnalyticsManager {
    func sendCourierConnectStartedEvent(source: String? = nil, networkType: String? = nil, trackingSource: CourierAnalyticsService.Source) {
        let event = CourierConnectStartedEvent(source: source, networkType: networkType)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
