// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "swift-extensions",
    platforms: [
        // The minimum platform versions here set the baseline requirements for the library, however
        // individual features of the library may be marked as `@available` only on newer versions.
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)
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
        .package(url: "https://github.com/orchetect/swift-testing-extensions", from: "0.2.4")
    ],
    targets: [
        .target(
            name: "SwiftExtensions",
            dependencies: [],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
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

#if canImport(Foundation) || canImport(CoreFoundation)
    #if canImport(Foundation)
        import class Foundation.ProcessInfo

        func getEnvironmentVar(_ name: String) -> String? {
            ProcessInfo.processInfo.environment[name]
        }
    #elseif canImport(CoreFoundation)
        import CoreFoundation

        func getEnvironmentVar(_ name: String) -> String? {
            guard let rawValue = getenv(name) else { return nil }
            return String(utf8String: rawValue)
        }
    #endif

    func isEnvironmentVarTrue(_ name: String) -> Bool {
        guard let value = getEnvironmentVar(name)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        else { return false }
        return ["true", "yes", "1"].contains(value.lowercased())
    }

    // MARK: - CI Pipeline

    if isEnvironmentVarTrue("GITHUB_ACTIONS") {
        for target in package.targets.filter(\.isTest) {
            if target.swiftSettings == nil { target.swiftSettings = [] }
            target.swiftSettings? += [.define("GITHUB_ACTIONS", .when(configuration: .debug))]
        }
    }
#endif
