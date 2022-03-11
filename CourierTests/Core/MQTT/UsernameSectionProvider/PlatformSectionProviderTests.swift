@testable import CourierCore
@testable import CourierMQTT
import XCTest

class PlatformSectionProviderTests: XCTestCase {

    var sut: PlatformSectionProvider!

    override func setUp() {
        sut = PlatformSectionProvider()
    }

    func testProvideSection() {
        XCTAssertEqual(sut.provideSection(), "IOS")
    }
}
