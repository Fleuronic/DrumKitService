// swift-tools-version:6.0
import PackageDescription

let package = Package(
	name: "DrumKitService",
	platforms: [
		.iOS(.v15),
		.macOS(.v12),
		.tvOS(.v15),
		.watchOS(.v8)
	],
	products: [
		.library(
			name: "DrumKitService",
			targets: ["DrumKitService"]
		),
	],
	dependencies: [
		// .package(path: "../.."),
		.package(url: "https://github.com/Fleuronic/DrumKit", branch: "main"),
		.package(url: "https://github.com/Fleuronic/Caesura", branch: "main")
	],
	targets: [
		.target(
			name: "DrumKitService",
			dependencies: [
				"DrumKit",
				"Caesura"
			]
		)
	],
	swiftLanguageModes: [.v6]
)

for target in package.targets {
	target.swiftSettings = [
		.enableExperimentalFeature("StrictConcurrency"),
		.enableUpcomingFeature("ExistentialAny"),
	]
}
