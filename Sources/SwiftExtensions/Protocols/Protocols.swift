//
//  Protocols.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - FloatingPointPowerComputable

/// Protocol allowing implementation of convenience method `power(_ exponent:)`.
/// - warning: (Internal use. Do not use this protocol.)
public protocol FloatingPointPowerComputable {
    func power(_ exponent: Self) -> Self
}

// MARK: - FloatingPointHighPrecisionStringConvertible

/// Protocol allowing implementation of convenience method `stringValueHighPrecision`.
/// - warning: (Internal use. Do not use this protocol.)
public protocol FloatingPointHighPrecisionStringConvertible {
    var stringValueHighPrecision: String { get }
}
