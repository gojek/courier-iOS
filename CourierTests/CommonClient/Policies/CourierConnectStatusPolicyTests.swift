import XCTest
@testable import CourierCore
@testable import CourierMQTT
@testable import CourierCommonClient

class CourierConnectStatusPolicyTests: XCTestCase {

    var sut: CourierConnectStatusPolicy!
    var mockAvailabilityListener: MockCourierAvailabilityListener!
    var taskWorkItemHandler: TaskWorkItemHandler!
    let dispatchQueue = DispatchQueue.main

    override func setUp() {
        mockAvailabilityListener = MockCourierAvailabilityListener()
        taskWorkItemHandler = TaskWorkItemHandler()

        sut = CourierConnectStatusPolicy(
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

        XCTAssertTrue(mockAvailabilityListener.invokedCourierConnected)
    }

    func testOnConnectionAvailable() {
        sut.onEvent(.connectionAvailable)
        XCTAssertNil(sut.availabilityHandler.task)

        XCTAssertTrue(mockAvailabilityListener.invokedCourierConnected)
    }

    func testOnConnectFailure() {
        sut.onEvent(.connectionFailure(error: nil))
        XCTAssertNotNil(sut.availabilityHandler.task)
        let exp = expectation(description: "availabilityHandler")

        dispatchQueue.asyncAfter(deadline: .now() + 0.1) {
            exp.fulfill()
        }

        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertTrue(self.mockAvailabilityListener.invokedCourierDisconnected)
        }
    }

    func testOnConnectionUnavailable() {
        sut.onEvent(.connectionUnavailable)
        XCTAssertNotNil(sut.availabilityHandler.task)
        let exp = expectation(description: "availabilityHandler")

        dispatchQueue.asyncAfter(deadline: .now() + 0.1) {
            exp.fulfill()
        }

        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertTrue(self.mockAvailabilityListener.invokedCourierDisconnected)
        }
    }

}

extension CourierConnectStatusPolicyTests {
    var stubbedPolicyConfig: CourierAvailabilityPolicyConfig {
        CourierAvailabilityPolicyConfig(
            policyEnabled: true,
            fallbackDelaySeconds: 0,
            isShadowMode: false
        )
    }
}
