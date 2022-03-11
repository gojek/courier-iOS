import Foundation

class MQTTConnectionLostEvent: IAnalyticsEvent {
    var name = EventName.mqttConnectionLost
    var properties = [String: String]()

    init(error: Error?, networkType: String? = nil, lastInboundDiff: Int? = nil, lastOutboundDiff: Int? = nil, timeTaken: Int? = nil) {
        if let error = error {
            properties[EventProperty.reasonMessage] = error.localizedDescription
            properties[EventProperty.reason] = String((error as NSError).code)
        }
        if let lastInboundDiff = lastInboundDiff {
            properties["LastInboundDiff"] = String(lastInboundDiff)
        }

        if let lastOutboundDiff = lastOutboundDiff {
            properties["LastOutboundDiff"] = String(lastOutboundDiff)
        }

        if let timeTaken = timeTaken {
            properties[EventProperty.timeTaken] = String(timeTaken)
        }

        properties[EventProperty.networkType] = networkType ?? NetworkType.unknown.trackingId
    }
}

extension ICourierAnalyticsManager {
    func sendMQTTConnectionLostEvent(error: Error?, networkType: String? = nil, trackingSource: CourierAnalyticsService.Source, lastInboundDiff: Int? = nil, lastOutboundDiff: Int? = nil, timeTaken: Int? = nil) {
        let event = MQTTConnectionLostEvent(error: error, networkType: networkType, lastInboundDiff: lastInboundDiff, lastOutboundDiff: lastOutboundDiff, timeTaken: timeTaken)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
