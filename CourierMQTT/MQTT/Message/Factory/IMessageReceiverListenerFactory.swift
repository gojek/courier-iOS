import Foundation


protocol IMessageReceiveListenerFactory {

    func makeListener(publishSubject: PublishSubject<MQTTPacket>,
                      publishSubjectDispatchQueue: DispatchQueue,
                      messagePersistenceTTLSeconds: TimeInterval,
                      messageCleanupInterval: TimeInterval,
                      useSafeDeleteForNonSQLiteStore: Bool) -> IMessageReceiveListener

}

struct MessageReceiveListenerFactory: IMessageReceiveListenerFactory {

    func makeListener(publishSubject: PublishSubject<MQTTPacket>,
                      publishSubjectDispatchQueue: DispatchQueue,
                      messagePersistenceTTLSeconds: TimeInterval,
                      messageCleanupInterval: TimeInterval,
                      useSafeDeleteForNonSQLiteStore: Bool) -> IMessageReceiveListener {
        MqttMessageReceiverListener(
            publishSubject: publishSubject,
            publishSubjectDispatchQueue: publishSubjectDispatchQueue,
            incomingMessagePersistence: IncomingMessagePersistence(useSafeDeleteForNonSQLiteStore: useSafeDeleteForNonSQLiteStore),
            messagePersistenceTTLSeconds: messagePersistenceTTLSeconds,
            messageCleanupInterval: messageCleanupInterval
        )
    }
        
}
