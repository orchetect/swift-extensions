//
//  DefaultDataReader.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import struct Foundation.Data

/// Alias to the most performant data reader for the current platform.
public typealias DefaultDataReader = PointerDataReader

// MARK: - DataProtocol Extensions

extension Data {
    @discardableResult
    public func withDataReader<T, E>(
        _ block: (_ reader: inout DefaultDataReader<Self>) throws(E) -> T
    ) throws(E) -> T {
        try withPointerDataReader(block)
    }
}

extension [UInt8] {
    @discardableResult
    public func withDataReader<T, E>(
        _ block: (_ reader: inout PointerDataReader<Self>) throws(E) -> T
    ) throws(E) -> T {
        try withPointerDataReader(block)
    }
}

extension [UInt8].SubSequence {
    @discardableResult
    public func withDataReader<T, E>(
        _ block: (_ reader: inout PointerDataReader<Self>) throws(E) -> T
    ) throws(E) -> T {
        try withPointerDataReader(block)
    }
}

#endif
