// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Engine",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
    ],
    products: [
        .library(
            name: "Engine",
            targets: ["Engine"]
        ),
    ],
    dependencies: [
        .package(path: "../Board"),
    ],
    targets: [
        .target(
            name: "Engine",
            dependencies: [
                .product(name: "Board", package: "Board"),
            ]
        ),

        .testTarget(
            name: "EngineTests",
            dependencies: ["Engine"]
        ),
        .testTarget(
            name: "EngineBenchmarks",
            dependencies: ["Engine"]
        ),
    ]
)
