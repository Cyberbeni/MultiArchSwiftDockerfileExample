// swift-tools-version:6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "ExampleApp",
	platforms: [.macOS(.v26)], // macOS version that corresponds with the "swift-tools-version", so no availability checks are required.
	products: [
		.executable(
			name: "ExampleApp",
			targets: ["ExampleApp"],
		),
		.library(
			name: "ExampleLib",
			targets: ["ExampleLib"],
		),
	],
	dependencies: [
	],
	targets: [
		.executableTarget(
			name: "ExampleApp",
			dependencies: [
			],
			swiftSettings: [
				.unsafeFlags(["-Xfrontend", "-warn-long-expression-type-checking=100"], .when(configuration: .debug)),
				// This can cause errors when your dependencies don't have it enabled:
				// .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
			],
			linkerSettings: [
				.unsafeFlags(["-Xlinker", "-s"], .when(configuration: .release)), // STRIP_STYLE = all
			],
		),
		.target(
			name: "ExampleLib",
			dependencies: [
			],
			swiftSettings: [
				.unsafeFlags(["-Xfrontend", "-warn-long-expression-type-checking=100"], .when(configuration: .debug)),
				.enableUpcomingFeature("NonisolatedNonsendingByDefault"),
			],
		),
		.binaryTarget(
			name: "swiftformat",
			url: "https://github.com/nicklockwood/SwiftFormat/releases/download/0.63.0/swiftformat.artifactbundle.zip",
			checksum: "d3c350a6655c0f687e2c23aac3e777b35345313a6428bb36b915fe7d9840ec78",
		),
	],
)
