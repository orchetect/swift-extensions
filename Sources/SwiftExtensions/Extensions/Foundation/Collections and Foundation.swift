//
//  Collections and Foundation.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
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

#endif
