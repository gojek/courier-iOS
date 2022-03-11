import Foundation
import MQTTClientGJ
@testable import CourierCore
@testable import CourierMQTT

class MockMQTTClientFrameworkSessionManagerDelegate: MQTTClientFrameworkSessionManagerDelegate {

    var invokedSessionManagerDidChangeState = false
    var invokedSessionManagerDidChangeStateCount = 0
    var invokedSessionManagerDidChangeStateParameters: (sessionManager: IMQTTClientFrameworkSessionManager, newState: MQTTSessionManagerState)?
    var invokedSessionManagerDidChangeStateParametersList = [(sessionManager: IMQTTClientFrameworkSessionManager, newState: MQTTSessionManagerState)]()

    func sessionManager(_ sessionManager: IMQTTClientFrameworkSessionManager, didChangeState newState: MQTTSessionManagerState) {
        invokedSessionManagerDidChangeState = true
        invokedSessionManagerDidChangeStateCount += 1
        invokedSessionManagerDidChangeStateParameters = (sessionManager, newState)
        invokedSessionManagerDidChangeStateParametersList.append((sessionManager, newState))
    }

    var invokedSessionManagerDidDeliverMessageID = false
    var invokedSessionManagerDidDeliverMessageIDCount = 0
    var invokedSessionManagerDidDeliverMessageIDParameters: (sessionManager: IMQTTClientFrameworkSessionManager, msgID: UInt16, topic: String, data: Data, qos: MQTTQosLevel, retainFlag: Bool)?
    var invokedSessionManagerDidDeliverMessageIDParametersList = [(sessionManager: IMQTTClientFrameworkSessionManager, msgID: UInt16, topic: String, data: Data, qos: MQTTQosLevel, retainFlag: Bool)]()

    func sessionManager(_ sessionManager: IMQTTClientFrameworkSessionManager, didDeliverMessageID msgID: UInt16, topic: String, data: Data, qos: MQTTQosLevel, retainFlag: Bool) {
        invokedSessionManagerDidDeliverMessageID = true
        invokedSessionManagerDidDeliverMessageIDCount += 1
        invokedSessionManagerDidDeliverMessageIDParameters = (sessionManager, msgID, topic, data, qos, retainFlag)
        invokedSessionManagerDidDeliverMessageIDParametersList.append((sessionManager, msgID, topic, data, qos, retainFlag))
    }

    var invokedSessionManagerDidReceiveMessageData = false
    var invokedSessionManagerDidReceiveMessageDataCount = 0
    var invokedSessionManagerDidReceiveMessageDataParameters: (sessionManager: IMQTTClientFrameworkSessionManager, data: Data, topic: String, qos: MQTTQosLevel, retained: Bool, mid: UInt32)?
    var invokedSessionManagerDidReceiveMessageDataParametersList = [(sessionManager: IMQTTClientFrameworkSessionManager, data: Data, topic: String, qos: MQTTQosLevel, retained: Bool, mid: UInt32)]()

    func sessionManager(_ sessionManager: IMQTTClientFrameworkSessionManager, didReceiveMessageData data: Data, onTopic topic: String, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
        invokedSessionManagerDidReceiveMessageData = true
        invokedSessionManagerDidReceiveMessageDataCount += 1
        invokedSessionManagerDidReceiveMessageDataParameters = (sessionManager, data, topic, qos, retained, mid)
        invokedSessionManagerDidReceiveMessageDataParametersList.append((sessionManager, data, topic, qos, retained, mid))
    }

    var invokedSessionManagerDidSubscribeTopics = false
    var invokedSessionManagerDidSubscribeTopicsCount = 0
    var invokedSessionManagerDidSubscribeTopicsParameters: (sessionManager: IMQTTClientFrameworkSessionManager, topics: [String])?
    var invokedSessionManagerDidSubscribeTopicsParametersList = [(sessionManager: IMQTTClientFrameworkSessionManager, topics: [String])]()

    func sessionManager(_ sessionManager: IMQTTClientFrameworkSessionManager, didSubscribeTopics topics: [String]) {
        invokedSessionManagerDidSubscribeTopics = true
        invokedSessionManagerDidSubscribeTopicsCount += 1
        invokedSessionManagerDidSubscribeTopicsParameters = (sessionManager, topics)
        invokedSessionManagerDidSubscribeTopicsParametersList.append((sessionManager, topics))
    }

    var invokedSessionManagerDidFailToSubscribeTopics = false
    var invokedSessionManagerDidFailToSubscribeTopicsCount = 0
    var invokedSessionManagerDidFailToSubscribeTopicsParameters: (sessionManager: IMQTTClientFrameworkSessionManager, topics: [String], error: Error)?
    var invokedSessionManagerDidFailToSubscribeTopicsParametersList = [(sessionManager: IMQTTClientFrameworkSessionManager, topics: [String], error: Error)]()

    func sessionManager(_ sessionManager: IMQTTClientFrameworkSessionManager, didFailToSubscribeTopics topics: [String], error: Error) {
        invokedSessionManagerDidFailToSubscribeTopics = true
        invokedSessionManagerDidFailToSubscribeTopicsCount += 1
        invokedSessionManagerDidFailToSubscribeTopicsParameters = (sessionManager, topics, error)
        invokedSessionManagerDidFailToSubscribeTopicsParametersList.append((sessionManager, topics, error))
    }

    var invokedSessionManagerDidUnsubscribeTopics = false
    var invokedSessionManagerDidUnsubscribeTopicsCount = 0
    var invokedSessionManagerDidUnsubscribeTopicsParameters: (sessionManager: IMQTTClientFrameworkSessionManager, topics: [String])?
    var invokedSessionManagerDidUnsubscribeTopicsParametersList = [(sessionManager: IMQTTClientFrameworkSessionManager, topics: [String])]()

    func sessionManager(_ sessionManager: IMQTTClientFrameworkSessionManager, didUnsubscribeTopics topics: [String]) {
        invokedSessionManagerDidUnsubscribeTopics = true
        invokedSessionManagerDidUnsubscribeTopicsCount += 1
        invokedSessionManagerDidUnsubscribeTopicsParameters = (sessionManager, topics)
        invokedSessionManagerDidUnsubscribeTopicsParametersList.append((sessionManager, topics))
    }

    var invokedSessionManagerDidFailToUnsubscribeTopics = false
    var invokedSessionManagerDidFailToUnsubscribeTopicsCount = 0
    var invokedSessionManagerDidFailToUnsubscribeTopicsParameters: (sessionManager: IMQTTClientFrameworkSessionManager, topics: [String], error: Error)?
    var invokedSessionManagerDidFailToUnsubscribeTopicsParametersList = [(sessionManager: IMQTTClientFrameworkSessionManager, topics: [String], error: Error)]()

    func sessionManager(_ sessionManager: IMQTTClientFrameworkSessionManager, didFailToUnsubscribeTopics topics: [String], error: Error) {
        invokedSessionManagerDidFailToUnsubscribeTopics = true
        invokedSessionManagerDidFailToUnsubscribeTopicsCount += 1
        invokedSessionManagerDidFailToUnsubscribeTopicsParameters = (sessionManager, topics, error)
        invokedSessionManagerDidFailToUnsubscribeTopicsParametersList.append((sessionManager, topics, error))
    }

    var invokedSessionManagerDidPing = false
    var invokedSessionManagerDidPingCount = 0
    var invokedSessionManagerDidPingParameters: (sessionManager: IMQTTClientFrameworkSessionManager, Void)?
    var invokedSessionManagerDidPingParametersList = [(sessionManager: IMQTTClientFrameworkSessionManager, Void)]()

    func sessionManagerDidPing(_ sessionManager: IMQTTClientFrameworkSessionManager) {
        invokedSessionManagerDidPing = true
        invokedSessionManagerDidPingCount += 1
        invokedSessionManagerDidPingParameters = (sessionManager, ())
        invokedSessionManagerDidPingParametersList.append((sessionManager, ()))
    }

    var invokedSessionManagerDidReceivePong = false
    var invokedSessionManagerDidReceivePongCount = 0
    var invokedSessionManagerDidReceivePongParameters: (sessionManager: IMQTTClientFrameworkSessionManager, Void)?
    var invokedSessionManagerDidReceivePongParametersList = [(sessionManager: IMQTTClientFrameworkSessionManager, Void)]()

    func sessionManagerDidReceivePong(_ sessionManager: IMQTTClientFrameworkSessionManager) {
        invokedSessionManagerDidReceivePong = true
        invokedSessionManagerDidReceivePongCount += 1
        invokedSessionManagerDidReceivePongParameters = (sessionManager, ())
        invokedSessionManagerDidReceivePongParametersList.append((sessionManager, ()))
    }

    var invokedSessionManagerDidSendConnectPacket = false
    var invokedSessionManagerDidSendConnectPacketCount = 0
    var invokedSessionManagerDidSendConnectPacketParameters: (sessionManager: IMQTTClientFrameworkSessionManager, Void)?
    var invokedSessionManagerDidSendConnectPacketParametersList = [(sessionManager: IMQTTClientFrameworkSessionManager, Void)]()

    func sessionManagerDidSendConnectPacket(_ sessionManager: IMQTTClientFrameworkSessionManager) {
        invokedSessionManagerDidSendConnectPacket = true
        invokedSessionManagerDidSendConnectPacketCount += 1
        invokedSessionManagerDidSendConnectPacketParameters = (sessionManager, ())
        invokedSessionManagerDidSendConnectPacketParametersList.append((sessionManager, ()))
    }
}
