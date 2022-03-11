@testable import CourierCore
@testable import CourierMQTT
@testable import CourierCommonClient

import XCTest

class ConnectionServiceFailurePolicyTests: XCTestCase {
    var sut: ConnectionServiceFailurePolicy!
    var mockAvailabilityListener: MockCourierAvailabilityListener!
    var taskWorkItemHandler: TaskWorkItemHandler!
    let dispatchQueue = DispatchQueue.main

    override func setUp() {
        mockAvailabilityListener = MockCourierAvailabilityListener()
        taskWorkItemHandler = TaskWorkItemHandler()

        sut = ConnectionServiceFailurePolicy(
            policyConfig: stubbedPolicyConfig,
            availabilityHandler: taskWorkItemHandler,
            dispatchQueue: dispatchQueue
        )
        sut.setAvailabilityListener(mockAvailabilityListener)
    }

    func testSetAvailabilityListener() {
        XCTAssertNotNil(sut.courierAvailabilityListener)
    }

    func testOnConnectAttempt() {
        sut.onEvent(.connectionAttempt)
        XCTAssertNil(sut.availabilityHandler.task)
        XCTAssertTrue(mockAvailabilityListener.invokedConnectionServiceAvailable)
    }

    func testOnConnectServiceAuthStart() {
        sut.onEvent(.connectionServiceAuthStart(source: "Test"))
        XCTAssertNotNil(sut.availabilityHandler.task)
        let exp = expectation(description: "availabilityHandler")

        dispatchQueue.asyncAfter(deadline: .now() + 0.1) {
            exp.fulfill()
        }

        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertTrue(self.mockAvailabilityListener.invokedConnectionServiceUnavailable)
        }
    }
}

extension ConnectionServiceFailurePolicyTests {
    var stubbedPolicyConfig: CourierAvailabilityPolicyConfig {
        CourierAvailabilityPolicyConfig(
            policyEnabled: true,
            fallbackDelaySeconds: 0,
            isShadowMode: false
        )
    }
}
