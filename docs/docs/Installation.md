Courier supports both Cocoapods and SPM for dependency manager. It is separated into 5 modules:
- `CourierCore`: Contains public APIs such as protocols and data types for Courier. Other modules have basic dependency on this module. You can use this module if you want to implement the interface in your project without adding Courier implementation in your project.
- `CourierMQTT`: Contains implementation of `CourierClient` and `CourierSession` using `MQTT`. This module has dependency to `MQTTClientGJ`.
- `MQTTClientGJ`: A forked version of open source library [MQTT-Client-Framework](https://github.com/novastone-media/MQTT-Client-Framework). It add several features such as connect and inactivity timeout. It also fixes race condition crashes in `MQTTSocketEncoder` and `Connack` status 5 not completing the decode before `MQTTTransportDidClose` got invoked bugs.
- `CourierProtobuf`: Contains implementation of `ProtobufMessageAdapter` using `Protofobuf`. It has dependency to `SwiftProtobuf` library, this is `optional` and can be used if you are using protobuf for data serialization.
- `CourierMQTTChuck`: Can be ussed to inspects all the outgoing or incoming packets for an underlying MQTT connection. It intercepts all the packets, persisting them and providing a UI for accessing all the MQTT packets sent or received. It also provides multiple other features like search, share, and clear data. Uses `SwiftUI` under the hood.

### Cocoapods
```ruby
// Podfile
target 'Example-App' do
  use_frameworks!
  pod 'CourierCore'
  pod 'CourierMQTT'
  pod 'CourierProtobuf' #optional
  pod 'CourierMQTTChuck' #optional
end
```

### Swift Package Manager (SPM)
Simply add the package dependency to your Package.swift and depend on `CourierCore` and `CourierMQTT` in the necessary targets:

```swift
dependencies: [
    .package(url: "https://github.com/gojek/courier-iOS", branch: "main")
]
```
