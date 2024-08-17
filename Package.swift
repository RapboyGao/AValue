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
            targets: ["AValue"]),
        .library(
            name: "AFunction",
            targets: ["AFunction"]),
        .library(
            name: "AFormula",
            targets: ["AFormula"]),
    ],
    dependencies: [
        .package(url: "https://github.com/RapboyGao/AUnit.git", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AValue",
            dependencies: [
                .product(name: "AUnit", package: "AUnit"),
            ]),
        .target(
            name: "AFunction",
            dependencies: [
                "AValue",
                .product(name: "AUnit", package: "AUnit"),
            ]),
        .target(
            name: "AFormula",
            dependencies: [
                "AValue",
                "AFunction",
                .product(name: "AUnit", package: "AUnit"),
            ]),
        .testTarget(
            name: "AValueTests",
            dependencies: ["AValue"]),
    ])
