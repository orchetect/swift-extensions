//
//  PassiveDataReader.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Utility to facilitate sequential reading of bytes.
/// The data is not mutated, but it is required to be a mutable `var` to facilitate `inout` access.
///
/// Usage:
///
/// ```swift
/// var data = Data( ... )
/// var dr = PassiveDataReader { $0(&data) }
///
/// if let bytes = dr.read(bytes: 4) { ... }
/// ```
public struct PassiveDataReader<D: DataProtocol> {
    public typealias DataAccess = (inout D) -> Void
    public typealias Closure = (_ block: DataAccess) -> Void
    
    let closure: Closure
    
    // MARK: - Init
    
    public init(_ closure: @escaping Closure) {
        self.closure = closure
    }
    
    // MARK: - State
    
    /// Current byte index of read offset (byte position).
    public internal(set) var readOffset = 0
    
    /// Returns number of available remaining bytes.
    public var remainingByteCount: Int { withData(\.count) - readOffset }
    
    /// Resets read offset back to 0.
    public mutating func reset() {
        readOffset = 0
    }
    
    // MARK: - Methods
    
    /// Manually advance by _n_ number of bytes from current read offset.
    /// Note that this method is unchecked which may result in an offset beyond the end of the data
    /// stream.
    public mutating func advanceBy(_ count: Int) {
        readOffset += count
    }
    
    /// Return the next byte and increment the read offset.
    ///
    /// If no bytes remain, `nil` will be returned.
    public mutating func readByte() throws(ReadError) -> D.Element {
        let d = try dataByte()
        defer { readOffset += 1 }
        return d
    }
    
    /// Read the next byte without advancing the read offset.
    /// If no bytes remain, `nil` will be returned.
    public func nonAdvancingReadByte() throws(ReadError) -> D.Element {
        try dataByte()
    }
    
    /// Return the next _n_ number of bytes and increment the read offset.
    ///
    /// If `bytes` parameter is nil, the remainder of the data will be returned.
    ///
    /// If fewer bytes remain than are requested, `nil` will be returned.
    public mutating func read(bytes count: Int? = nil) throws(ReadError) -> D.SubSequence {
        let d = try data(bytes: count)
        defer { readOffset += d.advanceCount }
        return d.data
    }
    
    /// Read _n_ number of bytes from the current read offset, without advancing the read offset.
    /// If `bytes count` passed is `nil`, the remainder of the data will be returned.
    /// If fewer bytes remain than are requested, `nil` will be returned.
    public func nonAdvancingRead(bytes count: Int? = nil) throws(ReadError) -> D.SubSequence {
        try data(bytes: count).data
    }
    
    // MARK: - Internal
    
    func withData<T>(_ block: (inout D) -> T) -> T {
        var out: T!
        closure { out = block(&$0) }
        return out
    }
    
    func dataByte() throws(ReadError) -> D.Element {
        guard remainingByteCount > 0 else { throw .pastEndOfStream }
        let readPosIndex = withData { $0.index($0.startIndex, offsetBy: readOffset) }
        return withData { $0[readPosIndex] }
    }
    
    func data(bytes count: Int? = nil) throws(ReadError) -> (data: D.SubSequence, advanceCount: Int) {
        if count == 0 {
            return (data: withData { $0[$0.startIndex ..< $0.startIndex] }, advanceCount: 0)
        }
        
        if let count,
           count < 0 { throw .invalidByteCount }
        
        let readPosStartIndex = withData { $0.index($0.startIndex, offsetBy: readOffset) }
        
        let remainingCount = remainingByteCount
        
        let count = count ?? remainingCount
        
        guard count <= remainingCount else {
            throw .pastEndOfStream
        }
        
        let endIndex = withData { $0.index(readPosStartIndex, offsetBy: count - 1) }
        
        guard withData({
            $0.indices.contains(readPosStartIndex) && $0.indices.contains(endIndex)
        }) else {
            throw .pastEndOfStream
        }
        
        let returnBytes = withData { $0[readPosStartIndex ... endIndex] }
        
        return (data: returnBytes, advanceCount: count)
    }
}

// MARK: - ReadError

#if compiler(>=6.2)
// this works fine in Xcode 26, which solved the compiler crash bug that Xcode 16.4 had

extension PassiveDataReader {
    /// Error returned by ``PassiveDataReader`` methods.
    public enum ReadError: Error {
        case pastEndOfStream
        case invalidByteCount
    }
}

#else
// workaround for Xcode 16.4 which has a compiler crash bug when referencing a type nested
// under a type that has associated generics in `throws()`

extension PassiveDataReader {
    /// Error returned by ``PassiveDataReader`` methods.
    public typealias ReadError = PassiveDataReaderError
}

/// Error returned by ``PassiveDataReader`` methods.
public enum PassiveDataReaderError: Error {
    case pastEndOfStream
    case invalidByteCount
}
#endif

// MARK: - Standard Type Extensions

extension DataProtocol {
    /// Accesses the data by providing a ``PassiveDataReader`` instance to a closure.
    @_disfavoredOverload @discardableResult
    public func withDataReader<Result, E>(
        _ block: (_ dataReader: inout PassiveDataReader<Self>) throws(E) -> Result
    ) throws(E) -> Result {
        var mutableSelf = self
        var reader = PassiveDataReader { $0(&mutableSelf) }
        return try block(&reader)
    }
}
