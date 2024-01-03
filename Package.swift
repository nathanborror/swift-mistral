// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MistralKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17)
    ],
    products: [
        .library(name: "MistralKit", targets: ["MistralKit"]),
    ],
    targets: [
        .target(name: "MistralKit"),
        .testTarget(name: "MistralKitTests", dependencies: ["MistralKit"]),
    ]
)
