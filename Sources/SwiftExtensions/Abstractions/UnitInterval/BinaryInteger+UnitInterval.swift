//
//  BinaryInteger+UnitInterval.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// MARK: - Numeric Inits

extension BinaryInteger {
    /// Initialize from a unit interval raw value.
    nonisolated
    public init(_ unitInterval: UnitInterval) {
        self.init(unitInterval.rawValue)
    }
}

extension BinaryFloatingPoint {
    /// Initialize from a unit interval raw value.
    nonisolated
    public init(_ unitInterval: UnitInterval) {
        self.init(unitInterval.rawValue)
    }
}
