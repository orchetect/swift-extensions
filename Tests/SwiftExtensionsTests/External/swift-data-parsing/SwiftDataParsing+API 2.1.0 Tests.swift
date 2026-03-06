//
//  SwiftDataParsing+API 2.1.0 Tests.swift
//  swift-data-parsing • https://github.com/orchetect/swift-data-parsing
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
import SwiftExtensions
import Testing

/// API Changes @ swift-extensions 2.1.0
@Suite struct SwiftDataParsing_API_2_1_0_Tests {
    @Test
    func dataReaderInit() async throws {
        let data = Data([0x01, 0x02])
        
        // old type name, expect a fixit to show on this line to use new data parser API
        var parser = DataReader(data)
        
        #expect(try parser.readByte() == 0x01)
        #expect(try parser.readByte() == 0x02)
        #expect((try? parser.readByte()) == nil)
        
        parser.reset()
        #expect(parser.readOffset == 0)
        
        parser.advanceBy(1)
        #expect(parser.readOffset == 1)
        
        #expect(try parser.nonAdvancingReadByte() == 0x02)
        #expect(parser.readOffset == 1)
        
        parser.reset()
        #expect(try parser.nonAdvancingRead() == [0x01, 0x02])
        #expect(parser.readOffset == 0)
        
        #expect(try parser.nonAdvancingRead(bytes: 1) == [0x01])
        #expect(parser.readOffset == 0)
    }
    
    @Test
    func passiveDataReaderInit() async throws {
        var data = Data([0x01, 0x02])
        
        // old type name, expect a fixit to show on this line to use new data parser API
        var parser = PassiveDataReader { $0(&data) }
        
        #expect(try parser.readByte() == 0x01)
        #expect(try parser.readByte() == 0x02)
        #expect((try? parser.readByte()) == nil)
        
        parser.reset()
        #expect(parser.readOffset == 0)
        
        parser.advanceBy(1)
        #expect(parser.readOffset == 1)
        
        #expect(try parser.nonAdvancingReadByte() == 0x02)
        #expect(parser.readOffset == 1)
        
        parser.reset()
        #expect(try parser.nonAdvancingRead() == [0x01, 0x02])
        #expect(parser.readOffset == 0)
        
        #expect(try parser.nonAdvancingRead(bytes: 1) == [0x01])
        #expect(parser.readOffset == 0)
    }
}

#endif
