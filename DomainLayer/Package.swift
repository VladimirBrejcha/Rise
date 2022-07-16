// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "DomainLayer",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "DomainLayer",
      targets: ["DomainLayer"]),
  ],
  dependencies: [
    .package(path: "Core/"),
    .package(path: "DataLayer/"),
    .package(path: "Localization/")
  ],
  targets: [
    .target(
      name: "DomainLayer",
      dependencies: ["DataLayer", "Core", "Localization"]),
    .testTarget(
      name: "DomainLayerTests",
      dependencies: ["DomainLayer"]),
  ]
)
