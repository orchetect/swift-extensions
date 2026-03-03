//
//  PassiveDataReader.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol describing a common API layer for data reader implementations.
public protocol PassiveDataReaderProtocol {
    associatedtype DataType: DataProtocol
    
    /// Current byte index of read offset (byte position).
    var readOffset: Int { get }
    
    /// Returns number of available remaining bytes.
    var remainingByteCount: Int { get }
    
    /// Manually advance by _n_ number of bytes from current read offset.
    /// Note that this method is unchecked which may result in an offset beyond the end of the data
    /// stream.
    mutating func advanceBy(_ count: Int)
    
    /// Return the next byte and increment the read offset.
    ///
    /// If no bytes remain, an error will be returned.
    mutating func readByte() throws(PassiveDataReaderError) -> DataType.Element
    
    /// Return the remainder of the data and increment the read offset.
    ///
    /// If fewer bytes remain than are requested, an error will be returned.
    mutating func read() throws(PassiveDataReaderError) -> DataType.SubSequence
    
    /// Return the next _n_ number of bytes and increment the read offset.
    ///
    /// If fewer bytes remain than are requested, an error will be returned.
    mutating func read(bytes count: Int) throws(PassiveDataReaderError) -> DataType.SubSequence
    
    /// Read the next byte without advancing the read offset.
    /// If no bytes remain, an error will be returned.
    func nonAdvancingReadByte() throws(PassiveDataReaderError) -> DataType.Element
    
    /// Read the remainder of the data, without advancing the read offset.
    /// If fewer bytes remain than are requested, an error will be returned.
    func nonAdvancingRead() throws(PassiveDataReaderError) -> DataType.SubSequence
    
    /// Read _n_ number of bytes from the current read offset, without advancing the read offset.
    /// If `bytes count` passed is `nil`, the remainder of the data will be returned.
    /// If fewer bytes remain than are requested, an error will be returned.
    func nonAdvancingRead(bytes count: Int) throws(PassiveDataReaderError) -> DataType.SubSequence
    
    /// Resets read offset back to byte index 0.
    mutating func reset()
}

/// Internal members of ``PassiveDataReaderProtocol``.
protocol _PassiveDataReaderProtocol: PassiveDataReaderProtocol {
    /// Current byte offset.
    var readOffset: Int { get set }
    
    /// Return the byte count of the data structure.
    func _dataSize() -> Int
    
    /// Return the data structure start index.
    func _dataStartIndex() -> DataType.Index
    
    /// Return the data structure index that corresponds to the current user-facing ``readOffset`` value,
    /// optionally offset by a byte distance.
    func _dataReadOffsetIndex(offsetBy offset: Int) -> DataType.Index
    
    /// Return the data byte at the given data structure index.
    func _dataByte(at dataIndex: DataType.Index) throws(PassiveDataReaderError) -> DataType.Element
    
    /// Return the data bytes in the given data structure index range.
    func _dataBytes(in dataIndexRange: Range<DataType.Index>) throws(PassiveDataReaderError) -> DataType.SubSequence
    
    /// Return the data bytes in the given data structure index range.
    func _dataBytes(in dataIndexRange: ClosedRange<DataType.Index>) throws(PassiveDataReaderError) -> DataType.SubSequence
}

extension _PassiveDataReaderProtocol {
    // MARK: - Public Implementation
    
    public var remainingByteCount: Int { _dataSize() - readOffset }
    
    public mutating func advanceBy(_ count: Int) {
        readOffset += count
    }
    
    public mutating func readByte() throws(PassiveDataReaderError) -> DataType.Element {
        let d = try dataByte()
        defer { readOffset += 1 }
        return d
    }
    
    public mutating func read() throws(PassiveDataReaderError) -> DataType.SubSequence {
        let d = try data()
        defer { readOffset += d.advanceCount }
        return d.data
    }
    
    public mutating func read(bytes count: Int) throws(PassiveDataReaderError) -> DataType.SubSequence {
        let d = try data(bytes: count)
        defer { readOffset += d.advanceCount }
        return d.data
    }
    
    public func nonAdvancingReadByte() throws(PassiveDataReaderError) -> DataType.Element {
        try dataByte()
    }
    
    public func nonAdvancingRead() throws(PassiveDataReaderError) -> DataType.SubSequence {
        try data().data
    }
    
    public func nonAdvancingRead(bytes count: Int) throws(PassiveDataReaderError) -> DataType.SubSequence {
        try data(bytes: count).data
    }
    
    public mutating func reset() {
        readOffset = 0
    }
    
    // MARK: - Internal Helpers
    
    func dataByte() throws(PassiveDataReaderError) -> DataType.Element {
        guard remainingByteCount > 0 else { throw .pastEndOfStream }
        let readPosIndex = _dataReadOffsetIndex(offsetBy: 0)
        return try _dataByte(at: readPosIndex)
    }
    
    func data(bytes count: Int? = nil) throws(PassiveDataReaderError) -> (data: DataType.SubSequence, advanceCount: Int) {
        if count == 0 {
            // return empty bytes, but as a SubSequence
            let index = _dataReadOffsetIndex(offsetBy: 0)
            let bytes = try _dataBytes(in: index ..< index)
            return (data: bytes, advanceCount: 0)
        }
        
        if let count,
           count < 0 { throw .invalidByteCount }
        
        let readPosStartIndex = _dataReadOffsetIndex(offsetBy: 0)
        
        let remainingCount = remainingByteCount
        
        let count = count ?? remainingCount
        
        guard count <= remainingCount else {
            throw .pastEndOfStream
        }
        
        let endIndex = _dataReadOffsetIndex(offsetBy: count - 1)
        
        let returnBytes = try _dataBytes(in: readPosStartIndex ... endIndex)
        
        return (data: returnBytes, advanceCount: count)
    }
}

/// Utility to facilitate sequential reading of bytes.
/// Passing the data in as a mutable `inout` facilitates passive memory reading. The data itself is never mutated.
///
/// Usage:
///
/// ```swift
/// var data = Data( ... )
/// var dr = PassiveDataReader { $0(&data) }
///
/// if let bytes = dr.read(bytes: 4) { ... }
/// ```
public struct PassiveDataReader<DataType: DataProtocol>: _PassiveDataReaderProtocol {
    public typealias DataAccess = (_ block: InoutDataAccess) -> Void
    public typealias InoutDataAccess = (inout DataType) -> Void
    
    let dataAccess: DataAccess
    
    // MARK: - Init
    
    public init(_ dataAccess: @escaping DataAccess) {
        self.dataAccess = dataAccess
    }
    
    // MARK: - State
    
    public internal(set) var readOffset = 0
    
    // MARK: - Internal
    
    func _dataSize() -> Int {
        withData { $0.count }
    }
    
    func _dataStartIndex() -> DataType.Index {
        withData { $0.startIndex }
    }
    
    func _dataReadOffsetIndex(offsetBy offset: Int) -> DataType.Index {
        withData { $0.index($0.startIndex, offsetBy: readOffset + offset) }
    }
    
    func _dataByte(at dataIndex: DataType.Index) throws(PassiveDataReaderError) -> UInt8 {
        withData { $0[dataIndex] }
    }
    
    func _dataBytes(in dataIndexRange: Range<DataType.Index>) throws(PassiveDataReaderError) -> DataType.SubSequence {
        withData { $0[dataIndexRange] }
    }
    
    func _dataBytes(in dataIndexRange: ClosedRange<DataType.Index>) throws(PassiveDataReaderError) -> DataType.SubSequence {
        withData { $0[dataIndexRange] }
    }
    
    // MARK: - Helpers
    
    private func withData<T>(_ block: (inout DataType) -> T) -> T {
        var out: T!
        dataAccess { out = block(&$0) }
        return out
    }
}

public struct PointerDataReader: _PassiveDataReaderProtocol {
    public typealias DataType = Data // [UInt8]
    public typealias DataAccess = () -> UnsafeBufferPointer<UInt8>
    
    let dataAccess: DataAccess
    
    // MARK: - Init
    
    public init(_ dataAccess: @escaping DataAccess) {
        self.dataAccess = dataAccess
    }
    
    // MARK: - State
    
    public internal(set) var readOffset = 0
    
    // MARK: - Internal
    
    func _dataSize() -> Int {
        withData { $0.count }
    }
    
    func _dataStartIndex() -> DataType.Index {
        withData { $0.startIndex }
    }
    
    func _dataReadOffsetIndex(offsetBy offset: Int) -> DataType.Index {
        withData { $0.index($0.startIndex, offsetBy: readOffset + offset) }
    }
    
    func _dataByte(at dataIndex: DataType.Index) throws(PassiveDataReaderError) -> UInt8 {
        withData { $0[dataIndex] }
    }
    
    func _dataBytes(in dataIndexRange: Range<DataType.Index>) throws(PassiveDataReaderError) -> DataType.SubSequence {
        withData {
            let bytes = $0.extracting(dataIndexRange) /* $0[dataIndexRange] */
            let wrapped = DataType.SubSequence(bytes)
            return wrapped
        }
    }
    
    func _dataBytes(in dataIndexRange: ClosedRange<DataType.Index>) throws(PassiveDataReaderError) -> DataType.SubSequence {
        withData {
            let bytes = $0.extracting(dataIndexRange) /* $0[dataIndexRange] */
            let wrapped = DataType.SubSequence(bytes)
            return wrapped
        }
    }
    
    // MARK: - Helpers
    
    private func withData<T>(_ block: (_ pointer: UnsafeBufferPointer<UInt8>) -> T) -> T {
        let ptr = dataAccess()
        return block(ptr)
    }
}

// MARK: - ReadError

/// Error returned by ``PassiveDataReader`` methods.
public enum PassiveDataReaderError: Error {
    case pastEndOfStream
    case invalidByteCount
}

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

//extension Data {
//    /// Accesses the data by providing a ``PassiveDataReader`` instance to a closure.
//    @_disfavoredOverload @discardableResult
//    public func withContiguousDataReader<Result, E>(
//        _ block: (_ dataReader: inout PassiveDataReader<Self>) throws(E) -> Result
//    ) throws(E) -> Result {
//        bytes
//        guard let result = withContiguousStorageIfAvailable { buffer in
//            var reader = PassiveDataReader { $0(buffer) }
//            return try block(&reader)
//        } else { throw }
//    }
//}
