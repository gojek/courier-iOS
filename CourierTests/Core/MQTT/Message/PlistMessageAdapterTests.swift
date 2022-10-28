import XCTest
@testable import CourierCore
@testable import CourierMQTT
class PlistMessageAdapterTests: XCTestCase {

    var sut: PlistMessageAdapter!

    struct Person: Codable {
        var name: String
    }

    override func setUp() {
        sut = PlistMessageAdapter()
    }

    func testFromMessage() {
        let person = Person(name: "henry")
        let data = try! sut.toMessage(data: person)
        let result: Person = try! sut.fromMessage(data)
        XCTAssertEqual(result.name, person.name)
    }

    func testToMessage() {
        let person = Person(name: "henry")
        XCTAssertNoThrow(try sut.toMessage(data: person))
    }
    
    func testContentType() {
        XCTAssertEqual(sut.contentType, "application/xml")
    }
}
