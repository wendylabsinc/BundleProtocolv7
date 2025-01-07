// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BundleProtocolv7",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BundleProtocolv7",
            targets: ["BundleProtocolv7"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BundleProtocolv7"
        ),
        .testTarget(
            name: "BundleProtocolv7Tests",
            dependencies: ["BundleProtocolv7"]
        ),
    ]
)
