import Foundation

class ConnectPacketSendEvent: IAnalyticsEvent {
    var name = EventName.connectPacketSend
    var properties = [String: String]()

    init(networkType: String? = nil) {
        properties[EventProperty.networkType] = networkType ?? NetworkType.unknown.trackingId
    }
}

extension ICourierAnalyticsManager {
    func sendConnectPacketSendEvent(networkType: String? = nil, trackingSource: CourierAnalyticsService.Source) {
        let event = ConnectPacketSendEvent(networkType: networkType)
        send(event.name, properties: event.properties, source: trackingSource)
    }
}
