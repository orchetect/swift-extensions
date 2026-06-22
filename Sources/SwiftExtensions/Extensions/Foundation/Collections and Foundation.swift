//
//  Collections and Foundation.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

// MARK: - Comparison

extension ComparisonResult {
    /// Returns the inverted comparison result.
    @inlinable @_disfavoredOverload
    public var inverted: Self {
        switch self {
        case .orderedAscending: .orderedDescending
        case .orderedSame: .orderedSame
        case .orderedDescending: .orderedAscending
        }
    }
}

// MARK: - StringProtocol contains(caseInsensitive:)

extension Sequence where Element: StringProtocol {
    /// Returns a Boolean value indicating whether the sequence contains the given element, using
    /// a case-insensitive string comparison.
    @inlinable @_disfavoredOverload
    public func contains(caseInsensitive string: some StringProtocol) -> Bool {
        contains { element in
            element.caseInsensitiveCompare(string) == .orderedSame
        }
    }
}

#endif
