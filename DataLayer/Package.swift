// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "DataLayer",
  platforms: [.iOS(.v14)],
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
