import Foundation
@preconcurrency import SwiftProtobuf

private struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
    struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
    typealias Version = _2
}


struct Empty {

    var unknownFields = SwiftProtobuf.UnknownStorage()

    init() {}
}

struct Note {

    var id: String = String()

    var title: String = String()

    var content: String = String()

    var unknownFields = SwiftProtobuf.UnknownStorage()

    init() {}
}

struct NoteList {

    var notes: [Note] = []

    var unknownFields = SwiftProtobuf.UnknownStorage()

    init() {}
}

struct NoteRequestId {

    var id: String = String()

    var unknownFields = SwiftProtobuf.UnknownStorage()

    init() {}
}

extension Empty: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
    static let protoMessageName: String = "Empty"
    static let _protobuf_nameMap = SwiftProtobuf._NameMap()

    mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
        while let _ = try decoder.nextFieldNumber() {
        }
    }

    func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
        try unknownFields.traverse(visitor: &visitor)
    }

    static func ==(lhs: Empty, rhs: Empty) -> Bool {
        if lhs.unknownFields != rhs.unknownFields {return false}
        return true
    }
}

extension Note: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
    static let protoMessageName: String = "Note"
    static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
        1: .same(proto: "id"),
        2: .same(proto: "title"),
        3: .same(proto: "content")
    ]

    mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
        while let fieldNumber = try decoder.nextFieldNumber() {

            switch fieldNumber {
            case 1: try { try decoder.decodeSingularStringField(value: &self.id) }()
            case 2: try { try decoder.decodeSingularStringField(value: &self.title) }()
            case 3: try { try decoder.decodeSingularStringField(value: &self.content) }()
            default: break
            }
        }
    }

    func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
        if !self.id.isEmpty {
            try visitor.visitSingularStringField(value: self.id, fieldNumber: 1)
        }
        if !self.title.isEmpty {
            try visitor.visitSingularStringField(value: self.title, fieldNumber: 2)
        }
        if !self.content.isEmpty {
            try visitor.visitSingularStringField(value: self.content, fieldNumber: 3)
        }
        try unknownFields.traverse(visitor: &visitor)
    }

    static func ==(lhs: Note, rhs: Note) -> Bool {
        if lhs.id != rhs.id {return false}
        if lhs.title != rhs.title {return false}
        if lhs.content != rhs.content {return false}
        if lhs.unknownFields != rhs.unknownFields {return false}
        return true
    }
}

extension NoteList: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
    static let protoMessageName: String = "NoteList"
    static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
        1: .same(proto: "notes")
    ]

    mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
        while let fieldNumber = try decoder.nextFieldNumber() {

            switch fieldNumber {
            case 1: try { try decoder.decodeRepeatedMessageField(value: &self.notes) }()
            default: break
            }
        }
    }

    func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
        if !self.notes.isEmpty {
            try visitor.visitRepeatedMessageField(value: self.notes, fieldNumber: 1)
        }
        try unknownFields.traverse(visitor: &visitor)
    }

    static func ==(lhs: NoteList, rhs: NoteList) -> Bool {
        if lhs.notes != rhs.notes {return false}
        if lhs.unknownFields != rhs.unknownFields {return false}
        return true
    }
}

extension NoteRequestId: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
    static let protoMessageName: String = "NoteRequestId"
    static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
        1: .same(proto: "id")
    ]

    mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
        while let fieldNumber = try decoder.nextFieldNumber() {

            switch fieldNumber {
            case 1: try { try decoder.decodeSingularStringField(value: &self.id) }()
            default: break
            }
        }
    }

    func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
        if !self.id.isEmpty {
            try visitor.visitSingularStringField(value: self.id, fieldNumber: 1)
        }
        try unknownFields.traverse(visitor: &visitor)
    }

    static func ==(lhs: NoteRequestId, rhs: NoteRequestId) -> Bool {
        if lhs.id != rhs.id {return false}
        if lhs.unknownFields != rhs.unknownFields {return false}
        return true
    }
}
