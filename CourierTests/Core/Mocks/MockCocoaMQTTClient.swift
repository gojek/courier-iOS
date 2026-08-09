import CocoaMQTT
import Foundation
@testable import CourierCore
@testable import CourierMQTT

final class MockCocoaMQTTClient: ICocoaMQTTClient {

    var username: String?
    var password: String?
    var keepAlive: UInt16 = 0
    var cleanSession: Bool = false
    var enableSSL: Bool = false
    var allowUntrustCACertificate: Bool = false
    var autoReconnect: Bool = true
    var connectProperties: MqttConnectProperties?
    var delegateQueue: DispatchQueue = .main
    weak var delegate: CocoaMQTT5Delegate?
    var connState: CocoaMQTTConnState = .disconnected

    var invokedConnect = false
    var invokedConnectCount = 0
    var stubbedConnectResult = true

    func connectToBroker() -> Bool {
        invokedConnect = true
        invokedConnectCount += 1
        return stubbedConnectResult
    }

    var invokedDisconnect = false
    var invokedDisconnectCount = 0

    func disconnectFromBroker() {
        invokedDisconnect = true
        invokedDisconnectCount += 1
    }

    var invokedPublish = false
    var invokedPublishCount = 0
    var invokedPublishParameters: (message: CocoaMQTT5Message, properties: MqttPublishProperties)?
    var stubbedPublishResult = 1

    func publishMessage(_ message: CocoaMQTT5Message, properties: MqttPublishProperties) -> Int {
        invokedPublish = true
        invokedPublishCount += 1
        invokedPublishParameters = (message, properties)
        return stubbedPublishResult
    }

    var invokedSubscribe = false
    var invokedSubscribeCount = 0
    var invokedSubscribeParameters: (topics: [MqttSubscription], Void)?

    func subscribeTopics(_ topics: [MqttSubscription]) {
        invokedSubscribe = true
        invokedSubscribeCount += 1
        invokedSubscribeParameters = (topics, ())
    }

    var invokedUnsubscribe = false
    var invokedUnsubscribeCount = 0
    var invokedUnsubscribeParameters: (topics: [String], Void)?

    func unsubscribeTopics(_ topics: [String]) {
        invokedUnsubscribe = true
        invokedUnsubscribeCount += 1
        invokedUnsubscribeParameters = (topics, ())
    }
}

final class MockCocoaMQTTClientFactory: ICocoaMQTTClientFactory {

    let stubbedClient: MockCocoaMQTTClient

    init(stubbedClient: MockCocoaMQTTClient = MockCocoaMQTTClient()) {
        self.stubbedClient = stubbedClient
    }

    var invokedMakeClient = false
    var invokedMakeClientCount = 0
    var invokedMakeClientParameters: (clientId: String, host: String, port: UInt16)?

    func makeClient(clientId: String, host: String, port: UInt16) -> ICocoaMQTTClient {
        invokedMakeClient = true
        invokedMakeClientCount += 1
        invokedMakeClientParameters = (clientId, host, port)
        return stubbedClient
    }
}
