// swift-tools-version: 6.0

import Foundation
import PackageDescription

let package = Package(
    name: "swift-extensions",
    platforms: [
        // The minimum platform versions here set the baseline requirements for the library, however
        // individual features of the library may be marked as `@available` only on newer versions.
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SwiftExtensions",
            targets: ["SwiftExtensions"]
        )
    ],
    dependencies: [
        // Testing-only dependencies
        .package(url: "https://github.com/apple/swift-numerics", from: "1.1.0"),
        .package(url: "https://github.com/orchetect/swift-testing-extensions", from: "0.3.1")
    ],
    targets: [
        .target(
            name: "SwiftExtensions",
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug))
            ]
        ),
        .testTarget(
            name: "SwiftExtensionsTests",
            dependencies: [
                "SwiftExtensions",
                .product(name: "Numerics", package: "swift-numerics"),
                .product(name: "TestingExtensions", package: "swift-testing-extensions")
            ]
        )
    ]
)

// MARK: - Utilities

func hasEnvironmentVariable(_ name: String) -> Bool {
    ProcessInfo.processInfo.environment[name] != nil
}

// MARK: - CI Pipeline

if hasEnvironmentVariable("GITHUB_ACTIONS") {
    for target in package.targets {
        if target.swiftSettings == nil { target.swiftSettings = [] }
        target.swiftSettings? += [.define("GITHUB_ACTIONS", .when(configuration: .debug))]
    }
}
