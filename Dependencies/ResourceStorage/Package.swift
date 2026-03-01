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
  dependencies: [
    .package(path: "../Logging"),
  ],
  targets: [
    .target(
      name: "ResourceStorage",
      dependencies: ["Logging"]
    ),
    .testTarget(
      name: "ResourceStorageTests",
      dependencies: ["ResourceStorage"]
    ),
  ]
)
