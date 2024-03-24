// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Paname_BaseUI",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Paname_BaseUI",
            targets: ["Paname_BaseUI"]),
    ],
    dependencies: [
        .package(path: "../CacheManager")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Paname_BaseUI",
            dependencies: ["CacheManager"]
        ),
        .testTarget(
            name: "Paname_BaseUITests",
            dependencies: ["Paname_BaseUI"]),
    ]
)
