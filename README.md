# SwiftExtensions

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Forchetect%2Fswift-extensions%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/orchetect/swift-extensions) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Forchetect%2Fswift-extensions%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/orchetect/swift-extensions) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/swift-extensions/blob/main/LICENSE)

Multi-platform general-purpose Swift extensions.

The library has full unit test coverage and is actively used in production.

## Getting Started

This library is available as a Swift Package Manager (SPM) package.

1. Add the **swift-extensions** repo as a dependency.
   ```swift
   .package(url: "https://github.com/orchetect/swift-extensions", from: "3.0.0")
   ```
2. Add **SwiftExtensions** to your target.
   ```swift
   .product(name: "SwiftExtensions", package: "swift-extensions")
   ```
3. Import **SwiftExtensions** to use it.
   It's recommended to use the `internal` access level if used in a package so that it is not exported to the user of your package.
   ```swift
   internal import SwiftExtensions
   ```

## Documentation

Most methods are implemented as category methods so they are generally discoverable.

All methods are documented with inline help explaining their purpose and basic usage examples.

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/swift-extensions/blob/master/LICENSE) for details.

## Community & Support

Please do not email maintainers for technical support. Several options are available for issues and questions:

- Questions and feature ideas can be posted to [Discussions](https://github.com/orchetect/swift-extensions/discussions).
- If an issue is a verifiable bug with reproducible steps it may be posted in [Issues](https://github.com/orchetect/swift-extensions/issues).

## Contributions

Contributions are welcome. Posting in [Discussions](https://github.com/orchetect/swift-extensions/discussions) first prior to new submitting PRs for features or modifications is encouraged.

## Code Quality & AI Contribution Policy

In an effort to maintain a consistent level of code quality and safety, this repository was built by hand and is maintained without the use of AI code generation.

AI-assisted contributions are welcome, but must remain modest in scope, maintain the same degree of quality and care, and be thoroughly vetted before acceptance.

## Legacy

This repository was formerly known as OTCore.
