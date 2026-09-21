import Foundation
import XCTest
import MQTTClientGJ
@testable import CourierCore
@testable import CourierMQTT
class MQTTClientFrameworkSessionManagerTests: XCTestCase {

    var sut: MQTTClientFrameworkSessionManager!
    var mockSession: MockMQTTSession!
    var mockPersistence: MockMQTTPersistence!
    var mockEventHandler: MockCourierEventHandler!
    var mockDelegate: MockMQTTClientFrameworkSessionManagerDelegate!

    override func setUp() {
        mockSession = MockMQTTSession()
        let sessionFactory = MockMQTTSessionFactory()
        sessionFactory.stubbedMakeSessionResult = mockSession

        mockPersistence = MockMQTTPersistence()
        let persistenceFactory = MockMQTTPersistenceFactory()
        persistenceFactory.stubbedMakePersistenceResult = mockPersistence

        mockEventHandler = MockCourierEventHandler()
        mockDelegate = MockMQTTClientFrameworkSessionManagerDelegate()

        sut = MQTTClientFrameworkSessionManager(
            retryInterval: 10,
            maxRetryInterval: 15,
            streamSSLLevel: "9999",
            queue: .main,
            mqttSessionFactory: sessionFactory,
            mqttPersistenceFactory: persistenceFactory,
            connectTimeoutPolicy: ConnectTimeoutPolicy(),
            idleActivityTimeoutPolicy: IdleActivityTimeoutPolicy(),
            eventHandler: mockEventHandler,
            fixCxxDestructCrash: false,
            serializeSessionAccess: false
        )

        sut.delegate = mockDelegate
    }

    func testInit() {
        XCTAssertEqual(sut.state, .starting)
    }

    func testConnectWithoutExistingSession() {
        let securityPolicy = MQTTSSLSecurityPolicy()
        setupSession(securityPolicy: securityPolicy)

        XCTAssertTrue(sut.session === mockSession)
        XCTAssertEqual(mockSession.invokedClientId, "clientid")
        XCTAssertEqual(mockSession.invokedUserName, "username")
        XCTAssertEqual(mockSession.invokedPassword, "password")
        XCTAssertEqual(mockSession.invokedKeepAliveInterval, UInt16(240))
        XCTAssertEqual(mockSession.invokedCleanSessionFlag, true)
        XCTAssertEqual(mockSession.invokedWillFlag!, false)
        XCTAssertEqual(mockSession.invokedWillTopic, nil)
        XCTAssertEqual(mockSession.invokedWillMsg, nil)
        XCTAssertEqual(mockSession.invokedWillQoS, .atMostOnce)
        XCTAssertEqual(mockSession.invokedWillRetainFlag!, false)
        XCTAssertEqual(mockSession.invokedProtocolLevel, .version311)
        XCTAssertEqual(mockSession.invokedQueue, .main)
        XCTAssertNil(mockSession.invokedCertificates)
        XCTAssertEqual(mockSession.invokedStreamSSLLevel, "9999")
        XCTAssertTrue(mockSession.invokedDelegate === sut)
        XCTAssertFalse(mockSession.invokedClose)
        XCTAssertEqual(sut.state, .connecting)
        let sslTransport = self.mockSession.invokedTransport as! MQTTSSLSecurityPolicyTransport
        XCTAssertTrue(sslTransport.securityPolicy == securityPolicy)
        XCTAssertEqual(sslTransport.host, "host")
        XCTAssertEqual(sslTransport.port, 443)
        XCTAssertEqual(sslTransport.tls, true)
        XCTAssertEqual(sslTransport.queue, .main)
        XCTAssertEqual(sslTransport.streamSSLLevel, "9999")
        XCTAssertTrue(mockSession.invokedConnect)

        XCTAssertTrue(mockDelegate.invokedSessionManagerDidChangeState)
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidChangeStateParameters?.newState, .connecting)
    }

    func testConnectWithExistingSessionShouldReconnect() {
        setupSession()
        XCTAssertEqual(mockSession.invokedCloseCount, 0)
        setupSession()
        XCTAssertEqual(mockSession.invokedCloseCount, 1)
    }

    func testDisconnect() {
        setupSession()
        sut.disconnect()
        XCTAssertEqual(sut.state, .closing)
        XCTAssertTrue(mockSession.invokedClose)
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidChangeStateParameters?.newState, .closing)
    }

    func testConnectToLast() {
        sut.handleEvent(MQTTSession(), event: .connected, error: nil)
        sut.connectToLast()
    }

    func testSubscribeTopicsSuccess() {
        setupSession()
        self.mockSession.stubbedSubscribeSubscribeHandlerResult = (nil, [NSNumber(value: 1)])
        sut.subscribe([("fbon", .one)])
        XCTAssertTrue(mockSession.invokedSubscribe)
        XCTAssertEqual(mockSession.invokedSubscribeParameters?.topics, ["fbon": NSNumber(value: 1)])
        XCTAssertNotNil(mockSession.invokedSubscribeParameters?.subscribeHandler)
        
        
        if case .subscribeAttempt(let topic) = self.mockEventHandler.invokedOnEventParametersList[0]?.event.type {
            XCTAssert(topic.contains("fbon"))
        } else {
            XCTAssert(false)
        }
        
        if case .subscribeSuccess(let topics, _) = self.mockEventHandler.invokedOnEventParametersList[1]?.event.type {
            XCTAssertEqual(topics[0].topic, "fbon")
        } else {
            XCTAssert(false)
        }
    }
    
    func testSubscribeTopicsFailure() {
        setupSession()
        self.mockSession.stubbedSubscribeSubscribeHandlerResult = (stubbedError, nil)
        sut.subscribe([("fbon", .one)])
        XCTAssertTrue(mockSession.invokedSubscribe)
        XCTAssertEqual(mockSession.invokedSubscribeParameters?.topics, ["fbon": NSNumber(value: 1)])
        XCTAssertNotNil(mockSession.invokedSubscribeParameters?.subscribeHandler)
        
        
        if case .subscribeAttempt(let topic) = self.mockEventHandler.invokedOnEventParametersList[0]?.event.type {
            XCTAssert(topic.contains("fbon"))
        } else {
            XCTAssert(false)
        }
        
        if case .subscribeFailure(let topics, _, let error) = self.mockEventHandler.invokedOnEventParametersList[1]?.event.type {
            XCTAssertEqual(topics[0].topic, "fbon")
            XCTAssertEqual(error!._domain, stubbedError.domain)
        } else {
            XCTAssert(false)
        }
    }

    func testUnsubscribeTopicsSuccess() {
        setupSession()
        mockSession.stubbedUnsubscribeHandlerResult = nil
        sut.unsubscribe(["fbon"])
        XCTAssertTrue(mockSession.invokedUnsubscribeTopics)
        XCTAssertEqual(mockSession.invokedUnsubscribeTopicsParameters?.topics?.first, "fbon")
        XCTAssertNotNil(mockSession.invokedUnsubscribeTopicsParameters?.unsubscribeHandler)
        
        if case .unsubscribeAttempt(let topic) = self.mockEventHandler.invokedOnEventParametersList[0]?.event.type {
            XCTAssert(topic.contains("fbon"))
        } else {
            XCTAssert(false)
        }
        
        if case .unsubscribeSuccess(let topics, _) = self.mockEventHandler.invokedOnEventParametersList[1]?.event.type {
            XCTAssertEqual(topics[0], "fbon")
        } else {
            XCTAssert(false)
        }
        
    }
    
    func testUnsubscribeTopicsFailure() {
        setupSession()
        mockSession.stubbedUnsubscribeHandlerResult = stubbedError
        sut.unsubscribe(["fbon"])
        XCTAssertTrue(mockSession.invokedUnsubscribeTopics)
        XCTAssertEqual(mockSession.invokedUnsubscribeTopicsParameters?.topics?.first, "fbon")
        XCTAssertNotNil(mockSession.invokedUnsubscribeTopicsParameters?.unsubscribeHandler)
        
        if case .unsubscribeAttempt(let topic) = self.mockEventHandler.invokedOnEventParametersList[0]?.event.type {
            XCTAssert(topic.contains("fbon"))
        } else {
            XCTAssert(false)
        }
        
        if case let .unsubscribeFailure(topics, _, error) = self.mockEventHandler.invokedOnEventParametersList[1]?.event.type {
            XCTAssertEqual(topics[0], "fbon")
            XCTAssert((error! as NSError).code ==  stubbedError.code)
            XCTAssert((error! as NSError).domain ==  stubbedError.domain)
        } else {
            XCTAssert(false)
        }
        
    }

    func testPublishPacket() {
        setupSession()
        sut.publish(packet: MQTTPacket(data: "Hello".data(using: .utf8)!, topic: "xxx", qos: .one))
        XCTAssertTrue(mockSession.invokedPublishData)
        XCTAssertEqual(mockSession.invokedPublishDataParameters?.data, "Hello".data(using: .utf8))
        XCTAssertEqual(mockSession.invokedPublishDataParameters?.topic, "xxx")
        XCTAssertEqual(mockSession.invokedPublishDataParameters?.retainFlag, false)
    }

    func testHandleEventConnected() {
        sut.handleEvent(MQTTSession(), event: .connected, error: nil)
        XCTAssertEqual(sut.state, .connected)
    }

    func testHandleEventConnectionClosed() {
        sut.handleEvent(MQTTSession(), event: .connectionClosed, error: nil)
        XCTAssertEqual(sut.state, .closed)
    }

    func testHandleEventConnectionClosedByBroker() {
        sut.handleEvent(MQTTSession(), event: .connectionClosedByBroker, error: nil)
        XCTAssertEqual(sut.state, .closed)
    }

    func testHandleEventProtocolErrorConnectionRefusedConnectionError() {
        sut.handleEvent(MQTTSession(), event: .protocolError, error: nil)
        XCTAssertEqual(sut.state, .error)
    }

    func testHandleSessionConnected() {
        sut.connected(MQTTSession(), sessionPresent: false)
    }

    func testHandleSessionNewMessage() {
        sut.newMessage(MQTTSession(), data: "Hello".data(using: .utf8), onTopic: "xxx", qos: .atLeastOnce, retained: false, mid: 1)
        XCTAssertTrue(mockDelegate.invokedSessionManagerDidReceiveMessageData)
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidReceiveMessageDataParameters?.mid, 1)
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidReceiveMessageDataParameters?.qos, .atLeastOnce)

        XCTAssertEqual(mockDelegate.invokedSessionManagerDidReceiveMessageDataParameters?.topic, "xxx")
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidReceiveMessageDataParameters?.data, "Hello".data(using: .utf8))
    }

    func testHandleSessionMessageDelivered() {
        sut.messageDelivered(MQTTSession(), msgID: 1, topic: "xxx", data: "Hello".data(using: .utf8), qos: .atLeastOnce, retainFlag: false)
        XCTAssertTrue(mockDelegate.invokedSessionManagerDidDeliverMessageID)
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidDeliverMessageIDParameters?.msgID, 1)
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidDeliverMessageIDParameters?.topic, "xxx")
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidDeliverMessageIDParameters?.data, "Hello".data(using: .utf8)!)
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidDeliverMessageIDParameters?.qos, .atLeastOnce)
        XCTAssertEqual(mockDelegate.invokedSessionManagerDidDeliverMessageIDParameters?.retainFlag, false)
    }

    func testHandleSessionSendingMQTTCommandConnect() {
        sut.sending(MQTTSession(), type: .connect, qos: .atLeastOnce, retained: false, duped: false, mid: 1, data: nil)
        XCTAssertTrue(mockDelegate.invokedSessionManagerDidSendConnectPacket)
    }

    func testHandleSessionSendingMQTTCommandPingReq() {
        sut.sending(MQTTSession(), type: .pingreq, qos: .atLeastOnce, retained: false, duped: false, mid: 1, data: nil)
        XCTAssertTrue(mockDelegate.invokedSessionManagerDidPing)
    }

    func testHandleSessionReceivedMQTTCommandPingResp() {
        sut.received(MQTTSession(), type: .pingresp, qos: .atLeastOnce, retained: false, duped: false, mid: 1, data: nil)
        XCTAssertTrue(mockDelegate.invokedSessionManagerDidReceivePong)
    }
}

extension MQTTClientFrameworkSessionManagerTests {

    // MARK: - serializeSessionAccess (MQTTSession subscribe/unsubscribe data-race fix)

    func testSubscribeRunsInlineWhenSerializeSessionAccessDisabled() {
        setupSession()
        mockSession.stubbedSubscribeSubscribeHandlerResult = (nil, [NSNumber(value: 1)])

        sut.subscribe([("fbon", .one)])

        // Legacy behaviour: the session is called on the caller's thread before returning.
        XCTAssertTrue(mockSession.invokedSubscribe)
    }

    func testSubscribeIsSerialisedOntoSessionQueueWhenEnabled() {
        let sessionQueue = DispatchQueue(label: "test.courier.session")
        sut = makeSUT(queue: sessionQueue, serializeSessionAccess: true)
        setupSession()
        sut.handleEvent(MQTTSession(), event: .connected, error: nil)
        mockSession.stubbedSubscribeSubscribeHandlerResult = (nil, [NSNumber(value: 1)])

        sessionQueue.suspend()
        sut.subscribe([("fbon", .one)])

        // The hop onto the session's own queue is the fix: nothing may touch the session
        // on the caller's thread, because that is what races the session's event handling.
        XCTAssertFalse(mockSession.invokedSubscribe, "subscribe must be deferred to the session queue")

        sessionQueue.resume()
        drain(sessionQueue)

        XCTAssertTrue(mockSession.invokedSubscribe)
        XCTAssertEqual(mockSession.invokedSubscribeParameters?.topics?.keys.first, "fbon")
    }

    func testUnsubscribeIsSerialisedOntoSessionQueueWhenEnabled() {
        let sessionQueue = DispatchQueue(label: "test.courier.session")
        sut = makeSUT(queue: sessionQueue, serializeSessionAccess: true)
        setupSession()
        sut.handleEvent(MQTTSession(), event: .connected, error: nil)

        sessionQueue.suspend()
        sut.unsubscribe(["fbon"])

        XCTAssertFalse(mockSession.invokedUnsubscribeTopics, "unsubscribe must be deferred to the session queue")

        sessionQueue.resume()
        drain(sessionQueue)

        XCTAssertTrue(mockSession.invokedUnsubscribeTopics)
        XCTAssertEqual(mockSession.invokedUnsubscribeTopicsParameters?.topics?.first, "fbon")
    }

    func testSubscribeIsDroppedWhenNotConnectedAndSerializeSessionAccessEnabled() {
        let sessionQueue = DispatchQueue(label: "test.courier.session")
        sut = makeSUT(queue: sessionQueue, serializeSessionAccess: true)
        setupSession() // reaches .connecting only, never .connected

        sut.subscribe([("fbon", .one)])
        drain(sessionQueue)

        // Deferred work re-validates state on the queue, so a subscribe issued while the
        // connection is down is dropped instead of being sent on a stale session. The
        // subscription store replays it on the next successful connect.
        XCTAssertFalse(mockSession.invokedSubscribe)
    }

    // MARK: - confineSessionLifecycleToQueue (MQTTSession .cxx_destruct over-release fix)

    func testConnectRunsInlineWhenConfineSessionLifecycleDisabled() {
        setupSession()

        // Legacy behaviour: the session is created and connected on the caller's thread.
        XCTAssertTrue(sut.session === mockSession)
        XCTAssertTrue(mockSession.invokedConnect)
    }

    func testConnectIsConfinedToSessionQueueWhenEnabled() {
        let sessionQueue = DispatchQueue(label: "test.courier.session")
        sut = makeSUT(queue: sessionQueue, serializeSessionAccess: false, confineSessionLifecycleToQueue: true)

        sessionQueue.suspend()
        setupSession()

        // `session` is only ever assigned on the session queue: the crash is two callers
        // replacing it from different queues and over-releasing the old MQTTSession.
        XCTAssertNil(sut.session, "session must not be created on the caller's thread")
        XCTAssertFalse(mockSession.invokedConnect)

        sessionQueue.resume()
        drain(sessionQueue)

        XCTAssertTrue(sut.session === mockSession)
        XCTAssertTrue(mockSession.invokedConnect)
        XCTAssertEqual(mockSession.invokedQueue, sessionQueue)
        XCTAssertEqual(sut.state, .connecting)
    }

    func testReplacingSessionClosesOldOneOnSessionQueueWhenEnabled() {
        let sessionQueue = DispatchQueue(label: "test.courier.session")
        sut = makeSUT(queue: sessionQueue, serializeSessionAccess: false, confineSessionLifecycleToQueue: true)
        setupSession()
        drain(sessionQueue)
        XCTAssertFalse(mockSession.invokedClose)

        sessionQueue.suspend()
        // Fresh credentials (the re-auth path in the crash) force a new session.
        sut.connect(to: "host", port: 443, keepAlive: 240, isCleanSession: true, isAuth: true, clientId: "clientid", username: "username", password: "new-password", lastWill: false, lastWillTopic: nil, lastWillMessage: nil, lastWillQoS: nil, lastWillRetainFlag: false, securityPolicy: .init(), certificates: nil, protocolLevel: .version311, connectOptions: stubConnectOptions, connectHandler: nil)
        XCTAssertFalse(mockSession.invokedClose, "old session must not be closed off-queue")

        sessionQueue.resume()
        drain(sessionQueue)

        XCTAssertTrue(mockSession.invokedClose)
        XCTAssertTrue(mockSession.invokedConnect)
    }

    func testDisconnectFlipsStateInlineButClosesSessionOnQueueWhenEnabled() {
        let sessionQueue = DispatchQueue(label: "test.courier.session")
        sut = makeSUT(queue: sessionQueue, serializeSessionAccess: false, confineSessionLifecycleToQueue: true)
        setupSession()
        drain(sessionQueue)

        sessionQueue.suspend()
        sut.disconnect(with: nil)

        // Callers such as MQTTClient.reconnect check `isConnecting`/`isConnected` straight
        // after disconnecting, so the state change stays synchronous...
        XCTAssertEqual(sut.state, .closing)
        // ...while the session itself is only touched on its own queue.
        XCTAssertFalse(mockSession.invokedClose, "close must be deferred to the session queue")

        sessionQueue.resume()
        drain(sessionQueue)

        XCTAssertTrue(mockSession.invokedClose)
    }

    func testPublishIsConfinedToSessionQueueWhenEnabled() {
        let sessionQueue = DispatchQueue(label: "test.courier.session")
        sut = makeSUT(queue: sessionQueue, serializeSessionAccess: false, confineSessionLifecycleToQueue: true)
        setupSession()
        drain(sessionQueue)

        sessionQueue.suspend()
        sut.publish(packet: MQTTPacket(data: "hello".data(using: .utf8)!, topic: "fbon", qos: .one))
        XCTAssertFalse(mockSession.invokedPublishData, "publish must be deferred to the session queue")

        sessionQueue.resume()
        drain(sessionQueue)

        XCTAssertTrue(mockSession.invokedPublishData)
    }

    func testSubscribeIsSerialisedWhenOnlyConfineSessionLifecycleEnabled() {
        let sessionQueue = DispatchQueue(label: "test.courier.session")
        sut = makeSUT(queue: sessionQueue, serializeSessionAccess: false, confineSessionLifecycleToQueue: true)
        setupSession()
        drain(sessionQueue)
        sut.handleEvent(MQTTSession(), event: .connected, error: nil)
        mockSession.stubbedSubscribeSubscribeHandlerResult = (nil, [NSNumber(value: 1)])

        sessionQueue.suspend()
        sut.subscribe([("fbon", .one)])
        XCTAssertFalse(mockSession.invokedSubscribe, "confining the lifecycle implies serialised subscribe")

        sessionQueue.resume()
        drain(sessionQueue)

        XCTAssertTrue(mockSession.invokedSubscribe)
    }

    func testWorkIssuedFromSessionQueueRunsInlineWhenEnabled() {
        let sessionQueue = DispatchQueue(label: "test.courier.session")
        sut = makeSUT(queue: sessionQueue, serializeSessionAccess: false, confineSessionLifecycleToQueue: true)
        setupSession()
        drain(sessionQueue)

        // The ReconnectTimer and MQTTSessionDelegate callbacks already run on the session
        // queue; re-enqueueing from there would reorder them against each other, so the hop
        // must be inline in that case.
        sessionQueue.sync {
            sut.disconnect(with: nil)
            XCTAssertTrue(mockSession.invokedClose, "already on the session queue: must run inline")
        }
    }

    private func makeSUT(queue: DispatchQueue, serializeSessionAccess: Bool, confineSessionLifecycleToQueue: Bool = false) -> MQTTClientFrameworkSessionManager {
        let sessionFactory = MockMQTTSessionFactory()
        sessionFactory.stubbedMakeSessionResult = mockSession
        let persistenceFactory = MockMQTTPersistenceFactory()
        persistenceFactory.stubbedMakePersistenceResult = mockPersistence

        let manager = MQTTClientFrameworkSessionManager(
            retryInterval: 10,
            maxRetryInterval: 15,
            streamSSLLevel: "9999",
            queue: queue,
            mqttSessionFactory: sessionFactory,
            mqttPersistenceFactory: persistenceFactory,
            connectTimeoutPolicy: ConnectTimeoutPolicy(),
            idleActivityTimeoutPolicy: IdleActivityTimeoutPolicy(),
            eventHandler: mockEventHandler,
            fixCxxDestructCrash: false,
            serializeSessionAccess: serializeSessionAccess,
            confineSessionLifecycleToQueue: confineSessionLifecycleToQueue
        )
        manager.delegate = mockDelegate
        return manager
    }

    private func drain(_ queue: DispatchQueue) {
        let drained = expectation(description: "session queue drained")
        queue.async { drained.fulfill() }
        wait(for: [drained], timeout: 5)
    }

    func setupSession(securityPolicy: MQTTSSLSecurityPolicy = .init()) {
        sut.connect(to: "host", port: 443, keepAlive: 240, isCleanSession: true, isAuth: true, clientId: "clientid", username: "username", password: "password", lastWill: false, lastWillTopic: nil, lastWillMessage: nil, lastWillQoS: nil, lastWillRetainFlag: false, securityPolicy: securityPolicy, certificates: nil, protocolLevel: .version311, connectOptions: stubConnectOptions, connectHandler: nil)
    }
    
    var stubConnectOptions: ConnectOptions {
        ConnectOptions(host: "host", port: 443, keepAlive: 240, clientId: "clientid", username: "username", password: "password", isCleanSession: true, userProperties: nil, alpn: nil, scheme: "tls")
    }
    
    var stubbedError: NSError {
        NSError(domain: "x", code: -1, userInfo: [:])
    }

}
