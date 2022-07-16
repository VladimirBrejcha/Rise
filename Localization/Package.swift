// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "Localization",
  defaultLocalization: "en",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "Localization",
      targets: ["Localization"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "Localization",
      dependencies: []),
    .testTarget(
      name: "LocalizationTests",
      dependencies: ["Localization"]),
  ]
)
