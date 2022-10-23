// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [.macOS(.v10_11)],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.50.3"),
        .package(url: "https://github.com/SwiftGen/SwiftGen", from: "6.6.2")
    ],
    targets: [.target(name: "BuildTools", path: "")]
)
