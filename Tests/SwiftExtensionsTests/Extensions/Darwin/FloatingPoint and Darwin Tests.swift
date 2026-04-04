//
//  FloatingPoint and Darwin Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)

import Darwin
@testable import SwiftExtensions
import Testing

@Suite struct Extensions_Darwin_FloatingPointAndDarwin_Tests {
    @Test
    func ceiling() async {
        #expect(123.45.ceiling == 124.0)
    }
    
    @Test
    func floor() async {
        #expect(123.45.floor == 123.0)
    }
    
    @Test
    func power() async {
        // Double
        #expect(2.0.power(3) == 8.0)
        
        // Float
        #expect(Float(2.0).power(3) == 8.0)
        
        // Float80 is now removed for ARM
        #if !(arch(arm64) || arch(arm) || os(watchOS))
        #expect(Float80(2.0).power(3) == 8.0)
        #endif
    }
}

#endif
