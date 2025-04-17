// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-mistral",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
        .tvOS(.v16),
    ],
    products: [
        .library(name: "Mistral", targets: ["Mistral"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", branch: "main"),
        .package(url: "https://github.com/loopwork-ai/JSONSchema", branch: "main"),
    ],
    targets: [
        .target(name: "Mistral", dependencies: [
            .product(name: "JSONSchema", package: "JSONSchema"),
        ]),
        .executableTarget(name: "CLI", dependencies: [
            "Mistral",
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
        ]),
    ]
)
