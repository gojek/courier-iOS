@testable import CourierCore
@testable import CourierMQTT
import XCTest

class CountrySectionProviderTests: XCTestCase {

    var sut: CountrySectionProvider!

    override func setUp() {
        sut = CountrySectionProvider(countryCodeProvider: {
            "ID"
        })
    }

    func testProvideSection() {
        XCTAssertEqual(sut.provideSection(), "ID")
    }
}
