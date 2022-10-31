import XCTest
@testable import CourierCore
@testable import CourierMQTT
class TextMessageAdapterTests: XCTestCase {

    var sut: TextMessageAdapter!

    override func setUp() {
        sut = TextMessageAdapter()
    }

    func testFromMessage() {
        let name = "hiro"
        let result: String = try! sut.fromMessage(name.data(using: .utf8)!, topic: "x")
        XCTAssertEqual(result, "hiro")
    }

    func testToMessage() {
        let name = "hiro"
        let convertedData = try! sut.toMessage(data: name, topic: "x")
        XCTAssertEqual("hiro", String(data: convertedData, encoding: .utf8))
    }
    
    func testContentType() {
        XCTAssertEqual(sut.contentType, "text/plain")
    }
    
}
