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
        .library(
            name: "Board",
            targets: ["Board"]
        ),
    ],
    targets: [
        .target(
            name: "Board"
        ),
        .target(
            name: "Engine",
            dependencies: ["Board"]
        ),

        .testTarget(
            name: "BoardTests",
            dependencies: ["Board"]
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
