//
//  PointerDataReader.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import struct Foundation.Data
import protocol Foundation.DataProtocol

/// Utility to facilitate sequential reading of bytes.
///
/// This type is not meant to be initialized directly, but rather used within a call to `<data>.withPointerDataReader { reader in }`.
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
public struct PointerDataReader<DataType: DataReaderDataProtocol>: _DataReaderProtocol where DataType.Index == Int {
    public typealias DataElement = DataType.Element
    public typealias DataRange = DataType.SubSequence
    
    private let pointer: UnsafeBufferPointer<UInt8>
    
    // MARK: - Init
    
    init(pointer: UnsafeBufferPointer<UInt8>) {
        self.pointer = pointer
    }
    
    // MARK: - State
    
    public internal(set) var readOffset = 0
    
    // MARK: - Internal
    
    func _dataSize() -> Int {
        withData { $0.count }
    }
    
    @inlinable
    func _dataStartIndex() -> DataType.Index {
        withData { $0.indices.lowerBound }
    }
    
    @inlinable
    func _dataReadOffsetIndex(offsetBy offset: Int) -> DataType.Index {
        withData { $0.indices.lowerBound.advanced(by: readOffset + offset) }
    }
    
    @inlinable
    func _dataByte(at dataIndex: DataType.Index) throws(DataReaderError) -> DataElement {
        withData { $0[dataIndex] }
    }
    
    func _dataBytes(in dataIndexRange: Range<DataType.Index>) throws(DataReaderError) -> DataRange {
        withData {
            let bytes = $0.extracting(dataIndexRange) /* $0[dataIndexRange] */
            let wrapped = DataType.subSequence(from: bytes)
            return wrapped
        }
    }
    
    func _dataBytes(in dataIndexRange: ClosedRange<DataType.Index>) throws(DataReaderError) -> DataRange {
        withData {
            let bytes = $0.extracting(dataIndexRange) /* $0[dataIndexRange] */
            let wrapped = DataType.subSequence(from: bytes)
            return wrapped
        }
    }
    
    // MARK: - Helpers
    
    @inline(__always) @usableFromInline
    func withData<T>(_ block: (UnsafeBufferPointer<UInt8>) -> T) -> T {
        block(pointer)
    }
}

// MARK: - DataProtocol Extensions

// Note that implementation on the `DataProtocol` protocol itself will not reliably get us the pointer we need.
// Instead, individual implementations on `Data` and `[UInt8]` are required in order to acquire the correct pointers.

extension Data {
    /// Accesses the data by way of unsafe pointer access by providing a ``PointerDataReader`` instance to a closure.
    @discardableResult
    public func withPointerDataReader<T, E>(
        _ block: (_ dataReader: inout PointerDataReader<Self>) throws(E) -> T
    ) throws(E) -> T {
        // since `withUnsafe... { }` does not work with typed error throws, we have to use a workaround to get the typed error out
        var result: Result<T, E>!
        withUnsafeBytes { ptr in
            let boundPtr = ptr.assumingMemoryBound(to: UInt8.self)
            var reader = PointerDataReader<Self>(pointer: boundPtr)
            do throws(E) {
                result = .success(try block(&reader))
            } catch {
                result = .failure(error)
            }
        }
        return try result.get()
    }
}

extension [UInt8] {
    /// Accesses the data by way of unsafe pointer access by providing a ``PointerDataReader`` instance to a closure.
    @discardableResult
    public func withPointerDataReader<T, E>(
        _ block: (_ dataReader: inout PointerDataReader<Self>) throws(E) -> T
    ) throws(E) -> T {
        // since `withUnsafe... { }` does not work with typed error throws, we have to use a workaround to get the typed error out
        var result: Result<T, E>!
        self.withUnsafeBytes { ptr in
            let boundPtr = ptr.assumingMemoryBound(to: UInt8.self)
            var reader = PointerDataReader<Self>(pointer: boundPtr)
            do throws(E) {
                result = .success(try block(&reader))
            } catch {
                result = .failure(error)
            }
        }
        return try result.get()
    }
}

extension [UInt8].SubSequence {
    /// Accesses the data by way of unsafe pointer access by providing a ``PointerDataReader`` instance to a closure.
    @discardableResult
    public func withPointerDataReader<T, E>(
        _ block: (_ dataReader: inout PointerDataReader<Self>) throws(E) -> T
    ) throws(E) -> T {
        // since `withUnsafe... { }` does not work with typed error throws, we have to use a workaround to get the typed error out
        var result: Result<T, E>!
        self.withUnsafeBytes { ptr in
            let boundPtr = ptr.assumingMemoryBound(to: UInt8.self)
            var reader = PointerDataReader<Self>(pointer: boundPtr)
            do throws(E) {
                result = .success(try block(&reader))
            } catch {
                result = .failure(error)
            }
        }
        return try result.get()
    }
}

#endif
