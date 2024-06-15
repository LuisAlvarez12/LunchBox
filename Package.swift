// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LunchBox",
    platforms: [
        .macOS("14"),
        .watchOS("6.2"),
        .iOS("17"),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LunchBox",
            targets: ["LunchBox"]
        ),
    ],
    dependencies: [
        .package(name: "RevenueCat", url: "https://github.com/RevenueCat/purchases-ios.git", from: "4.31.4"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LunchBox",
            dependencies: [
                .product(name: "RevenueCat", package: "RevenueCat"),
                .product(name: "RevenueCatUI", package: "RevenueCat"),
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        .testTarget(
            name: "LunchBoxTests",
            dependencies: ["LunchBox"]
        ),
    ]
)
