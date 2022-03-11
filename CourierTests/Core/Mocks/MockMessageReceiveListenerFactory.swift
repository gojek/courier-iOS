import Foundation
@testable import CourierCore
@testable import CourierMQTT
class MockMessageReceiveListenerFactory: IMessageReceiveListenerFactory {

    var invokedMakeListener = false
    var invokedMakeListenerCount = 0
    var invokedMakeListenerParameters: (publishSubject: PublishSubject<MQTTPacket>, publishSubjectDispatchQueue: DispatchQueue)?
    var invokedMakeListenerParametersList = [(publishSubject: PublishSubject<MQTTPacket>, publishSubjectDispatchQueue: DispatchQueue)]()
    var stubbedMakeListenerResult: IMessageReceiveListener!

    func makeListener(publishSubject: PublishSubject<MQTTPacket>, publishSubjectDispatchQueue: DispatchQueue) -> IMessageReceiveListener {
        invokedMakeListener = true
        invokedMakeListenerCount += 1
        invokedMakeListenerParameters = (publishSubject, publishSubjectDispatchQueue)
        invokedMakeListenerParametersList.append((publishSubject, publishSubjectDispatchQueue))
        return stubbedMakeListenerResult
    }
}
