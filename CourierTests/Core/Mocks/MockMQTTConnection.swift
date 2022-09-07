import Foundation
@testable import CourierCore
@testable import CourierMQTT

class MockMQTTConnection: IMQTTConnection {

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

    var invokedIsDisconnectedGetter = false
    var invokedIsDisconnectedGetterCount = 0
    var stubbedIsDisconnected: Bool! = false

    var isDisconnected: Bool {
        invokedIsDisconnectedGetter = true
        invokedIsDisconnectedGetterCount += 1
        return stubbedIsDisconnected
    }

    var invokedServerUriGetter = false
    var invokedServerUriGetterCount = 0
    var stubbedServerUri: String!

    var serverUri: String? {
        invokedServerUriGetter = true
        invokedServerUriGetterCount += 1
        return stubbedServerUri
    }

    var invokedHasExistingSessionGetter = false
    var invokedHasExistingSessionGetterCount = 0
    var stubbedHasExistingSession: Bool! = false

    var hasExistingSession: Bool {
        invokedHasExistingSessionGetter = true
        invokedHasExistingSessionGetterCount += 1
        return stubbedHasExistingSession
    }

    var invokedConnect = false
    var invokedConnectCount = 0
    var invokedConnectParameters: (connectOptions: ConnectOptions, messageReceiveListener: IMessageReceiveListener)?
    var invokedConnectParametersList = [(connectOptions: ConnectOptions, messageReceiveListener: IMessageReceiveListener)]()

    func connect(connectOptions: ConnectOptions, messageReceiveListener: IMessageReceiveListener) {
        invokedConnect = true
        invokedConnectCount += 1
        invokedConnectParameters = (connectOptions, messageReceiveListener)
        invokedConnectParametersList.append((connectOptions, messageReceiveListener))
    }

    var invokedDisconnect = false
    var invokedDisconnectCount = 0

    func disconnect() {
        invokedDisconnect = true
        invokedDisconnectCount += 1
    }

    var invokedPublish = false
    var invokedPublishCount = 0
    var invokedPublishParameters: (packet: MQTTPacket, Void)?
    var invokedPublishParametersList = [(packet: MQTTPacket, Void)]()

    func publish(packet: MQTTPacket) {
        invokedPublish = true
        invokedPublishCount += 1
        invokedPublishParameters = (packet, ())
        invokedPublishParametersList.append((packet, ()))
    }

    var invokedDeleteAllPersistedMessages = false
    var invokedDeleteAllPersistedMessagesCount = 0

    func deleteAllPersistedMessages() {
        invokedDeleteAllPersistedMessages = true
        invokedDeleteAllPersistedMessagesCount += 1
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

    var invokedResetParams = false
    var invokedResetParamsCount = 0

    func resetParams() {
        invokedResetParams = true
        invokedResetParamsCount += 1
    }
}
