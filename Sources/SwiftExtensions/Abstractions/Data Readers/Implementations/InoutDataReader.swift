//
//  InoutDataReader.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import protocol Foundation.DataProtocol

/// Utility to facilitate sequential reading of bytes.
/// Passing the data in as a mutable `inout` allows for passive memory reading. The data itself is never mutated.
///
/// > Note:
/// >
/// > This type is less performant than the inout/pointer-based data readers, however the return types
/// > are fully copy-on-write compliant and are safe to use as-is after being passed out of the
/// >`withCopyingDataReader { reader in }` closure.
///
/// > Note:
/// >
/// > This type is not meant to be initialized directly, but rather used within a call to `<data>.withPointerDataReader { reader in }`.
///
/// Usage with `Data`:
///
/// ```swift
/// let data = Data( ... )
/// try data.withInoutDataReader { reader in
///     let bytes = try reader.read(bytes: 4)
///     // ...
/// }
/// ```
///
/// Usage with `[UInt8]`:
///
/// ```swift
/// let bytes: [UInt8] = [ ... ]
/// try bytes.withInoutDataReader { reader in
///     let bytes = try reader.read(bytes: 4)
///     // ...
/// }
/// ```
public struct InoutDataReader<DataType: DataProtocol>: _DataReaderProtocol {
    public typealias DataElement = DataType.Element
    public typealias DataRange = DataType.SubSequence
    
    typealias DataAccess = (_ block: InoutDataAccess) -> Void
    typealias InoutDataAccess = (inout DataType) -> Void
    
    let dataAccess: DataAccess
    
    // MARK: - Init
    
    init(dataAccess: @escaping DataAccess) {
        self.dataAccess = dataAccess
    }
    
    // MARK: - State
    
    public internal(set) var readOffset = 0
    
    // MARK: - Internal
    
    @usableFromInline
    typealias DataIndex = DataType.Index
    
    @inlinable
    func _dataSize() -> Int {
        withData { $0.count }
    }
    
    @inlinable
    func _dataStartIndex() -> DataIndex {
        withData { $0.startIndex }
    }
    
    @inlinable
    func _dataReadOffsetIndex(offsetBy offset: Int) -> DataIndex {
        withData { $0.index($0.startIndex, offsetBy: readOffset + offset) }
    }
    
    @inlinable
    func _dataByte(at dataIndex: DataIndex) throws(DataReaderError) -> DataElement {
        withData { $0[dataIndex] }
    }
    
    func _dataBytes(in dataIndexRange: Range<DataIndex>) throws(DataReaderError) -> DataRange {
        withData { $0[dataIndexRange] }
    }
    
    func _dataBytes(in dataIndexRange: ClosedRange<DataIndex>) throws(DataReaderError) -> DataRange {
        withData { $0[dataIndexRange] }
    }
    
    // MARK: - Helpers
    
    @inline(__always) @usableFromInline
    func withData<T>(_ block: (inout DataType) -> T) -> T {
        var out: T!
        dataAccess { out = block(&$0) }
        return out
    }
}

// MARK: - DataProtocol Extensions

// This generic implementation will work on any `DataProtocol`-conforming concrete type without needing
// individual implementations on the known concrete types.

extension DataProtocol {
    /// Accesses the data by providing an ``InoutDataReader`` instance to a closure.
    ///
    /// > Note:
    /// >
    /// > This type is less performant than the inout/pointer-based data readers, however the return types
    /// > are fully copy-on-write compliant and are safe to use as-is after being passed out of the
    /// >`withCopyingDataReader { reader in }` closure.
    @discardableResult
    public mutating func withInoutDataReader<T, E>(
        _ block: (_ reader: inout InoutDataReader<Self>) throws(E) -> T
    ) throws(E) -> T {
        // since `withUnsafe... { }` does not work with typed error throws, we have to use a workaround to get the typed error out
        var result: Result<T, E>!
        
        withUnsafeMutablePointer(to: &self) { ptr in
            var reader = InoutDataReader(dataAccess: { $0(&ptr.pointee) })
            do throws(E) {
                let value = try block(&reader)
                result = .success(value)
            } catch {
                result = .failure(error)
            }
        }
        return try result.get()
    }
}

// MARK: - API Changes in 2.1.0

@_documentation(visibility: internal)
@available(*, renamed: "InoutDataReader")
public typealias PassiveDataReader = InoutDataReader

extension PassiveDataReader {
    @_documentation(visibility: internal)
    @available(*, renamed: "DataType")
    public typealias D = DataType
    
    @_documentation(visibility: internal)
    @available(*, deprecated, message: "Data readers are no longer instanced directly. Instead, call `data.withDataReader { reader in }`.")
    public init(_ closure: @escaping (_ block: (inout DataType) -> Void) -> Void) {
        self.dataAccess = closure
    }
    
    @_documentation(visibility: internal)
    @available(*, renamed: "DataReaderError")
    public typealias ReadError = DataReaderError
}

#endif
