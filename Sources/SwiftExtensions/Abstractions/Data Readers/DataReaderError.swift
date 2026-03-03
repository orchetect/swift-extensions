//
//  DataReaderError.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// Error returned by methods in ``DataReaderProtocol``-conforming types.
public enum DataReaderError: Error {
    case pastEndOfStream
    case invalidByteCount
}

extension DataReaderError: Equatable { }

extension DataReaderError: Hashable { }

extension DataReaderError: Sendable { }
