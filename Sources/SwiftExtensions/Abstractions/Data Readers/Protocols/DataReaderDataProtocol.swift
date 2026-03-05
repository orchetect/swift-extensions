//
//  DataReaderDataProtocol.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

/// Protocol adopted by data types supported by ``DataReaderProtocol``.
public protocol DataReaderDataProtocol where Self: DataProtocol, SubSequence: DataReaderDataProtocol {
    associatedtype SubSequence
    
    init()
    init(_ other: Self)
    init(_ other: SubSequence)
    
    // Restated from DataProtocol concrete types
    func withUnsafeBytes<ResultType>(_ body: (UnsafeRawBufferPointer) throws -> ResultType) rethrows -> ResultType
    
    /// Returns a subsequence formed from the pointer.
    static func subSequence(from pointer: UnsafeBufferPointer<UInt8>) -> SubSequence
}

// MARK: - Concrete Type Conformances

extension Data: DataReaderDataProtocol {
    public static func subSequence(from pointer: UnsafeBufferPointer<UInt8>) -> SubSequence {
        SubSequence(pointer)
    }
}
// extension Data.SubSequence: DataReaderDataProtocol { } // not needed since Data.SubSequence == Data

extension [UInt8]: DataReaderDataProtocol {
    public static func subSequence(from pointer: UnsafeBufferPointer<UInt8>) -> SubSequence {
        SubSequence(pointer)
    }
}
extension [UInt8].SubSequence: DataReaderDataProtocol {
    public static func subSequence(from pointer: UnsafeBufferPointer<UInt8>) -> SubSequence {
        SubSequence(pointer)
    }
}

#endif
