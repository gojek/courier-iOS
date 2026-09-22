import CourierCore
import Foundation

public struct CourierClientFactory {

    public init() {}

    /**
     Creates an instance of CourierClient that uses MQTT as its bi-directional communication protocol
     - Parameter config: MQTTClientConfig

     - Returns: CourierClient
     */
    public func makeMQTTClient(config: MQTTClientConfig) -> CourierClient {
        MQTTCourierClient(config: config)
    }
}

public struct MQTTClientConfig {

    public let topics: [String: QoS]

    public let authService: IConnectionServiceProvider

    public let messageAdapters: [MessageAdapter]

    public let isMessagePersistenceEnabled: Bool

    public let isMessageInMemoryPersistenceEnabled: Bool

    public let autoReconnectInterval: UInt16

    public let maxAutoReconnectInterval: UInt16

    public let connectTimeoutPolicy: IConnectTimeoutPolicy

    public let idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol

    public let enableAuthenticationTimeout: Bool

    public let authenticationTimeoutInterval: TimeInterval
        
    public let messagePersistenceTTLSeconds: TimeInterval
    
    public let messageCleanupInterval: TimeInterval
    
    public let shouldInitializeCoreDataPersistenceContext: Bool
    
    public var incomingMessagePersistenceEnabled: Bool {
        messagePersistenceTTLSeconds > 0
    }
    
    public let fixCxxDestructCrash: Bool
    
    public let useSafeDeleteForNonSQLiteStore: Bool

    /**
     Serialises every call into the underlying `MQTTSession` onto the session's own
     dispatch queue, instead of running them on the caller's thread.

     Fixes the `-[MQTTSession subscribeToTopics:subscribeHandler:]` data race, where a
     subscribe issued by the app raced the re-subscribe triggered by the session's own
     CONNACK handling and corrupted `MQTTSession`'s handler dictionaries.

     Kill switch. The value is captured for the lifetime of the client, so the host app
     must read it once at construction time; flipping it takes effect on the next launch.
     Defaults to `false` (legacy behaviour).
     */
    public let serializeSessionAccess: Bool

    /**
     Confines the whole `MQTTSession` lifecycle — connect, disconnect, reconnect, publish
     and the replacement of a retired session — to the session's own dispatch queue.

     Fixes the `-[MQTTSession .cxx_destruct]` crash. `MQTTSession` schedules its streams,
     decoder and timers on that queue, but the session manager's `connect`/`disconnect`
     and its `session` property were driven inline from whichever queue called them (the
     auth-result queue, the reconnect timer, reachability/foreground on main). Two callers
     racing on the property over-released the session, so it deallocated while still in
     use. `fixCxxDestructCrash` closed the old session first but still did so off-queue,
     which is why that crash survived it.

     Implies `serializeSessionAccess`. Kill switch; captured for the lifetime of the client,
     so flipping it takes effect on the next launch. Defaults to `false` (legacy behaviour).
     */
    public let confineSessionLifecycleToQueue: Bool

    public init(
        topics: [String: QoS] = [:],
        authService: IConnectionServiceProvider,
        messageAdapters: [MessageAdapter] = [JSONMessageAdapter()],
        isMessagePersistenceEnabled: Bool = false,
        isMessageInMemoryPersistenceEnabled: Bool = false,
        autoReconnectInterval: UInt16 = 5,
        maxAutoReconnectInterval: UInt16 = 10,
        enableAuthenticationTimeout: Bool = false,
        authenticationTimeoutInterval: TimeInterval = 30,
        connectTimeoutPolicy: IConnectTimeoutPolicy = ConnectTimeoutPolicy(),
        idleActivityTimeoutPolicy: IdleActivityTimeoutPolicyProtocol = IdleActivityTimeoutPolicy(),
        messagePersistenceTTLSeconds: TimeInterval = 0,
        messageCleanupInterval: TimeInterval = 10,
        shouldInitializeCoreDataPersistenceContext: Bool = true,
        fixCxxDestructCrash: Bool = false,
        useSafeDeleteForNonSQLiteStore: Bool = false,
        serializeSessionAccess: Bool = false,
        confineSessionLifecycleToQueue: Bool = false
    ) {
        self.topics = topics
        self.authService = authService
        self.messageAdapters = messageAdapters
        self.isMessagePersistenceEnabled = isMessagePersistenceEnabled
        self.isMessageInMemoryPersistenceEnabled = isMessageInMemoryPersistenceEnabled
        self.autoReconnectInterval = autoReconnectInterval
        self.maxAutoReconnectInterval = maxAutoReconnectInterval
        self.enableAuthenticationTimeout = enableAuthenticationTimeout
        self.authenticationTimeoutInterval = authenticationTimeoutInterval
        self.connectTimeoutPolicy = connectTimeoutPolicy
        self.idleActivityTimeoutPolicy = idleActivityTimeoutPolicy
        self.messagePersistenceTTLSeconds = messagePersistenceTTLSeconds
        self.messageCleanupInterval = messageCleanupInterval
        self.shouldInitializeCoreDataPersistenceContext = shouldInitializeCoreDataPersistenceContext
        self.fixCxxDestructCrash = fixCxxDestructCrash
        self.useSafeDeleteForNonSQLiteStore = useSafeDeleteForNonSQLiteStore
        self.serializeSessionAccess = serializeSessionAccess
        self.confineSessionLifecycleToQueue = confineSessionLifecycleToQueue
    }
}
