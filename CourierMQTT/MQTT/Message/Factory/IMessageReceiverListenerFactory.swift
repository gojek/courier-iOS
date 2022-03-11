import Foundation

protocol IMessageReceiveListenerFactory {

    func makeListener(publishSubject: PublishSubject<MQTTPacket>, publishSubjectDispatchQueue: DispatchQueue) -> IMessageReceiveListener

}

struct MessageReceiveListenerFactory: IMessageReceiveListenerFactory {

    func makeListener(publishSubject: PublishSubject<MQTTPacket>, publishSubjectDispatchQueue: DispatchQueue) -> IMessageReceiveListener {
        MqttMessageReceiverListener(
            publishSubject: publishSubject,
            publishSubjectDispatchQueue: publishSubjectDispatchQueue
        )
    }
}
