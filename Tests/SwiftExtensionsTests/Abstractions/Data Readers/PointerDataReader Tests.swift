//
//  PointerDataReader Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftExtensions
import Testing

@Suite struct Abstractions_PointerDataReader_Tests {
    // MARK: - Data storage starting with index 0
    
    @Test
    func read() throws {
        let data = Data([0x01, 0x02, 0x03, 0x04])
        
        // .read(bytes:)
        try data.withPointerDataReader { dr in
            #expect(dr.readOffset == 0)
            #expect(dr.remainingByteCount == 4)
            try #expect(dr.read(bytes: 1) == Data([0x01]))
            #expect(dr.remainingByteCount == 3)
            try #expect(dr.read(bytes: 1) == Data([0x02]))
            #expect(dr.remainingByteCount == 2)
            try #expect(dr.read(bytes: 1) == Data([0x03]))
            #expect(dr.remainingByteCount == 1)
            try #expect(dr.read(bytes: 1) == Data([0x04]))
            #expect(dr.remainingByteCount == 0)
            #expect(throws: (any Error).self) { try dr.read(bytes: 1) }
            #expect(dr.remainingByteCount == 0)
        }
        
        // .readByte()
        try data.withPointerDataReader { dr in
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
        try data.withPointerDataReader { dr in
            try #expect(dr.read() == data)
            #expect(throws: (any Error).self) { try dr.read(bytes: 1) }
        }
        
        // .read - zero count read - return empty data, not nil
        try data.withPointerDataReader { dr in
            try #expect(dr.read(bytes: 0) == Data())
        }
        
        // .read - read overflow - return nil
        data.withPointerDataReader { dr in
            #expect(throws: (any Error).self) { try dr.read(bytes: 5) }
        }
    }
    
//    @Test
//    func nonAdvancingRead() throws {
//        let data = Data([0x01, 0x02, 0x03, 0x04])
//        
//        // .nonAdvancingRead - nil read - return all remaining bytes
//        try data.withPointerDataReader { dr in
//            #expect(try dr.nonAdvancingRead() == data)
//            #expect(try dr.read(bytes: 1) == Data([0x01]))
//        }
//        
//        // single bytes
//        try data.withPointerDataReader { dr in
//            #expect(try dr.nonAdvancingReadByte() == data[0])
//            #expect(try dr.nonAdvancingReadByte() == data[0])
//            #expect(try dr.readByte() == data[0])
//            #expect(try dr.readByte() == data[1])
//        }
//        
//        // .nonAdvancingRead - read byte counts
//        try data.withPointerDataReader { dr in
//            #expect(try dr.nonAdvancingRead(bytes: 1) == Data([0x01]))
//            #expect(try dr.nonAdvancingRead(bytes: 2) == Data([0x01, 0x02]))
//        }
//        
//        // .nonAdvancingRead - read overflow - return nil
//        try data.withPointerDataReader { dr in
//            #expect(throws: (any Error).self) { try dr.nonAdvancingRead(bytes: 5) }
//            #expect(try dr.read(bytes: 1) == Data([0x01]))
//        }
//    }
//    
//    @Test
//    func advanceBy() throws {
//        let data = Data([0x01, 0x02, 0x03, 0x04])
//        
//        // advanceBy
//        try data.withPointerDataReader { dr in
//            dr.advanceBy(1)
//            #expect(try dr.read(bytes: 1) == Data([0x02]))
//        }
//    }
//    
//    @Test
//    func reset() throws {
//        let data = Data([0x01, 0x02, 0x03, 0x04])
//        
//        // reset
//        try data.withPointerDataReader { dr in
//            #expect(try dr.read(bytes: 1) == Data([0x01]))
//            #expect(try dr.read(bytes: 2) == Data([0x02, 0x03]))
//            dr.reset()
//            #expect(try dr.read(bytes: 1) == Data([0x01]))
//        }
//    }
//    
//    /// Test to ensure closure does not capture the data.
//    @Test
//    func readMutation() throws {
//        let data = Data([0x01, 0x02, 0x03, 0x04])
//        
//        try data.withPointerDataReader { dr in
//            #expect(dr.readOffset == 0)
//            #expect(try dr.read(bytes: 1) == Data([0x01]))
//            #expect(try dr.read(bytes: 1) == Data([0x02]))
//        }
//    }
//    
//    @Test
//    func readMutationB() throws {
//        let data = Data([0x0A, 0x0B, 0x0C, 0x0D])
//        
//        try data.withPointerDataReader { dr in
//            #expect(try dr.read(bytes: 1) == Data([0x0C]))
//            #expect(try dr.read(bytes: 1) == Data([0x0D]))
//            #expect(throws: (any Error).self) { try dr.read(bytes: 1) }
//        }
//    }
//    
//    // MARK: - Data storage starting with index >0
//    
//    @Test
//    func read_DataIndicesOffset()throws  {
//        let rawData = Data([0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04])
//        let data = rawData[3 ... 6]
//        
//        // .read - byte by byte
//        try data.withPointerDataReader { dr in
//            #expect(dr.readOffset == 0)
//            #expect(try dr.read(bytes: 1) == Data([0x01]))
//            #expect(try dr.read(bytes: 1) == Data([0x02]))
//            #expect(try dr.read(bytes: 1) == Data([0x03]))
//            #expect(try dr.read(bytes: 1) == Data([0x04]))
//            #expect(throws: (any Error).self) { try dr.read(bytes: 1) }
//        }
//        
//        // .read - nil read - return all remaining bytes
//        try data.withPointerDataReader { dr in
//            #expect(try dr.read() == data)
//            #expect(throws: (any Error).self) { try dr.read(bytes: 1) }
//        }
//        
//        // .read - zero count read - return empty data, not nil
//        try data.withPointerDataReader { dr in
//            #expect(try dr.read(bytes: 0) == Data())
//        }
//        
//        // .read - read overflow - return nil
//        try data.withPointerDataReader { dr in
//            #expect(throws: (any Error).self) { try dr.read(bytes: 5) }
//        }
//    }
//    
//    @Test
//    func nonAdvancingRead_DataIndicesOffset() throws {
//        let rawData = Data([0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04])
//        let data = rawData[3 ... 6]
//        
//        // .nonAdvancingRead - nil read - return all remaining bytes
//        try data.withPointerDataReader { dr in
//            #expect(try dr.nonAdvancingRead() == data)
//            #expect(try dr.read(bytes: 1) == Data([0x01]))
//        }
//        
//        // .nonAdvancingRead - read byte counts
//        try data.withPointerDataReader { dr in
//            #expect(try dr.nonAdvancingRead(bytes: 1) == Data([0x01]))
//            #expect(try dr.nonAdvancingRead(bytes: 2) == Data([0x01, 0x02]))
//        }
//        
//        // .nonAdvancingRead - read overflow - return nil
//        try data.withPointerDataReader { dr in
//            #expect(throws: (any Error).self) { try dr.nonAdvancingRead(bytes: 5) }
//            #expect(try dr.read(bytes: 1) == Data([0x01]))
//        }
//        
//        // .nonAdvancingRead - read overflow - return nil
//        try data.withPointerDataReader { dr in
//            #expect(throws: (any Error).self) { try dr.read(bytes: 8) }
//        }
//    }
//    
//    @Test
//    func advanceBy_DataIndicesOffset() throws {
//        let rawData = Data([0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04])
//        let data = rawData[3 ... 6]
//        
//        // advanceBy
//        try data.withPointerDataReader { dr in
//            dr.advanceBy(1)
//            #expect(try dr.read(bytes: 1) == Data([0x02]))
//        }
//    }
//    
//    @Test
//    func reset_DataIndicesOffset() throws {
//        let rawData = Data([0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04])
//        let data = rawData[3 ... 6]
//        
//        // reset
//        try data.withPointerDataReader { dr in
//            #expect(try dr.read(bytes: 1) == Data([0x01]))
//            #expect(try dr.read(bytes: 2) == Data([0x02, 0x03]))
//            dr.reset()
//            #expect(try dr.read(bytes: 1) == Data([0x01]))
//        }
//    }
//    
//    @Test
//    func withPointerDataReader() throws {
//        let data = Data([0x01, 0x02, 0x03, 0x04])
//        
//        try data.withPointerDataReader { reader in
//            #expect(reader.readOffset == 0)
//            try #expect(reader.read(bytes: 1) == Data([0x01]))
//            try #expect(reader.read(bytes: 1) == Data([0x02]))
//            try #expect(reader.read(bytes: 1) == Data([0x03]))
//            try #expect(reader.read(bytes: 1) == Data([0x04]))
//            #expect(throws: (any Error).self) { try reader.read(bytes: 1) }
//        }
//        
//        struct TestError: Error { }
//        
//        #expect(throws: (any Error).self) {
//            try data.withPointerDataReader { reader in
//                throw TestError()
//            }
//        }
//    }
//    
//    @Test
//    func withPointerDataReader_ReturnsValue() throws {
//        let data = Data([0x01, 0x02, 0x03, 0x04])
//        
//        #if swift(>=5.7)
//        let getByte = try data.withPointerDataReader { reader in
//            _ = try reader.readByte()
//            return try reader.readByte()
//        }
//        #else
//        let getByte: UInt8 = try data.withPointerDataReader { reader in
//            _ = try reader.readByte()
//            return try reader.readByte()
//        }
//        #endif
//        
//        #expect(getByte == 0x02)
//    }
}
