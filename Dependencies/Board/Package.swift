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
	targets: [
		.target(
			name: "Board"
		),
		.target(
			name: "BoardUI",
			dependencies: ["Board"],
			resources: [.process("Resources")]
		),

		.testTarget(
			name: "BoardTests",
			dependencies: ["Board"]
		),
	]
)
