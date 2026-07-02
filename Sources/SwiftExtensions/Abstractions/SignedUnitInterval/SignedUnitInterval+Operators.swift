//
//  SignedUnitInterval+Operators.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

extension SignedUnitInterval {
    // +
    
    nonisolated
    public static func + (lhs: Self, rhs: Double) -> Self {
        .init(lhs.rawValue + rhs)
    }
    
    nonisolated
    public static func + (lhs: Double, rhs: Self) -> Self {
        .init(lhs + rhs.rawValue)
    }
    
    // -
    
    nonisolated
    public static func - (lhs: Self, rhs: Double) -> Self {
        .init(lhs.rawValue - rhs)
    }
    
    nonisolated
    public static func - (lhs: Double, rhs: Self) -> Self {
        .init(lhs - rhs.rawValue)
    }
}

extension SignedUnitInterval {
    // +=

    nonisolated
    public static func += (lhs: inout Self, rhs: Double) {
        lhs = .init(lhs.rawValue + rhs)
    }

    nonisolated
    public static func += (lhs: inout Double, rhs: Self) {
        lhs += rhs.rawValue
    }
    
    // -=

    nonisolated
    public static func -= (lhs: inout Self, rhs: Double) {
        lhs = .init(lhs.rawValue - rhs)
    }
    
    nonisolated
    public static func -= (lhs: inout Double, rhs: Self) {
        lhs -= rhs.rawValue
    }
}

nonisolated
public prefix func - (_ signedUnitInterval: SignedUnitInterval) -> SignedUnitInterval {
    signedUnitInterval.negated
}
