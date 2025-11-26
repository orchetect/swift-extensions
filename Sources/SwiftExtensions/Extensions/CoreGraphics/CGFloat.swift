//
//  CGFloat.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(CoreGraphics)

import CoreGraphics

// MARK: - FloatingPointHighPrecisionStringConvertible

extension CGFloat: FloatingPointHighPrecisionStringConvertible { }

// MARK: - Convenience type conversion methods

extension BinaryInteger {
    /// Same as `CGFloat(self)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var cgFloat: CGFloat { CGFloat(self) }
    
    /// Same as `CGFloat(exactly: self)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var cgFloatExactly: CGFloat? { CGFloat(exactly: self) }
}

extension BinaryFloatingPoint {
    /// Same as `CGFloat(self)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var cgFloat: CGFloat { CGFloat(self) }
    
    /// Same as `CGFloat(exactly: self)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var cgFloatExactly: CGFloat? { CGFloat(exactly: self) }
}

// MARK: - FloatingPointPowerComputable

// MARK: - .power()

extension CGFloat: FloatingPointPowerComputable {
    /// Same as `pow()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public func power(_ exponent: CGFloat) -> CGFloat {
        pow(self, exponent)
    }
}

// MARK: - From String

extension StringProtocol {
    /// Constructs `CGFloat` from a `String` by converting to `Double` as intermediary.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var cgFloat: CGFloat? {
        guard let doubleValue = Double(self) else { return nil }
        return CGFloat(doubleValue)
    }
}

#if canImport(Foundation)
import Foundation

// MARK: - Digit Places

extension CGFloat {
    /// Returns the number of digit places of the ``integral`` portion (left of the decimal).
    @inlinable @_disfavoredOverload
    public var integralDigitPlaces: Int {
        Decimal(self).integralDigitPlaces
    }
    
    /// Returns the number of digit places of the ``fraction`` portion (right of the decimal).
    @inlinable @_disfavoredOverload
    public var fractionDigitPlaces: Int {
        Decimal(self).fractionDigitPlaces
    }
}

#endif

#endif
