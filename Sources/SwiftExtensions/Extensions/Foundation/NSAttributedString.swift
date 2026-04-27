//
//  NSAttributedString.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import class Foundation.NSAttributedString
import class Foundation.NSMutableAttributedString
import struct Foundation.NSRange

#if os(macOS)
import class AppKit.NSMutableParagraphStyle
import enum AppKit.NSTextAlignment
#else
import class UIKit.NSMutableParagraphStyle
import enum UIKit.NSTextAlignment
#endif

extension NSAttributedString {
    /// Convenience. Returns a new `NSAttributedString` with the attribute applied to the entire string.
    @_disfavoredOverload
    public func addingAttribute(alignment: NSTextAlignment) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment

        guard let copy = mutableCopy() as? NSMutableAttributedString
        else {
            print("Could not create mutable NSAttributedString copy.")
            return self
        }

        copy.addAttributes(
            [.paragraphStyle: paragraph],
            range: NSRange(location: 0, length: length)
        )

        return copy
    }
}

extension NSMutableAttributedString {
    /// Convenience. Adds the attribute applied to the entire string.
    @_disfavoredOverload
    public func addAttribute(alignment: NSTextAlignment) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment

        addAttributes(
            [.paragraphStyle: paragraph],
            range: NSRange(location: 0, length: length)
        )
    }
}
#endif
