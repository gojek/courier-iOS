






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
        sut.onEvent(.connectionServiceAuthStart(source: "TEST"))
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case .connectionServiceAuthStart(let source):
            XCTAssert(true)
            XCTAssertEqual(source, "TEST")
        default:
            XCTAssert(false)
        }
    }

    func testOnCourierReconnect() {
        sut.onEvent(.reconnect)
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case .reconnect:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testConnectionServiceAuthSuccess() {
        sut.onEvent(.connectionServiceAuthSuccess(host: "xyz", port: 999, isCache: false))
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case let .connectionServiceAuthSuccess(host, port, _):
            XCTAssertEqual(host, "xyz")
            XCTAssertEqual(port, 999)
        default:
            XCTAssert(false)
        }
    }

    func testConnectionServiceAuthFailure() {
        sut.onEvent(.connectionServiceAuthFailure(error: stubbedError))
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case let .connectionServiceAuthFailure(error):
            let error = error! as NSError
            XCTAssertEqual(error.domain, stubbedError.domain)
            XCTAssertEqual(error.code, stubbedError.code)
        default:
            XCTAssert(false)
        }
    }

    func testOnCourierClientConnectedPacketSent() {
        sut.onEvent(.connectedPacketSent)
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case .connectedPacketSent:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testConnectionAttempt() {
        sut.onEvent(.connectionAttempt)
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case .connectionAttempt:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testConnectionSuccess() {
        sut.onEvent(.connectionSuccess)
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case .connectionSuccess:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testOnConnectionFailure() {
        sut.onEvent(.connectionFailure(error: stubbedError))
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case let .connectionFailure(error):
            let error = error! as NSError
            XCTAssertEqual(error.domain, stubbedError.domain)
            XCTAssertEqual(error.code, stubbedError.code)
        default:
            XCTAssert(false)
        }
    }

    func testOnConnectionLost() {
        sut.onEvent(.connectionLost(error: stubbedError, diffLastInbound: nil, diffLastOutbound: nil))
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case let .connectionLost(error, _, _):
            let error = error! as NSError
            XCTAssertEqual(error.domain, stubbedError.domain)
            XCTAssertEqual(error.code, stubbedError.code)
        default:
            XCTAssert(false)
        }
    }

    func testOnDisconnect() {
        sut.onEvent(.connectionDisconnect)
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case .connectionDisconnect:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testOnCourierDisconnect() {
        sut.onEvent(.courierDisconnect(clearState: true))
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case .courierDisconnect(let clearState):
            XCTAssert(true)
            XCTAssertTrue(clearState)
        default:
            XCTAssert(false)
        }
    }

    func testOnSubscribeSuccess() {
        sut.onEvent(.subscribeSuccess(topic: stubbedTopic))
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case let .subscribeSuccess(topic):
            XCTAssertEqual(stubbedTopic, topic)
        default:
            XCTAssert(false)
        }
    }

    func testOnUnsubscribeSuccess() {
        sut.onEvent(.unsubscribeSuccess(topic: stubbedTopic))
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case let .unsubscribeSuccess(topic):
            XCTAssertEqual(stubbedTopic, topic)
        default:
            XCTAssert(false)
        }
    }

    func testOnSubscribeFailure() {
        sut.onEvent(.subscribeFailure(topic: stubbedTopic, error: stubbedError))
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
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
        sut.onEvent(.unsubscribeFailure(topic: stubbedTopic, error: stubbedError))
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
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
        sut.onEvent(.ping(url: stubbedServerUri))
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case let .ping(url):
            XCTAssertEqual(stubbedServerUri, url)
        default:
            XCTAssert(false)
        }
    }

    func testOnPong() {
        sut.onEvent(.pongReceived(timeTaken: stubbedTimeTaken))
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case let .pongReceived(timeTaken):
            XCTAssertEqual(timeTaken, stubbedTimeTaken)
        default:
            XCTAssert(false)
        }
    }


    func testOnPingFailure() {
        sut.onEvent(.pingFailure(timeTaken: stubbedTimeTaken, error: stubbedError))
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
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
        sut.onEvent(.messageReceive(topic: stubbedTopic, sizeBytes: 100))
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case let .messageReceive(topic, sizeBytes):
            XCTAssertEqual(topic, stubbedTopic)
            XCTAssertEqual(sizeBytes, 100)
        default:
            XCTAssert(false)
        }
    }

    func testOnMessageReceiveFailure() {
        sut.onEvent(.messageReceiveFailure(topic: stubbedTopic, error: stubbedError, sizeBytes: 100))
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
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
        sut.onEvent(.messageSend(topic: stubbedTopic, qos: .zero, sizeBytes: 100))
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case let .messageSend(topic, qos, sizeBytes):
            XCTAssertEqual(topic, stubbedTopic)
            XCTAssertEqual(qos, .zero)
            XCTAssertEqual(sizeBytes, 100)
        default:
            XCTAssert(false)
        }
    }

    func testOnMessageSendFailure() {
        sut.onEvent(.messageSendFailure(topic: stubbedTopic, qos: .zero, error: stubbedError, sizeBytes: 100))
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
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
        sut.onEvent(.appForeground)
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case .appForeground:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testOnConnectionUnavailable() {
        sut.onEvent(.connectionUnavailable)
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case .connectionUnavailable:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testConnectionAvailable() {
        sut.onEvent(.connectionAvailable)
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case .connectionAvailable:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testOnMQTTSubscribeAttempt() {
        sut.onEvent(.subscribeAttempt(topic: stubbedTopic))
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
        case let .subscribeAttempt(topic):
            XCTAssertEqual(topic, stubbedTopic)
        default:
            XCTAssert(false)
        }
    }

    func testOnMQTTUnsubscribeAttempt() {
        sut.onEvent(.unsubscribeAttempt(topic: stubbedTopic))
        switch mockCourierEventHandler.invokedOnEventParameters?.event {
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
        "https:
    }

    var stubbedTimeTaken: Int {
        20
    }

}

