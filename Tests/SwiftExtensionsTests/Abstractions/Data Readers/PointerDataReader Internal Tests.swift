//
//  PointerDataReader Internal Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftExtensions
import Testing

@Suite struct Abstractions_PointerDataReader_Internal_Tests {
    @Test
    func internals() async throws {
        let data = Data([0x01, 0x02, 0x03, 0x04])
        
        try data.withPointerDataReader { dr in
            #expect(dr._dataSize() == 4)
            
            #expect(dr._dataStartIndex() == 0)
            
            #expect(dr._dataReadOffsetIndex(offsetBy: 0) == 0)
            #expect(dr._dataReadOffsetIndex(offsetBy: 1) == 1)
            #expect(dr._dataReadOffsetIndex(offsetBy: 2) == 2)
            
            try #expect(dr._dataByte(at: 0) == 0x01)
            try #expect(dr._dataByte(at: 1) == 0x02)
            try #expect(dr._dataByte(at: 2) == 0x03)
            try #expect(dr._dataByte(at: 3) == 0x04)
            
            try #expect(dr._dataBytes(in: 0 ... 0) == [0x01])
            try #expect(dr._dataBytes(in: 1 ... 1) == [0x02])
            try #expect(dr._dataBytes(in: 2 ... 2) == [0x03])
            try #expect(dr._dataBytes(in: 3 ... 3) == [0x04])
            try #expect(dr._dataBytes(in: 0 ... 1) == [0x01, 0x02])
            try #expect(dr._dataBytes(in: 0 ... 3) == [0x01, 0x02, 0x03, 0x04])
            try #expect(dr._dataBytes(in: 1 ... 3) == [0x02, 0x03, 0x04])
        }
    }
}
