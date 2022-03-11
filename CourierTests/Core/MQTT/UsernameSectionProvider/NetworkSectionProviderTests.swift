@testable import CourierCore
@testable import CourierMQTT
import XCTest

class NetworkSectionProviderTests: XCTestCase {

    var sut: NetworkSectionProvider!
    var mockNetworkTypeProvider: MockNetworkTypeProvider!

    override func setUp() {
        mockNetworkTypeProvider = MockNetworkTypeProvider()
        sut = NetworkSectionProvider(networkTypeProvider: mockNetworkTypeProvider)
    }

    func testProviderSectionForNoConnection() {
        mockNetworkTypeProvider.stubbedNetworkType = .noConnection
        XCTAssertEqual(sut.provideSection(), "-1")
    }

    func testProvideSectionForWifi() {
        mockNetworkTypeProvider.stubbedNetworkType = .wifi
        XCTAssertEqual(sut.provideSection(), "1")
    }

    func testProvideSectionForCellular4G() {
        mockNetworkTypeProvider.stubbedNetworkType = .wwan4g
        mockNetworkTypeProvider.stubbedNetworkWWANType = .wwan4g
        XCTAssertEqual(sut.provideSection(), "4")
    }

    func testProvideSectionForCellular3G() {
        mockNetworkTypeProvider.stubbedNetworkType = .wwan3g
        mockNetworkTypeProvider.stubbedNetworkWWANType = .wwan3g
        XCTAssertEqual(sut.provideSection(), "3")

    }

    func testProvideSectionForCellular2G() {
        mockNetworkTypeProvider.stubbedNetworkType = .wwan2g
        mockNetworkTypeProvider.stubbedNetworkWWANType = .wwan2g
        XCTAssertEqual(sut.provideSection(), "2")

    }

    func testProvideSectionForCellularUnknown() {
        mockNetworkTypeProvider.stubbedNetworkType = .unknownTechnology(name: "XTE")
        mockNetworkTypeProvider.stubbedNetworkWWANType = .unknown
        XCTAssertEqual(sut.provideSection(), "-1")
    }

}
