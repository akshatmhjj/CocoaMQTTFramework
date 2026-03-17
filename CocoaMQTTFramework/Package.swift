// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CocoaMQTTFramework",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .library(
            name: "CocoaMQTTFramework",
            targets: ["CocoaMQTTFramework"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/emqx/CocoaMQTT.git", from: "2.1.0"),
    ],
    targets: [
        .target(
            name: "CocoaMQTTFramework",
            dependencies: [
                .product(name: "CocoaMQTT", package: "CocoaMQTT"),
            ]
        ),
        .testTarget(
            name: "CocoaMQTTFrameworkTests",
            dependencies: ["CocoaMQTTFramework"]
        ),
    ]
)
