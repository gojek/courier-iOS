import CourierCore
import UIKit

extension MQTTCourierClient: ICourierEventHandler {

    func onEvent(_ event: CourierEvent) {
        switch event {
        case .connectionAttempt:
            onMQTTConnectAttempt()
        case .connectionSuccess:
            onMQTTConnectSuccess()
        case .connectionFailure:
            onMQTTConnectFailure()
        case .connectionLost:
            onMQTTConnectionLost()
        case .connectionDisconnect:
            onMQTTDisconnect()
        case .unsubscribeSuccess(let topic):
            onMQTTUnsubscribeSuccess(topic: topic)
        case .appForeground:
            onAppForeground()
        case .appBackground:
            onAppBackground()
        case .connectionAvailable:
            connect()

        default: break
        }
    }

    private func onMQTTConnectAttempt() {
        publishConnectionState(connectionState)
    }

    private func onMQTTConnectSuccess() {
        let isCleanSession = client.connectOptions?.isCleanSession ?? false
        if isCleanSession {
            subscriptionStore.clearAllSubscriptions()
        }

        publishConnectionState(connectionState)
        client.unsubscribe( Array(subscriptionStore.pendingUnsubscriptions))
        client.subscribe(subscriptionStore.subscriptions.map { ($0.key, $0.value) })
    }

    private func onMQTTConnectFailure() {
        publishConnectionState(connectionState)
    }

    private func onMQTTConnectionLost() {
        publishConnectionState(connectionState)
    }

    private func onMQTTDisconnect() {
        courierEventHandler.onEvent(.courierDisconnect(clearState: isDestroyed))
        publishConnectionState(connectionState)
    }

    private func onMQTTUnsubscribeSuccess(topic: String) {
        subscriptionStore.unsubscribeAcked([topic])
    }

    private func onAppBackground() {
        let delay: TimeInterval
        self.backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "Cleanup pending unsub") { [weak self] in
            guard let self = self, let backgroundTaskID = self.backgroundTaskID else { return }
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
        }
        delay = 1.0

        #if DEBUG || INTEGRATION
        printDebug("MQTT - COURIER: ON App Background, Unsubscribing: \(self.subscriptionStore.pendingUnsubscriptions.map { $0 })")
        #endif

        self.clearConnectionTimerAndFlags()
        let token = Date().timeIntervalSince1970
        self.onBackgroundToken = token

        dispatchQueue.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self, self.onBackgroundToken == token else { return }
            printDebug("MQTT - COURIER: Disconnected on background")
            self.client.disconnect()
            if let backgroundTaskID = self.backgroundTaskID {
                UIApplication.shared.endBackgroundTask(backgroundTaskID)
                self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
            }
        }
    }

    private func onAppForeground() {
        self.onBackgroundToken = nil
        if let backgroundTaskID = self.backgroundTaskID {
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
        }

        dispatchQueue.async { [weak self] in
            self?.connectSource = "App Foreground"
            self?.connect()
        }
    }
}
