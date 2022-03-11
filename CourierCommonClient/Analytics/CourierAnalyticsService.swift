import Foundation
import Reachability
import CourierCore
import CourierMQTT

public typealias CourierAnalyticsManagerProvider = (_ name: String, _ properties: [String: Any]?) -> Void

protocol ICourierAnalyticsManager {
    func send(_ name: String, properties: [String: Any]?, source: CourierAnalyticsService.Source)
}

struct CourierAnalyticsManager: ICourierAnalyticsManager {

    let appStateObserver: IAppStateObserver
    let analyticsManagerProvider: CourierAnalyticsManagerProvider
    let clickstreamAnalyticsManagerProvider: CourierAnalyticsManagerProvider

    func send(_ name: String, properties: [String: Any]?, source: CourierAnalyticsService.Source) {
        var propertiesToSend = properties
        switch source {
        case .clickstream:
            clickstreamAnalyticsManagerProvider(name, propertiesToSend)

        default:
            let currentTimeInMillis = Int(floor(Date().timeIntervalSince1970 * 1000))
            propertiesToSend?[EventProperty.systemTime] = String(currentTimeInMillis)
            switch appStateObserver.state {
            case .active:
                propertiesToSend?[EventProperty.appState] = "Foreground"
            default:
                propertiesToSend?[EventProperty.appState] = "Background"
            }
            analyticsManagerProvider(name, propertiesToSend)
        }
    }
}

public class CourierAnalyticsService: ICourierEventHandler {
    let analyticsManager: ICourierAnalyticsManager
    private let appStateObserver: IAppStateObserver
    let eventProbability: Int
    let clickstreamTrackingEnabled: Bool
    let clickstreamEventProbability: Int
    let reachability: Reachability?
    private var connectionServiceStartTimestamp: Date?
    private var connectionServiceTimeTaken: Int? { calculateTimeTakenDiff(startTimestamp: connectionServiceStartTimestamp) }
    private var mqttConnectStartTimestamp: Date?
    private var mqttConnectSuccessTimestamp: Date?
    private var mqttConnectTimeTaken: Int? { calculateTimeTakenDiff(startTimestamp: mqttConnectStartTimestamp) }
    private var mqttConnectSuccessToLostTimeTaken: Int? { calculateTimeTakenDiff(startTimestamp: mqttConnectSuccessTimestamp) }

    private func calculateTimeTakenDiff(startTimestamp: Date?) -> Int? {
        guard let startTimestamp = startTimestamp else {
            return nil
        }
        return Int((Date().timeIntervalSince1970 - startTimestamp.timeIntervalSince1970) * 1000)
    }

    private var topicsSubscribeStartTimestamp: [String: Date] = [:]
    private var topicsUnsubscribeStartTimestamp: [String: Date] = [:]

    public private(set) var shouldLog = false
    public private(set) var shouldLogClickstream = false

    enum Source {
        case clevertap
        case clickstream
    }

    public init(analyticsManagerProvider: @escaping CourierAnalyticsManagerProvider,
                eventProbability: Int = 100,
                clickstreamAnalyticsManagerProvider: @escaping CourierAnalyticsManagerProvider,
                clickstreamTrackingEnabled: Bool = false,
                clickstreamEventProbability: Int = 100,
                reachability: Reachability? = nil,
                appStateObserver: IAppStateObserver = AppStateObserver.shared) {
        self.appStateObserver = appStateObserver
        self.analyticsManager = CourierAnalyticsManager(
            appStateObserver: appStateObserver,
            analyticsManagerProvider: analyticsManagerProvider,
            clickstreamAnalyticsManagerProvider: clickstreamAnalyticsManagerProvider)
        self.clickstreamTrackingEnabled = clickstreamTrackingEnabled
        self.clickstreamEventProbability = clickstreamEventProbability
        self.eventProbability = eventProbability
        if let reachability = reachability {
            self.reachability = reachability
        } else {
            self.reachability = try? Reachability()
        }
        self.reset()
    }

    public func reset() {
        shouldLog = Int.random(in: 0 ..< 100) < eventProbability
        shouldLogClickstream = Int.random(in: 0 ..< 100) < clickstreamEventProbability && clickstreamTrackingEnabled
    }

    private var networkType: String? {
        reachability?.networkType.trackingId
    }

    public func onEvent(_ event: CourierEvent) {
        logEvent(event: event, trackingSource: .clevertap)
        logEvent(event: event, trackingSource: .clickstream)
    }

    private func logEvent(event: CourierEvent, trackingSource: Source) {
        switch event {
        case .appBackground, .appForeground:
            analyticsManager.sendAppActiveTimeTrackerEvent(action: appStateObserver.state == .active ? "Foreground" : "Background", trackingSource: trackingSource)
            return
        default: break
        }

        switch trackingSource {
        case .clickstream:
            guard shouldLogClickstream else { return }
        default:
            guard shouldLog else { return }
        }

        switch event {
        case let .connectionServiceAuthStart(source):
            connectionServiceStartTimestamp = Date()
            analyticsManager.sendCourierConnectStartedEvent(source: source, networkType: networkType, trackingSource: trackingSource)
        case let .connectionServiceAuthSuccess(host, port, isCache):
            analyticsManager.sendCourierConnectSucceededEvent(host: host, port: port, isCache: isCache, networkType: networkType, timeTaken: connectionServiceTimeTaken, trackingSource: trackingSource)
        case let .connectionServiceAuthFailure(error):
            analyticsManager.sendCourierConnectFailedEvent(networkType: networkType, error: error, timeTaken: connectionServiceTimeTaken, trackingSource: trackingSource)
        case .connectionAttempt:
            mqttConnectSuccessTimestamp = nil
            topicsSubscribeStartTimestamp.removeAll()
            topicsUnsubscribeStartTimestamp.removeAll()
            mqttConnectStartTimestamp = Date()
            analyticsManager.sendMQTTConnectAttemptEvent(networkType: networkType, trackingSource: trackingSource)
        case .connectionSuccess:
            analyticsManager.sendMQTTConnectSuccessEvent(networkType: networkType, timeTaken: mqttConnectTimeTaken, trackingSource: trackingSource)
            mqttConnectSuccessTimestamp = Date()
        case let .connectionFailure(error):
            analyticsManager.sendMQTTConnectFailureEvent(error: error, networkType: networkType, timeTaken: mqttConnectTimeTaken, trackingSource: trackingSource)
        case .connectionDisconnect:
            analyticsManager.sendMQTTConnectionDisconnectEvent(trackingSource: trackingSource)
        case let .courierDisconnect(clearState):
            analyticsManager.sendCourierDisconnectEventEvent(clearState: clearState, trackingSource: trackingSource)
        case let .connectionLost(error, diffLastInbound, diffLastOutbound):
            analyticsManager.sendMQTTConnectionLostEvent(error: error, networkType: networkType, trackingSource: trackingSource, lastInboundDiff: diffLastInbound, lastOutboundDiff: diffLastOutbound, timeTaken: calculateTimeTakenDiff(startTimestamp: mqttConnectSuccessTimestamp))
        case let .subscribeAttempt(topic):
            topicsSubscribeStartTimestamp[topic] = Date()
            analyticsManager.sendMQTTSubscribeAttemptEvent(topic: topic, networkType: networkType, trackingSource: trackingSource)
        case let .unsubscribeAttempt(topic):
            topicsUnsubscribeStartTimestamp[topic] = Date()
            analyticsManager.sendMQTTUnsubscribeAttemptEvent(topic: topic, networkType: networkType, trackingSource: trackingSource)
        case let .subscribeSuccess(topic):
            let timeTaken = calculateTimeTakenDiff(startTimestamp: topicsSubscribeStartTimestamp[topic])
            topicsSubscribeStartTimestamp[topic] = nil
            analyticsManager.sendMQTTSubscribeSuccessEvent(topic: topic, networkType: networkType, timeTaken: timeTaken, trackingSource: trackingSource)
        case let .unsubscribeSuccess(topic):
            let timeTaken = calculateTimeTakenDiff(startTimestamp: topicsUnsubscribeStartTimestamp[topic])
            topicsUnsubscribeStartTimestamp[topic] = nil
            analyticsManager.sendMQTTUnsubscribeSuccessEvent(topic: topic, networkType: networkType, timeTaken: timeTaken, trackingSource: trackingSource)
        case let .subscribeFailure(topic, error):
            let timeTaken = calculateTimeTakenDiff(startTimestamp: topicsSubscribeStartTimestamp[topic])
            topicsSubscribeStartTimestamp[topic] = nil
            analyticsManager.sendMQTTSubscribeFailureEvent(topic: topic, error: error, networkType: networkType, timeTaken: timeTaken, trackingSource: trackingSource)
        case let .unsubscribeFailure(topic, error):
            let timeTaken = calculateTimeTakenDiff(startTimestamp: topicsUnsubscribeStartTimestamp[topic])
            topicsUnsubscribeStartTimestamp[topic] = nil
            analyticsManager.sendMQTTUnsubscribeFailureEvent(topic: topic, error: error, networkType: networkType, timeTaken: timeTaken, trackingSource: trackingSource)
        case let .ping(url):
            analyticsManager.sendMQTTPingInitiatedEvent(serverUri: url, networkType: networkType, trackingSource: trackingSource)
        case let .pongReceived(timeTaken):
            analyticsManager.sendMQTTPingSuccessEvent(timeTaken: timeTaken, networkType: networkType, trackingSource: trackingSource)
        case let .pingFailure(timeTaken, error):
            analyticsManager.sendMQTTPingFailureEvent(timeTaken: timeTaken, error: error, networkType: networkType, trackingSource: trackingSource)
        case let .messageReceive(topic, sizeBytes):
            analyticsManager.sendMQTTMessageReceiveEvent(networkType: networkType, topic: topic, sizeBytes: sizeBytes, trackingSource: trackingSource)
        case let .messageReceiveFailure(topic, error, sizeBytes):
            analyticsManager.sendMQTTMessageReceiveFailedEvent(networkType: networkType, error: error, topic: topic, sizeBytes: sizeBytes, trackingSource: trackingSource)
        case let .messageSendSuccess(topic, qos, sizeBytes):
            analyticsManager.sendMQTTMessageSendSuccessEvent(networkType: networkType, qos: qos, topic: topic, sizeBytes: sizeBytes, trackingSource: trackingSource)
        case let .messageSend(topic, qos, sizeBytes):
            analyticsManager.sendMQTTMessageSendEvent(networkType: networkType, qos: qos, topic: topic, sizeBytes: sizeBytes, trackingSource: trackingSource)
        case let .messageSendFailure(topic, qos, error, sizeBytes):
            analyticsManager.sendMQTTMessageSendFailedEvent(error: error, qos: qos, networkType: networkType, topic: topic, sizeBytes: sizeBytes, trackingSource: trackingSource)
        case .connectedPacketSent:
            analyticsManager.sendConnectPacketSendEvent(networkType: networkType, trackingSource: trackingSource)
        case .reconnect:
            analyticsManager.sendCourierReconnectEvent(networkType: networkType, trackingSource: trackingSource)
        case .connectDiscarded(let reason):
            analyticsManager.sendMQTTConnectDiscardedEvent(reason: reason, networkType: networkType, trackingSource: trackingSource)
        default:
            break
        }
    }

}
