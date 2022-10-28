import Foundation

public protocol MessageAdapter {
    
    var contentType: String { get }

    func fromMessage<T>(_ message: Data) throws -> T

    func toMessage<T>(data: T) throws -> Data
}
