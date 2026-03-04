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
/// Usage with `Data`:
///
/// ```swift
/// let data = Data( ... )
/// data.withInoutDataReader { reader in
///     if let bytes = reader.read(bytes: 4) { ... }
/// }
/// ```
///
/// Usage with `[UInt8]`:
///
/// ```swift
/// let bytes: [UInt8] = [ ... ]
/// bytes.withInoutDataReader { reader in
///     if let bytes = reader.read(bytes: 4) { ... }
/// }
/// ```
public struct InoutDataReader<DataType: DataReaderDataProtocol>: _DataReaderProtocol where DataType.Index == Int {
    public typealias DataElement = DataType.Element
    public typealias DataRange = DataType.SubSequence
    
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
    
    func _dataByte(at dataIndex: DataType.Index) throws(DataReaderError) -> DataElement {
        withData { $0[dataIndex] }
    }
    
    func _dataBytes(in dataIndexRange: Range<DataType.Index>) throws(DataReaderError) -> DataRange {
        withData { $0[dataIndexRange] }
    }
    
    func _dataBytes(in dataIndexRange: ClosedRange<DataType.Index>) throws(DataReaderError) -> DataRange {
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
    @discardableResult
    public mutating func withInoutDataReader<T, E>(
        _ block: (_ dataReader: inout InoutDataReader<Self>) throws(E) -> T
    ) throws(E) -> T {
        // since `withUnsafe... { }` does not work with typed error throws, we have to use a workaround to get the typed error out
        var result: Result<T, E>!
        
        withUnsafeMutablePointer(to: &self) { ptr in
            var reader = InoutDataReader { $0(&ptr.pointee) }
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
