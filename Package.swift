// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "spm-adpie-framework",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "spm-adpie-framework",
            targets: [
                "spm-adpie-framework-target",
            ]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "adpie-binary-target",
            path: "AdPieSDK/AdPieSDK.xcframework"
        ),
        .target(
            name: "spm-adpie-framework-target",
            dependencies: [
                "adpie-binary-target",
            ],
            path: "AdPieSDK/Dependency",
            exclude: [
                "../../AdPieSample",
                "../../AdPieSwiftSample",
                "../../Mediations"
            ]
        ),
    ]
)
