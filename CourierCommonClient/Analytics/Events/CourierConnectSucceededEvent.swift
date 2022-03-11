import Foundation

class CourierConnectSucceededEvent: IAnalyticsEvent {
    var name = EventName.courierConnectSucceeded
    var properties = [String: String]()

    init(host: String, port: Int, isCache: Bool, networkType: String? = nil, timeTaken: Int? = nil) {
        properties[EventProperty.host] = host
        properties[EventProperty.port] = String(port)
        properties[EventProperty.networkType] = networkType ?? NetworkType.unknown.trackingId

        properties[EventProperty.source] = isCache ? "cache" : "api"

        if let timeTaken = timeTaken {
            properties[EventProperty.timeTaken] = String(timeTaken)
        }
    }
}

extension ICourierAnalyticsManager {
    func sendCourierConnectSucceededEvent(host: String, port: Int, isCache: Bool, networkType: String? = nil, timeTaken: Int? = nil, trackingSource: CourierAnalyticsService.Source) {
        let event = CourierConnectSucceededEvent(host: host, port: port, isCache: isCache, networkType: networkType, timeTaken: timeTaken)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
