//
//  UnitInterval+ScaleType.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import func Foundation.log2
import func Foundation.log10

// MARK: - Scale Functions

extension UnitInterval {
    /// Type describing a `UnitInterval` scale type for use with ``UnitInterval/scaled(as:)``.
    public enum ScaleType {
        /// Linear (value in `==` value) out unchanged.
        case linear
        
        /// log2 curve; starts gradual.
        case log2
        
        /// log2 curve; ends gradual.
        case log2Inverted

        /// log10 curve; starts gradual.
        case log10
        
        /// log10 curve; ends gradual.
        case log10Inverted
    }
}

extension UnitInterval.ScaleType: Equatable { }

extension UnitInterval.ScaleType: Hashable { }

extension UnitInterval.ScaleType: CaseIterable { }

extension UnitInterval.ScaleType: Sendable { }

extension UnitInterval {
    /// Scales a unit interval (`0.0 ... 1.0`) to a particular curve function.
    nonisolated
    public func scaled(using scaleType: ScaleType) -> Double {
        switch scaleType {
        case .linear:
            rawValue
            
        case .log2:
            1.0 - log2(1.0 + (1.0 - rawValue))
            
        case .log2Inverted:
            log2(1.0 + rawValue)
            
        case .log10:
            1.0 - log10(1.0 + ((1.0 - rawValue) * 9.0))
            
        case .log10Inverted:
            log10(1.0 + (rawValue * 9.0))
        }
    }
}
