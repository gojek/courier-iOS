@testable import CourierCore
@testable import CourierMQTT
import XCTest

class UsernameModifierTests: XCTestCase {

    var sut: UserNameModifier!
    var mockCountrySectionProvider: MockUserNameSectionProvider!
    var mockNetworkSectionProvider: MockUserNameSectionProvider!
    var mockPlatformSectionProvider: MockUserNameSectionProvider!
    var mockAppVersionSectionProvider: MockUserNameSectionProvider!
    var mockAppStateSectionProvider: MockUserNameSectionProvider!

    override func setUp() {
        mockCountrySectionProvider = MockUserNameSectionProvider()
        mockNetworkSectionProvider = MockUserNameSectionProvider()
        mockPlatformSectionProvider = MockUserNameSectionProvider()
        mockAppVersionSectionProvider = MockUserNameSectionProvider()
        mockAppStateSectionProvider = MockUserNameSectionProvider()

        sut = UserNameModifier(
            countrySectionProvider: mockCountrySectionProvider,
            networkSectionProvider: mockNetworkSectionProvider,
            platformSectionProvider: mockPlatformSectionProvider,
            appVersionSectionProvider: mockAppVersionSectionProvider,
            appStateSectionProvider: mockAppStateSectionProvider
        )
    }

    func testProviderUsername() {
        mockCountrySectionProvider.stubbedProvideSectionResult = "ID"
        mockNetworkSectionProvider.stubbedProvideSectionResult = "5"
        mockPlatformSectionProvider.stubbedProvideSectionResult = "UNIX"
        mockAppVersionSectionProvider.stubbedProvideSectionResult = "999.99"
        mockAppStateSectionProvider.stubbedProvideSectionResult = "FG"
        XCTAssertEqual(sut.provideUserName(username: "g123"), "g123:ID:5:UNIX:999.99:FG")
    }
}
