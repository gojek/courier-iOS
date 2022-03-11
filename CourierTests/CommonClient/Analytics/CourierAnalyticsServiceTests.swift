import XCTest

@testable import CourierCore
@testable import CourierMQTT
@testable import CourierCommonClient

class CourierAnalyticsServiceTests: XCTestCase {

    var sut: CourierAnalyticsService!
    var mockAnalyticsManager: MockCourierAnalyticsManager!
    var mockReachability: MockReachability!
    var eventProbability = 100

    override func setUp() {
        mockAnalyticsManager = MockCourierAnalyticsManager()
        mockReachability = try! MockReachability()
        mockReachability.stubbedConnection = .wifi
        sut = CourierAnalyticsService(analyticsManagerProvider: {
            self.mockAnalyticsManager.send($0, properties: $1, source: .clevertap)
        }, eventProbability: eventProbability, clickstreamAnalyticsManagerProvider: { _, _ in }, reachability: mockReachability)

        sut.reset()
    }

    func testOnCourierConnectStart() {
        sut.onEvent(.connectionServiceAuthStart(source: "Test"))
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.courierConnectStarted)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties![EventProperty.source] as! String, "Test")
    }

    func testOnCourierReconnect() {
        sut.onEvent(.reconnect)
        XCTAssertTrue(mockAnalyticsManager.invokedSend)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.courierReconnect)
    }

    func testOnCourierConnectSuccess() {
        sut.onEvent(.connectionServiceAuthSuccess(host: "xyz", port: 9999, isCache: false))
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.courierConnectSucceeded)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.host] as! String, "xyz")
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.port] as! String, "9999")
    }

    func testOnCourierConnectFailure() {
        sut.onEvent(.connectionServiceAuthFailure(error: stubbedError))
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.courierConnectFailed)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.reasonMessage] as! String, stubbedError.localizedDescription)
    }

    func testOnCourierClientConnectedPacketSent() {
        sut.onEvent(.connectedPacketSent)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.connectPacketSend)
    }

    func testOnMQTTConnectAttempt() {
        sut.onEvent(.connectionAttempt)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.mqttConnectAttempt)
    }

    func testonMQTTConnectSuccess() {
        sut.onEvent(.connectionSuccess)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.mqttConnectSuccess)
    }

    func testOnMQTTConnectFailure() {
        sut.onEvent(.connectionFailure(error: stubbedError))
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.mqttConnectFailure)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.reasonMessage] as! String, stubbedError.localizedDescription)
    }

    func testOnMQTTDisconnect() {
        sut.onEvent(.connectionDisconnect)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.mqttConnectionDisconnect)
    }

    func testOnCourierDisconnect() {
        sut.onEvent(.courierDisconnect(clearState: true))
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.courierDisconnect)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.clearState] as! String, String(true))
    }

    func testOnMQTTConnectionLost() {
        sut.onEvent(.connectionLost(error: stubbedError, diffLastInbound: nil, diffLastOutbound: nil))
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.mqttConnectionLost)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.reasonMessage] as! String, stubbedError.localizedDescription)
    }

    func testOnMQTTSubscribeSuccess() {
        sut.onEvent(.subscribeSuccess(topic: "fbon/1"))
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.mqttSubscribeSucceess)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.topic] as! String, "fbon/1")
    }

    func testOnMQTTUnsubscribeSuccess() {
        sut.onEvent(.unsubscribeSuccess(topic: "fbon/3"))
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.mqttUnsubscribeSuccess)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.topic] as! String, "fbon/3")
    }

    func testOnMQTTSubscribeFailure() {
        sut.onEvent(.subscribeFailure(topic: "fbon", error: stubbedError))
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.mqttSubscribeFailure)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.topic] as! String, "fbon")
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.reasonMessage] as! String, stubbedError.localizedDescription)
    }

    func testOnMQTTUnsubscribeFailure() {
        sut.onEvent(.unsubscribeFailure(topic: "fbon", error: stubbedError))
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.mqttUnsubscribeFailure)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.topic] as! String, "fbon")
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.reasonMessage] as! String, stubbedError.localizedDescription)
    }

    func testOnMQTTReceivePing() {
        sut.onEvent(.ping(url: "courier"))
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.mqttPingInitiated)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.serverURI] as! String, "courier")
    }

    func testOnMQTTReceiverPong() {
        sut.onEvent(.pongReceived(timeTaken: 20))
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.mqttPingSuccess)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.timeTaken] as! String, "20")
    }

    func testOnMQTTPingFailure() {
        sut.onEvent(.pingFailure(timeTaken: 20, error: stubbedError))
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.mqttPingFailure)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.reasonMessage] as! String, stubbedError.localizedDescription)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.timeTaken] as! String, "20")
    }

    func testOnMQTTMessageReceive() {
        sut.onEvent(.messageReceive(topic: "fbon", sizeBytes: 100))
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.mqttMessageReceive)
    }

    func testOnMQTTMessageReceiveFailure() {
        sut.onEvent(.messageReceiveFailure(topic: "fbon", error: stubbedError, sizeBytes: 100))
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.mqttMessageReceiveFailed)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.reasonMessage] as! String, stubbedError.localizedDescription)
    }

    func testOnMQTTMessageSend() {
        sut.onEvent(.messageSend(topic: "fbon", qos: .zero, sizeBytes: 100))
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.mqttMessageSend)
    }

    func testOnMQTTMessageSendFailure() {
        sut.onEvent(.messageSendFailure(topic: "fbon", qos: .zero, error: stubbedError, sizeBytes: 100))
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.mqttMessageSendFailed)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.reasonMessage] as! String, stubbedError.localizedDescription)
    }

    func testOnMQTTSubscribeAttempt() {
        sut.onEvent(.subscribeAttempt(topic: "fbon/2"))
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.mqttSubscribeAttempt)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.topic] as! String, "fbon/2")
    }

    func testOnMQTTUnsubscribeAttempt() {
        sut.onEvent(.unsubscribeAttempt(topic: "fbon/2"))
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.name, EventName.mqttUnsubscribeAttempt)
        XCTAssertEqual(mockAnalyticsManager.invokedSendParameters?.properties?[EventProperty.topic] as! String, "fbon/2")
    }

}

extension CourierAnalyticsServiceTests {

    var stubbedError: NSError {
        NSError(domain: "x", code: -1, userInfo: [NSLocalizedDescriptionKey: "error"])
    }

    var stubbedPolicyConfig: CourierAvailabilityPolicyConfig {
        CourierAvailabilityPolicyConfig(policyEnabled: true, fallbackDelaySeconds: 30, isShadowMode: true)
    }

}
