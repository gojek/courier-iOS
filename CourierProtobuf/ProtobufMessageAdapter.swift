import CourierCore
import CourierMQTT
import SwiftProtobuf

public class ProtobufMessageAdapter: MessageAdapter {

    public init() {}
    public func fromMessage<T>(_ message: Data) throws -> T {
        if let decodableType = T.self as? SwiftProtobuf.Message.Type,
           let value = try decodableType.init(serializedData: message) as? T {
            return value
        }
        throw CourierError.decodingError.asNSError
    }

    public func toMessage<T>(data: T) throws -> Data {
        if let encodable = data as? SwiftProtobuf.Message {
            return try encodable.serializedData()
        }
        throw CourierError.encodingError.asNSError
    }
}
