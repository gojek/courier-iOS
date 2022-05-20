After we have connected to broker, we can subscribe to any topic that we want and receive emitted message from that particular topic when the broker pushes the message.

### Subscribe to topics from Broker

To subscribe to a topic from the broker. we can invoke `CourierSession/subscribe(_:)` and pass a tuple containing the topic string and QoS enum.

```swift
courierClient.subscribe(("chat/user1", QoS.zero))
```

You can also subscribe to multiple topics, invoking `CourierSession/subscribe(_:)` and pass an array containing tuples of topic string and QoS enum

```swift
courierClient.subscribe([
    ("chat/user1", QoS.zero),
    ("order/1234", QoS.one),
    ("order/123456", QoS.two),
])
```

### Receive Message from Subscribed Topic

After you have subscribed to the topic, you need to subscribe to a message publisher passing the associated topic using `CourierSession/messagePublisher(topic:)`. This method uses `Generic` for serializing the binary data to a type. Make sure you have provided the associated MessageAdapter that can decode the data to the type. 

```swift
courierClient.messagePublisher(topic: topic)
    .sink { [weak self] (note: Note) in
        self?.messages.insert(Message(id: UUID().uuidString, name: "Protobuf: \(note.title)", timestamp: Date()), at: 0)
    }.store(in: &cancellables)
```

This method returns AnyPublisher which you can chain with operators such as `AnyPublisher/filter(predicate:)` or `AnyPublisher/map(transform:)`.

The observable API that Courier provide is very similar to Apple Combine although it is implemented internally using RxSwift so we can support iOS 12, only the `filter` and `map` operators are supported.

### Unsubscribe from topics

To unsubscribe from a topic. we can invoke `CourierSession/unsubscribe(_:)` and pass a topic string.

```swift
courierClient.unsubscribe("chat/user1")
```

You can also subscribe to multiple topics, invoking `CourierSession/unsubscribe(_:)` and pass an array containing tuples of topic string and QoS enum

```swift
courierClient.unsubscribe([
    "chat/user1",
    "order/"
])
```
