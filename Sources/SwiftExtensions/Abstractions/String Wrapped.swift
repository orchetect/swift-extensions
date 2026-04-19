//
//  String Wrapped.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

extension String {
    /// Returns the string adding the passed `with` parameter as a prefix and suffix.
    @inline(__always) @_disfavoredOverload
    public func wrapped(with prefixAndSuffix: String) -> String {
        prefixAndSuffix + self + prefixAndSuffix
    }

    /// Returns the string adding the passed `with` parameter as a prefix and suffix.
    @inline(__always) @_disfavoredOverload
    public func wrapped(with prefixAndSuffix: StringWrappedEnclosingType) -> String {
        switch prefixAndSuffix {
        case .parentheses: "(" + self + ")"
        case .brackets: "[" + self + "]"
        case .braces: "{" + self + "}"
        case .angleBrackets: "<" + self + ">"
        case .singleQuotes: "'" + self + "'"
        case .quotes: "\"" + self + "\""
        }
    }

    /// Type describing a pair of enclosing brackets/braces or similar characters that are different
    /// for prefix and suffix.
    public enum StringWrappedEnclosingType: Equatable, Hashable, Sendable {
        /// `( )` a.k.a. parens
        case parentheses

        /// `[ ]` a.k.a. square brackets
        case brackets

        /// `{ }` a.k.a. curly braces
        case braces

        /// `< >`
        case angleBrackets

        /// `' '`
        case singleQuotes

        /// `" "`
        case quotes
    }

    /// Syntactic sugar. Returns the string wrapped with parentheses: `( )`.
    /// Same as `self.wrapped(with: .parentheses)`
    @inline(__always) @_disfavoredOverload
    public var parenthesized: Self {
        wrapped(with: .parentheses)
    }

    /// Syntactic sugar. Returns the string wrapped with single quote marks: `' '`.
    /// Same as `self.wrapped(with: .singleQuotes)`
    @inline(__always) @_disfavoredOverload
    public var singleQuoted: Self {
        wrapped(with: .singleQuotes)
    }

    /// Syntactic sugar. Returns the string wrapped with double quote marks: `" "`.
    /// Same as `self.wrapped(with: .quotes)`
    @inline(__always) @_disfavoredOverload
    public var quoted: Self {
        wrapped(with: .quotes)
    }
}

// MARK: - API Changes in 1.4.0

extension String {
    /// Syntactic sugar. Returns the string wrapped with parentheses: `( )`.
    /// Same as `self.wrapped(with: .parentheses)`
    @_documentation(visibility: internal)
    @inline(__always) @_disfavoredOverload
    @available(*, unavailable, renamed: "parenthesized")
    public var parens: Self {
        parenthesized
    }
}
