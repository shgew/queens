// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "Board",
  platforms: [
    .iOS(.v26),
    .macOS(.v26),
  ],
  products: [
    .library(
      name: "Board",
      targets: ["Board"]
    ),
    .library(
      name: "BoardUI",
      targets: ["BoardUI"]
    ),
  ],
  dependencies: [
    .package(path: "../Logging"),
  ],
  targets: [
    .target(
      name: "Board",
      dependencies: [
        .product(name: "Logging", package: "Logging")
      ]
    ),
    .target(
      name: "BoardUI",
      dependencies: [
        "Board",
        .product(name: "Logging", package: "Logging"),
      ],
      resources: [.process("Resources")]
    ),

    .testTarget(
      name: "BoardTests",
      dependencies: ["Board"]
    ),
  ]
)
