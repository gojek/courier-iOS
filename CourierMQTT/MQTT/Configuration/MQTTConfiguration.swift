import CourierCore
import Foundation

struct MQTTConfiguration: IMQTTConfiguration {
    var connectRetryTimePolicy: IConnectRetryTimePolicy
    var connectTimeoutPolicy: IConnectTimeoutPolicy
    var idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol
    var authFailureHandler: IAuthFailureHandler
    var eventHandler: ICourierEventHandler
    var usernameModifier: IUserNameModifier 
    var messagePersistenceTTLSeconds: TimeInterval
    var messageCleanupInterval: TimeInterval

    init(connectRetryTimePolicy: IConnectRetryTimePolicy = ConnectRetryTimePolicy(),
         connectTimeoutPolicy: IConnectTimeoutPolicy = ConnectTimeoutPolicy(),
         idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol = IdleActivityTimeoutPolicy(),
         authFailureHandler: IAuthFailureHandler,
         eventHandler: ICourierEventHandler,
         usernameModifier: IUserNameModifier,
         messagePersistenceTTLSeconds: TimeInterval = 0,
         messageCleanupInterval: TimeInterval = 10) {
        self.connectRetryTimePolicy = connectRetryTimePolicy
        self.connectTimeoutPolicy = connectTimeoutPolicy
        self.idleActivityTimeoutPolicy = idleActivityTimeoutPolicy
        self.authFailureHandler = authFailureHandler
        self.eventHandler = eventHandler
        self.usernameModifier = usernameModifier
        self.messagePersistenceTTLSeconds = messagePersistenceTTLSeconds
        self.messageCleanupInterval = messageCleanupInterval
    }
}
