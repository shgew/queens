// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "Game",
  platforms: [
    .iOS(.v26),
    .macOS(.v26),
  ],
  products: [
    .library(
      name: "Game",
      targets: ["Game"]
    )
  ],
  dependencies: [
    .package(path: "../Board"),
    .package(path: "../Problems"),
    .package(path: "../Logging"),
  ],
  targets: [
    .target(
      name: "Game",
      dependencies: [
        .product(name: "Board", package: "Board"),
        .product(name: "Problems", package: "Problems"),
        .product(name: "QueensLogging", package: "Logging"),
      ]
    ),
    .testTarget(
      name: "GameTests",
      dependencies: ["Game"]
    ),
  ]
)
