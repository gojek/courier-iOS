import Foundation

class CourierConnectFailedEvent: IAnalyticsEvent {
    var name = EventName.courierConnectFailed
    var properties = [String: String]()

    init(networkType: String? = nil, error: Error?, timeTaken: Int? = nil) {
        if let error = error {
            properties[EventProperty.reasonMessage] = error.localizedDescription
            properties[EventProperty.reason] = String((error as NSError).code)
        }
        if let timeTaken = timeTaken {
            properties[EventProperty.timeTaken] = String(timeTaken)
        }

        properties[EventProperty.networkType] = networkType ?? NetworkType.unknown.trackingId
    }
}

extension ICourierAnalyticsManager {
    func sendCourierConnectFailedEvent(networkType: String? = nil, error: Error?, timeTaken: Int? = nil, trackingSource: CourierAnalyticsService.Source) {
        let event = CourierConnectFailedEvent(networkType: networkType, error: error, timeTaken: timeTaken)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
