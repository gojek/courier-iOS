
Courier supports minimum deployment target of `iOS 11`. Cocoapods is used for dependency management. It is separated into these modules:
- `CourierCore`: Contains public APIs such as protocols and data types for Courier. Other modules have basic dependency on this module. You can use this module if you want to implement the interface in your project without adding Courier implementation in your project.
- `CourierMQTT`: Contains implementation of `CourierClient` and `CourierSession` using `MQTT`. This module has dependency to `MQTTClientGJ`(A forked version of open source library [MQTT-Client-Framework](https://github.com/novastone-media/MQTT-Client-Framework) with several adjustment and fixes.
- `CourierProtobuf`: Contains implementation of `ProtobufMessageAdapter` using `Protofobuf`. It has dependency to `SwiftProtobuf` library, this is `optional` and can be used if you are using protobuf for data serialization.

```ruby
// Podfile
target 'Example-App' do
  use_frameworks!
  pod 'CourierCore'
  pod 'CourierMQTT'
  pod 'CourierProtobuf' # Optional, if you want to use Protobuf Message Adapter
end
```