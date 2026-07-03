//
//  UnitInterval.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import struct Foundation.Locale

/// A floating point type that can contain values between `0.0 ... 1.0`.
public struct UnitInterval {
    public let rawValue: Double

    /// Construct by clamping.
    nonisolated
    public init(_ rawValue: Double) {
        self.rawValue = rawValue.clamped(to: Self.range)
    }

    /// Construct by clamping.
    @_disfavoredOverload
    nonisolated
    public init<T: BinaryFloatingPoint>(_ value: T) {
        self.init(Double(value))
    }

    /// Construct by clamping.
    @_disfavoredOverload
    nonisolated
    public init<T: BinaryInteger>(_ value: T) {
        self.init(Double(value))
    }

    /// Construct by clamping.
    nonisolated
    public init?<S>(_ text: S) where S: StringProtocol {
        guard let valueFromText = Double(text) else { return nil }
        self.init(valueFromText)
    }
}

extension UnitInterval: RawRepresentable {
    nonisolated
    public init(rawValue: Double) {
        self.init(rawValue)
    }
}

extension UnitInterval: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Double
    
    nonisolated
    public init(floatLiteral: FloatLiteralType) {
        self.init(floatLiteral)
    }
}

extension UnitInterval: Equatable {
    nonisolated
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

extension UnitInterval: Comparable {
    nonisolated
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    nonisolated
    public static func > (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue > rhs.rawValue
    }
}

extension UnitInterval: Hashable { }

extension UnitInterval: Codable { }

extension UnitInterval: Sendable { }

extension UnitInterval: CustomStringConvertible {
    nonisolated
    public var description: String {
        rawValue.description
    }
}

extension UnitInterval: CustomDebugStringConvertible {
    nonisolated
    public var debugDescription: String {
        rawValue.debugDescription
    }
}

// MARK: - Static

extension UnitInterval {
    /// Returns the min and max as a range.
    nonisolated
    public static let range: ClosedRange<Double> = 0.0 ... 1.0

    /// Returns the minimum value.
    nonisolated
    public static let min: Self = .init(0.0)

    /// Returns the mid (center) value between the minimum and maximum value.
    nonisolated
    public static let mid: Self = .init(0.5)

    /// Returns the minimum value.
    nonisolated
    public static let max: Self = .init(1.0)
}

// MARK: - Properties

extension UnitInterval {
    /// Returns a signed unit interval constructed from the unit interval with either positive or
    /// negative polarity.
    nonisolated
    public func signedUnitInterval(sign: FloatingPointSign) -> SignedUnitInterval {
        SignedUnitInterval(sign == .plus ? rawValue : -rawValue)
    }

    /// Returns a signed unit interval constructed by scaling the unit interval linearly.
    nonisolated
    public var scaledSignedUnitInterval: SignedUnitInterval {
        SignedUnitInterval(scaling: self)
    }
}

// MARK: - Formatting

extension UnitInterval {
    /// Returns the unit interval formatted as localized string containing a percentage (ie: "50%")
    /// with an unbounded fraction length.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func localizedPercentageString(locale: Locale = .current) -> String {
        rawValue
            .formatted(
                .percent
                    .locale(locale)
            )
    }

    /// Returns the unit interval formatted as localized string containing a percentage (ie: "50%")
    /// rounding to a fixed fraction length.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func localizedPercentageString(fractionLength: Int, locale: Locale = .current) -> String {
        rawValue
            .formatted(
                .percent
                    .precision(.fractionLength(fractionLength.clamped(to: 0...)))
                    .locale(locale)
            )
    }

    /// Returns the unit interval formatted as localized string containing a percentage (ie: "50%")
    /// rounding to a maximum fraction length.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func localizedPercentageString(maxFractionLength: Int, locale: Locale = .current) -> String {
        rawValue
            .formatted(
                .percent
                    .precision(.integerAndFractionLength(integerLimits: 1..., fractionLimits: ...maxFractionLength.clamped(to: 0...)))
                    .locale(locale)            )
    }
}

// MARK: - Conversion

extension UnitInterval {
    /// Convert a signed unit interval to a unit interval by scalings its value linearly.
    nonisolated
    public init(scaling signedUnitInterval: SignedUnitInterval) {
        let converted = (signedUnitInterval.rawValue + 1.0) / 2.0
        self.init(converted)
    }
}
