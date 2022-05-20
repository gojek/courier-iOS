### Configure and Create MQTT CourierClient Instance with CourierClientFactory

Next, we need to create instance of CourierClient that uses MQTT as its implementation. Initialize `CourierClientFactory` instance and invoke `CourierClientFactory/makeMQTTClient(config:)`. We need to pass instance MQTTClientConfig with several parameters that we can customize. 

```swift
let clientFactory = CourierClientFactory()
let courierClient = clientFactory.makeMQTTClient(
    config: MQTTClientConfig(
        authService: HiveMQAuthService(),
        messageAdapters: [
            JSONMessageAdapter(),
            ProtobufMessageAdapter()
        ],
        autoReconnectInterval: 1,
        maxAutoReconnectInterval: 30
    )
)
```

- `MQTTClientConfig/messageAdapters`: we need to pass array of `MessageAdapter`. This will be used for serialization when receiving from broker and sending message to the broker. `CourierMQTT` provides built in message adapters for JSON `(JSONMessageAdapter)` and Plist `(PlistMessageAdapter)` format that conforms to `Codable` protocol. You can only use one of them because both implements to Codable to avoid any conflict. To use protobuf, please import `CourierProtobuf` and pass `ProtobufMessageAdapter`.
- `MQTTClientConfig/authService`: we need to pass our implementation of IConnectionServiceProvider protocol for providing the ConnectOptions to the client.
- `MQTTClientConfig/autoReconnectInterval` The interval used to make reconnection to broker in case of connection lost. This will be multiplied by 2 for each time until it successfully make the connection. The upper limit is based on `MQTTClientConfig/maxAutoReconnectInterval`.