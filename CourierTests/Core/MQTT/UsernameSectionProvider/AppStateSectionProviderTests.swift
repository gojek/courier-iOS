@testable import CourierCore
@testable import CourierMQTT
import XCTest

class AppStateSectionProviderTests: XCTestCase {

    var sut: AppStateSectionProvider!
    var mockAppStateObserver: MockAppStateObserver!

    override func setUp() {
        mockAppStateObserver = MockAppStateObserver()
        sut = AppStateSectionProvider(appStateObserver: mockAppStateObserver)
    }

    func testProvideSectionForeground() {
        mockAppStateObserver.stubbedState = .active
        XCTAssertEqual(sut.provideSection(), "FG")
    }

    func testProvideSectionBackground() {
        mockAppStateObserver.stubbedState = .background
        XCTAssertEqual(sut.provideSection(), "BG")

        mockAppStateObserver.stubbedState = .inactive
        XCTAssertEqual(sut.provideSection(), "BG")
    }

}
