//
//  InoutDataReader Deprecations Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
import SwiftExtensions
import Testing

@Suite struct Abstractions_InoutDataReader_Deprecations_Tests {
    // MARK: - API Changes in 2.1.0
    
    @Test
    func deprecationTest() async throws {
        var data = Data([0x01, 0x02])
        
        // old type name, expect a fixit to show on this line to use new data reader API
        var dr = PassiveDataReader { $0(&data) }
        
        #expect(try dr.readByte() == 0x01)
        #expect(try dr.readByte() == 0x02)
        #expect((try? dr.readByte()) == nil)
    }
}

#endif
