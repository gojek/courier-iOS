import Foundation
@testable import CourierCore
@testable import CourierMQTT

class MockMQTTClient: IMQTTClient {

    var invokedIsConnectedGetter = false
    var invokedIsConnectedGetterCount = 0
    var stubbedIsConnected: Bool! = false

    var isConnected: Bool {
        invokedIsConnectedGetter = true
        invokedIsConnectedGetterCount += 1
        return stubbedIsConnected
    }

    var invokedIsConnectingGetter = false
    var invokedIsConnectingGetterCount = 0
    var stubbedIsConnecting: Bool! = false

    var isConnecting: Bool {
        invokedIsConnectingGetter = true
        invokedIsConnectingGetterCount += 1
        return stubbedIsConnecting
    }

    var invokedHasExistingSessionGetter = false
    var invokedHasExistingSessionGetterCount = 0
    var stubbedHasExistingSession: Bool! = false

    var hasExistingSession: Bool {
        invokedHasExistingSessionGetter = true
        invokedHasExistingSessionGetterCount += 1
        return stubbedHasExistingSession
    }

    var invokedConnectOptionsGetter = false
    var invokedConnectOptionsGetterCount = 0
    var stubbedConnectOptions: ConnectOptions!

    var connectOptions: ConnectOptions? {
        invokedConnectOptionsGetter = true
        invokedConnectOptionsGetterCount += 1
        return stubbedConnectOptions
    }

    var invokedSubscribedMessageStreamGetter = false
    var invokedSubscribedMessageStreamGetterCount = 0
    var stubbedSubscribedMessageStream: Observable<MQTTPacket>!

    var subscribedMessageStream: Observable<MQTTPacket> {
        invokedSubscribedMessageStreamGetter = true
        invokedSubscribedMessageStreamGetterCount += 1
        return stubbedSubscribedMessageStream
    }

    var invokedMessageReceiverListenerGetter = false
    var invokedMessageReceiverListenerGetterCount = 0
    var stubbedMessageReceiverListener: IMessageReceiveListener!

    var messageReceiverListener: IMessageReceiveListener {
        invokedMessageReceiverListenerGetter = true
        invokedMessageReceiverListenerGetterCount += 1
        return stubbedMessageReceiverListener
    }

    var invokedConnect = false
    var invokedConnectCount = 0
    var invokedConnectParameters: (connectOptions: ConnectOptions, Void)?
    var invokedConnectParametersList = [(connectOptions: ConnectOptions, Void)]()

    func connect(connectOptions: ConnectOptions) {
        invokedConnect = true
        invokedConnectCount += 1
        invokedConnectParameters = (connectOptions, ())
        invokedConnectParametersList.append((connectOptions, ()))
    }

    var invokedReconnect = false
    var invokedReconnectCount = 0

    func reconnect() {
        invokedReconnect = true
        invokedReconnectCount += 1
    }

    var invokedDisconnect = false
    var invokedDisconnectCount = 0

    func disconnect() {
        invokedDisconnect = true
        invokedDisconnectCount += 1
    }

    var invokedSubscribe = false
    var invokedSubscribeCount = 0
    var invokedSubscribeParameters: (topics: [(topic: String, qos: QoS)], Void)?
    var invokedSubscribeParametersList = [(topics: [(topic: String, qos: QoS)], Void)]()

    func subscribe(_ topics: [(topic: String, qos: QoS)]) {
        invokedSubscribe = true
        invokedSubscribeCount += 1
        invokedSubscribeParameters = (topics, ())
        invokedSubscribeParametersList.append((topics, ()))
    }

    var invokedUnsubscribe = false
    var invokedUnsubscribeCount = 0
    var invokedUnsubscribeParameters: (topics: [String], Void)?
    var invokedUnsubscribeParametersList = [(topics: [String], Void)]()

    func unsubscribe(_ topics: [String]) {
        invokedUnsubscribe = true
        invokedUnsubscribeCount += 1
        invokedUnsubscribeParameters = (topics, ())
        invokedUnsubscribeParametersList.append((topics, ()))
    }

    var invokedSend = false
    var invokedSendCount = 0
    var invokedSendParameters: (packet: MQTTPacket, Void)?
    var invokedSendParametersList = [(packet: MQTTPacket, Void)]()

    func send(packet: MQTTPacket) {
        invokedSend = true
        invokedSendCount += 1
        invokedSendParameters = (packet, ())
        invokedSendParametersList.append((packet, ()))
    }

    var invokedDeleteAllPersistedMessages = false
    var invokedDeleteAllPersistedMessagesCount = 0

    func deleteAllPersistedMessages() {
        invokedDeleteAllPersistedMessages = true
        invokedDeleteAllPersistedMessagesCount += 1
    }

    var invokedReset = false
    var invokedResetCount = 0

    func reset() {
        invokedReset = true
        invokedResetCount += 1
    }

    var invokedDestroy = false
    var invokedDestroyCount = 0

    func destroy() {
        invokedDestroy = true
        invokedDestroyCount += 1
    }

    var invokedSetKeepAliveFailureHandler = false
    var invokedSetKeepAliveFailureHandlerCount = 0
    var invokedSetKeepAliveFailureHandlerParameters: (handler: KeepAliveFailureHandler, Void)?
    var invokedSetKeepAliveFailureHandlerParametersList = [(handler: KeepAliveFailureHandler, Void)]()

    func setKeepAliveFailureHandler(handler: KeepAliveFailureHandler) {
        invokedSetKeepAliveFailureHandler = true
        invokedSetKeepAliveFailureHandlerCount += 1
        invokedSetKeepAliveFailureHandlerParameters = (handler, ())
        invokedSetKeepAliveFailureHandlerParametersList.append((handler, ()))
    }
}
