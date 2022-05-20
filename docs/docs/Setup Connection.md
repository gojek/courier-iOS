### Providing Connect Options

To connect to MQTT broker you need to provide `ConnectOptions` by implementing IConnectionServiceProvider. First you need to implement `IConnectionServiceProvider/clientId` to return an unique string to identify your client. This must be unique for each device that connect to broker.

```swift
var clientId: String {
    UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
}
```

Next, you need to implement `IConnectionServiceProvider/getConnectOptions(completion:)` method. You need to provide `ConnectOptions` instance that will be used to make connection to the broker. This method provides an escaping closure, in case you need to retrieve the credential from remote API asynchronously. 

```swift
func getConnectOptions(completion: @escaping (Result<ConnectOptions, AuthError>) -> Void) {
    // Provide your own logic to retrieve connect options
    // The completion is @escaping in case you want to retrieve the connect options from internet
}
```

## ConnectOptions Properties

Here are the data that you need to provide in ConnectOptions.

```swift
/// IP Host address of the broker
public let host: String
/// Port of the broker
public let port: UInt16
/// Keep Alive interval used to ping the broker over time to maintain the long run connection
public let keepAlive: UInt16
/// Unique Client ID used by broker to identify connected clients
public let clientId: String
/// Username of the client
public let username: String
/// Password of the client used for authentication by the broker
public let password: String
/// Tells broker whether to clear the previous session by the clients
public let isCleanSession: Bool
```

## Example of IConnectionServiceProvider Implementation

You can take a look at this example that provides hardcoded ConnectOptions in `getConnectOptions(completion:` method`.

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