// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WorkoutManager",
    platforms: [
        .iOS(.v16),
        .watchOS(.v10),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WorkoutManager",
            targets: ["WorkoutManager"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WorkoutManager"),
        .testTarget(
            name: "WorkoutManagerTests",
            dependencies: ["WorkoutManager"]
        ),
    ]
)
