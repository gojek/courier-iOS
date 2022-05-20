## Listening to Courier System Events

Courier provides ability to register and listen to internal events emitted by the Client. All you need to do is conforming to `ICourierEventHandler` protocol and implement `ICourierEventHandler/onEvent(_:)` method.

```swift
class MyEventHandler: ICourierEventHandler {

  func onEvent(_ event: CourierEvent) {
      // Implement your own event handling logic (e.g logging to analytics, etc)
  }
}
```

Finally, make sure to have strong reference to the instance, and invoke the `addEventHandler(_:)` from the `CourierClient` passing the instance.

```swift
self.myEventHandler = MyEventHandler()
courierClient.addEventHandler(self.myEventHandler)
```

## List of CourierEvent Enumerations

Here is the list containing all the cases for `CourierEvent` enum:

```swift
public enum CourierEvent {

    case connectionServiceAuthStart(source: String? = nil)
    case connectionServiceAuthSuccess(host: String, port: Int, isCache: Bool)
    case connectionServiceAuthFailure(error: Error?)
    case connectedPacketSent
    case courierDisconnect(clearState: Bool)

    case connectionAttempt
    case connectionSuccess
    case connectionFailure(error: Error?)
    case connectionLost(error: Error?, diffLastInbound: Int?, diffLastOutbound: Int?)
    case connectionDisconnect
    case reconnect
    case connectDiscarded(reason: String)

    case subscribeAttempt(topic: String)
    case unsubscribeAttempt(topic: String)
    case subscribeSuccess(topic: String)
    case unsubscribeSuccess(topic: String)
    case subscribeFailure(topic: String, error: Error?)
    case unsubscribeFailure(topic: String, error: Error?)

    case ping(url: String)
    case pongReceived(timeTaken: Int)
    case pingFailure(timeTaken: Int, error: Error?)

    case messageReceive(topic: String, sizeBytes: Int)
    case messageReceiveFailure(topic: String, error: Error?, sizeBytes: Int)

    case messageSend(topic: String, qos: QoS, sizeBytes: Int)
    case messageSendSuccess(topic: String, qos: QoS, sizeBytes: Int)
    case messageSendFailure(topic: String, qos: QoS, error: Error?, sizeBytes: Int)

    case appForeground
    case appBackground
    case connectionAvailable
    case connectionUnavailable
}
```