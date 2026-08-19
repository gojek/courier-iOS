import Foundation
import CourierCore
import MQTTClientGJ

protocol IMQTTClientFrameworkFactory {
    func makeSessionManager(
        connectRetryTimePolicy: IConnectRetryTimePolicy,
        persistenceFactory: IMQTTPersistenceFactory,
        dispatchQueue: DispatchQueue,
        delegate: MQTTClientFrameworkSessionManagerDelegate,
        connectTimeoutPolicy: IConnectTimeoutPolicy,
        idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol,
        eventHandler: ICourierEventHandler,
        fixCxxDestructCrash: Bool,
        serializeSessionAccess: Bool
    ) -> IMQTTClientFrameworkSessionManager
}

struct MQTTClientFrameworkFactory: IMQTTClientFrameworkFactory {

    func makeSessionManager(connectRetryTimePolicy: IConnectRetryTimePolicy, persistenceFactory: IMQTTPersistenceFactory, dispatchQueue: DispatchQueue, delegate: MQTTClientFrameworkSessionManagerDelegate, connectTimeoutPolicy: IConnectTimeoutPolicy,
                            idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol, eventHandler: ICourierEventHandler, fixCxxDestructCrash: Bool,
                            serializeSessionAccess: Bool) -> IMQTTClientFrameworkSessionManager {
        guard !MQTTClientcourier.isEmpty else { fatalError("Please use the MQTTClientGJ from courier podspecs") }

        let sessionManager = MQTTClientFrameworkSessionManager(
            retryInterval: TimeInterval(connectRetryTimePolicy.autoReconnectInterval),
            maxRetryInterval: TimeInterval(connectRetryTimePolicy.maxAutoReconnectInterval),
            streamSSLLevel: kCFStreamSocketSecurityLevelNegotiatedSSL as String,
            queue: dispatchQueue,
            mqttPersistenceFactory: persistenceFactory,
            connectTimeoutPolicy: connectTimeoutPolicy,
            idleActivityTimeoutPolicy: idleActivityTimeoutPolicy,
            eventHandler: eventHandler,
            fixCxxDestructCrash: fixCxxDestructCrash,
            serializeSessionAccess: serializeSessionAccess
        )
        sessionManager.delegate = delegate

        #if INTEGRATION || DEBUG
        MQTTLog.setLogLevel(.info)
        #endif

        return sessionManager
    }
}
