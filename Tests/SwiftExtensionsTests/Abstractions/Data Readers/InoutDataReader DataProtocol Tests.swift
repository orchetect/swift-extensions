//
//  InoutDataReader DataProtocol Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
import SwiftExtensions
import Testing

@Suite struct Abstractions_InoutDataReader_DataProtocol_Tests {
    @Test
    func dataProtocolGenerics() async throws {
        var data = Data([0x01, 0x02, 0x03, 0x04])
        
        try await readGenericData(data: &data)
    }
    
    func readGenericData<D: DataProtocol>(data: inout D) async throws {
        try data.withInoutDataReader { dr in
            // basic test
            try #expect(dr.readByte() == 0x01)
            try #expect(dr.readByte() == 0x02)
            try #expect(dr.readByte() == 0x03)
            try #expect(dr.readByte() == 0x04)
        }
    }
}

#endif
