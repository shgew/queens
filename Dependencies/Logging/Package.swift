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
      name: "Logging",
      targets: ["Logging"]
    )
  ],
  targets: [
    .target(
      name: "Logging"
    )
  ]
)
