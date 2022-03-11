import CourierCore
import Foundation

struct MqttMessageReceiverListener: IMessageReceiveListener {
    private var publishSubject: PublishSubject<MQTTPacket>
    private let publishSubjectDispatchQueue: DispatchQueue

    init(publishSubject: PublishSubject<MQTTPacket>, publishSubjectDispatchQueue: DispatchQueue) {
        self.publishSubject = publishSubject
        self.publishSubjectDispatchQueue = publishSubjectDispatchQueue
    }

    func messageArrived(data: Data, topic: String, qos: QoS) {
        publishSubjectDispatchQueue.async {
            publishSubject.onNext(MQTTPacket(data: data, topic: topic, qos: qos))
        }
    }
}
