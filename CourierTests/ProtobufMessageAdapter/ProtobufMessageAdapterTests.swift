@testable import CourierCore
@testable import CourierMQTT
@testable import CourierProtobuf
import XCTest

class ProtobufMessageAdapterTests: XCTestCase {

    var sut: ProtobufMessageAdapter!

    override func setUp() {
        sut = ProtobufMessageAdapter()
    }

    func testDecodeDataFromProto() {
        let note = stubbedNote(title: "x", content: "y")
        let data = try! note.serializedData()

        let decodedNote: Note = try! sut.fromMessage(data)
        XCTAssertEqual(decodedNote.title, note.title)
        XCTAssertEqual(decodedNote.content, note.content)
    }

    func testProtoDataSerialization() {
        let note = stubbedNote(title: "x", content: "y")
        let encodedData = try! sut.toMessage(data: note)

        let decodedNote: Note = try! sut.fromMessage(encodedData)
        XCTAssertEqual(decodedNote.title, note.title)
        XCTAssertEqual(decodedNote.content, note.content)
    }

}

extension ProtobufMessageAdapterTests {

    func stubbedNote(title: String = "title", content: String = "content") -> Note {
        var note = Note()
        note.title = title
        note.content = content
        return note
    }

}
