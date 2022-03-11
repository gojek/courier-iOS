import XCTest
@testable import CourierCore
@testable import CourierMQTT
class DiskSubscriptionStoreTests: XCTestCase {

    var sut: DiskSubscriptionStore!
    let userDefaults = UserDefaults.standard
    let pendingUnsubKey = "test.courier.disksubscriptionstore."

    override func setUp() {
        sut = DiskSubscriptionStore(topics: [:], pendingUnsubKey: pendingUnsubKey, userDefaults: userDefaults)
    }

    override func tearDown() {
        sut.clearAllSubscriptions()
    }

    func testInitializeWithPendingUnsubsExistsInUserDefaults() {
        XCTAssertTrue(sut.pendingUnsubscriptions.isEmpty)
        userDefaults.setValue(Array(["x1", "x2", "x3"]), forKey: pendingUnsubKey)
        sut = DiskSubscriptionStore(topics: [:], pendingUnsubKey: pendingUnsubKey, userDefaults: userDefaults)
        XCTAssertEqual(sut.pendingUnsubscriptions, ["x1", "x2", "x3"])
    }

    func testInitializeWithExistingSubs() {
        sut = DiskSubscriptionStore(topics: ["x1": .one], pendingUnsubKey: pendingUnsubKey, userDefaults: userDefaults)
        XCTAssertEqual(sut.subscriptions, ["x1": .one])
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
        XCTAssertNil(userDefaults.stringArray(forKey: pendingUnsubKey))
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
