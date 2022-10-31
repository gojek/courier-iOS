@testable import CourierCore
@testable import CourierMQTT
import XCTest

class MessageAdaptersCoordinatorsTests: XCTestCase {

    var sut: MessageAdaptersCoordinator!

    struct Person: Codable {
        let name: String
    }

    func testDecodePlistAndJSONMessage() {
        setupJSONAndPlistMessageAdapters()

        let henryAsJSONData = try! JSONEncoder().encode(Person(name: "HENRY"))
        let dennisAsPlistData = try! PropertyListEncoder().encode(Person(name: "DENNIS"))

        let dennis: Person? = sut.decodeMessage(dennisAsPlistData, topic: "x")
        XCTAssertEqual(dennis?.name, "DENNIS")

        let henry: Person? = sut.decodeMessage(henryAsJSONData, topic: "x")
        XCTAssertEqual(henry?.name, "HENRY")
    }

    func testEncodeShouldUseTheFirstAdapterToEncode() {
        setupJSONAndPlistMessageAdapters()

        let henry = Person(name: "Henry")
        let data = try! sut.encodeMessage(henry, topic: "x")

        XCTAssertNoThrow(try JSONSerialization.jsonObject(with: data, options: .mutableContainers))
    }

}

extension MessageAdaptersCoordinatorsTests {

    func setupJSONAndPlistMessageAdapters() {
        sut = MessageAdaptersCoordinator(messageAdapters: [
            JSONMessageAdapter(),
            PlistMessageAdapter()
        ])
    }

}
