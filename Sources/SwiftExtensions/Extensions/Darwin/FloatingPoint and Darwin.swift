//
//  FloatingPoint and Darwin.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#endif

import Darwin

// MARK: - ceiling / floor

extension FloatingPoint {
    /// Same as `ceil()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var ceiling: Self {
        #if canImport(Darwin)
        Darwin.ceil(self)
        #elseif canImport(Glibc)
        Glibc.ceil(self)
        #elseif canImport(Musl)
        Musl.ceil(self)
        #endif
    }

    /// Same as `floor()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var floor: Self {
        #if canImport(Darwin)
        Darwin.floor(self)
        #elseif canImport(Glibc)
        Glibc.floor(self)
        #elseif canImport(Musl)
        Musl.floor(self)
        #endif
    }
}

// MARK: - FloatingPointPowerComputable

// MARK: - .power()

extension Double: FloatingPointPowerComputable {
    /// Same as `pow()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public func power(_ exponent: Double) -> Double {
        pow(self, exponent)
    }
}

extension Float: FloatingPointPowerComputable {
    /// Same as `powf()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public func power(_ exponent: Float) -> Float {
        powf(self, exponent)
    }
}

#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
extension Float80: FloatingPointPowerComputable {
    /// Same as `powl()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public func power(_ exponent: Float80) -> Float80 {
        powl(self, exponent)
    }
}
#endif
