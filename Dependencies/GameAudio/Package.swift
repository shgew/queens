// swift-tools-version: 6.2

import PackageDescription

let package = Package(
	name: "GameAudio",
	platforms: [
		.iOS(.v26),
		.macOS(.v26),
	],
	products: [
		.library(
			name: "GameAudio",
			targets: ["GameAudio"]
		)
	],
	targets: [
		.target(
			name: "GameAudio",
			resources: [.process("Resources")]
		)
	]
)
