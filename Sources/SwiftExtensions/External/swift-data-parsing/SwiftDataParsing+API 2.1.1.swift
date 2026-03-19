//
//  SwiftDataParsing.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import SwiftDataParsing

#if canImport(Foundation)

// MARK: - API Changes @ swift-extensions 2.1.1

// MARK: ByteOrder.swift

@_documentation(visibility: internal)
@available(*, deprecated, renamed: "ByteOrder")
public typealias DataEndianness = ByteOrder

extension Int8 {
    /// Returns a two's complement bit format of an `Int8` so it can be stored as a byte (`UInt8`).
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "toUInt8(as:)")
    @inlinable @_disfavoredOverload
    public var twosComplement: UInt8 {
        toUInt8(as: .twosComplement)
    }
}

#endif
