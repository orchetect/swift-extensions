//
//  PointerDataReader.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Utility to facilitate sequential reading of bytes.
///
/// Usage with `Data`:
///
/// ```swift
/// let data = Data( ... )
/// data.withPointerDataReader { reader in
///     if let bytes = reader.read(bytes: 4) { ... }
/// }
/// ```
///
/// Usage with `[UInt8]`:
///
/// ```swift
/// let bytes: [UInt8] = [ ... ]
/// bytes.withPointerDataReader { reader in
///     if let bytes = reader.read(bytes: 4) { ... }
/// }
/// ```
public struct PointerDataReader: _DataReaderProtocol {
    public typealias DataType = Data
    public typealias DataPointer = UnsafeBufferPointer<UInt8>
    
    let dataPointer: DataPointer
    
    // MARK: - Init
    
    public init(pointer: UnsafeBufferPointer<UInt8>) {
        dataPointer = pointer
    }
    
    // MARK: - State
    
    public internal(set) var readOffset = 0
    
    // MARK: - Internal
    
    func _dataSize() -> Int {
        withData { $0.count }
    }
    
    @inlinable
    func _dataStartIndex() -> DataType.Index {
        withData { $0.startIndex }
    }
    
    @inlinable
    func _dataReadOffsetIndex(offsetBy offset: Int) -> DataType.Index {
        withData { $0.index($0.startIndex, offsetBy: readOffset + offset) }
    }
    
    @inlinable
    func _dataByte(at dataIndex: DataType.Index) throws(DataReaderError) -> UInt8 {
        withData { $0[dataIndex] }
    }
    
    func _dataBytes(in dataIndexRange: Range<DataType.Index>) throws(DataReaderError) -> DataType.SubSequence {
        withData {
            let bytes = $0.extracting(dataIndexRange) /* $0[dataIndexRange] */
            let wrapped = DataType.SubSequence(bytes)
            return wrapped
        }
    }
    
    func _dataBytes(in dataIndexRange: ClosedRange<DataType.Index>) throws(DataReaderError) -> DataType.SubSequence {
        withData {
            let bytes = $0.extracting(dataIndexRange) /* $0[dataIndexRange] */
            let wrapped = DataType.SubSequence(bytes)
            return wrapped
        }
    }
    
    // MARK: - Helpers
    
    @inline(__always) @usableFromInline
    func withData<T>(_ block: (_ pointer: UnsafeBufferPointer<UInt8>) -> T) -> T {
        block(dataPointer)
    }
}

// MARK: - DataProtocol Extensions

extension DataProtocol {
    /// Accesses the data by way of unsafe pointer access by providing a ``PointerDataReader`` instance to a closure.
    @discardableResult
    public func withPointerDataReader<T, E>(
        _ block: (_ dataReader: inout PointerDataReader) throws(E) -> T
    ) throws(E) -> T {
        // since `withUnsafeBytes { }` does not work with typed error throws, we have to use a workaround to get the typed error out
        var result: Result<T, E>!
        withUnsafeBytes(of: Self.self) { ptr in
            let boundPtr = ptr.assumingMemoryBound(to: UInt8.self)
            var reader = PointerDataReader(pointer: boundPtr)
            do throws(E) {
                result = .success(try block(&reader))
            } catch {
                result = .failure(error)
            }
        }
        return try result.get()
    }
}
