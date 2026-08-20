// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "FeatureKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "FeatureKit",
            targets: ["FeatureKit"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "FeatureKit",
            url: "https://raw.githubusercontent.com/NicolasNC/FeatureKit-iOS/369fb45ac6ad27696e232a855fa850f11fbef363/FeatureKit.xcframework.zip",
            checksum: "c42d22589c3d3ceb6d9ddca6feda7871bdf84dde278f5e35408ffb9a31551274"
        )
    ]
)
