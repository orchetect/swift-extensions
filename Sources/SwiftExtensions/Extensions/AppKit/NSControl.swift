//
//  NSControl.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) && !targetEnvironment(macCatalyst)

import AppKit

extension Bool {
    /// Returns `NSControl.StateValue` instance of `on` (true) or `off` (false).
    @inline(__always) @_disfavoredOverload
    public var stateValue: NSControl.StateValue {
        self ? .on : .off
    }
}

extension NSControl.StateValue {
    /// Returns the inverted (toggled) state.
    /// If `off`, will return `on`.
    /// If `on` or `mixed`, will return `off`.
    @inline(__always) @_disfavoredOverload
    public static prefix func ! (stateValue: Self) -> Self {
        stateValue.toggled()
    }
    
    /// Returns the inverted (toggled) state.
    /// If `off`, will return `on`.
    /// If `on` or `mixed`, will return `off`.
    @inline(__always) @_disfavoredOverload
    public func toggled() -> Self {
        self == .off ? .on : .off
    }
    
    /// Inverts (toggles) the state.
    /// If `off`, will return `on`.
    /// If `on` or `mixed`, will return `off`.
    @inline(__always) @_disfavoredOverload
    public mutating func toggle() {
        self = toggled()
    }
}

#endif
