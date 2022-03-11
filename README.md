## About Courier

Courier is a library for creating long running connections. 

Long running connection is a persistent connection established between client & server for bi-directional communication. A long running connection is maintained for as long as possible with the help of keepalive packets for instant updates. This also saves battery and data on mobile devices.

### Running
* Install cocoapods on your machine and run `pod install` in project directory.

### Protobuf Message Adapter
* Courier provides optional default Protobuf Message Adapter that you can include by adding this to your Podfile. It uses SwiftProtobuf as the dependency.
```
pod 'Courier/Protobuf'
```

### Common Client Helper Library

* Courier provides common helper library containing fallback policies and analytics handling if you plan to integrate Courier Lib into an iOS app.
```
pod 'Courier/CommonClient'
```