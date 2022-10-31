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
        XCTAssertEqual(test, try! sut.fromMessage(test, topic: "x"))
    }

    func testToMessage() {
        let test = "test".data(using: .utf8)!
        XCTAssertNoThrow(try sut.toMessage(data: test, topic: "x"))
    }
    
    func testContentType() {
        XCTAssertEqual(sut.contentType, "application/octet-stream")
    }
}
