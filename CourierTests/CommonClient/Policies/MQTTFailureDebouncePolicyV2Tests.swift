@testable import CourierCore
@testable import CourierMQTT
@testable import CourierCommonClient

import XCTest

class MQTTFailureDebouncePolicyV2Tests: XCTestCase {
    var sut: MQTTFailureDebouncePolicyV2!
    var mockAvailabilityListener: MockCourierAvailabilityListener!
    var taskWorkItemHandler: TaskWorkItemHandler!
    let dispatchQueue = DispatchQueue.main

    override func setUp() {
        mockAvailabilityListener = MockCourierAvailabilityListener()
        taskWorkItemHandler = TaskWorkItemHandler()

        sut = MQTTFailureDebouncePolicyV2(
            policyConfig: stubbedPolicyConfig,
            availabilityHandler: taskWorkItemHandler,
            subscribeAssertion: { $0.contains("food") },
            dispatchQueue: dispatchQueue
        )
        sut.setAvailabilityListener(mockAvailabilityListener)
    }

    func testSetAvailabilityListener() {
        XCTAssertNotNil(sut.courierAvailabilityListener)
    }

    func testOnConnectAttempt() {
        sut.onEvent(.connectionAttempt)
        XCTAssertNotNil(sut.availabilityHandler.task)
        let exp = expectation(description: "availabilityHandler")

        dispatchQueue.asyncAfter(deadline: .now() + 0.1) {
            exp.fulfill()
        }

        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertTrue(self.mockAvailabilityListener.invokedCourierUnavailable)
        }
    }

    func testOnConnectionDisconnect() {
        sut.onEvent(.connectionDisconnect)
        XCTAssertNil(sut.availabilityHandler.task)

        XCTAssertTrue(mockAvailabilityListener.invokedCourierAvailable)
    }

    func testOnUnsubscribeAttempt() {
        sut.onEvent(.unsubscribeAttempt(topic: "food"))
        XCTAssertNil(sut.availabilityHandler.task)

        XCTAssertTrue(mockAvailabilityListener.invokedCourierAvailable)
    }

    func testOnSubscribeAttempt() {
        sut.onEvent(.subscribeAttempt(topic: "food"))
        XCTAssertNil(sut.availabilityHandler.task)

        XCTAssertTrue(mockAvailabilityListener.invokedCourierAvailable)
    }

    func testOnSubscribeAttemptInvalidTopic() {
        sut.availabilityHandler.task = DispatchWorkItem {}
        sut.onEvent(.subscribeAttempt(topic: "pay"))
        XCTAssertNotNil(sut.availabilityHandler.task)
    }

    func testOnUnsubscribeAttemptInvalidTopic() {
        sut.availabilityHandler.task = DispatchWorkItem {}
        sut.onEvent(.unsubscribeAttempt(topic: "pay"))
        XCTAssertNotNil(sut.availabilityHandler.task)
    }
}

extension MQTTFailureDebouncePolicyV2Tests {
    var stubbedPolicyConfig: CourierAvailabilityPolicyConfig {
        CourierAvailabilityPolicyConfig(
            policyEnabled: true,
            fallbackDelaySeconds: 0,
            isShadowMode: false
        )
    }
}
