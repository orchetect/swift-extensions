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
/// > Note:
/// >
/// > This type is less performant than the inout/pointer-based data readers, however the return types
/// > are fully copy-on-write compliant and are safe to use as-is after being passed out of the
/// > `withCopyingDataReader { reader in }` closure.
///
/// > Note:
/// >
/// > This type is not meant to be initialized directly, but rather used within a call to `<data>.withPointerDataReader { reader in }`.
///
/// Usage with `Data`:
///
/// ```swift
/// let data = Data( ... )
/// try data.withCopyingDataReader { reader in
///     let bytes = try reader.read(bytes: 4)
///     // ...
/// }
/// ```
///
/// Usage with `[UInt8]`:
///
/// ```swift
/// let bytes: [UInt8] = [ ... ]
/// try bytes.withCopyingDataReader { reader in
///     let bytes = try reader.read(bytes: 4)
///     // ...
/// }
/// ```
public struct CopyingDataReader<DataType: DataProtocol & Sendable>: _DataReaderProtocol {
    public typealias DataElement = DataType.Element
    public typealias DataRange = DataType.SubSequence

    @usableFromInline
    let base: DataType

    init(data: DataType) {
        base = data
    }

    // MARK: - State

    public internal(set) var readOffset = 0

    // MARK: - Internal

    @usableFromInline
    typealias DataIndex = DataType.Index
    
    @inlinable
    func _dataSize() -> Int {
        base.count
    }

    @inlinable
    func _dataStartIndex() -> DataIndex {
        base.startIndex
    }

    @inlinable
    func _dataReadOffsetIndex(offsetBy offset: Int) -> DataIndex {
        base.index(base.startIndex, offsetBy: readOffset + offset)
    }

    @inlinable
    func _dataByte(at dataIndex: DataIndex) throws(DataReaderError) -> DataElement {
        base[dataIndex]
    }

    func _dataBytes(in dataIndexRange: Range<DataIndex>) throws(DataReaderError) -> DataRange {
        base[dataIndexRange]
    }

    func _dataBytes(in dataIndexRange: ClosedRange<DataIndex>) throws(DataReaderError) -> DataRange {
        base[dataIndexRange]
    }
}

extension CopyingDataReader: Sendable { }

// MARK: - DataProtocol Extensions

// This generic implementation will work on any `DataProtocol`-conforming concrete type without needing
// individual implementations on the known concrete types.

extension DataProtocol {
    /// Accesses the data by providing a ``CopyingDataReader`` instance to a closure.
    ///
    /// > Note:
    /// >
    /// > This type is less performant than the inout/pointer-based data readers, however the return types
    /// > are fully copy-on-write compliant and are safe to use as-is after being passed out of the
    /// > `withCopyingDataReader { reader in }` closure.
    @discardableResult
    public func withCopyingDataReader<T, E>(
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
