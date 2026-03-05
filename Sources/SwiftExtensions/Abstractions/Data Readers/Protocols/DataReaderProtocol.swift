//
//  DataReaderProtocol.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

/// Protocol describing a common API layer for data reader implementations.
public protocol DataReaderProtocol {
    associatedtype DataType: DataProtocol
    associatedtype DataRange
    associatedtype DataElement
    
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
    mutating func readByte() throws(DataReaderError) -> DataElement
    
    /// Return the remainder of the data and increment the read offset.
    ///
    /// If fewer bytes remain than are requested, an error will be returned.
    mutating func read() throws(DataReaderError) -> DataRange
    
    /// Return the next _n_ number of bytes and increment the read offset.
    ///
    /// If fewer bytes remain than are requested, an error will be returned.
    mutating func read(bytes count: Int) throws(DataReaderError) -> DataRange
    
    /// Read the next byte without advancing the read offset.
    /// If no bytes remain, an error will be returned.
    func nonAdvancingReadByte() throws(DataReaderError) -> DataElement
    
    /// Read the remainder of the data, without advancing the read offset.
    /// If fewer bytes remain than are requested, an error will be returned.
    func nonAdvancingRead() throws(DataReaderError) -> DataRange
    
    /// Read _n_ number of bytes from the current read offset, without advancing the read offset.
    /// If `bytes count` passed is `nil`, the remainder of the data will be returned.
    /// If fewer bytes remain than are requested, an error will be returned.
    func nonAdvancingRead(bytes count: Int) throws(DataReaderError) -> DataRange
    
    /// Resets read offset back to byte index 0.
    mutating func reset()
}

/// Internal members of ``DataReaderProtocol``.
protocol _DataReaderProtocol: DataReaderProtocol {
    associatedtype DataIndex: Comparable
    
    /// Current byte offset.
    var readOffset: Int { get set }
    
    /// Return the byte count of the data structure.
    func _dataSize() -> Int
    
    /// Return the data structure start index.
    func _dataStartIndex() -> DataIndex
    
    /// Return the data structure index that corresponds to the current user-facing ``readOffset`` value,
    /// optionally offset by a byte distance.
    func _dataReadOffsetIndex(offsetBy offset: Int) -> DataIndex
    
    /// Return the data byte at the given data structure index.
    func _dataByte(at dataIndex: DataIndex) throws(DataReaderError) -> DataElement
    
    /// Return the data bytes in the given data structure index range.
    func _dataBytes(in dataIndexRange: Range<DataIndex>) throws(DataReaderError) -> DataRange
    
    /// Return the data bytes in the given data structure index range.
    func _dataBytes(in dataIndexRange: ClosedRange<DataIndex>) throws(DataReaderError) -> DataRange
}

// MARK: - Public Implementation

extension _DataReaderProtocol {
    public var remainingByteCount: Int { _dataSize() - readOffset }
    
    public mutating func advanceBy(_ count: Int) {
        readOffset += count
    }
    
    public mutating func readByte() throws(DataReaderError) -> DataElement {
        let d = try dataByte()
        defer { readOffset += 1 }
        return d
    }
    
    public mutating func read() throws(DataReaderError) -> DataRange {
        let d = try data()
        defer { readOffset += d.advanceCount }
        return d.data
    }
    
    public mutating func read(bytes count: Int) throws(DataReaderError) -> DataRange {
        let d = try data(bytes: count)
        defer { readOffset += d.advanceCount }
        return d.data
    }
    
    public func nonAdvancingReadByte() throws(DataReaderError) -> DataElement {
        try dataByte()
    }
    
    public func nonAdvancingRead() throws(DataReaderError) -> DataRange {
        try data().data
    }
    
    public func nonAdvancingRead(bytes count: Int) throws(DataReaderError) -> DataRange {
        try data(bytes: count).data
    }
    
    public mutating func reset() {
        readOffset = 0
    }
}

// MARK: - Internal Helpers

extension _DataReaderProtocol {
    func dataByte() throws(DataReaderError) -> DataElement {
        guard remainingByteCount > 0 else { throw .pastEndOfStream }
        let readPosIndex = _dataReadOffsetIndex(offsetBy: 0)
        return try _dataByte(at: readPosIndex)
    }
    
    func data(bytes count: Int? = nil) throws(DataReaderError) -> (data: DataRange, advanceCount: Int) {
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

#endif
