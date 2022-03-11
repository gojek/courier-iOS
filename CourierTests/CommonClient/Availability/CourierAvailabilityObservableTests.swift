@testable import CourierCore
@testable import CourierMQTT
@testable import CourierCommonClient

import XCTest

class CourierAvailabilityObservableTests: XCTestCase {
    var sut: CourierAvailabilityObservable!
    var mockEventHandler: MockMulticastCourierEventHandler!
    var mockMQTTFailureDebouncePolicy: MockAvailabilityPolicy!
    var mockConnectionServiceFailurePolicy: MockAvailabilityPolicy!
    var mockCourierConnectStatusPolicy: MockAvailabilityPolicy!
    var mockCourierClient: MockCourierClient!

    private var cancellables = Set<AnyCancellable>()
    let dispatchQueue = DispatchQueue.main

    override func setUp() {
        mockEventHandler = MockMulticastCourierEventHandler()
        mockMQTTFailureDebouncePolicy = MockAvailabilityPolicy()
        mockConnectionServiceFailurePolicy = MockAvailabilityPolicy()
        mockCourierConnectStatusPolicy = MockAvailabilityPolicy()
        mockCourierClient = MockCourierClient()
        mockCourierClient.stubbedConnectionState = .disconnected

        let mockAvailabilityPoliciesFactory = MockAvailabilityPoliciesFactory()
        mockAvailabilityPoliciesFactory.stubbedCreatePoliciesResult = [
            mockMQTTFailureDebouncePolicy,
            mockConnectionServiceFailurePolicy,
            mockCourierConnectStatusPolicy
        ]

        sut = CourierAvailabilityObservable(
            courierEventManager: mockCourierClient,
            availabilityPoliciesFactory: mockAvailabilityPoliciesFactory,
            dispatchQueue: dispatchQueue
        )
    }

    func testInitializerSetAvailabilityListener() {
        XCTAssertTrue(mockMQTTFailureDebouncePolicy.invokedSetAvailabilityListener)
        XCTAssertTrue(mockConnectionServiceFailurePolicy.invokedSetAvailabilityListener)
        XCTAssertTrue(mockCourierConnectStatusPolicy.invokedSetAvailabilityListener)
    }

    func testClearObservabilityTask() {
        let taskWorkItems = (0 ..< 4).map { _ -> TaskWorkItemHandler in
            var taskWorkItem = TaskWorkItemHandler()
            taskWorkItem.task = DispatchWorkItem {}
            return taskWorkItem
        }

        mockMQTTFailureDebouncePolicy.stubbedAvailabilityHandler = taskWorkItems[0]
        mockConnectionServiceFailurePolicy.stubbedAvailabilityHandler = taskWorkItems[1]
        mockCourierConnectStatusPolicy.stubbedAvailabilityHandler = taskWorkItems[2]
        sut.clearAvailabilityTask()
        XCTAssertTrue(mockMQTTFailureDebouncePolicy.availabilityHandler.task?.isCancelled ?? false)
        XCTAssertTrue(mockConnectionServiceFailurePolicy.availabilityHandler.task?.isCancelled ?? false)
        XCTAssertTrue(mockCourierConnectStatusPolicy.availabilityHandler.task?.isCancelled ?? false)
    }

    func testCourierConnected() {
        testPublishAvailabilityEvent(matching: .courierConnected) {
            sut.courierConnected()
        }
    }

    func testCourierDisconnected() {
        testPublishAvailabilityEvent(matching: .courierDisconnected) {
            sut.courierDisconnected()
        }
    }

    func testCourierAvailable() {
        testPublishAvailabilityEvent(matching: .courierAvailable) {
            sut.courierAvailable()
        }
    }

    func testCourierUnavailable() {
        testPublishAvailabilityEvent(matching: .courierUnavailable) {
            sut.courierUnavailable()
        }
    }

    func testConnectionServiceAvailable() {
        testPublishAvailabilityEvent(matching: .connectionServiceAvailable) {
            sut.connectionServiceAvailable()
        }
    }

    func testConnectionServiceUnavailable() {
        testPublishAvailabilityEvent(matching: .connectionServiceUnavailable) {
            sut.connectionServiceUnavailable()
        }
    }

    func testCourierIdle() {
        testPublishAvailabilityEvent(matching: .courierIdle) {
            sut.courierIdle()
        }
    }

    func testCourierNotIdle() {
        testPublishAvailabilityEvent(matching: .courierNotIdle) {
            sut.courierNotIdle()
        }
    }
}

extension CourierAvailabilityObservableTests {
    func testPublishAvailabilityEvent(matching availability: AvailabilityEvent, invocation: () -> Void) {
        let exp = expectation(description: "availability")
        sut.currentValueSubject
            .sink { event in
                guard let event = event else { return }
                XCTAssertEqual(event, availability)
                exp.fulfill()
            }.store(in: &cancellables)
        invocation()
        waitForExpectations(timeout: 0.1, handler: nil)
    }

    var stubbedPolicyConfig: CourierAvailabilityPolicyConfig {
        CourierAvailabilityPolicyConfig(policyEnabled: true, fallbackDelaySeconds: 0, isShadowMode: true)
    }
}
