// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LayoutManager",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15)
    ],
    products: [
        .library(name: "LayoutManager", targets: [
            "LayoutManager"
        ])
    ],
    targets: [
        .target(name: "LayoutManager")
    ]
)
