//
//  CopyingDataReader.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import protocol Foundation.DataProtocol

/// Utility to facilitate sequential reading of bytes.
///
/// This type is not meant to be initialized directly, but rather used within a call to `<data>.withCopyingDataReader { reader in }`.
public struct CopyingDataReader<DataType: DataReaderDataProtocol & Sendable>: _DataReaderProtocol where DataType.Index == Int {
    public typealias DataElement = DataType.Element
    public typealias DataRange = DataType.SubSequence

    let base: DataType

    init(_ data: DataType) {
        base = data
    }

    // MARK: - State

    public internal(set) var readOffset = 0

    // MARK: - Internal

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
        _ block: (_ dataReader: inout CopyingDataReader<Self>) throws(E) -> T
    ) throws(E) -> T {
        var reader = CopyingDataReader(self)
        return try block(&reader)
    }
}

#endif
