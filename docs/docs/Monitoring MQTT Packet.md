`CourierMQTTChuck` is used to inspects all the outgoing or incoming packets for an underlying MQTT connection.

It intercepts all the packets, persisting them and providing a UI for accessing all the MQTT packets sent or received. It also provides multiple other features like search, share, and clear data.

It uses SwiftUI under the hood with minimum iOS deployment version of 15, you can still build this on iOS 11 to access the logger without the view.

![Simulator Screen Shot - iPhone 14 Pro - 2023-04-10 at 17 26 54](https://user-images.githubusercontent.com/6789991/230884730-6734de28-ead7-44a4-a467-9c008de22392.png)

![Simulator Screen Shot - iPhone 14 Pro - 2023-04-10 at 17 27 31](https://user-images.githubusercontent.com/6789991/230884765-7e822e54-1c2e-44aa-9169-6572c5c612c6.png)

### Usage

Add Dependency to `CourierMQTTChuck` and simply declare the logger like so:

```swift
import CourierMQTTChuck

let logger = MQTTChuckLogger()
```

Then Declare the `MQTTChuckView` passing the `logger` in SwiftUI View.

```swift
.sheet(isPresented: $showChuckView, content: {
            NavigationView {
                MQTTChuckView(logger: logger)
            }
        })
```
