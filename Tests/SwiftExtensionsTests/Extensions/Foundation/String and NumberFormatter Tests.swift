//
//  String and NumberFormatter Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import SwiftExtensions
import Testing

@Suite struct Extensions_Foundation_StringAndNumberFormatter_Tests {
    @Test
    func stringInterpolationFormatter() {
        #expect("\(3, format: .ordinal)" == "3rd")
        #expect("\(3, format: .spellOut)" == "three")
    }
}

#endif
