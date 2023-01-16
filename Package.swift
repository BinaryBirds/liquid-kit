// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "liquid-kit",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "LiquidKit",
            targets: [
                "LiquidKit"
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-nio.git",
            from: "2.46.0"
        ),
        .package(
            url: "https://github.com/apple/swift-log.git",
            from: "1.4.0"
        ),
        .package(
            url: "https://github.com/apple/swift-docc-plugin",
            from: "1.0.0"
        ),
    ],
    targets: [
        .target(
            name: "LiquidKit",
            dependencies: [
                .product(
                    name: "NIO",
                    package: "swift-nio"
                ),
                .product(
                    name: "Logging",
                    package: "swift-log"
                ),
            ]),
        .testTarget(
            name: "LiquidKitTests",
            dependencies: [
                .target(
                    name: "LiquidKit"
                )
            ]),
    ]
)
