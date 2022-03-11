import UIKit
import XCTest
@testable import CourierCore
@testable import CourierMQTT
class AppStateObserverTests: XCTestCase {

    var sut: AppStateObserver!
    var mockNotificationCenter: MockNotificationCenter!

    override func setUp() {
        mockNotificationCenter = MockNotificationCenter()
        sut = AppStateObserver(notificationCenter: mockNotificationCenter)
    }

    func testInitShouldAddObserverForMovedToBackground_withoutActiveNotifications() {
        sut = AppStateObserver(useAppDidEnterBGAndWillEnterFGNotification: true, notificationCenter: mockNotificationCenter)
        let isContaining = mockNotificationCenter.invokedAddObserverParametersList.contains { (_: Any, selector: Selector, name: NSNotification.Name?, _) in
            if name == UIApplication.didEnterBackgroundNotification && selector == #selector(AppStateObserver.appMovedToBackground) {
                return true
            }
            return false
        }
        XCTAssertTrue(isContaining)
    }

    func testInitShouldAddObserverForMovedToForeground_WithoutActiveNotifications() {
        sut = AppStateObserver(useAppDidEnterBGAndWillEnterFGNotification: true, notificationCenter: mockNotificationCenter)
        let isContaining = mockNotificationCenter.invokedAddObserverParametersList.contains { (_: Any, selector: Selector, name: NSNotification.Name?, _) in
            if name == UIApplication.willEnterForegroundNotification && selector == #selector(AppStateObserver.appMovedToForeground) {
                return true
            }
            return false
        }
        XCTAssertTrue(isContaining)
    }

    func testDeinitShouldRemoveObserverForDidEnterBackgroundNotification_withoutActiveNotifications() {
        sut = AppStateObserver(useAppDidEnterBGAndWillEnterFGNotification: true, notificationCenter: mockNotificationCenter)
        sut.removeObservers()
        sut = nil
        let isContaining = mockNotificationCenter.invokedRemoveObserverWithNameParametersList.contains { (_: Any, name: NSNotification.Name?, _) in
            if name == UIApplication.didEnterBackgroundNotification {
                return true
            }
            return false
        }

        XCTAssertTrue(isContaining)
    }

    func testDeinitShouldRemoveObserverForWillEnterForegroundNotification_withoutActiveNotifications() {
        sut = AppStateObserver(useAppDidEnterBGAndWillEnterFGNotification: true, notificationCenter: mockNotificationCenter)
        sut.removeObservers()
        sut = nil
        let isContaining = mockNotificationCenter.invokedRemoveObserverWithNameParametersList.contains { (_: Any, name: NSNotification.Name?, _) in
            if name == UIApplication.willEnterForegroundNotification {
                return true
            }
            return false
        }
        XCTAssertTrue(isContaining)
    }

    func testInitShouldAddObserverForMovedToBackground_withActiveNotifications() {
        sut = AppStateObserver(useAppDidEnterBGAndWillEnterFGNotification: false, notificationCenter: mockNotificationCenter)
        let isContaining = mockNotificationCenter.invokedAddObserverParametersList.contains { (_: Any, selector: Selector, name: NSNotification.Name?, _) in
            if name == UIApplication.willResignActiveNotification && selector == #selector(AppStateObserver.appMovedToBackground) {
                return true
            }
            return false
        }
        XCTAssertTrue(isContaining)
    }

    func testInitShouldAddObserverForMovedToForeground_WithActiveNotifications() {
        sut = AppStateObserver(useAppDidEnterBGAndWillEnterFGNotification: false, notificationCenter: mockNotificationCenter)
        let isContaining = mockNotificationCenter.invokedAddObserverParametersList.contains { (_: Any, selector: Selector, name: NSNotification.Name?, _) in
            if name == UIApplication.didBecomeActiveNotification && selector == #selector(AppStateObserver.appMovedToForeground) {
                return true
            }
            return false
        }
        XCTAssertTrue(isContaining)
    }

    func testDeinitShouldRemoveObserverForDidEnterBackgroundNotification_withActiveNotifications() {
        sut = AppStateObserver(useAppDidEnterBGAndWillEnterFGNotification: false, notificationCenter: mockNotificationCenter)
        sut.removeObservers()
        sut = nil
        let isContaining = mockNotificationCenter.invokedRemoveObserverWithNameParametersList.contains { (_: Any, name: NSNotification.Name?, _) in
            if name == UIApplication.willResignActiveNotification {
                return true
            }
            return false
        }

        XCTAssertTrue(isContaining)
    }

    func testDeinitShouldRemoveObserverForWillEnterForegroundNotification_withActiveNotifications() {
        sut = AppStateObserver(useAppDidEnterBGAndWillEnterFGNotification: false, notificationCenter: mockNotificationCenter)
        sut.removeObservers()
        sut = nil
        let isContaining = mockNotificationCenter.invokedRemoveObserverWithNameParametersList.contains { (_: Any, name: NSNotification.Name?, _) in
            if name == UIApplication.didBecomeActiveNotification {
                return true
            }
            return false
        }
        XCTAssertTrue(isContaining)
    }

    func testAppMovedToBackgrounShouldSetStateToBackground() {
        sut.appMovedToBackground()
        XCTAssertEqual(sut.state, .background)
    }

    func testAppMovedToForegroundShouldSetStateToForeground() {
        sut.appMovedToForeground()
        XCTAssertEqual(sut.state, .active)
    }
}
