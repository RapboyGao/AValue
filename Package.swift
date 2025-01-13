// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AValue",
    defaultLocalization: "en",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AValue",
            targets: ["AValue"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/RapboyGao/AUnit.git", branch: "main"),
        .package(url: "https://github.com/RapboyGao/AUnitViews.git", branch: "main"),
        .package(url: "https://github.com/RapboyGao/AUnits.git", branch: "main"),
        .package(url: "https://github.com/RapboyGao/AViewUI.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMinor(from: "0.0.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AValue",
            dependencies: [
                .product(name: "AViewUI", package: "AViewUI"),
                .product(name: "AUnit", package: "AUnit"),
                .product(name: "AUnits", package: "AUnits"),
                .product(name: "AUnitViews", package: "AUnitViews"),
                .product(name: "Algorithms", package: "swift-algorithms")
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "AValueTests",
            dependencies: ["AValue"]
        ),
    ]
)
