






import XCTest
@testable import CourierCore
@testable import CourierMQTT
class MulticastCourierEventHandlerTests: XCTestCase {

    var sut: MulticastCourierEventHandler!
    var mockMulticastDelegate: MockMulticastDelegate!
    var mockCourierEventHandler: MockCourierEventHandler!

    override func setUp() {
        mockMulticastDelegate = MockMulticastDelegate()
        mockCourierEventHandler = MockCourierEventHandler()
        mockMulticastDelegate.stubbedInvokeCourierEventHandler = mockCourierEventHandler
        sut = MulticastCourierEventHandler(multicast: mockMulticastDelegate)
    }

    func testAddEventHandler() {
        sut.addEventHandler(mockCourierEventHandler)
        XCTAssertTrue(mockMulticastDelegate.invokedAdd)
    }

    func testRemoveEventHandler() {
        sut.removeEventHandler(mockCourierEventHandler)
        XCTAssertTrue(mockMulticastDelegate.invokedRemove)
    }

    func testReset() {
        sut.reset()
        XCTAssertTrue(mockCourierEventHandler.invokedReset)
    }

    func testConnectionServiceAuthStart() {
        sut.onEvent(.init(connectionInfo: nil, event: .connectionServiceAuthStart(source: "TEST")))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case .connectionServiceAuthStart(let source):
            XCTAssert(true)
            XCTAssertEqual(source, "TEST")
        default:
            XCTAssert(false)
        }
    }

    func testOnCourierReconnect() {
        sut.onEvent(.init(connectionInfo: nil, event: .reconnect))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case .reconnect:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testConnectionServiceAuthSuccess() {
        sut.onEvent(.init(connectionInfo: nil, event: .connectionServiceAuthSuccess(host: "xyz", port: 999)))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case let .connectionServiceAuthSuccess(host, port):
            XCTAssertEqual(host, "xyz")
            XCTAssertEqual(port, 999)
        default:
            XCTAssert(false)
        }
    }

    func testConnectionServiceAuthFailure() {
        sut.onEvent(.init(connectionInfo: nil, event: .connectionServiceAuthFailure(error: stubbedError)))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case let .connectionServiceAuthFailure(error):
            let error = error! as NSError
            XCTAssertEqual(error.domain, stubbedError.domain)
            XCTAssertEqual(error.code, stubbedError.code)
        default:
            XCTAssert(false)
        }
    }

    func testOnCourierClientConnectedPacketSent() {
        sut.onEvent(.init(connectionInfo: nil, event: .connectedPacketSent))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case .connectedPacketSent:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testConnectionAttempt() {
        sut.onEvent(.init(connectionInfo: nil, event: .connectionAttempt))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case .connectionAttempt:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testConnectionSuccess() {
        sut.onEvent(.init(connectionInfo: nil, event: .connectionSuccess))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case .connectionSuccess:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testOnConnectionFailure() {
        sut.onEvent(.init(connectionInfo: nil, event: .connectionFailure(error: stubbedError)))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case let .connectionFailure(error):
            let error = error! as NSError
            XCTAssertEqual(error.domain, stubbedError.domain)
            XCTAssertEqual(error.code, stubbedError.code)
        default:
            XCTAssert(false)
        }
    }

    func testOnConnectionLost() {
        sut.onEvent(.init(connectionInfo: nil, event: .connectionLost(error: stubbedError, diffLastInbound: nil, diffLastOutbound: nil)))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case let .connectionLost(error, _, _):
            let error = error! as NSError
            XCTAssertEqual(error.domain, stubbedError.domain)
            XCTAssertEqual(error.code, stubbedError.code)
        default:
            XCTAssert(false)
        }
    }

    func testOnDisconnect() {
        sut.onEvent(.init(connectionInfo: nil, event: .connectionDisconnect))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case .connectionDisconnect:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testOnCourierDisconnect() {
        sut.onEvent(.init(connectionInfo: nil, event: .courierDisconnect(clearState: true)))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case .courierDisconnect(let clearState):
            XCTAssert(true)
            XCTAssertTrue(clearState)
        default:
            XCTAssert(false)
        }
    }

    func testOnSubscribeSuccess() {
        sut.onEvent(.init(connectionInfo: nil, event: .subscribeSuccess(topic: stubbedTopic)))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case let .subscribeSuccess(topic):
            XCTAssertEqual(stubbedTopic, topic)
        default:
            XCTAssert(false)
        }
    }

    func testOnUnsubscribeSuccess() {
        sut.onEvent(.init(connectionInfo: nil, event: .unsubscribeSuccess(topic: stubbedTopic)))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case let .unsubscribeSuccess(topic):
            XCTAssertEqual(stubbedTopic, topic)
        default:
            XCTAssert(false)
        }
    }

    func testOnSubscribeFailure() {
        sut.onEvent(.init(connectionInfo: nil, event: .subscribeFailure(topic: stubbedTopic, error: stubbedError)))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case let .subscribeFailure(topic, error):
            XCTAssertEqual(stubbedTopic, topic)
            let error = error! as NSError
            XCTAssertEqual(error.domain, stubbedError.domain)
            XCTAssertEqual(error.code, stubbedError.code)
        default:
            XCTAssert(false)
        }
    }

    func testOnUnsubscribeFailure() {
        sut.onEvent(.init(connectionInfo: nil, event: .unsubscribeFailure(topic: stubbedTopic, error: stubbedError)))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case let .unsubscribeFailure(topic, error):
            XCTAssertEqual(stubbedTopic, topic)
            let error = error! as NSError
            XCTAssertEqual(error.domain, stubbedError.domain)
            XCTAssertEqual(error.code, stubbedError.code)
        default:
            XCTAssert(false)
        }
    }

    func testOnPing() {
        sut.onEvent(.init(connectionInfo: nil, event: .ping(url: stubbedServerUri)))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case let .ping(url):
            XCTAssertEqual(stubbedServerUri, url)
        default:
            XCTAssert(false)
        }
    }

    func testOnPong() {
        sut.onEvent(.init(connectionInfo: nil, event: .pongReceived(timeTaken: stubbedTimeTaken)))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case let .pongReceived(timeTaken):
            XCTAssertEqual(timeTaken, stubbedTimeTaken)
        default:
            XCTAssert(false)
        }
    }


    func testOnPingFailure() {
        sut.onEvent(.init(connectionInfo: nil, event: .pingFailure(timeTaken: stubbedTimeTaken, error: stubbedError)))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case let .pingFailure(timeTaken, error):
            XCTAssertEqual(timeTaken, stubbedTimeTaken)
            let error = error! as NSError
            XCTAssertEqual(error.domain, stubbedError.domain)
            XCTAssertEqual(error.code, stubbedError.code)
        default:
            XCTAssert(false)
        }
    }

    func testOnMessageReceive() {
        sut.onEvent(.init(connectionInfo: nil, event: .messageReceive(topic: stubbedTopic, sizeBytes: 100)))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case let .messageReceive(topic, sizeBytes):
            XCTAssertEqual(topic, stubbedTopic)
            XCTAssertEqual(sizeBytes, 100)
        default:
            XCTAssert(false)
        }
    }

    func testOnMessageReceiveFailure() {
        sut.onEvent(.init(connectionInfo: nil, event: .messageReceiveFailure(topic: stubbedTopic, error: stubbedError, sizeBytes: 100)))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case let .messageReceiveFailure(topic, error, sizeBytes):
            XCTAssertEqual(topic, stubbedTopic)
            XCTAssertEqual(sizeBytes, 100)
            let error = error! as NSError
            XCTAssertEqual(error.domain, stubbedError.domain)
            XCTAssertEqual(error.code, stubbedError.code)
        default:
            XCTAssert(false)
        }
    }

    func testOnMQTTMessageSend() {
        sut.onEvent(.init(connectionInfo: nil, event: .messageSend(topic: stubbedTopic, qos: .zero, sizeBytes: 100)))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case let .messageSend(topic, qos, sizeBytes):
            XCTAssertEqual(topic, stubbedTopic)
            XCTAssertEqual(qos, .zero)
            XCTAssertEqual(sizeBytes, 100)
        default:
            XCTAssert(false)
        }
    }

    func testOnMessageSendFailure() {
        sut.onEvent(.init(connectionInfo: nil, event: .messageSendFailure(topic: stubbedTopic, qos: .zero, error: stubbedError, sizeBytes: 100)))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case let .messageSendFailure(topic, qos, error, sizeBytes):
            XCTAssertEqual(topic, stubbedTopic)
            let error = error! as NSError
            XCTAssertEqual(error.domain, stubbedError.domain)
            XCTAssertEqual(error.code, stubbedError.code)
            XCTAssertEqual(qos, .zero)
            XCTAssertEqual(sizeBytes, 100)
        default:
            XCTAssert(false)
        }
    }

    func testOnAppForeground() {
        sut.onEvent(.init(connectionInfo: nil, event: .appForeground))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case .appForeground:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testOnConnectionUnavailable() {
        sut.onEvent(.init(connectionInfo: nil, event: .connectionUnavailable))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case .connectionUnavailable:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testConnectionAvailable() {
        sut.onEvent(.init(connectionInfo: nil, event: .connectionAvailable))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case .connectionAvailable:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testOnMQTTSubscribeAttempt() {
        sut.onEvent(.init(connectionInfo: nil, event: .subscribeAttempt(topic: stubbedTopic)))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case let .subscribeAttempt(topic):
            XCTAssertEqual(topic, stubbedTopic)
        default:
            XCTAssert(false)
        }
    }

    func testOnMQTTUnsubscribeAttempt() {
        sut.onEvent(.init(connectionInfo: nil, event: .unsubscribeAttempt(topic: stubbedTopic)))
        switch mockCourierEventHandler.invokedOnEventParameters?.event.type {
        case let .unsubscribeAttempt(topic):
            XCTAssertEqual(topic, stubbedTopic)
        default:
            XCTAssert(false)
        }
    }

}

extension MulticastCourierEventHandlerTests {

    var stubbedError: NSError {
        NSError(domain: "x", code: -1, userInfo: [:])
    }

    var stubbedTopic: String {
        "fbon/1"
    }

    var stubbedServerUri: String {
        "https://example.com"
    }

    var stubbedTimeTaken: Int {
        20
    }

}

