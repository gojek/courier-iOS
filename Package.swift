// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Courier",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "CourierCore",
            targets: ["CourierCore"]),
        .library(
            name: "CourierMQTT",
            targets: ["CourierMQTT"]),
        .library(
            name: "MQTTClientGJ",
            targets: ["MQTTClientGJ"])
    ],
    dependencies: [
        .package(url: "https://github.com/ashleymills/Reachability.swift", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "CourierCore",
            dependencies: [],
            path: "CourierCore"),
        .target(
            name: "CourierMQTT",
            dependencies: [
                "CourierCore",
                "MQTTClientGJ",
                "Reachability"
            ],
            path: "CourierMQTT"),
        .target(
            name: "MQTTClientGJ",
            dependencies: [],
            path: "Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ",
            publicHeadersPath: "")
    ]
)