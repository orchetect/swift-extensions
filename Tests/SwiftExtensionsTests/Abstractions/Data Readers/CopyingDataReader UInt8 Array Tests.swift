//
//  CopyingDataReader UInt8 Array Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftExtensions
import Testing

/// Identical to `Data` tests, except using `[Int8]` as base data type instead.
@Suite struct Abstractions_CopyingDataReader_UInt8Array_Tests {
    // MARK: - Data storage starting with index 0
    
    @Test
    func read() async throws {
        var data: [UInt8] = [0x01, 0x02, 0x03, 0x04]
        
        // .read(bytes:)
        try data.withCopyingDataReader { dr in
            #expect(dr.readOffset == 0)
            #expect(dr.remainingByteCount == 4)
            try #expect(dr.read(bytes: 1) == [0x01])
            #expect(dr.remainingByteCount == 3)
            try #expect(dr.read(bytes: 1) == [0x02])
            #expect(dr.remainingByteCount == 2)
            try #expect(dr.read(bytes: 1) == [0x03])
            #expect(dr.remainingByteCount == 1)
            try #expect(dr.read(bytes: 1) == [0x04])
            #expect(dr.remainingByteCount == 0)
            #expect(throws: (any Error).self) { try dr.read(bytes: 1) }
            #expect(dr.remainingByteCount == 0)
        }
        
        // .readByte()
        try data.withCopyingDataReader { dr in
            #expect(dr.readOffset == 0)
            #expect(dr.remainingByteCount == 4)
            try #expect(dr.readByte() == 0x01)
            #expect(dr.remainingByteCount == 3)
            try #expect(dr.readByte() == 0x02)
            #expect(dr.remainingByteCount == 2)
            try #expect(dr.readByte() == 0x03)
            #expect(dr.remainingByteCount == 1)
            try #expect(dr.readByte() == 0x04)
            #expect(dr.remainingByteCount == 0)
            #expect(throws: (any Error).self) { try dr.readByte() }
            #expect(dr.remainingByteCount == 0)
        }
        
        // .read - nil read - return all remaining bytes
        try data.withCopyingDataReader { dr in
            try #expect(dr.read() == [0x01, 0x02, 0x03, 0x04])
            #expect(throws: (any Error).self) { try dr.read(bytes: 1) }
        }
        
        // .read - zero count read - return empty data, not nil
        try data.withCopyingDataReader { dr in
            try #expect(dr.read(bytes: 0) == [])
        }
        
        // .read - read overflow - return nil
        data.withCopyingDataReader { dr in
            #expect(throws: (any Error).self) { try dr.read(bytes: 5) }
        }
    }
    
    @Test
    func nonAdvancingRead() async throws {
        var data: [UInt8] = [0x01, 0x02, 0x03, 0x04]
        
        // .nonAdvancingRead - nil read - return all remaining bytes
        try data.withCopyingDataReader { dr in
            try #expect(dr.nonAdvancingRead() == [0x01, 0x02, 0x03, 0x04])
            try #expect(dr.read(bytes: 1) == [0x01])
        }
        
        // single bytes
        try data.withCopyingDataReader { dr in
            try #expect(dr.nonAdvancingReadByte() == 0x01)
            try #expect(dr.nonAdvancingReadByte() == 0x01)
            try #expect(dr.readByte() == 0x01)
            try #expect(dr.readByte() == 0x02)
        }
        
        // .nonAdvancingRead - read byte counts
        try data.withCopyingDataReader { dr in
            try #expect(dr.nonAdvancingRead(bytes: 1) == [0x01])
            try #expect(dr.nonAdvancingRead(bytes: 2) == [0x01, 0x02])
        }
        
        // .nonAdvancingRead - read overflow - return nil
        try data.withCopyingDataReader { dr in
            #expect(throws: (any Error).self) { try dr.nonAdvancingRead(bytes: 5) }
            try #expect(dr.read(bytes: 1) == [0x01])
        }
    }
    
    @Test
    func advanceBy() async throws {
        var data: [UInt8] = [0x01, 0x02, 0x03, 0x04]
        
        // advanceBy
        try data.withCopyingDataReader { dr in
            dr.advanceBy(1)
            try #expect(dr.read(bytes: 1) == [0x02])
        }
    }
    
    @Test
    func reset() async throws {
        var data: [UInt8] = [0x01, 0x02, 0x03, 0x04]
        
        // reset
        try data.withCopyingDataReader { dr in
            try #expect(dr.read(bytes: 1) == [0x01])
            try #expect(dr.read(bytes: 2) == [0x02, 0x03])
            dr.reset()
            try #expect(dr.read(bytes: 1) == [0x01])
        }
    }
    
    // MARK: - Data storage starting with index >0
    
    @Test
    func read_DataIndicesOffset() async throws {
        let rawData: [UInt8] = [0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04]
        var data = rawData[3 ... 6]
        
        // .read - byte by byte
        try data.withCopyingDataReader { dr in
            #expect(dr.readOffset == 0)
            try #expect(dr.read(bytes: 1) == [0x01])
            try #expect(dr.read(bytes: 1) == [0x02])
            try #expect(dr.read(bytes: 1) == [0x03])
            try #expect(dr.read(bytes: 1) == [0x04])
            #expect(throws: (any Error).self) { try dr.read(bytes: 1) }
        }
        
        // .read - nil read - return all remaining bytes
        try data.withCopyingDataReader { dr in
            try #expect(dr.read() == [0x01, 0x02, 0x03, 0x04])
            #expect(throws: (any Error).self) { try dr.read(bytes: 1) }
        }
        
        // .read - zero count read - return empty data, not nil
        try data.withCopyingDataReader { dr in
            try #expect(dr.read(bytes: 0) == [])
        }
        
        // .read - read overflow - return nil
        data.withCopyingDataReader { dr in
            #expect(throws: (any Error).self) { try dr.read(bytes: 5) }
        }
    }
    
    @Test
    func nonAdvancingRead_DataIndicesOffset() async throws {
        let rawData: [UInt8] = [0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04]
        var data = rawData[3 ... 6]
        
        // .nonAdvancingRead - nil read - return all remaining bytes
        try data.withCopyingDataReader { dr in
            try #expect(dr.nonAdvancingRead() == [0x01, 0x02, 0x03, 0x04])
            try #expect(dr.read(bytes: 1) == [0x01])
        }
        
        // .nonAdvancingRead - read byte counts
        try data.withCopyingDataReader { dr in
            try #expect(dr.nonAdvancingRead(bytes: 1) == [0x01])
            try #expect(dr.nonAdvancingRead(bytes: 2) == [0x01, 0x02])
        }
        
        // .nonAdvancingRead - read overflow - return nil
        try data.withCopyingDataReader { dr in
            #expect(throws: (any Error).self) { try dr.nonAdvancingRead(bytes: 5) }
            try #expect(dr.read(bytes: 1) == [0x01])
        }
        
        // .nonAdvancingRead - read overflow - return nil
        data.withCopyingDataReader { dr in
            #expect(throws: (any Error).self) { try dr.read(bytes: 8) }
        }
    }
    
    @Test
    func advanceBy_DataIndicesOffset() async throws {
        let rawData: [UInt8] = [0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04]
        var data = rawData[3 ... 6]
        
        // advanceBy
        try data.withCopyingDataReader { dr in
            dr.advanceBy(1)
            try #expect(dr.read(bytes: 1) == [0x02])
        }
    }
    
    @Test
    func reset_DataIndicesOffset() async throws {
        let rawData: [UInt8] = [0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04]
        var data = rawData[3 ... 6]
        
        // reset
        try data.withCopyingDataReader { dr in
            try #expect(dr.read(bytes: 1) == [0x01])
            try #expect(dr.read(bytes: 2) == [0x02, 0x03])
            dr.reset()
            try #expect(dr.read(bytes: 1) == [0x01])
        }
    }
    
    @Test
    func withCopyingDataReader() async throws {
        var data: [UInt8] = [0x01, 0x02, 0x03, 0x04]
        
        try data.withCopyingDataReader { reader in
            #expect(reader.readOffset == 0)
            try #expect(reader.read(bytes: 1) == [0x01])
            try #expect(reader.read(bytes: 1) == [0x02])
            try #expect(reader.read(bytes: 1) == [0x03])
            try #expect(reader.read(bytes: 1) == [0x04])
            #expect(throws: (any Error).self) { try reader.read(bytes: 1) }
        }
        
        struct TestError: Error { }
        
        #expect(throws: (any Error).self) {
            try data.withCopyingDataReader { reader in
                throw TestError()
            }
        }
    }
    
    @Test
    func withCopyingDataReader_ReturnsValue() async throws {
        var data: [UInt8] = [0x01, 0x02, 0x03, 0x04]

        #if swift(>=5.7)
        let getByte = try data.withCopyingDataReader { reader in
            _ = try reader.readByte()
            return try reader.readByte()
        }
        #else
        let getByte: UInt8 = try data.withCopyingDataReader { reader in
            _ = try reader.readByte()
            return try reader.readByte()
        }
        #endif

        #expect(getByte == 0x02)
    }
}
