// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "ResourceStorage",
  platforms: [
    .iOS(.v26),
    .macOS(.v26),
  ],
  products: [
    .library(
      name: "ResourceStorage",
      targets: ["ResourceStorage"]
    )
  ],
  targets: [
    .target(
      name: "ResourceStorage"
    ),
    .testTarget(
      name: "ResourceStorageTests",
      dependencies: ["ResourceStorage"]
    ),
  ]
)
