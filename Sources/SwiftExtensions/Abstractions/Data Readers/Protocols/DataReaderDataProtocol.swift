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
    
    // Restated from DataProtocol concrete types
    func withUnsafeBytes<ResultType>(_ body: (UnsafeRawBufferPointer) throws -> ResultType) rethrows -> ResultType
}

// MARK: - Concrete Type Conformances

extension Data: DataReaderDataProtocol { }
// extension Data.SubSequence: DataReaderDataProtocol { } // not needed since Data.SubSequence == Data

extension [UInt8]: DataReaderDataProtocol { }
extension [UInt8].SubSequence: DataReaderDataProtocol { }

extension UnsafeBufferPointer<UInt8>: DataReaderDataProtocol { }
extension UnsafeBufferPointer<UInt8>.SubSequence: DataReaderDataProtocol { }

#endif
