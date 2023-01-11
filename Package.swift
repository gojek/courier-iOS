// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Courier",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "MQTTClientGJ",
            targets: ["MQTTClientGJ"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MQTTClientGJ",
            dependencies: [],
            path: "Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ",
            publicHeadersPath: "")
    ]
)