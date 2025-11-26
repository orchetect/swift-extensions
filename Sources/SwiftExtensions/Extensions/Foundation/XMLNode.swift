//
//  XMLNode.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

// This is Mac-only because even though XMLNode exists in Foundation, it is only available on macOS
#if os(macOS)

import Foundation

// MARK: - Typing

extension XMLNode {
    /// Returns `self` typed as `XMLElement`.
    @inlinable @_disfavoredOverload
    public var asElement: XMLElement? {
        self as? XMLElement
    }
    
    /// Returns `parent` typed as `XMLElement`.
    @inlinable @_disfavoredOverload
    public var parentElement: XMLElement? {
        parent as? XMLElement
    }
    
    /// Returns `children` typed as `XMLElement`s.
    @inlinable @_disfavoredOverload
    public var childElements: LazyCompactMapSequence<[XMLNode], XMLElement> {
        (children ?? []).asElements()
    }
}

// MARK: - Sequence Typing

extension Sequence where Element: XMLNode {
    /// Returns the collection as a lazy iterator that compact maps to `XMLElement`.
    /// Mapping is performed lazily.
    @inlinable @_disfavoredOverload
    public func asElements() -> LazyCompactMapSequence<Self, XMLElement> {
        lazy.compactMap(\.asElement)
    }
}

// MARK: - Sequence Filtering

extension Sequence where Element: XMLNode {
    /// Filters by the given XML node name.
    /// Filter is performed lazily.
    @inlinable @_disfavoredOverload
    public func filter(
        whereNodeNamed nodeName: String
    ) -> LazyFilterSequence<LazySequence<Self>.Elements> {
        lazy.filter(whereNodeNamed: nodeName)
    }
}

// MARK: - LazySequence Filtering

extension LazySequence where Element: XMLNode {
    /// Filters by the given XML node name.
    /// Filter is performed lazily.
    @inlinable @_disfavoredOverload
    public func filter(
        whereNodeNamed nodeName: String
    ) -> LazyFilterSequence<LazySequence<Base>.Elements> {
        filter { $0.name == nodeName }
    }
}

// MARK: - Sequence First

extension Sequence where Element: XMLNode {
    /// Returns the first node with the given XML node name.
    @inlinable @_disfavoredOverload
    public func first(
        whereNodeNamed nodeName: String
    ) -> Element? {
        first { $0.name == nodeName }
    }
}

#endif
