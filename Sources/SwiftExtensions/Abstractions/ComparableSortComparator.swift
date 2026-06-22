//
//  RawRepresentableSortComparator.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

/// Allows comparison of instances of a `Comparable` type using standard equality and comparison operators.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ComparableSortComparator<Compared: Comparable>: SortComparator {
    public var order: SortOrder

    public init(type: Compared.Type = Compared.self, order: SortOrder = .forward) {
        self.order = order
    }

    public func compare(_ lhs: Compared, _ rhs: Compared) -> ComparisonResult {
        let forwardOrder: ComparisonResult = if lhs == rhs { .orderedSame }
        else if lhs < rhs { .orderedAscending }
        else { .orderedDescending }

        return switch order {
        case .forward: forwardOrder
        case .reverse: forwardOrder.inverted
        }
    }
}

#endif
