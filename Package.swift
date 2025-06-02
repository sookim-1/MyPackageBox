// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyPackageBox",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MyPackageBox",
            targets: ["CommonExtensions"]),
        .library(
            name: "CommonExtensions",
            targets: ["CommonExtensions"]),
        .library(
            name: "AnalyticsTool",
            targets: ["AnalyticsTool"])
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MyPackageBox"),
        .target(
            name: "CommonExtensions"),
        .target(
            name: "AnalyticsTool"),
    ]
)
