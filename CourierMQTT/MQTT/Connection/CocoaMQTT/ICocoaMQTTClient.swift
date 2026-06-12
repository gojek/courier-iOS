import CocoaMQTT
import Foundation

/// Thin abstraction over `CocoaMQTT5` so the v5 connection can be unit tested
/// without opening a real socket. `CocoaMQTT5` conforms to it directly.
protocol ICocoaMQTTClient: AnyObject {
    var username: String? { get set }
    var password: String? { get set }
    var keepAlive: UInt16 { get set }
    var cleanSession: Bool { get set }
    var enableSSL: Bool { get set }
    var allowUntrustCACertificate: Bool { get set }
    var autoReconnect: Bool { get set }
    var connectProperties: MqttConnectProperties? { get set }
    var delegateQueue: DispatchQueue { get set }
    var delegate: CocoaMQTT5Delegate? { get set }
    var connState: CocoaMQTTConnState { get }

    @discardableResult func connectToBroker() -> Bool
    func disconnectFromBroker()
    @discardableResult func publishMessage(_ message: CocoaMQTT5Message, properties: MqttPublishProperties) -> Int
    func subscribeTopics(_ topics: [MqttSubscription])
    func unsubscribeTopics(_ topics: [String])
}

extension CocoaMQTT5: ICocoaMQTTClient {

    @discardableResult
    func connectToBroker() -> Bool {
        connect()
    }

    func disconnectFromBroker() {
        disconnect()
    }

    @discardableResult
    func publishMessage(_ message: CocoaMQTT5Message, properties: MqttPublishProperties) -> Int {
        publish(message, properties: properties)
    }

    func subscribeTopics(_ topics: [MqttSubscription]) {
        subscribe(topics)
    }

    func unsubscribeTopics(_ topics: [String]) {
        topics.forEach { unsubscribe($0) }
    }
}

protocol ICocoaMQTTClientFactory {
    func makeClient(clientId: String, host: String, port: UInt16) -> ICocoaMQTTClient
}

struct CocoaMQTTClientFactory: ICocoaMQTTClientFactory {
    func makeClient(clientId: String, host: String, port: UInt16) -> ICocoaMQTTClient {
        CocoaMQTT5(clientID: clientId, host: host, port: port)
    }
}
