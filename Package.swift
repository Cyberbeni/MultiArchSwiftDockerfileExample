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
	],
	dependencies: [
		// Plugins:
		.package(url: "https://codeberg.org/Cyberbeni/SwiftFormat-mirror", from: "0.60.1"),
	],
	targets: [
		.executableTarget(
			name: "ExampleApp",
			dependencies: [
			],
			swiftSettings: [
				.unsafeFlags(["-Xfrontend", "-warn-long-expression-type-checking=100"], .when(configuration: .debug)),
				.unsafeFlags(["-warnings-as-errors"], .when(configuration: .release)),
				// This can cause errors when your dependencies don't have it enabled:
				// .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
			],
			linkerSettings: [
				.unsafeFlags(["-Xlinker", "-s"], .when(configuration: .release)), // STRIP_STYLE = all
			],
		),
	],
)
