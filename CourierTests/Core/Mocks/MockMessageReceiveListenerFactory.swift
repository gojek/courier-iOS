import Foundation
@testable import CourierCore
@testable import CourierMQTT
import RxSwift

class MockMessageReceiveListenerFactory: IMessageReceiveListenerFactory {

    var invokedMakeListener = false
    var invokedMakeListenerCount = 0
    var invokedMakeListenerParameters: (publishSubject: PublishSubject<MQTTPacket>, publishSubjectDispatchQueue: DispatchQueue, messagePersistenceTTLSeconds: TimeInterval, messageCleanupInterval: TimeInterval)?
    var invokedMakeListenerParametersList = [(publishSubject: PublishSubject<MQTTPacket>, publishSubjectDispatchQueue: DispatchQueue, messagePersistenceTTLSeconds: TimeInterval, messageCleanupInterval: TimeInterval)]()
    var stubbedMakeListenerResult: IMessageReceiveListener!

    func makeListener(publishSubject: PublishSubject<MQTTPacket>,
        publishSubjectDispatchQueue: DispatchQueue,
        messagePersistenceTTLSeconds: TimeInterval,
        messageCleanupInterval: TimeInterval) -> IMessageReceiveListener {
        invokedMakeListener = true
        invokedMakeListenerCount += 1
        invokedMakeListenerParameters = (publishSubject, publishSubjectDispatchQueue, messagePersistenceTTLSeconds, messageCleanupInterval)
        invokedMakeListenerParametersList.append((publishSubject, publishSubjectDispatchQueue, messagePersistenceTTLSeconds, messageCleanupInterval))
        return stubbedMakeListenerResult
    }
}

