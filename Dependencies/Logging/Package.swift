// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "Logging",
  platforms: [
    .iOS(.v26),
    .macOS(.v26),
  ],
  products: [
    .library(
      name: "QueensLogging",
      targets: ["QueensLogging"]
    )
  ],
  targets: [
    .target(
      name: "QueensLogging"
    )
  ]
)
