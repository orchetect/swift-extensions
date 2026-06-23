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
public struct RawRepresentableSortComparator<
    Compared: RawRepresentable,
    RawValueComparator: SortComparator
>: SortComparator where Compared.RawValue: Comparable, RawValueComparator.Compared == Compared.RawValue {
    public var comparator: RawValueComparator
    public var order: SortOrder

    public init(
        type: Compared.Type = Compared.self,
        order: SortOrder = .forward
    ) where RawValueComparator == ComparableSortComparator<Compared.RawValue> {
        comparator = ComparableSortComparator(order: order)
        self.order = order
    }

    /// Acts as a proxy for another sort comparator that acts upon the raw value of the type.
    public init(
        type: Compared.Type = Compared.self,
        wrapping comparator: RawValueComparator,
        order: SortOrder = .forward
    ) {
        self.comparator = comparator
        self.order = order
    }

    public func compare(_ lhs: Compared, _ rhs: Compared) -> ComparisonResult {
        comparator.compare(lhs.rawValue, rhs.rawValue)
    }
}

extension Sequence where Element: RawRepresentable, Element.RawValue: Comparable {
    /// Returns the sequence sorted using the given sort comparator by evaluating the `Comparable` implementation
    /// of the underlying `RawValue` type.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    @_disfavoredOverload
    public func sortedByRawValue<Comparator: SortComparator>(
        using comparator: Comparator
    ) -> [Element] where Comparator.Compared == Element.RawValue {
        sorted(using: RawRepresentableSortComparator(wrapping: comparator))
    }
}

extension MutableCollection where Self: RandomAccessCollection, Element: RawRepresentable, Element.RawValue: Comparable {
    /// Sorts the sequence in-place using the given sort comparator by evaluating the `Comparable` implementation
    /// of the underlying `RawValue` type.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    @_disfavoredOverload
    public mutating func sortByRawValue<Comparator: SortComparator>(
        using comparator: Comparator
    ) where Comparator.Compared == Element.RawValue {
        sort(using: RawRepresentableSortComparator(wrapping: comparator))
    }
}

#endif
