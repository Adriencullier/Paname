// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Paname_Core",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Paname_Core",
            targets: ["Paname_Core"]),
    ],
    dependencies: [
        .package(path: "../CacheManager"),
        .package(path: "../HTTPAgent")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Paname_Core",
            dependencies: ["CacheManager", "HTTPAgent"]
        ),
        .testTarget(
            name: "Paname_CoreTests",
            dependencies: ["Paname_Core"]),
    ]
)
