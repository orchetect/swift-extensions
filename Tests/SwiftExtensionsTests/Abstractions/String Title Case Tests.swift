//
//  String Title Case Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import SwiftExtensions
import Testing

@Suite struct Abstractions_StringTitleCase_Tests {
    @Test
    func titleCased() {
        #expect("this".titleCased == "This")
        #expect("this thing".titleCased == "This Thing")
        #expect("this is a test".titleCased == "This is a Test")
    }
}
