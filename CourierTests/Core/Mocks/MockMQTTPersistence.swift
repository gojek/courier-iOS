import Foundation
import MQTTClientGJ
@testable import CourierCore
@testable import CourierMQTT
class MockMQTTPersistence: MQTTPersistence {

    var invokedMaxWindowSizeSetter = false
    var invokedMaxWindowSizeSetterCount = 0
    var invokedMaxWindowSize: UInt?
    var invokedMaxWindowSizeList = [UInt?]()
    var invokedMaxWindowSizeGetter = false
    var invokedMaxWindowSizeGetterCount = 0
    var stubbedMaxWindowSize: UInt!
    var maxWindowSize: UInt {
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

    var maxMessages: UInt {
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
    var persistent: Bool {
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
    var maxSize: UInt {
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

    func windowSize(_ clientId: String!) -> UInt {
        0
    }

    func storeMessage(forClientId clientId: String!, topic: String!, data: Data!, retainFlag: Bool, qos: MQTTQosLevel, msgId: UInt16, incomingFlag: Bool, commandType: UInt8, deadline: Date!) -> MQTTFlowProtocol! {
        nil
    }

    func delete(_ flow: MQTTFlowProtocol!) {}

    var invokedDeleteAllFlows = false
    var invokedDeleteAllFlowsCount = 0
    var invokedDeleteAllFlowsParameters: (clientId: String, Void)?
    var invokedDeleteAllFlowsParametersList = [(clientId: String, Void)]()
    func deleteAllFlows(forClientId clientId: String!) {
        invokedDeleteAllFlows = true
        invokedDeleteAllFlowsCount += 1
        invokedDeleteAllFlowsParameters = (clientId, ())
        invokedDeleteAllFlowsParametersList.append((clientId, ()))
    }

    func allFlowsforClientId(_ clientId: String!, incomingFlag: Bool) -> [Any]! {
        nil
    }

    func flowforClientId(_ clientId: String!, incomingFlag: Bool, messageId: UInt16) -> MQTTFlowProtocol! {
        nil
    }

    func sync() {}

}
