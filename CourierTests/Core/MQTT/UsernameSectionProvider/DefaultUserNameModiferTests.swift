@testable import CourierCore
@testable import CourierMQTT
import XCTest

class DefaultUserNameModifierTests: XCTestCase {

    var sut: DefaultUserNameModifier!

    override func setUp() {
        sut = DefaultUserNameModifier()
    }

    func testProvideUserName() {
        let username = "janedoe"
        XCTAssertEqual(username, sut.provideUserName(username: username))
    }

}
