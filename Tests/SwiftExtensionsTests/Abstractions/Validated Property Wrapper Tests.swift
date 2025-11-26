//
//  Validated Property Wrapper Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import SwiftExtensions
import Testing

@Suite struct Abstractions_Validated_Tests {
    @Test
    func validated() {
        struct SomeStruct {
            @Validated({
                $0.clamped(to: 5 ... 10)
            }) var value = 1
        }
        
        var someStruct = SomeStruct()
        
        #expect(someStruct.value == 5) // default value validated
        
        someStruct.value = 2
        #expect(someStruct.value == 5)
        
        someStruct.value = 5
        #expect(someStruct.value == 5)
        
        someStruct.value = 10
        #expect(someStruct.value == 10)
        
        someStruct.value = 11
        #expect(someStruct.value == 10)
    }
}
