//
//  Collections and Foundation Tests.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import SwiftExtensions
import Testing

@Suite
struct Extensions_Foundation_Collections_Tests {
    // MARK: - Comparison

    @Test
    func comparisonResultInverted() {
        #expect(ComparisonResult.orderedAscending.inverted == .orderedDescending)
        #expect(ComparisonResult.orderedSame.inverted == .orderedSame)
        #expect(ComparisonResult.orderedDescending.inverted == .orderedAscending)
    }

    // MARK: - contains(caseInsensitive:)

    @Test
    func containsCaseInsensitive() {
        let strings: [String] = ["abc", "example", "Some.String", "Emoji 😀"]

        #expect(strings.contains(caseInsensitive: "example"))
        #expect(strings.contains(caseInsensitive: "EXAMPLE"))
        #expect(strings.contains(caseInsensitive: "some.string"))
        #expect(strings.contains(caseInsensitive: "Some.String"))
        #expect(strings.contains(caseInsensitive: "SOME.STRING"))
        #expect(strings.contains(caseInsensitive: "emoji 😀"))
        #expect(strings.contains(caseInsensitive: "Emoji 😀"))
        #expect(strings.contains(caseInsensitive: "EMOJI 😀"))

        #expect(!strings.contains(caseInsensitive: "example "))
        #expect(!strings.contains(caseInsensitive: " example"))
        #expect(!strings.contains(caseInsensitive: "zzz"))
        #expect(!strings.contains(caseInsensitive: ""))
    }
}

#endif
