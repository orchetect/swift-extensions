//
//  TimeInterval.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

extension TimeInterval {
    // TODO: Might remove this since TimeInterval is an alias for Double and this init may be ambiguous.
    /// Convenience constructor from `timespec`.
    @inlinable @_disfavoredOverload
    public init(_ time: timespec) {
        self = time.doubleValue
    }
}

#endif
