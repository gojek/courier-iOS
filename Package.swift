// swift-tools-version:6.2
import PackageDescription

let package = Package(
    name: "Courier",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "CourierCore",
            targets: ["CourierCore"]),
        .library(
            name: "CourierMQTT",
            targets: ["CourierMQTT"]),
        .library(
            name: "CourierProtobuf",
            targets: ["CourierProtobuf"]),
        .library(
            name: "CourierMQTTChuck",
            targets: ["CourierMQTTChuck"])
    ],
    dependencies: [
        .package(url: "https://github.com/ashleymills/Reachability.swift", from: "5.0.0"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.30.0")
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
                .product(name: "Reachability", package: "Reachability.swift")
            ],
            path: "CourierMQTT"),
        .binaryTarget(
            name: "MQTTClientGJ",
            path: "MQTTClientGJ.xcframework"
        ),
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
