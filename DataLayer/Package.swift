// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "DataLayer",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "DataLayer",
      targets: ["DataLayer"]),
  ],
  dependencies: [
    .package(path: "Core/")
  ],
  targets: [
    .target(
      name: "DataLayer",
      dependencies: ["Core"]),
    .testTarget(
      name: "DataLayerTests",
      dependencies: ["DataLayer"]),
  ]
)
