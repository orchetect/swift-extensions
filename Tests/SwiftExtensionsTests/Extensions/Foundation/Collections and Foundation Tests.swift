//
//  Collections and Foundation Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import SwiftExtensions
import Testing

@Suite struct Extensions_Foundation_Collections_Tests {
    @Test
    func comparisonResultInverted() {
        #expect(ComparisonResult.orderedAscending.inverted == .orderedDescending)
        #expect(ComparisonResult.orderedSame.inverted == .orderedSame)
        #expect(ComparisonResult.orderedDescending.inverted == .orderedAscending)
    }
}

#endif
