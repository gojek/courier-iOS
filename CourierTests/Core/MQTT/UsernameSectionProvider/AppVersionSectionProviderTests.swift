@testable import CourierCore
@testable import CourierMQTT
import XCTest

class AppVersionSectionProviderTests: XCTestCase {

    var sut: AppVersionSectionProvider!
    var mockAppVersionProvider: MockAppVersionProvider!

    override func setUp() {
        mockAppVersionProvider = MockAppVersionProvider()
        sut = AppVersionSectionProvider(appVersionProvider: mockAppVersionProvider)
    }

    func testProvideSection() {
        mockAppVersionProvider.stubbedAppVersion = "macOS X 10.0"
        XCTAssertEqual(sut.provideSection(), "macOS X 10.0")
    }
}
