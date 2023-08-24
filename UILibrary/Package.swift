// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "UILibrary",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "UILibrary",
            targets: ["UILibrary"]),
    ],
    dependencies: [
        .package(path: "Core/")
    ],
    targets: [
        .target(
            name: "UILibrary",
            dependencies: ["Core",],
            resources: [.process("Resources")])
    ]
)
