import XCTest
@testable import CourierCore
@testable import CourierMQTT
class InMemorySubscriptionStoreTests: XCTestCase {

    var sut: InMemorySubscriptionStore!

    override func setUp() {
        sut = InMemorySubscriptionStore(topics: [:])
    }

    func testInitializeWithExistingSubs() {
        sut = InMemorySubscriptionStore(topics: ["x2": .two])
        XCTAssertEqual(sut.subscriptions, ["x2": .two])
    }

    func testSubscribeTopics() {
        sut.unsubscribe(["fbon/1"])
        sut.subscribe([
            ("fbon/1", .zero),
            ("fbon/2", .one)
        ])
        XCTAssertFalse(sut.isCurrentlyPendingUnsubscribe(topic: "fbon/1"))
        XCTAssertEqual(sut.subscriptions["fbon/1"], .zero)
        XCTAssertEqual(sut.subscriptions["fbon/2"], .one)
    }

    func testUnsubscribetopics() {
        sut.subscribe([
            ("fbon/1", .zero),
            ("fbon/2", .one)
        ])
        XCTAssertNotNil(sut.subscriptions["fbon/1"])
        XCTAssertNotNil(sut.subscriptions["fbon/2"])
        sut.unsubscribe([
            "fbon/1",
            "fbon/2"
        ])

        XCTAssertNil(sut.subscriptions["fbon/1"])
        XCTAssertNil(sut.subscriptions["fbon/2"])
        XCTAssertTrue(sut.pendingUnsubscriptions.contains("fbon/1"))
        XCTAssertTrue(sut.pendingUnsubscriptions.contains("fbon/2"))

    }

    func testClearAllSubscriptions() {
        sut.subscribe([
            ("fbon/1", .zero),
            ("fbon/2", .one)
        ])
        sut.unsubscribe(["xca"])
        XCTAssertNotNil(sut.subscriptions["fbon/1"])
        XCTAssertNotNil(sut.subscriptions["fbon/2"])
        XCTAssertTrue(sut.pendingUnsubscriptions.contains("xca"))

        sut.clearAllSubscriptions()
        XCTAssertNil(sut.subscriptions["fbon/1"])
        XCTAssertNil(sut.subscriptions["fbon/2"])
        XCTAssertFalse(sut.pendingUnsubscriptions.contains("xca"))
    }

    func testIsCurrentlyPendingUnsubscribe() {
        sut.unsubscribe(["xca"])
        XCTAssertTrue(sut.isCurrentlyPendingUnsubscribe(topic: "xca"))
    }

    func testUnsubscribeAcked() {
        sut.unsubscribe(["xca"])
        XCTAssertTrue(sut.pendingUnsubscriptions.contains("xca"))
        sut.unsubscribeAcked(["xca"])
        XCTAssertFalse(sut.pendingUnsubscriptions.contains("xca"))
    }
}
