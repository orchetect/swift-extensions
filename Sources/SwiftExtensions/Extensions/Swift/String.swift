//
//  String.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - String Convenience Constants

extension String {
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var quote: Self { "\"" }
    
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var tab: Self { "\t" }
    
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var space: Self { " " }
    
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var newLine: Self { "\n" }
    
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var null: Self { "\0" } // { Self(UnicodeScalar(0)) }
}

// MARK: - Character Convenience Constants

extension Character {
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var quote: Self { "\"" }
    
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var tab: Self { "\t" }
    
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var space: Self { " " }
    
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var newLine: Self { "\n" }
    
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var null: Self { "\0" } // { Self(UnicodeScalar(0)) }
}

// MARK: - String functional append constants

extension String {
    /// Returns a new String appending a newline character to the end.
    @inlinable @_disfavoredOverload
    public var newLined: Self {
        self + Self.newLine
    }
    
    /// Returns a new String appending a tab character to the end.
    @inlinable @_disfavoredOverload
    public var tabbed: Self {
        self + Self.tab
    }
    
    /// Appends a newline character to the end of the string.
    @inlinable @_disfavoredOverload
    public mutating func newLine() {
        self += Self.newLine
    }
    
    /// Appends a tab character to the end of the string.
    @inlinable @_disfavoredOverload
    public mutating func tab() {
        self += Self.tab
    }
}

extension Substring {
    /// Returns a new String appending a newline character to the end.
    @inlinable @_disfavoredOverload
    public var newLined: String {
        String(self) + String.newLine
    }
    
    /// Returns a new String appending a tab character to the end.
    @inlinable @_disfavoredOverload
    public var tabbed: String {
        String(self) + String.tab
    }
}

// MARK: - Segmentation

extension String {
    /// Same as `String(repeating: self, count: count)`
    /// (Functional convenience method)
    @_disfavoredOverload
    public func repeating(_ count: Int) -> String {
        String(repeating: self, count: count)
    }
}

extension Substring {
    /// Same as `String(repeating: self, count: count)`
    /// (Functional convenience method)
    @_disfavoredOverload
    public func repeating(_ count: Int) -> String {
        String(repeating: string, count: count)
    }
}

extension Character {
    /// Same as `String(repeating: self, count: count)`
    /// (Functional convenience method)
    @_disfavoredOverload
    public func repeating(_ count: Int) -> String {
        String(repeating: self, count: count)
    }
}

extension String {
    /// Convenience function to trim whitespaces and newlines off start and end.
    @inlinable @_disfavoredOverload
    public mutating func trim() {
        self = trimmed
    }
}

// MARK: - Prefix and Suffix

extension StringProtocol {
    /// Returns a new `SubSequence` removing the prefix if it matches.
    @inlinable @_disfavoredOverload
    public func removingPrefix<T: StringProtocol>(_ prefix: T) -> SubSequence {
        hasPrefix(prefix)
            ? dropFirst(prefix.count)
            : self[startIndex ..< endIndex]
    }
    
    /// Returns a new `SubSequence` removing the suffix if it matches.
    @inlinable @_disfavoredOverload
    public func removingSuffix<T: StringProtocol>(_ suffix: T) -> SubSequence {
        hasSuffix(suffix)
            ? dropLast(suffix.count)
            : self[startIndex ..< endIndex]
    }
}

extension String {
    /// Removes the prefix of a String if it exists.
    @inlinable @_disfavoredOverload
    public mutating func removePrefix<T: StringProtocol>(_ prefix: T) {
        if hasPrefix(prefix) {
            removeFirst(prefix.count)
        }
    }
    
    /// Removes the suffix of a String if it exists.
    @inlinable @_disfavoredOverload
    public mutating func removeSuffix<T: StringProtocol>(_ suffix: T) {
        if hasSuffix(suffix) {
            removeLast(suffix.count)
        }
    }
}

// MARK: - String Optionals

/// Convenience: Returns unwrapped String representation of a Swift Optional, otherwise returns
/// contents of `default` string.
///
/// Also accessible through the string interpolation variant:
///
/// ```swift
/// "\(object, ifNil: "Object is nil.")"
/// ```
@inlinable @_disfavoredOverload
public func optionalString(
    describing object: Any?,
    ifNil: String
) -> String {
    object != nil
        ? String(describing: object!)
        : ifNil
}

// MARK: - String Interpolation Extensions

extension DefaultStringInterpolation {
    /// Convenience: Returns unwrapped String representation of a Swift Optional, otherwise returns
    /// contents of `ifNil` string.
    @inlinable @_disfavoredOverload
    public mutating func appendInterpolation(
        _ object: Any?,
        ifNil: String
    ) {
        appendLiteral(optionalString(describing: object, ifNil: ifNil))
    }
}

extension DefaultStringInterpolation {
    /// Convenience interpolator for converting a value to a given radix.
    @inlinable @_disfavoredOverload
    public mutating func appendInterpolation(
        _ value: String,
        radix: Int
    ) {
        guard let result = Int(value, radix: radix) else {
            appendLiteral("nil")
            return
        }
        appendLiteral(String(result))
    }
}

// MARK: - Functional methods

extension Substring {
    /// Same as `String(self)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var string: String {
        String(self)
    }
}

extension Character {
    /// Same as `String(self)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var string: String {
        String(self)
    }
}
