//
//  String.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// MARK: - String Convenience Constants

extension String {
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var quote: Self {
        "\""
    }

    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var tab: Self {
        "\t"
    }

    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var space: Self {
        " "
    }

    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var newLine: Self {
        "\n"
    }

    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var null: Self {
        "\0"
    } // { Self(UnicodeScalar(0)) }
}

// MARK: - Character Convenience Constants

extension Character {
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var quote: Self {
        "\""
    }

    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var tab: Self {
        "\t"
    }

    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var space: Self {
        " "
    }

    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var newLine: Self {
        "\n"
    }

    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var null: Self {
        // Self(UnicodeScalar(0))
        "\0"
    }
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
    public func removingPrefix(_ prefix: some StringProtocol) -> SubSequence {
        hasPrefix(prefix)
            ? dropFirst(prefix.count)
            : self[startIndex ..< endIndex]
    }

    /// Returns a new `SubSequence` removing the suffix if it matches.
    @inlinable @_disfavoredOverload
    public func removingSuffix(_ suffix: some StringProtocol) -> SubSequence {
        hasSuffix(suffix)
            ? dropLast(suffix.count)
            : self[startIndex ..< endIndex]
    }
}

extension String {
    /// Removes the prefix of a String if it exists.
    @inlinable @_disfavoredOverload
    public mutating func removePrefix(_ prefix: some StringProtocol) {
        if hasPrefix(prefix) {
            removeFirst(prefix.count)
        }
    }

    /// Removes the suffix of a String if it exists.
    @inlinable @_disfavoredOverload
    public mutating func removeSuffix(_ suffix: some StringProtocol) {
        if hasSuffix(suffix) {
            removeLast(suffix.count)
        }
    }
}

// MARK: - Character Case

extension StringProtocol {
    /// Returns `true` if the string is entirely comprised of ASCII characters (0-127).
    @inlinable @_disfavoredOverload
    public var isASCII: Bool {
        allSatisfy(\.isASCII)
    }

    /// Returns `true` if all characters within the string are lowercase characters.
    /// By default, non-cased characters are ignored.
    ///
    /// An empty string always evaluates to `true`.
    ///
    /// - Parameters:
    ///   - ignoreWhitespace: When `true`, any whitespace characters are ignored.
    ///   - ignoreNonCased: When `true`, any non-whitespace characters that cannot be cased
    ///     (symbols, emojis, etc.) are ignored and only characters that can be cased are included
    ///     in the evaluation. When `false`, all characters must strictly match as lowercase.
    @inlinable @_disfavoredOverload
    public func isLowercase(ignoreWhitespace: Bool = true, ignoreNonCased: Bool = true) -> Bool {
        allSatisfy {
            if $0.isWhitespace { return ignoreWhitespace }
            if ignoreNonCased, !$0.isCased { return true }
            return $0.isLowercase
        }
    }

    /// Returns `true` if all characters within the string are uppercase characters.
    /// By default, non-cased characters are ignored.
    ///
    /// An empty string always evaluates to `true`.
    ///
    /// - Parameters:
    ///   - ignoreWhitespace: When `true`, any whitespace characters are ignored.
    ///   - ignoreNonCased: When `true`, any non-whitespace characters that cannot be cased
    ///     (symbols, emojis, etc.) are ignored and only characters that can be cased are included
    ///     in the evaluation. When `false`, all characters must strictly match as uppercase.
    @inlinable @_disfavoredOverload
    public func isUppercase(ignoreWhitespace: Bool = true, ignoreNonCased: Bool = true) -> Bool {
        allSatisfy {
            if $0.isWhitespace { return ignoreWhitespace }
            if ignoreNonCased, !$0.isCased { return true }
            return $0.isUppercase
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
