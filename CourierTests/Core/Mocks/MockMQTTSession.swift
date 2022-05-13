import Foundation
import MQTTClientGJ
@testable import CourierCore
@testable import CourierMQTT

class MockMQTTSession: IMQTTSession {

    var invokedPersistenceSetter = false
    var invokedPersistenceSetterCount = 0
    var invokedPersistence: MQTTPersistence?
    var invokedPersistenceList = [MQTTPersistence?]()
    var invokedPersistenceGetter = false
    var invokedPersistenceGetterCount = 0
    var stubbedPersistence: MQTTPersistence!

    var persistence: MQTTPersistence! {
        set {
            invokedPersistenceSetter = true
            invokedPersistenceSetterCount += 1
            invokedPersistence = newValue
            invokedPersistenceList.append(newValue)
        }
        get {
            invokedPersistenceGetter = true
            invokedPersistenceGetterCount += 1
            return stubbedPersistence
        }
    }

    var invokedDelegateSetter = false
    var invokedDelegateSetterCount = 0
    var invokedDelegate: MQTTSessionDelegate?
    var invokedDelegateList = [MQTTSessionDelegate?]()
    var invokedDelegateGetter = false
    var invokedDelegateGetterCount = 0
    var stubbedDelegate: MQTTSessionDelegate!

    var delegate: MQTTSessionDelegate! {
        set {
            invokedDelegateSetter = true
            invokedDelegateSetterCount += 1
            invokedDelegate = newValue
            invokedDelegateList.append(newValue)
        }
        get {
            invokedDelegateGetter = true
            invokedDelegateGetterCount += 1
            return stubbedDelegate
        }
    }

    var invokedStreamSSLLevelSetter = false
    var invokedStreamSSLLevelSetterCount = 0
    var invokedStreamSSLLevel: String?
    var invokedStreamSSLLevelList = [String?]()
    var invokedStreamSSLLevelGetter = false
    var invokedStreamSSLLevelGetterCount = 0
    var stubbedStreamSSLLevel: String!

    var streamSSLLevel: String! {
        set {
            invokedStreamSSLLevelSetter = true
            invokedStreamSSLLevelSetterCount += 1
            invokedStreamSSLLevel = newValue
            invokedStreamSSLLevelList.append(newValue)
        }
        get {
            invokedStreamSSLLevelGetter = true
            invokedStreamSSLLevelGetterCount += 1
            return stubbedStreamSSLLevel
        }
    }

    var invokedClientIdSetter = false
    var invokedClientIdSetterCount = 0
    var invokedClientId: String?
    var invokedClientIdList = [String?]()
    var invokedClientIdGetter = false
    var invokedClientIdGetterCount = 0
    var stubbedClientId: String!

    var clientId: String! {
        set {
            invokedClientIdSetter = true
            invokedClientIdSetterCount += 1
            invokedClientId = newValue
            invokedClientIdList.append(newValue)
        }
        get {
            invokedClientIdGetter = true
            invokedClientIdGetterCount += 1
            return stubbedClientId
        }
    }

    var invokedUserNameSetter = false
    var invokedUserNameSetterCount = 0
    var invokedUserName: String?
    var invokedUserNameList = [String?]()
    var invokedUserNameGetter = false
    var invokedUserNameGetterCount = 0
    var stubbedUserName: String!

    var userName: String! {
        set {
            invokedUserNameSetter = true
            invokedUserNameSetterCount += 1
            invokedUserName = newValue
            invokedUserNameList.append(newValue)
        }
        get {
            invokedUserNameGetter = true
            invokedUserNameGetterCount += 1
            return stubbedUserName
        }
    }

    var invokedPasswordSetter = false
    var invokedPasswordSetterCount = 0
    var invokedPassword: String?
    var invokedPasswordList = [String?]()
    var invokedPasswordGetter = false
    var invokedPasswordGetterCount = 0
    var stubbedPassword: String!

    var password: String! {
        set {
            invokedPasswordSetter = true
            invokedPasswordSetterCount += 1
            invokedPassword = newValue
            invokedPasswordList.append(newValue)
        }
        get {
            invokedPasswordGetter = true
            invokedPasswordGetterCount += 1
            return stubbedPassword
        }
    }

    var invokedKeepAliveIntervalSetter = false
    var invokedKeepAliveIntervalSetterCount = 0
    var invokedKeepAliveInterval: UInt16?
    var invokedKeepAliveIntervalList = [UInt16]()
    var invokedKeepAliveIntervalGetter = false
    var invokedKeepAliveIntervalGetterCount = 0
    var stubbedKeepAliveInterval: UInt16! = 0

    var keepAliveInterval: UInt16 {
        set {
            invokedKeepAliveIntervalSetter = true
            invokedKeepAliveIntervalSetterCount += 1
            invokedKeepAliveInterval = newValue
            invokedKeepAliveIntervalList.append(newValue)
        }
        get {
            invokedKeepAliveIntervalGetter = true
            invokedKeepAliveIntervalGetterCount += 1
            return stubbedKeepAliveInterval
        }
    }

    var invokedCleanSessionFlagSetter = false
    var invokedCleanSessionFlagSetterCount = 0
    var invokedCleanSessionFlag: Bool?
    var invokedCleanSessionFlagList = [Bool]()
    var invokedCleanSessionFlagGetter = false
    var invokedCleanSessionFlagGetterCount = 0
    var stubbedCleanSessionFlag: Bool! = false

    var cleanSessionFlag: Bool {
        set {
            invokedCleanSessionFlagSetter = true
            invokedCleanSessionFlagSetterCount += 1
            invokedCleanSessionFlag = newValue
            invokedCleanSessionFlagList.append(newValue)
        }
        get {
            invokedCleanSessionFlagGetter = true
            invokedCleanSessionFlagGetterCount += 1
            return stubbedCleanSessionFlag
        }
    }

    var invokedWillFlagSetter = false
    var invokedWillFlagSetterCount = 0
    var invokedWillFlag: Bool?
    var invokedWillFlagList = [Bool]()
    var invokedWillFlagGetter = false
    var invokedWillFlagGetterCount = 0
    var stubbedWillFlag: Bool! = false

    var willFlag: Bool {
        set {
            invokedWillFlagSetter = true
            invokedWillFlagSetterCount += 1
            invokedWillFlag = newValue
            invokedWillFlagList.append(newValue)
        }
        get {
            invokedWillFlagGetter = true
            invokedWillFlagGetterCount += 1
            return stubbedWillFlag
        }
    }

    var invokedWillTopicSetter = false
    var invokedWillTopicSetterCount = 0
    var invokedWillTopic: String?
    var invokedWillTopicList = [String?]()
    var invokedWillTopicGetter = false
    var invokedWillTopicGetterCount = 0
    var stubbedWillTopic: String!

    var willTopic: String! {
        set {
            invokedWillTopicSetter = true
            invokedWillTopicSetterCount += 1
            invokedWillTopic = newValue
            invokedWillTopicList.append(newValue)
        }
        get {
            invokedWillTopicGetter = true
            invokedWillTopicGetterCount += 1
            return stubbedWillTopic
        }
    }

    var invokedWillMsgSetter = false
    var invokedWillMsgSetterCount = 0
    var invokedWillMsg: Data?
    var invokedWillMsgList = [Data?]()
    var invokedWillMsgGetter = false
    var invokedWillMsgGetterCount = 0
    var stubbedWillMsg: Data!

    var willMsg: Data! {
        set {
            invokedWillMsgSetter = true
            invokedWillMsgSetterCount += 1
            invokedWillMsg = newValue
            invokedWillMsgList.append(newValue)
        }
        get {
            invokedWillMsgGetter = true
            invokedWillMsgGetterCount += 1
            return stubbedWillMsg
        }
    }

    var invokedWillQoSSetter = false
    var invokedWillQoSSetterCount = 0
    var invokedWillQoS: MQTTQosLevel?
    var invokedWillQoSList = [MQTTQosLevel]()
    var invokedWillQoSGetter = false
    var invokedWillQoSGetterCount = 0
    var stubbedWillQoS: MQTTQosLevel!

    var willQoS: MQTTQosLevel {
        set {
            invokedWillQoSSetter = true
            invokedWillQoSSetterCount += 1
            invokedWillQoS = newValue
            invokedWillQoSList.append(newValue)
        }
        get {
            invokedWillQoSGetter = true
            invokedWillQoSGetterCount += 1
            return stubbedWillQoS
        }
    }

    var invokedWillRetainFlagSetter = false
    var invokedWillRetainFlagSetterCount = 0
    var invokedWillRetainFlag: Bool?
    var invokedWillRetainFlagList = [Bool]()
    var invokedWillRetainFlagGetter = false
    var invokedWillRetainFlagGetterCount = 0
    var stubbedWillRetainFlag: Bool! = false

    var willRetainFlag: Bool {
        set {
            invokedWillRetainFlagSetter = true
            invokedWillRetainFlagSetterCount += 1
            invokedWillRetainFlag = newValue
            invokedWillRetainFlagList.append(newValue)
        }
        get {
            invokedWillRetainFlagGetter = true
            invokedWillRetainFlagGetterCount += 1
            return stubbedWillRetainFlag
        }
    }

    var invokedProtocolLevelSetter = false
    var invokedProtocolLevelSetterCount = 0
    var invokedProtocolLevel: MQTTProtocolVersion?
    var invokedProtocolLevelList = [MQTTProtocolVersion]()
    var invokedProtocolLevelGetter = false
    var invokedProtocolLevelGetterCount = 0
    var stubbedProtocolLevel: MQTTProtocolVersion!

    var protocolLevel: MQTTProtocolVersion {
        set {
            invokedProtocolLevelSetter = true
            invokedProtocolLevelSetterCount += 1
            invokedProtocolLevel = newValue
            invokedProtocolLevelList.append(newValue)
        }
        get {
            invokedProtocolLevelGetter = true
            invokedProtocolLevelGetterCount += 1
            return stubbedProtocolLevel
        }
    }

    var invokedQueueSetter = false
    var invokedQueueSetterCount = 0
    var invokedQueue: DispatchQueue?
    var invokedQueueList = [DispatchQueue?]()
    var invokedQueueGetter = false
    var invokedQueueGetterCount = 0
    var stubbedQueue: DispatchQueue!

    var queue: DispatchQueue! {
        set {
            invokedQueueSetter = true
            invokedQueueSetterCount += 1
            invokedQueue = newValue
            invokedQueueList.append(newValue)
        }
        get {
            invokedQueueGetter = true
            invokedQueueGetterCount += 1
            return stubbedQueue
        }
    }

    var invokedTransportSetter = false
    var invokedTransportSetterCount = 0
    var invokedTransport: MQTTTransportProtocol?
    var invokedTransportList = [MQTTTransportProtocol?]()
    var invokedTransportGetter = false
    var invokedTransportGetterCount = 0
    var stubbedTransport: MQTTTransportProtocol!

    var transport: MQTTTransportProtocol! {
        set {
            invokedTransportSetter = true
            invokedTransportSetterCount += 1
            invokedTransport = newValue
            invokedTransportList.append(newValue)
        }
        get {
            invokedTransportGetter = true
            invokedTransportGetterCount += 1
            return stubbedTransport
        }
    }

    var invokedCertificatesSetter = false
    var invokedCertificatesSetterCount = 0
    var invokedCertificates: [Any]?
    var invokedCertificatesList = [[Any]?]()
    var invokedCertificatesGetter = false
    var invokedCertificatesGetterCount = 0
    var stubbedCertificates: [Any]!

    var certificates: [Any]! {
        set {
            invokedCertificatesSetter = true
            invokedCertificatesSetterCount += 1
            invokedCertificates = newValue
            invokedCertificatesList.append(newValue)
        }
        get {
            invokedCertificatesGetter = true
            invokedCertificatesGetterCount += 1
            return stubbedCertificates
        }
    }

    var invokedVoipSetter = false
    var invokedVoipSetterCount = 0
    var invokedVoip: Bool?
    var invokedVoipList = [Bool]()
    var invokedVoipGetter = false
    var invokedVoipGetterCount = 0
    var stubbedVoip: Bool! = false

    var voip: Bool {
        set {
            invokedVoipSetter = true
            invokedVoipSetterCount += 1
            invokedVoip = newValue
            invokedVoipList.append(newValue)
        }
        get {
            invokedVoipGetter = true
            invokedVoipGetterCount += 1
            return stubbedVoip
        }
    }

    var invokedUserPropertySetter = false
    var invokedUserPropertySetterCount = 0
    var invokedUserProperty: [String: String]?
    var invokedUserPropertyList = [[String: String]?]()
    var invokedUserPropertyGetter = false
    var invokedUserPropertyGetterCount = 0
    var stubbedUserProperty: [String: String]!

    var userProperty: [String: String]! {
        set {
            invokedUserPropertySetter = true
            invokedUserPropertySetterCount += 1
            invokedUserProperty = newValue
            invokedUserPropertyList.append(newValue)
        }
        get {
            invokedUserPropertyGetter = true
            invokedUserPropertyGetterCount += 1
            return stubbedUserProperty
        }
    }

    var invokedShouldEnableActivityCheckTimeoutSetter = false
    var invokedShouldEnableActivityCheckTimeoutSetterCount = 0
    var invokedShouldEnableActivityCheckTimeout: Bool?
    var invokedShouldEnableActivityCheckTimeoutList = [Bool]()
    var invokedShouldEnableActivityCheckTimeoutGetter = false
    var invokedShouldEnableActivityCheckTimeoutGetterCount = 0
    var stubbedShouldEnableActivityCheckTimeout: Bool! = false

    var shouldEnableActivityCheckTimeout: Bool {
        set {
            invokedShouldEnableActivityCheckTimeoutSetter = true
            invokedShouldEnableActivityCheckTimeoutSetterCount += 1
            invokedShouldEnableActivityCheckTimeout = newValue
            invokedShouldEnableActivityCheckTimeoutList.append(newValue)
        }
        get {
            invokedShouldEnableActivityCheckTimeoutGetter = true
            invokedShouldEnableActivityCheckTimeoutGetterCount += 1
            return stubbedShouldEnableActivityCheckTimeout
        }
    }

    var invokedShouldEnableConnectCheckTimeoutSetter = false
    var invokedShouldEnableConnectCheckTimeoutSetterCount = 0
    var invokedShouldEnableConnectCheckTimeout: Bool?
    var invokedShouldEnableConnectCheckTimeoutList = [Bool]()
    var invokedShouldEnableConnectCheckTimeoutGetter = false
    var invokedShouldEnableConnectCheckTimeoutGetterCount = 0
    var stubbedShouldEnableConnectCheckTimeout: Bool! = false

    var shouldEnableConnectCheckTimeout: Bool {
        set {
            invokedShouldEnableConnectCheckTimeoutSetter = true
            invokedShouldEnableConnectCheckTimeoutSetterCount += 1
            invokedShouldEnableConnectCheckTimeout = newValue
            invokedShouldEnableConnectCheckTimeoutList.append(newValue)
        }
        get {
            invokedShouldEnableConnectCheckTimeoutGetter = true
            invokedShouldEnableConnectCheckTimeoutGetterCount += 1
            return stubbedShouldEnableConnectCheckTimeout
        }
    }

    var invokedActivityCheckTimerIntervalSetter = false
    var invokedActivityCheckTimerIntervalSetterCount = 0
    var invokedActivityCheckTimerInterval: TimeInterval?
    var invokedActivityCheckTimerIntervalList = [TimeInterval]()
    var invokedActivityCheckTimerIntervalGetter = false
    var invokedActivityCheckTimerIntervalGetterCount = 0
    var stubbedActivityCheckTimerInterval: TimeInterval!

    var activityCheckTimerInterval: TimeInterval {
        set {
            invokedActivityCheckTimerIntervalSetter = true
            invokedActivityCheckTimerIntervalSetterCount += 1
            invokedActivityCheckTimerInterval = newValue
            invokedActivityCheckTimerIntervalList.append(newValue)
        }
        get {
            invokedActivityCheckTimerIntervalGetter = true
            invokedActivityCheckTimerIntervalGetterCount += 1
            return stubbedActivityCheckTimerInterval
        }
    }

    var invokedConnectTimeoutCheckTimerIntervalSetter = false
    var invokedConnectTimeoutCheckTimerIntervalSetterCount = 0
    var invokedConnectTimeoutCheckTimerInterval: TimeInterval?
    var invokedConnectTimeoutCheckTimerIntervalList = [TimeInterval]()
    var invokedConnectTimeoutCheckTimerIntervalGetter = false
    var invokedConnectTimeoutCheckTimerIntervalGetterCount = 0
    var stubbedConnectTimeoutCheckTimerInterval: TimeInterval!

    var connectTimeoutCheckTimerInterval: TimeInterval {
        set {
            invokedConnectTimeoutCheckTimerIntervalSetter = true
            invokedConnectTimeoutCheckTimerIntervalSetterCount += 1
            invokedConnectTimeoutCheckTimerInterval = newValue
            invokedConnectTimeoutCheckTimerIntervalList.append(newValue)
        }
        get {
            invokedConnectTimeoutCheckTimerIntervalGetter = true
            invokedConnectTimeoutCheckTimerIntervalGetterCount += 1
            return stubbedConnectTimeoutCheckTimerInterval
        }
    }

    var invokedConnectTimeoutSetter = false
    var invokedConnectTimeoutSetterCount = 0
    var invokedConnectTimeout: TimeInterval?
    var invokedConnectTimeoutList = [TimeInterval]()
    var invokedConnectTimeoutGetter = false
    var invokedConnectTimeoutGetterCount = 0
    var stubbedConnectTimeout: TimeInterval!

    var connectTimeout: TimeInterval {
        set {
            invokedConnectTimeoutSetter = true
            invokedConnectTimeoutSetterCount += 1
            invokedConnectTimeout = newValue
            invokedConnectTimeoutList.append(newValue)
        }
        get {
            invokedConnectTimeoutGetter = true
            invokedConnectTimeoutGetterCount += 1
            return stubbedConnectTimeout
        }
    }

    var invokedConnectTimestampGetter = false
    var invokedConnectTimestampGetterCount = 0
    var stubbedConnectTimestamp: TimeInterval!

    var connectTimestamp: TimeInterval {
        invokedConnectTimestampGetter = true
        invokedConnectTimestampGetterCount += 1
        return stubbedConnectTimestamp
    }

    var invokedInactivityTimeoutSetter = false
    var invokedInactivityTimeoutSetterCount = 0
    var invokedInactivityTimeout: TimeInterval?
    var invokedInactivityTimeoutList = [TimeInterval]()
    var invokedInactivityTimeoutGetter = false
    var invokedInactivityTimeoutGetterCount = 0
    var stubbedInactivityTimeout: TimeInterval!

    var inactivityTimeout: TimeInterval {
        set {
            invokedInactivityTimeoutSetter = true
            invokedInactivityTimeoutSetterCount += 1
            invokedInactivityTimeout = newValue
            invokedInactivityTimeoutList.append(newValue)
        }
        get {
            invokedInactivityTimeoutGetter = true
            invokedInactivityTimeoutGetterCount += 1
            return stubbedInactivityTimeout
        }
    }

    var invokedReadTimeoutSetter = false
    var invokedReadTimeoutSetterCount = 0
    var invokedReadTimeout: TimeInterval?
    var invokedReadTimeoutList = [TimeInterval]()
    var invokedReadTimeoutGetter = false
    var invokedReadTimeoutGetterCount = 0
    var stubbedReadTimeout: TimeInterval!

    var readTimeout: TimeInterval {
        set {
            invokedReadTimeoutSetter = true
            invokedReadTimeoutSetterCount += 1
            invokedReadTimeout = newValue
            invokedReadTimeoutList.append(newValue)
        }
        get {
            invokedReadTimeoutGetter = true
            invokedReadTimeoutGetterCount += 1
            return stubbedReadTimeout
        }
    }

    var invokedFastReconnectTimestampGetter = false
    var invokedFastReconnectTimestampGetterCount = 0
    var stubbedFastReconnectTimestamp: TimeInterval!

    var fastReconnectTimestamp: TimeInterval {
        invokedFastReconnectTimestampGetter = true
        invokedFastReconnectTimestampGetterCount += 1
        return stubbedFastReconnectTimestamp
    }

    var invokedLastInboundActivityTimestampGetter = false
    var invokedLastInboundActivityTimestampGetterCount = 0
    var stubbedLastInboundActivityTimestamp: TimeInterval!

    var lastInboundActivityTimestamp: TimeInterval {
        invokedLastInboundActivityTimestampGetter = true
        invokedLastInboundActivityTimestampGetterCount += 1
        return stubbedLastInboundActivityTimestamp
    }

    var invokedLastOutboundActivityTimestampGetter = false
    var invokedLastOutboundActivityTimestampGetterCount = 0
    var stubbedLastOutboundActivityTimestamp: TimeInterval!

    var lastOutboundActivityTimestamp: TimeInterval {
        invokedLastOutboundActivityTimestampGetter = true
        invokedLastOutboundActivityTimestampGetterCount += 1
        return stubbedLastOutboundActivityTimestamp
    }

    var invokedConnect = false
    var invokedConnectCount = 0
    var invokedConnectParameters: (connectHandler: MQTTConnectHandler?, Void)?
    var invokedConnectParametersList = [(connectHandler: MQTTConnectHandler?, Void)]()

    func connect(connectHandler: MQTTConnectHandler!) {
        invokedConnect = true
        invokedConnectCount += 1
        invokedConnectParameters = (connectHandler, ())
        invokedConnectParametersList.append((connectHandler, ()))
    }

    var invokedClose = false
    var invokedCloseCount = 0
    var invokedCloseParameters: (disconnectHandler: MQTTDisconnectHandler?, Void)?
    var invokedCloseParametersList = [(disconnectHandler: MQTTDisconnectHandler?, Void)]()

    func close(disconnectHandler: MQTTDisconnectHandler!) {
        invokedClose = true
        invokedCloseCount += 1
        invokedCloseParameters = (disconnectHandler, ())
        invokedCloseParametersList.append((disconnectHandler, ()))
    }

    var invokedSubscribe = false
    var invokedSubscribeCount = 0
    var invokedSubscribeParameters: (topics: [String: NSNumber]?, subscribeHandler: MQTTSubscribeHandler?)?
    var invokedSubscribeParametersList = [(topics: [String: NSNumber]?, subscribeHandler: MQTTSubscribeHandler?)]()
    var stubbedSubscribeResult: UInt16! = 0

    func subscribe(toTopics topics: [String: NSNumber]!, subscribeHandler: MQTTSubscribeHandler!) -> UInt16 {
        invokedSubscribe = true
        invokedSubscribeCount += 1
        invokedSubscribeParameters = (topics, subscribeHandler)
        invokedSubscribeParametersList.append((topics, subscribeHandler))
        return stubbedSubscribeResult
    }

    var invokedUnsubscribeTopics = false
    var invokedUnsubscribeTopicsCount = 0
    var invokedUnsubscribeTopicsParameters: (topics: [String]?, unsubscribeHandler: MQTTUnsubscribeHandler?)?
    var invokedUnsubscribeTopicsParametersList = [(topics: [String]?, unsubscribeHandler: MQTTUnsubscribeHandler?)]()
    var stubbedUnsubscribeTopicsResult: UInt16! = 0

    func unsubscribeTopics(_ topics: [String]!, unsubscribeHandler: MQTTUnsubscribeHandler!) -> UInt16 {
        invokedUnsubscribeTopics = true
        invokedUnsubscribeTopicsCount += 1
        invokedUnsubscribeTopicsParameters = (topics, unsubscribeHandler)
        invokedUnsubscribeTopicsParametersList.append((topics, unsubscribeHandler))
        return stubbedUnsubscribeTopicsResult
    }

    var invokedPublishData = false
    var invokedPublishDataCount = 0
    var invokedPublishDataParameters: (data: Data?, topic: String?, retainFlag: Bool, qos: MQTTQosLevel, publishHandler: MQTTPublishHandler?)?
    var invokedPublishDataParametersList = [(data: Data?, topic: String?, retainFlag: Bool, qos: MQTTQosLevel, publishHandler: MQTTPublishHandler?)]()
    var stubbedPublishDataResult: UInt16! = 0

    func publishData(_ data: Data!, onTopic topic: String!, retain retainFlag: Bool, qos: MQTTQosLevel, publishHandler: MQTTPublishHandler!) -> UInt16 {
        invokedPublishData = true
        invokedPublishDataCount += 1
        invokedPublishDataParameters = (data, topic, retainFlag, qos, publishHandler)
        invokedPublishDataParametersList.append((data, topic, retainFlag, qos, publishHandler))
        return stubbedPublishDataResult
    }
}
