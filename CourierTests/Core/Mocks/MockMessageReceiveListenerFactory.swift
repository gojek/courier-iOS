import Foundation
@testable import CourierCore
@testable import CourierMQTT
import Combine

class MockMessageReceiveListenerFactory: IMessageReceiveListenerFactory {

    var invokedMakeListener = false
    var invokedMakeListenerCount = 0
    var invokedMakeListenerParameters: (publishSubject: PassthroughSubject<MQTTPacket, Never>, publishSubjectDispatchQueue: DispatchQueue, messagePersistenceTTLSeconds: TimeInterval, messageCleanupInterval: TimeInterval)?
    var invokedMakeListenerParametersList = [(publishSubject: PassthroughSubject<MQTTPacket, Never>, publishSubjectDispatchQueue: DispatchQueue, messagePersistenceTTLSeconds: TimeInterval, messageCleanupInterval: TimeInterval)]()
    var stubbedMakeListenerResult: IMessageReceiveListener!

    func makeListener(publishSubject: PassthroughSubject<MQTTPacket, Never>,
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

