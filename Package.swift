// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SpasiboUIKit",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SpasiboUIKit",
            targets: ["BottomSheet"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BottomSheet",
            dependencies: []),
        .testTarget(
            name: "BottomSheetTests",
            dependencies: ["BottomSheet"]),
    ]
)
