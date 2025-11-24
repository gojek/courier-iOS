import Foundation
import Combine


protocol IMessageReceiveListenerFactory {

    func makeListener(publishSubject: PassthroughSubject<MQTTPacket, Never>,
                      publishSubjectDispatchQueue: DispatchQueue,
                      messagePersistenceTTLSeconds: TimeInterval,
                      messageCleanupInterval: TimeInterval) -> IMessageReceiveListener

}

struct MessageReceiveListenerFactory: IMessageReceiveListenerFactory {

    func makeListener(publishSubject: PassthroughSubject<MQTTPacket, Never>,
                      publishSubjectDispatchQueue: DispatchQueue,
                      messagePersistenceTTLSeconds: TimeInterval,
                      messageCleanupInterval: TimeInterval) -> IMessageReceiveListener {
        MqttMessageReceiverListener(
            publishSubject: publishSubject,
            publishSubjectDispatchQueue: publishSubjectDispatchQueue,
            messagePersistenceTTLSeconds: messagePersistenceTTLSeconds,
            messageCleanupInterval: messageCleanupInterval
        )
    }
        
}
