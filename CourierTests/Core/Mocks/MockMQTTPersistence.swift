import Foundation
import MQTTClientGJ
@testable import CourierCore
@testable import CourierMQTT
class MockMQTTPersistence: MQTTCoreDataPersistence {

    var invokedMaxWindowSizeSetter = false
    var invokedMaxWindowSizeSetterCount = 0
    var invokedMaxWindowSize: UInt?
    var invokedMaxWindowSizeList = [UInt?]()
    var invokedMaxWindowSizeGetter = false
    var invokedMaxWindowSizeGetterCount = 0
    var stubbedMaxWindowSize: UInt!
    override var maxWindowSize: UInt {
        set {
            invokedMaxWindowSizeSetter = true
            invokedMaxWindowSizeSetterCount += 1
            invokedMaxWindowSize = newValue
            invokedMaxWindowSizeList.append(newValue)
        }

        get {
            invokedMaxWindowSizeGetter = true
            invokedMaxWindowSizeGetterCount += 1
            return stubbedMaxWindowSize
        }
    }

    var invokedMaxMessagesSetter = false
    var invokedMaxMessagesSetterCount = 0
    var invokedMaxMessages: UInt?
    var invokedMaxMessagesList = [UInt?]()
    var invokedMaxMessagesGetter = false
    var invokedMaxMessagesGetterCount = 0
    var stubbedMaxMessages: UInt!

    override var maxMessages: UInt {
        set {
            invokedMaxMessagesSetter = true
            invokedMaxMessagesSetterCount += 1
            invokedMaxMessages = newValue
            invokedMaxMessagesList.append(newValue)
        }

        get {
            invokedMaxMessagesGetter = true
            invokedMaxMessagesGetterCount += 1
            return stubbedMaxMessages
        }
    }

    var invokedPersistentSetter = false
    var invokedPersistentSetterCount = 0
    var invokedPersistent: Bool?
    var invokedPersistentList = [Bool?]()
    var invokedPersistentGetter = false
    var invokedPersistentGetterCount = 0
    var stubbedPersistent: Bool!
    override var persistent: Bool {
        set {
            invokedPersistentSetter = true
            invokedPersistentSetterCount += 1
            invokedPersistent = newValue
            invokedPersistentList.append(newValue)
        }

        get {
            invokedPersistentGetter = true
            invokedPersistentGetterCount += 1
            return stubbedPersistent
        }
    }

    var invokedMaxSizeSetter = false
    var invokedMaxSizeSetterCount = 0
    var invokedMaxSize: UInt?
    var invokedMaxSizeList = [UInt?]()
    var invokedMaxSizeGetter = false
    var invokedMaxSizeGetterCount = 0
    var stubbedMaxSize: UInt!
    override var maxSize: UInt {
        set {
            invokedMaxSizeSetter = true
            invokedMaxSizeSetterCount += 1
            invokedMaxSize = newValue
            invokedMaxSizeList.append(newValue)
        }

        get {
            invokedMaxSizeGetter = true
            invokedMaxSizeGetterCount += 1
            return stubbedMaxSize
        }
    }

    override func windowSize(_ clientId: String!) -> UInt {
        0
    }

    override func storeMessage(forClientId clientId: String!, topic: String!, data: Data!, retainFlag: Bool, qos: MQTTQosLevel, msgId: UInt16, incomingFlag: Bool, commandType: UInt8, deadline: Date!) -> MQTTFlowProtocol! {
        nil
    }

    override func delete(_ flow: MQTTFlowProtocol!) {}

    var invokedDeleteAllFlows = false
    var invokedDeleteAllFlowsCount = 0
    var invokedDeleteAllFlowsParameters: (clientId: String, Void)?
    var invokedDeleteAllFlowsParametersList = [(clientId: String, Void)]()
    override func deleteAllFlows(forClientId clientId: String!) {
        invokedDeleteAllFlows = true
        invokedDeleteAllFlowsCount += 1
        invokedDeleteAllFlowsParameters = (clientId, ())
        invokedDeleteAllFlowsParametersList.append((clientId, ()))
    }

    override func allFlowsforClientId(_ clientId: String!, incomingFlag: Bool) -> [Any]! {
        nil
    }

    override func flowforClientId(_ clientId: String!, incomingFlag: Bool, messageId: UInt16) -> MQTTFlowProtocol! {
        nil
    }

    override func sync() {}

}
