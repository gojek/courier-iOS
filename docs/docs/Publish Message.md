To publish message to the broker, first make sure you have provided a `MessageAdapter` that is able to encode your object to the binary data format. For example, if you have a data struct that you want to send as JSON. Make sure, it conforms to `Encodable` protocol and pass `JSONMessageAdapter` in `MQTTClientConfig` when creating the `CourierClient` instance.

You simply need to invoke `CourierSession/publishMessage(_:topic:qos:)` passing the topic string and QoS enum. This is a `throwing` function which can throw in case it fails to encode to data.

```swift
let message = Message(
    id: UUID().uuidString,
    name: message,
    timestamp: Date()
)
        
try? courierService?.publishMessage(
    message,
    topic: "chat/1234",
    qos: QoS.zero
)
```