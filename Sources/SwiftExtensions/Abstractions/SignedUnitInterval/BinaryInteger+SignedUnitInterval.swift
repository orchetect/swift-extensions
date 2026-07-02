//
//  BinaryInteger+SignedUnitInterval.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// MARK: - Numeric Inits

extension BinaryInteger {
    /// Initialize from a signed unit interval raw value.
    nonisolated
    public init(_ signedUnitInterval: SignedUnitInterval) {
        self.init(signedUnitInterval.rawValue)
    }
}

extension BinaryFloatingPoint {
    /// Initialize from a signed unit interval raw value.
    nonisolated
    public init(_ signedUnitInterval: SignedUnitInterval) {
        self.init(signedUnitInterval.rawValue)
    }
}
