import CourierCore
import Foundation

protocol ICourierAnalyticsService {
    func sendCourierConnectStartEvent()
    func sendCourierConnectSuccessEvent(host: String, port: Int)
    func sendCourierConnectFailureEvent(error: Error?)
    func sendCourierReconnectEvent()

    func sendMQTTConnectAttemptEvent()
    func sendMQTTConnectSuccessEvent()
    func sendMQTTConnectFailureEvent(error: Error?)
    func sendMQTTConnectionLostEvent(error: Error?)

    func sendMQTTSubscribeAttemptEvent(topic: String)
    func sendMQTTUnsubscribeAttemptEvent(topic: String)
    func sendMQTTSubscribeSuccessEvent(topic: String)
    func sendMQTTSubscribeFailureEvent(topic: String, error: Error?)

    func sendMQTTUnSubscribeSuccessEvent(topic: String)
    func sendMQTTUnSubscribeFailureEvent(topic: String, error: Error?)

    func sendMQTTMessageReceiveEvent(topic: String, sizeBytes: Int)
    func sendMQTTMessageReceiveFailureEvent(topic: String, error: Error?, sizeBytes: Int)

    func sendMQTTMessageSendEvent(topic: String, qos: QoS, sizeBytes: Int)
    func sendMQTTMessageSendSuccessEvent(topic: String, qos: QoS, sizeBytes: Int)
    func sendMQTTMessageSendFailureEvent(topic: String, error: Error?, qos: QoS, sizeBytes: Int)

    func sendSocketConnectAttemptEvent(port: Int, host: String?, timeout: Int)
    func sendSocketConnectSuccessEvent(timeTakenMillis: Int, port: Int, host: String?, timeout: Int)
    func sendSocketConnectFailureEvent(timeTakenMillis: Int, port: Int, host: String?, timeout: Int, error: Error?)
    func sendConnectPacketSendEvent()

    func sendSSLSocketSuccessEvent(port: Int, host: String?, timeout: Int, timeTakenMillis: Int)
    func sendSSLSocketFailureEvent(port: Int, host: String?, timeout: Int, error: Error?)
    func sendSSLHandshakeSuccessEvent(port: Int, host: String?, timeout: Int, timeTakenMillis: Int)

    func sendMQTTPingInitiatedEvent(serverUri: String?)
    func sendMQTTPingFailureEvent(timeTaken: Int, error: Error?)
    func sendMQTTPingSuccessEvent(timeTaken: Int)
    func sendMQTTPingTokenNullEvent(keepAliveSecs: Int)
}
