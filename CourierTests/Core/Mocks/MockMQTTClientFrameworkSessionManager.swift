import Foundation
import MQTTClientGJ
@testable import CourierCore
@testable import CourierMQTT

class MockMQTTClientFrameworkSessionManager: IMQTTClientFrameworkSessionManager {

    var invokedSessionGetter = false
    var invokedSessionGetterCount = 0
    var stubbedSession: IMQTTSession!

    var session: IMQTTSession? {
        invokedSessionGetter = true
        invokedSessionGetterCount += 1
        return stubbedSession
    }

    var invokedLastErrorGetter = false
    var invokedLastErrorGetterCount = 0
    var stubbedLastError: NSError!

    var lastError: NSError? {
        invokedLastErrorGetter = true
        invokedLastErrorGetterCount += 1
        return stubbedLastError
    }

    var invokedStateGetter = false
    var invokedStateGetterCount = 0
    var stubbedState: MQTTSessionManagerState!

    var state: MQTTSessionManagerState? {
        invokedStateGetter = true
        invokedStateGetterCount += 1
        return stubbedState
    }

    var invokedConnect = false
    var invokedConnectCount = 0
    var invokedConnectParameters: (host: String, port: Int, keepAlive: Int, isCleanSession: Bool, isAuth: Bool, clientId: String, username: String, password: String, lastWill: Bool, lastWillTopic: String?, lastWillMessage: Data?, lastWillQoS: MQTTQosLevel?, lastWillRetainFlag: Bool, securityPolicy: MQTTSSLSecurityPolicy?, certificates: [Any]?, protocolLevel: MQTTProtocolVersion, userProperties: [String: String]?, connectHandler: MQTTConnectHandler?)?
    var invokedConnectParametersList = [(host: String, port: Int, keepAlive: Int, isCleanSession: Bool, isAuth: Bool, clientId: String, username: String, password: String, lastWill: Bool, lastWillTopic: String?, lastWillMessage: Data?, lastWillQoS: MQTTQosLevel?, lastWillRetainFlag: Bool, securityPolicy: MQTTSSLSecurityPolicy?, certificates: [Any]?, protocolLevel: MQTTProtocolVersion, userProperties: [String: String]?, connectHandler: MQTTConnectHandler?)]()

    func connect(
        to host: String,
        port: Int,
        keepAlive: Int,
        isCleanSession: Bool,
        isAuth: Bool,
        clientId: String,
        username: String,
        password: String,
        lastWill: Bool,
        lastWillTopic: String?,
        lastWillMessage: Data?,
        lastWillQoS: MQTTQosLevel?,
        lastWillRetainFlag: Bool,
        securityPolicy: MQTTSSLSecurityPolicy?,
        certificates: [Any]?,
        protocolLevel: MQTTProtocolVersion,
        userProperties: [String: String]?,
        connectHandler: MQTTConnectHandler?) {
        invokedConnect = true
        invokedConnectCount += 1
        invokedConnectParameters = (host, port, keepAlive, isCleanSession, isAuth, clientId, username, password, lastWill, lastWillTopic, lastWillMessage, lastWillQoS, lastWillRetainFlag, securityPolicy, certificates, protocolLevel, userProperties, connectHandler)
        invokedConnectParametersList.append((host, port, keepAlive, isCleanSession, isAuth, clientId, username, password, lastWill, lastWillTopic, lastWillMessage, lastWillQoS, lastWillRetainFlag, securityPolicy, certificates, protocolLevel, userProperties, connectHandler))
    }

    var invokedDisconnect = false
    var invokedDisconnectCount = 0
    var invokedDisconnectParameters: (disconnectHandler: MQTTDisconnectHandler?, Void)?
    var invokedDisconnectParametersList = [(disconnectHandler: MQTTDisconnectHandler?, Void)]()

    func disconnect(with disconnectHandler: MQTTDisconnectHandler?) {
        invokedDisconnect = true
        invokedDisconnectCount += 1
        invokedDisconnectParameters = (disconnectHandler, ())
        invokedDisconnectParametersList.append((disconnectHandler, ()))
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
}
