// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MySwiftPackage",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "CommonExtensions",
            targets: ["CommonExtensions"]),
        .library(
            name: "KAnalyticsManager",
            targets: ["KAnalyticsManager"]),
        .library(
            name: "KImageLoader",
            targets: ["KImageLoader"])
    ],
    targets: [
        .target(
            name: "CommonExtensions"),
        .target(
            name: "KAnalyticsManager"),
        .target(
            name: "KImageLoader"),
    ]
)
