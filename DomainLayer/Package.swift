// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "DomainLayer",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "DomainLayer",
      targets: ["DomainLayer"]),
  ],
  dependencies: [
    .package(path: "Core/"),
    .package(path: "DataLayer/"),
    .package(path: "Localization/"),
    .package(path: "UILibrary/")
  ],
  targets: [
    .target(
      name: "DomainLayer",
      dependencies: ["DataLayer", "UILibrary", "Core", "Localization"]),
    .testTarget(
      name: "DomainLayerTests",
      dependencies: ["DomainLayer"]),
  ]
)
