import XCTest
@testable import CourierCore
@testable import CourierMQTT
class DataMessageAdapterTests: XCTestCase {

    var sut: DataMessageAdapter!

    override func setUp() {
        sut = DataMessageAdapter()
    }

    func testFromMessage() {
        let test = "test".data(using: .utf8)!
        XCTAssertEqual(test, try! sut.fromMessage(test))
    }

    func testToMessage() {
        let test = "test".data(using: .utf8)!
        XCTAssertNoThrow(try sut.toMessage(data: test))
    }
}
