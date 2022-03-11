import Foundation

class AppActiveTimeTrackerEvent: IAnalyticsEvent {
    var name = EventName.appActiveTimeTracker
    var properties = [String: String]()
}

extension ICourierAnalyticsManager {
    func sendAppActiveTimeTrackerEvent(action: String, trackingSource: CourierAnalyticsService.Source) {
        let event = AppActiveTimeTrackerEvent()
        event.properties["Action"] = action
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
