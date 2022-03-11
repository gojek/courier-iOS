@testable import CourierCore
@testable import CourierMQTT
@testable import CourierCommonClient

import XCTest

class MQTTFailureDebouncePolicyTests: XCTestCase {
    var sut: MQTTFailureDebouncePolicy!
    var mockAvailabilityListener: MockCourierAvailabilityListener!
    var taskWorkItemHandler: TaskWorkItemHandler!
    let dispatchQueue = DispatchQueue.main

    override func setUp() {
        mockAvailabilityListener = MockCourierAvailabilityListener()
        taskWorkItemHandler = TaskWorkItemHandler()

        sut = MQTTFailureDebouncePolicy(
            policyConfig: stubbedPolicyConfig,
            availabilityHandler: taskWorkItemHandler,
            dispatchQueue: dispatchQueue
        )
        sut.setAvailabilityListener(mockAvailabilityListener)
    }

    func testSetAvailabilityListener() {
        XCTAssertNotNil(sut.courierAvailabilityListener)
    }

    func testOnConnectSuccess() {
        sut.onEvent(.connectionSuccess)
        XCTAssertNil(sut.availabilityHandler.task)

        XCTAssertTrue(mockAvailabilityListener.invokedCourierAvailable)
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

    func testOnConnecttionLost() {
        sut.onEvent(.connectionLost(error: nil, diffLastInbound: nil, diffLastOutbound: nil))
        XCTAssertNotNil(sut.availabilityHandler.task)
        let exp = expectation(description: "availabilityHandler")

        dispatchQueue.asyncAfter(deadline: .now() + 0.1) {
            exp.fulfill()
        }

        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertTrue(self.mockAvailabilityListener.invokedCourierUnavailable)
        }
    }
}

extension MQTTFailureDebouncePolicyTests {
    var stubbedPolicyConfig: CourierAvailabilityPolicyConfig {
        CourierAvailabilityPolicyConfig(
            policyEnabled: true,
            fallbackDelaySeconds: 0,
            isShadowMode: false
        )
    }
}
