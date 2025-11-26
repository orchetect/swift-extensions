//
//  NSFont.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) && !targetEnvironment(macCatalyst)

import AppKit

extension NSFont {
    /// Convert an `NSFont` instance to a new `CGFont` instance.
    @_disfavoredOverload
    public var cgFont: CGFont {
        CTFontCopyGraphicsFont(self, nil)
    }
}

#endif
