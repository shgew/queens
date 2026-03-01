// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "Problems",
  platforms: [
    .iOS(.v26),
    .macOS(.v26),
  ],
  products: [
    .library(
      name: "Problems",
      targets: ["Problems"]
    )
  ],
  dependencies: [
    .package(path: "../Board")
  ],
  targets: [
    .target(
      name: "Problems",
      dependencies: [
        .product(name: "Board", package: "Board")
      ]
    ),

    .testTarget(
      name: "ProblemsBenchmarks",
      dependencies: ["Problems"]
    ),
  ]
)
