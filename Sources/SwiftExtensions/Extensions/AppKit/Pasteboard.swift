//
//  Pasteboard.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) && !targetEnvironment(macCatalyst)

import AppKit

extension NSPasteboard.PasteboardType {
    // TODO: Remove in future swift-extensions release.
    /// Can use in place of `fileURL` when building for platforms earlier than macOS 10.13.
    @available(
        *,
        deprecated,
        renamed: "fileURL",
        message: "Since swift-extensions now has a minimum target of macOS 10.15, this property is redundant and will be removed in a future release of swift-extensions."
    )
    @_disfavoredOverload
    public static var fileURLBackCompat: Self {
        if #available(macOS 10.13, *) {
            return .fileURL
            
        } else {
            // Fallback on earlier versions
            return .init(kUTTypeFileURL as String)
        }
    }
}

#endif
