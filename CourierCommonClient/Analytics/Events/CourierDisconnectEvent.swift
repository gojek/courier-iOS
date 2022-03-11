import Foundation

class CourierDisconnectEvent: IAnalyticsEvent {
    var properties: [String: String] = [:]
    var name = EventName.courierDisconnect

    init(clearState: Bool) {
        properties[EventProperty.clearState] = String(clearState)
    }
}

extension ICourierAnalyticsManager {
    func sendCourierDisconnectEventEvent(clearState: Bool, trackingSource: CourierAnalyticsService.Source) {
        let event = CourierDisconnectEvent(clearState: clearState)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
