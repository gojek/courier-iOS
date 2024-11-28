// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Courier",
    platforms: [
        .iOS("14.0")
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
            targets: ["MQTTClientGJ"]),
        .library(
            name: "CourierProtobuf",
            targets: ["CourierProtobuf"]),
        .library(
            name: "CourierMQTTChuck",
            targets: ["CourierMQTTChuck"])
    ],
    dependencies: [
        .package(url: "https://github.com/ashleymills/Reachability.swift", from: "5.0.0"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.6.0")
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
            publicHeadersPath: ""),
        .target(
            name: "CourierProtobuf",
            dependencies: [
                "CourierCore",
                "CourierMQTT",
                .product(name: "SwiftProtobuf", package: "swift-protobuf")
            ],
            path: "CourierProtobuf"),
        .target(
            name: "CourierMQTTChuck",
            dependencies: [
                "CourierCore",
                "CourierMQTT",
                "MQTTClientGJ"
            ],
            path: "CourierMQTTChuck")
    ]
)