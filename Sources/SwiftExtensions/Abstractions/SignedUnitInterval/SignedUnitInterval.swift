//
//  SignedUnitInterval.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

/// A floating point type that can contain values between `-1.0 ... 1.0`.
public struct SignedUnitInterval {
    public let rawValue: Double

    /// Construct by clamping.
    nonisolated
    public init(_ value: Double) {
        self.rawValue = value.clamped(to: Self.range)
    }

    /// Construct by clamping.
    @_disfavoredOverload
    nonisolated
    public init(_ value: some BinaryFloatingPoint) {
        self.init(Double(value))
    }

    /// Construct by clamping.
    @_disfavoredOverload
    nonisolated
    public init(_ value: some BinaryInteger) {
        self.init(Double(value))
    }

    /// Construct by clamping.
    nonisolated
    public init?(_ text: some StringProtocol) {
        guard let valueFromText = Double(text) else { return nil }
        self.init(valueFromText)
    }
}

extension SignedUnitInterval: RawRepresentable {
    nonisolated
    public init(rawValue: Double) {
        self.init(rawValue)
    }
}

extension SignedUnitInterval: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Double
    
    nonisolated
    public init(floatLiteral: FloatLiteralType) {
        self.init(floatLiteral)
    }
}

extension SignedUnitInterval: Equatable {
    nonisolated
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

extension SignedUnitInterval: Comparable {
    nonisolated
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    nonisolated
    public static func > (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue > rhs.rawValue
    }
}

extension SignedUnitInterval: Hashable { }

extension SignedUnitInterval: Codable { }

extension SignedUnitInterval: Sendable { }

extension SignedUnitInterval: CustomStringConvertible {
    nonisolated
    public var description: String {
        rawValue.description
    }
}

extension SignedUnitInterval: CustomDebugStringConvertible {
    nonisolated
    public var debugDescription: String {
        rawValue.debugDescription
    }
}

// MARK: - Static

extension SignedUnitInterval {
    /// Returns the min and max as a range.
    nonisolated
    public static let range: ClosedRange<Double> = -1.0 ... 1.0

    /// Returns the minimum value.
    nonisolated
    public static let min: Self = .init(-1.0)

    /// Returns the mid (center) value between the minimum and maximum value.
    nonisolated
    public static let mid: Self = .init(0.0)

    /// Returns the minimum value.
    nonisolated
    public static let max: Self = .init(1.0)
}

// MARK: - Properties

extension SignedUnitInterval {
    /// The sign of the floating-point unit interval value.
    nonisolated
    public var sign: FloatingPointSign {
        rawValue.sign
    }

    /// Returns the signed unit interval as an absolute unit interval.
    nonisolated
    public var absoluteUnitInterval: UnitInterval {
        UnitInterval(sign == .minus ? -rawValue : rawValue)
    }

    /// Returns a unit interval constructed by scaling the signed unit interval linearly.
    nonisolated
    public var scaledUnitInterval: UnitInterval {
        UnitInterval(scaling: self)
    }

    /// Inverts the sign.
    nonisolated
    public mutating func negate() {
        var value = rawValue
        value.negate()
        self = SignedUnitInterval(value)
    }

    /// Returns a new copy of the signed unit interval with its sign inverted.
    nonisolated
    public var negated: SignedUnitInterval {
        var copy = self
        copy.negate()
        return copy
    }
}

// MARK: - Conversion

extension SignedUnitInterval {
    /// Convert a unit interval to a signed unit interval by scalings its value linearly.
    nonisolated
    public init(scaling unitInterval: UnitInterval) {
        let converted = (unitInterval.rawValue * 2.0) - 1.0
        self.init(converted)
    }
}
