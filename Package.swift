// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "ExampleApp",
	products: [
		.executable(
			name: "ExampleApp",
			targets: ["ExampleApp"]
		),
	],
	dependencies: [
		// .package(url: "https://github.com/swift-server-community/mqtt-nio", from: "2.11.0"),
		// Plugins:
		.package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.54.5"),
	],
	targets: [
		.executableTarget(
			name: "ExampleApp",
			dependencies: [
				// .product(name: "MQTTNIO", package: "mqtt-nio"),
			],
			swiftSettings: [
				.unsafeFlags(["-warnings-as-errors"], .when(configuration: .release)),
			],
			linkerSettings: [
				.unsafeFlags(["-Xlinker", "-s"], .when(configuration: .release)), // STRIP_STYLE = all
			]
		),
	]
)
