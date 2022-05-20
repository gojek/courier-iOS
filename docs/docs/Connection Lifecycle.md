To connect to the broker, you simply need to invoke `connect` method

```swift
courierClient.connect()
```

To disconnect, you just need to invoke `disconnect` method

```swift
courierClient.disconnect()
```

To get the ConnectionState, you can access the CourierSession/connectionState property

```swift
courierClient.connectionState
```

You can also subscribe the `ConnectionState` publisher using the `CourierSession/connectionStatePublisher` property. The observable API that Courier provide is very similar to `Apple Combine` although it is implemented internally using `RxSwift` so we can support `iOS 11`.

```swift
courierClient.connectionStatePublisher
    .sink { [weak self] self?.handleConnectionStateEvent($0) }
    .store(in: &cancellables)
```

As MQTT supports QoS 1 and QoS 2 message to ensure deliverability when there is no internet connection and user reconnected back to broker, we also persists those message in local cache. To disconnect and remove all of this cache, you can invoke.

```swift
courierClient.destroy()
```

There are several things that you need to keep in mind when using Courier:
- Courier will always disconnect when the app goes to background as iOS doesn't support long run socket connection in background.
- Courier will always automatically reconnect when the app goes to foreground if there is a topic to subscribe.
- Courier handles reconnection in case of bad/lost internet connection using Reachability framework.
- Courier will persist QoS > 0 messages in case there are no active subscription to Observable/Publisher using configurable TTL.
