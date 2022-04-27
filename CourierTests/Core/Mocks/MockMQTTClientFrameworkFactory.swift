import Foundation
@testable import CourierCore
@testable import CourierMQTT

class MockMQTTClientFrameworkFactory: IMQTTClientFrameworkFactory {

    var invokedMakeSessionManager = false
    var invokedMakeSessionManagerCount = 0
    var invokedMakeSessionManagerParameters: (connectRetryTimePolicy: IConnectRetryTimePolicy, persistenceFactory: IMQTTPersistenceFactory, dispatchQueue: DispatchQueue, delegate: MQTTClientFrameworkSessionManagerDelegate, connectTimeoutPolicy: IConnectTimeoutPolicy, idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol)?
    var invokedMakeSessionManagerParametersList = [(connectRetryTimePolicy: IConnectRetryTimePolicy, persistenceFactory: IMQTTPersistenceFactory, dispatchQueue: DispatchQueue, delegate: MQTTClientFrameworkSessionManagerDelegate, connectTimeoutPolicy: IConnectTimeoutPolicy, idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol)]()
    var stubbedMakeSessionManagerResult: IMQTTClientFrameworkSessionManager!

    func makeSessionManager(
        connectRetryTimePolicy: IConnectRetryTimePolicy,
        persistenceFactory: IMQTTPersistenceFactory,
        dispatchQueue: DispatchQueue,
        delegate: MQTTClientFrameworkSessionManagerDelegate,
        connectTimeoutPolicy: IConnectTimeoutPolicy,
        idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol
    ) -> IMQTTClientFrameworkSessionManager {
        invokedMakeSessionManager = true
        invokedMakeSessionManagerCount += 1
        invokedMakeSessionManagerParameters = (connectRetryTimePolicy, persistenceFactory, dispatchQueue, delegate, connectTimeoutPolicy, idleActivityTimeoutPolicy)
        invokedMakeSessionManagerParametersList.append((connectRetryTimePolicy, persistenceFactory, dispatchQueue, delegate, connectTimeoutPolicy, idleActivityTimeoutPolicy))
        return stubbedMakeSessionManagerResult
    }
}
