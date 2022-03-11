@testable import CourierCore
@testable import CourierMQTT
import Foundation

class MockCourierClient: CourierClient {

    var invokedConnectionStateGetter = false
    var invokedConnectionStateGetterCount = 0
    var stubbedConnectionState: ConnectionState!

    var connectionState: ConnectionState {
        invokedConnectionStateGetter = true
        invokedConnectionStateGetterCount += 1
        return stubbedConnectionState
    }

    var invokedConnectionStatePublisherGetter = false
    var invokedConnectionStatePublisherGetterCount = 0
    var stubbedConnectionStatePublisher: AnyPublisher<ConnectionState, Never>!

    var connectionStatePublisher: AnyPublisher<ConnectionState, Never> {
        invokedConnectionStatePublisherGetter = true
        invokedConnectionStatePublisherGetterCount += 1
        return stubbedConnectionStatePublisher
    }

    var invokedHasExistingSessionGetter = false
    var invokedHasExistingSessionGetterCount = 0
    var stubbedHasExistingSession: Bool! = false

    var hasExistingSession: Bool {
        invokedHasExistingSessionGetter = true
        invokedHasExistingSessionGetterCount += 1
        return stubbedHasExistingSession
    }

    var invokedConnect = false
    var invokedConnectCount = 0

    func connect() {
        invokedConnect = true
        invokedConnectCount += 1
    }

    var invokedConnectSource = false
    var invokedConnectSourceCount = 0
    var invokedConnectSourceParameters: (source: String, Void)?
    var invokedConnectSourceParametersList = [(source: String, Void)]()

    func connect(source: String) {
        invokedConnectSource = true
        invokedConnectSourceCount += 1
        invokedConnectSourceParameters = (source, ())
        invokedConnectSourceParametersList.append((source, ()))
    }

    var invokedDestroy = false
    var invokedDestroyCount = 0

    func destroy() {
        invokedDestroy = true
        invokedDestroyCount += 1
    }

    var invokedSubscribe = false
    var invokedSubscribeCount = 0
    var invokedSubscribeParameters: (topics: [(topic: String, qos: QoS)], Void)?
    var invokedSubscribeParametersList = [(topics: [(topic: String, qos: QoS)], Void)]()

    func subscribe(_ topics: (topic: String, qos: QoS)...) {
        invokedSubscribe = true
        invokedSubscribeCount += 1
        invokedSubscribeParameters = (topics, ())
        invokedSubscribeParametersList.append((topics, ()))
    }

    var invokedUnsubscribe = false
    var invokedUnsubscribeCount = 0
    var invokedUnsubscribeParameters: (topics: [String], Void)?
    var invokedUnsubscribeParametersList = [(topics: [String], Void)]()

    func unsubscribe(_ topics: String...) {
        invokedUnsubscribe = true
        invokedUnsubscribeCount += 1
        invokedUnsubscribeParameters = (topics, ())
        invokedUnsubscribeParametersList.append((topics, ()))
    }

    var invokedSubscribeArray = false
    var invokedSubscribeArrayCount = 0
    var invokedSubscribeArrayParameters: (topics: [(topic: String, qos: QoS)], Void)?
    var invokedSubscribeArrayParametersList = [(topics: [(topic: String, qos: QoS)], Void)]()

    func subscribe(_ topics: [(topic: String, qos: QoS)]) {
        invokedSubscribeArray = true
        invokedSubscribeArrayCount += 1
        invokedSubscribeArrayParameters = (topics, ())
        invokedSubscribeArrayParametersList.append((topics, ()))
    }

    var invokedUnsubscribeArray = false
    var invokedUnsubscribeArrayCount = 0
    var invokedUnsubscribeArrayParameters: (topics: [String], Void)?
    var invokedUnsubscribeArrayParametersList = [(topics: [String], Void)]()

    func unsubscribe(_ topics: [String]) {
        invokedUnsubscribeArray = true
        invokedUnsubscribeArrayCount += 1
        invokedUnsubscribeArrayParameters = (topics, ())
        invokedUnsubscribeArrayParametersList.append((topics, ()))
    }

    var invokedPublishMessage = false
    var invokedPublishMessageCount = 0
    var invokedPublishMessageParameters: (data: Any, topic: String, qos: QoS)?
    var invokedPublishMessageParametersList = [(data: Any, topic: String, qos: QoS)]()
    var stubbedPublishMessageError: Error?

    func publishMessage<E>(_ data: E, topic: String, qos: QoS) throws {
        invokedPublishMessage = true
        invokedPublishMessageCount += 1
        invokedPublishMessageParameters = (data, topic, qos)
        invokedPublishMessageParametersList.append((data, topic, qos))
        if let error = stubbedPublishMessageError {
            throw error
        }
    }

    var invokedMessagePublisher = false
    var invokedMessagePublisherCount = 0
    var invokedMessagePublisherParameters: (topic: String, Void)?
    var invokedMessagePublisherParametersList = [(topic: String, Void)]()
    var stubbedMessagePublisherResult: Any!

    func messagePublisher<D>(topic: String) -> AnyPublisher<D, Never> {
        invokedMessagePublisher = true
        invokedMessagePublisherCount += 1
        invokedMessagePublisherParameters = (topic, ())
        invokedMessagePublisherParametersList.append((topic, ()))
        return stubbedMessagePublisherResult as! AnyPublisher<D, Never>
    }

    var invokedMessageDataPublisher = false
    var invokedMessageDataPublisherCount = 0
    var stubbedMessageDataPublisherResult: Any!
    func messagePublisher() -> AnyPublisher<Message, Never> {
        invokedMessageDataPublisher = true
        invokedMessageDataPublisherCount += 1
        return stubbedMessageDataPublisherResult as! AnyPublisher<Message, Never>
    }

    var invokedMessagePublisherTopicErrorDecodeHandler = false
    var invokedMessagePublisherTopicErrorDecodeHandlerCount = 0
    var invokedMessagePublisherTopicErrorDecodeHandlerParameters: (topic: String, Void)?
    var invokedMessagePublisherTopicErrorDecodeHandlerParametersList = [(topic: String, Void)]()
    var stubbedMessagePublisherErrorDecodeHandlerResult: Any?
    var stubbedMessagePublisherTopicErrorDecodeHandlerResult: Any!

    func messagePublisher<D, E>(topic: String, errorDecodeHandler: @escaping ((E) -> Error)) -> AnyPublisher<Result<D, NSError>, Never> {
        invokedMessagePublisherTopicErrorDecodeHandler = true
        invokedMessagePublisherTopicErrorDecodeHandlerCount += 1
        invokedMessagePublisherTopicErrorDecodeHandlerParameters = (topic, ())
        invokedMessagePublisherTopicErrorDecodeHandlerParametersList.append((topic, ()))
        if let result = stubbedMessagePublisherErrorDecodeHandlerResult {
            _ = errorDecodeHandler(result as! E)
        }
        return stubbedMessagePublisherTopicErrorDecodeHandlerResult as! AnyPublisher<Result<D, NSError>, Never>
    }

    var invokedAddEventHandler = false
    var invokedAddEventHandlerCount = 0
    var invokedAddEventHandlerParameters: (handler: ICourierEventHandler, Void)?
    var invokedAddEventHandlerParametersList = [(handler: ICourierEventHandler, Void)]()

    func addEventHandler(_ handler: ICourierEventHandler) {
        invokedAddEventHandler = true
        invokedAddEventHandlerCount += 1
        invokedAddEventHandlerParameters = (handler, ())
        invokedAddEventHandlerParametersList.append((handler, ()))
    }

    var invokedRemoveEventHandler = false
    var invokedRemoveEventHandlerCount = 0
    var invokedRemoveEventHandlerParameters: (handler: ICourierEventHandler, Void)?
    var invokedRemoveEventHandlerParametersList = [(handler: ICourierEventHandler, Void)]()

    func removeEventHandler(_ handler: ICourierEventHandler) {
        invokedRemoveEventHandler = true
        invokedRemoveEventHandlerCount += 1
        invokedRemoveEventHandlerParameters = (handler, ())
        invokedRemoveEventHandlerParametersList.append((handler, ()))
    }

    var invokedDisconnect = false
    var invokedDisconnectCount = 0

    func disconnect() {
        invokedDisconnect = true
        invokedDisconnectCount += 1
    }
}
