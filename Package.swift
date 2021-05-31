// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "JSONAPI",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "JSONAPI",
            targets: ["JSONAPI"]),
        .library(
            name: "JSONAPITesting",
            targets: ["JSONAPITesting"])
    ],
    dependencies: [
        .package(url: "https://github.com/facile-it/Poly.git", .branch("upstream_2_5_2")),
    ],
    targets: [
        .target(
            name: "JSONAPI",
            dependencies: ["Poly"]),
        .target(
            name: "JSONAPITesting",
            dependencies: ["JSONAPI"]),
        .testTarget(
            name: "JSONAPITests",
            dependencies: ["JSONAPI", "JSONAPITesting"]),
        .testTarget(
            name: "JSONAPITestingTests",
            dependencies: ["JSONAPI", "JSONAPITesting"])
    ],
    swiftLanguageVersions: [.v5]
)
