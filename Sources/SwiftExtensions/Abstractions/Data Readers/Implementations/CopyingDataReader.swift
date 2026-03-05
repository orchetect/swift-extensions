//
//  CopyingDataReader.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import struct Foundation.Data
import protocol Foundation.DataProtocol

/// Utility to facilitate sequential reading of bytes.
///
/// This type is not meant to be initialized directly, but rather used within a call to `<data>.withCopyingDataReader { reader in }`.
public struct CopyingDataReader<DataType: DataProtocol & Sendable>: _DataReaderProtocol {
    public typealias DataElement = DataType.Element
    public typealias DataRange = DataType.SubSequence

    let base: DataType

    init(data: DataType) {
        base = data
    }

    // MARK: - State

    public internal(set) var readOffset = 0

    // MARK: - Internal

    typealias DataIndex = DataType.Index
    
    func _dataSize() -> Int {
        base.count
    }

    func _dataStartIndex() -> DataType.Index {
        base.startIndex
    }

    func _dataReadOffsetIndex(offsetBy offset: Int) -> DataType.Index {
        base.index(base.startIndex, offsetBy: readOffset + offset)
    }

    func _dataByte(at dataIndex: DataType.Index) throws(DataReaderError) -> DataElement {
        base[dataIndex]
    }

    func _dataBytes(in dataIndexRange: Range<DataType.Index>) throws(DataReaderError) -> DataRange {
        base[dataIndexRange]
    }

    func _dataBytes(in dataIndexRange: ClosedRange<DataType.Index>) throws(DataReaderError) -> DataRange {
        base[dataIndexRange]
    }
}

extension CopyingDataReader: Sendable { }

// MARK: - DataProtocol Extensions

// This generic implementation will work on any `DataProtocol`-conforming concrete type without needing
// individual implementations on the known concrete types.

extension DataProtocol {
    /// Accesses the data by providing a ``CopyingDataReader`` instance to a closure.
    @discardableResult
    public mutating func withCopyingDataReader<T, E>(
        _ block: (_ reader: inout CopyingDataReader<Self>) throws(E) -> T
    ) throws(E) -> T {
        var reader = CopyingDataReader(data: self)
        return try block(&reader)
    }
}

// MARK: - API Changes in 2.1.0

@_documentation(visibility: internal)
@available(*, renamed: "CopyingDataReader")
public typealias DataReader = CopyingDataReader

extension DataReader where DataType == Data {
    @_documentation(visibility: internal)
    @available(*, deprecated, message: "Data readers are no longer instanced directly. Instead, call `data.withDataReader { reader in }`.")
    public init(_ data: Data) {
        self.init(data: data)
    }
}

#endif
