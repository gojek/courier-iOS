Apart from building topic strings yourself, a topic can contain **connection placeholders**. These are resolved automatically from the established MQTT connection's `ConnectOptions` when the message is actually published/subscribed/unsubscribed, so you don't have to pass these values yourself.

| Placeholder | Resolved with |
| --- | --- |
| `%u` | The connection's username |
| `%c` | The connection's client id |

```swift
try? courierService?.publishMessage(
    message,
    topic: "user/%u/send",
    qos: QoS.one
)

courierService?.subscribe(("client/%c/receive", QoS.one))
```

For example, if the connection is established with username `alice` and client id `alice-ios`, the topics above resolve to `user/alice/send` and `client/alice-ios/receive` respectively.

### Splitting a placeholder value

A placeholder value can be split by a delimiter and a single part of it can be used in the topic. The syntax is `(<placeholder>,<delimiter>,<index>)` where `<index>` is **0-based**.

```swift
try? courierService?.publishMessage(
    message,
    topic: "user/(%c,:,2)/send",
    qos: QoS.one
)
```

If the client id is `region:tenant:device`, then `(%c,:,2)` splits it by `:` into `[region, tenant, device]` and picks the part at index `2`, resolving the topic to `user/device/send`. An index that is out of range leaves the topic unresolved and logs an error.

Placeholders can be combined freely with plain placeholders in the same topic, e.g. `user/(%c,:,0)/%u`.

**Note** : Topic placeholders are resolved while publishing, subscribing and unsubscribing. They are **not** resolved for message observation — `messagePublisher(topic:)` is registered against the topic string as-is, so use the already-resolved topic when observing messages for a placeholder-based subscription.
