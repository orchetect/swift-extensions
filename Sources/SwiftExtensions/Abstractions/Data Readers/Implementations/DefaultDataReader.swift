//
//  DefaultDataReader.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import struct Foundation.Data
import protocol Foundation.DataProtocol

/// Alias to the most performant data reader for the current platform.
public typealias DefaultDataReader = PointerDataReader

// MARK: - DataReader Extensions

extension DataProtocol {
    /// Accesses the data using the most performant data reader for the current platform.
    @_disfavoredOverload @discardableResult
    public func withDataReader<T, E>(
        _ block: (_ reader: inout DefaultDataReader<Self>) throws(E) -> T
    ) throws(E) -> T {
        try withPointerDataReader(block)
    }
}

#endif
