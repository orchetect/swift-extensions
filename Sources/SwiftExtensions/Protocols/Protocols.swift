//
//  Protocols.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - NumberEndianness

/// Enum describing endianness when stored in data form.
public enum NumberEndianness: Sendable {
    case platformDefault
    case littleEndian
    case bigEndian
}

#if canImport(CoreFoundation)
import CoreFoundation

extension NumberEndianness {
    /// Returns the current system hardware's byte order endianness.
    public static let system: NumberEndianness =
        CFByteOrderGetCurrent() == CFByteOrderBigEndian.rawValue
            ? .bigEndian
            : .littleEndian
}
#endif

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
