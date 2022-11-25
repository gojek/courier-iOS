import Foundation
@testable import CourierCore
@testable import CourierMQTT

class MockMQTTClientFrameworkFactory: IMQTTClientFrameworkFactory {

    var invokedMakeSessionManager = false
    var invokedMakeSessionManagerCount = 0
    var invokedMakeSessionManagerParameters: (connectRetryTimePolicy: IConnectRetryTimePolicy, persistenceFactory: IMQTTPersistenceFactory, dispatchQueue: DispatchQueue, delegate: MQTTClientFrameworkSessionManagerDelegate, connectTimeoutPolicy: IConnectTimeoutPolicy, idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol, eventHandler: ICourierEventHandler)?
    var invokedMakeSessionManagerParametersList = [(connectRetryTimePolicy: IConnectRetryTimePolicy, persistenceFactory: IMQTTPersistenceFactory, dispatchQueue: DispatchQueue, delegate: MQTTClientFrameworkSessionManagerDelegate, connectTimeoutPolicy: IConnectTimeoutPolicy, idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol, eventHandler: ICourierEventHandler)]()
    var stubbedMakeSessionManagerResult: IMQTTClientFrameworkSessionManager!

    func makeSessionManager(
        connectRetryTimePolicy: IConnectRetryTimePolicy,
        persistenceFactory: IMQTTPersistenceFactory,
        dispatchQueue: DispatchQueue,
        delegate: MQTTClientFrameworkSessionManagerDelegate,
        connectTimeoutPolicy: IConnectTimeoutPolicy,
        idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol,
        eventHandler: ICourierEventHandler
    ) -> IMQTTClientFrameworkSessionManager {
        invokedMakeSessionManager = true
        invokedMakeSessionManagerCount += 1
        invokedMakeSessionManagerParameters = (connectRetryTimePolicy, persistenceFactory, dispatchQueue, delegate, connectTimeoutPolicy, idleActivityTimeoutPolicy, eventHandler)
        invokedMakeSessionManagerParametersList.append((connectRetryTimePolicy, persistenceFactory, dispatchQueue, delegate, connectTimeoutPolicy, idleActivityTimeoutPolicy, eventHandler))
        return stubbedMakeSessionManagerResult
    }
}
