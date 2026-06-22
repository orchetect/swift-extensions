//
//  RawRepresentableSortComparator.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

/// Allows comparison of instances of a `RawRepresentable` type by using the `Comparable` implementation of
/// the underlying `RawValue` type as a proxy for comparison.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RawRepresentableSortComparator<Compared: RawRepresentable>: SortComparator where Compared.RawValue: Comparable {
    public var order: SortOrder

    public init(type: Compared.Type = Compared.self, order: SortOrder = .forward) {
        self.order = order
    }

    public func compare(_ lhs: Compared, _ rhs: Compared) -> ComparisonResult {
        if lhs.rawValue == rhs.rawValue { return .orderedSame }
        if lhs.rawValue < rhs.rawValue { return .orderedAscending }
        return .orderedDescending
    }
}

#endif
