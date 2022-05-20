To serialize and deserialize received and published messages, Courier uses MessageAdapter. With this, you don't need to handle the serialization and deserialization process when publishing and receiving messages from broker 

```swift
// Using type inference, the client will use the provided message adapter to deserialize the byte array data into Message model
courierClient.messagePublisher(topic: topic)
        .sink { (message: Message) in
            // Process decoded message
        }.store(in: &cancellables)
```

Out of the box, Courier already provides `JSONMessageAdapter` which can be used to decode and encode JSON data to Swift model that conforms to `Codable` protocol.


All you need to do is to pass this to `MQTTClientConfig/messageAdapters` parameter, by default it uses `JSONMessageAdapter`. The config accepts multiple type of MessageAdapter as you can see in example below. 

```swift
let courierClient = clientFactory.makeMQTTClient(
    config: MQTTClientConfig(
        //...
        messageAdapters: [
            JSONMessageAdapter(),
            ProtobufMessageAdapter()
        ],
        //...
    )
)
```

If you are using protobuf format, you can also add `CourierProtobuf` dependency to your `Podfile` and pass `ProtobufMessageAdapter`

### Create your own Message Adapter

You can also provide your own Message Adapter by conforming `MessageAdapter` protocol and implement both `fromMessage` and `toMessage` method. You can take a look on how JSONMessageAdapter implementation below.

```swift
/// A protocol used to decode and encode message using JSON format
public struct JSONMessageAdapter: MessageAdapter {

    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder

    public init(jsonDecoder: JSONDecoder = JSONDecoder(),
                jsonEncoder: JSONEncoder = JSONEncoder()) {
        self.jsonDecoder = jsonDecoder
        self.jsonEncoder = jsonEncoder
    }
    
    public func fromMessage<T>(_ message: Data) throws -> T {
        if let decodableType = T.self as? Decodable.Type,
           let value = try decodableType.init(data: message, jsonDecoder: jsonDecoder) as? T {
            return value
        }
        throw CourierError.decodingError.asNSError
    }
    
    public func toMessage<T>(data: T) throws -> Data {
        guard !(data is Data) else {
            throw CourierError.encodingError.asNSError
        }
        
        if let encodable = data as? Encodable {
            return try encodable.encode(jsonEncoder: jsonEncoder)
        }
        throw CourierError.encodingError.asNSError
    }
}


fileprivate extension Decodable {
    
    init(data: Data, jsonDecoder: JSONDecoder) throws {
        self = try jsonDecoder.decode(Self.self, from: data)
    }
}

fileprivate extension Encodable {
    
    func encode(jsonEncoder: JSONEncoder) throws -> Data {
        try jsonEncoder.encode(self)
    }
    
}
```