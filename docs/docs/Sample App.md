To understand the connection flow and behaviors of the library, you can play around, debug, and run the sample SwiftUI App that connects to [HiveMQ](https://broker.mqttdashboard.com) public broker. 

## Steps
- Clone the project from [GitHub](https://github.com/gojek/courier-iOS)
- Run `pod install`
- Open `Courier.xcworkspace`
- Select `Chat-Example` from the scheme.


## HiveMQAuthService

The app provides `HiveMQAuthService` that conforms to `IConnectionServiceProvider` to provide connection options to public HiveMQ Broker

```swift
final class HiveMQAuthService: IConnectionServiceProvider {

  var extraIdProvider: (() -> String?)?

  var clientId: String {
      let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
      return "\(deviceId)|\(username)"
  }

  private let username = "123456"

  func getConnectOptions(completion: @escaping (Result<ConnectOptions, AuthError>) -> Void) {
      let connectOptions = ConnectOptions(
          host: "broker.mqttdashboard.com",
          port: 1883,
          keepAlive: 60,
          clientId: clientId,
          username: username,
          password: "",
          isCleanSession: false,
          userProperties: ["service": "hivemq", "type": "public"]
      )

      completion(.success(connectOptions))
  }
}
```

## Client Setup in CourierObservableObject

You can peek at how the client is created and configured inside `CourierObservableObject` class `connect` method.

```swift
  
func connect() {
    let clientFactory = CourierClientFactory()
    let courierClient = clientFactory.makeMQTTClient(
        config: MQTTClientConfig(
            authService: HiveMQAuthService(),
            messageAdapters: [
                JSONMessageAdapter(),
                TextMessageAdapter()
            ],
            autoReconnectInterval: 1,
            maxAutoReconnectInterval: 30,
            connectTimeoutPolicy: ConnectTimeoutPolicy(isEnabled: true),
            idleActivityTimeoutPolicy: IdleActivityTimeoutPolicy(isEnabled: true),
            messagePersistenceTTLSeconds: 86400,
            messageCleanupInterval: 10
        )
    )

    courierClient.connect()
    courierClient.subscribe((topic, qos))
    courierClient.messagePublisher(topic: topic)
        .sink { [weak self] (message: String) in
            guard let self = self else { return }
            self.messages.insert(Message(id: UUID().uuidString, name: "Text Adapter: \(message)", timestamp: Date()), at: 0)
        }.store(in: &cancellables)
```
