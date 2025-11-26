//
//  NSScreen.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) && !targetEnvironment(macCatalyst)

import AppKit

extension NSScreen {
    /// Returns the screen that currently contains the user's mouse pointer.
    @_disfavoredOverload
    public static var screenWithMouseCursor: NSScreen {
        .screens
            .first { NSMouseInRect(NSEvent.mouseLocation, $0.frame, false) }
            ?? .main
            ?? .screens[0] // index 0 is virtually guaranteed to exist
    }
    
    /// Returns `true` if the screen currently contains the user's mouse pointer.
    @_disfavoredOverload
    public var containsMouseCursor: Bool {
        Self.screenWithMouseCursor == self
    }
}

#endif
