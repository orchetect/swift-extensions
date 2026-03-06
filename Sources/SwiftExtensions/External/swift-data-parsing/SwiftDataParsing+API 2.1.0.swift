//
//  SwiftDataParsing.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import SwiftDataParsing

#if canImport(Foundation)

// MARK: - API Changes @ swift-extensions 2.1.0

import struct Foundation.Data
import protocol Foundation.DataProtocol

// MARK: CopyingDataParser.swift

@_documentation(visibility: internal)
@available(*, deprecated, renamed: "CopyingDataParser")
public typealias DataReader = CopyingDataParser

extension CopyingDataParser where DataType == Data {
    @_documentation(visibility: internal)
    @available(*, deprecated, message: "Data parsers are no longer instanced directly. Instead, call `data.withDataParser { parser in }`.")
    @_disfavoredOverload
    public init(_ data: Data) {
        self = data.withCopyingDataParser { $0 }
    }
}

// MARK: InoutDataParser.swift

@_documentation(visibility: internal)
@available(*, deprecated, renamed: "InoutDataParser")
public typealias PassiveDataReader = CopyingDataParser

extension CopyingDataParser {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "DataType")
    public typealias D = DataType
    
    @_documentation(visibility: internal)
    @available(*, deprecated, message: "Data parsers are no longer instanced directly. Instead, call `data.withDataReader { parser in }`.")
    @_disfavoredOverload
    public init(_ closure: @escaping (_ block: (inout DataType) -> Void) -> Void) {
        var data: DataType!
        closure { block in data = block }
        self = data.withCopyingDataParser { $0 }
    }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "DataParserError")
    public typealias ReadError = DataParserError
}

// MARK: DataParserProtocol.swift

extension DataParserProtocol {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "seek(by:)")
    public mutating func advanceBy(_ count: Int) {
        try? seek(by: count)
    }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "readByte(advance:)")
    public mutating func nonAdvancingReadByte() throws(DataParserError) -> DataElement {
        try readByte(advance: false)
    }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "read(advance:)")
    public mutating func nonAdvancingRead() throws(DataParserError) -> DataRange {
        try read(advance: false)
    }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "read(bytes:advance:)")
    public mutating func nonAdvancingRead(bytes count: Int) throws(DataParserError) -> DataRange {
        try read(bytes: count, advance: false)
    }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "seekToStart()")
    public mutating func reset() {
        seekToStart()
    }
}

// MARK: DataEndianness.swift

@_documentation(visibility: internal)
@available(*, deprecated, renamed: "DataEndianness")
public typealias NumberEndianness = DataEndianness

// MARK: DataEndianness+Static.swift

extension DataEndianness {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "platformDefault")
    @inline(__always)
    public static var system: NumberEndianness { platformDefault }
}

#endif
