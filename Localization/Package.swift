// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "Localization",
  defaultLocalization: "en",
  platforms: [.iOS(.v16)],
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
      dependencies: [])
  ]
)
