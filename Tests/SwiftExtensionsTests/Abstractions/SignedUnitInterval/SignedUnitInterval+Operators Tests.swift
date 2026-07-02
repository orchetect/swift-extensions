//
//  SignedUnitInterval+Operators Tests.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftExtensions
import Testing

@Suite
struct SignedUnitInterval_Operators_Tests {
    @Test
    func add() {
        #expect(SignedUnitInterval(-1.0) + (-0.1 as Double) == SignedUnitInterval(-1.0))
        #expect(SignedUnitInterval(-1.0) + (0.0 as Double) == SignedUnitInterval(-1.0))
        #expect(SignedUnitInterval(-1.0) + (0.5 as Double) == SignedUnitInterval(-0.5))
        #expect(SignedUnitInterval(-1.0) + (1.5 as Double) == SignedUnitInterval(0.5))
        #expect(SignedUnitInterval(-1.0) + (2.0 as Double) == SignedUnitInterval(1.0))
        #expect(SignedUnitInterval(-1.0) + (2.1 as Double) == SignedUnitInterval(1.0))

        #expect(SignedUnitInterval(0.0) + (-1.1 as Double) == SignedUnitInterval(-1.0))
        #expect(SignedUnitInterval(0.0) + (-0.1 as Double) == SignedUnitInterval(-0.1))
    }

    @Test
    func subtract() {
        #expect(SignedUnitInterval(1.0) - (-0.1 as Double) == SignedUnitInterval(1.0))
        #expect(SignedUnitInterval(1.0) - (0.0 as Double) == SignedUnitInterval(1.0))
        #expect(SignedUnitInterval(1.0) - (0.5 as Double) == SignedUnitInterval(0.5))
        #expect(SignedUnitInterval(1.0) - (1.5 as Double) == SignedUnitInterval(-0.5))
        #expect(SignedUnitInterval(1.0) - (2.0 as Double) == SignedUnitInterval(-1.0))
        #expect(SignedUnitInterval(1.0) - (2.1 as Double) == SignedUnitInterval(-1.0))

        #expect(SignedUnitInterval(0.0) - (-1.1 as Double) == SignedUnitInterval(1.0))
        #expect(SignedUnitInterval(0.0) - (-0.1 as Double) == SignedUnitInterval(0.1))
    }

    @Test
    func addAssign() {
        func added(_ lhs: SignedUnitInterval, _ rhs: Double) -> SignedUnitInterval {
            var lhs = lhs
            lhs += rhs
            return lhs
        }

        #expect(added(SignedUnitInterval(-1.0), -0.1) == SignedUnitInterval(-1.0))
        #expect(added(SignedUnitInterval(-1.0), 0.0) == SignedUnitInterval(-1.0))
        #expect(added(SignedUnitInterval(-1.0), 0.5) == SignedUnitInterval(-0.5))
        #expect(added(SignedUnitInterval(-1.0), 1.5) == SignedUnitInterval(0.5))
        #expect(added(SignedUnitInterval(-1.0), 2.0) == SignedUnitInterval(1.0))
        #expect(added(SignedUnitInterval(-1.0), 2.1) == SignedUnitInterval(1.0))

        #expect(added(SignedUnitInterval(0.0), -1.1) == SignedUnitInterval(-1.0))
        #expect(added(SignedUnitInterval(0.0), -0.1) == SignedUnitInterval(-0.1))
    }

    @Test
    func subtractAssign() {
        func subtracted(_ lhs: SignedUnitInterval, _ rhs: Double) -> SignedUnitInterval {
            var lhs = lhs
            lhs -= rhs
            return lhs
        }

        #expect(subtracted(SignedUnitInterval(1.0), -0.1) == SignedUnitInterval(1.0))
        #expect(subtracted(SignedUnitInterval(1.0), 0.0) == SignedUnitInterval(1.0))
        #expect(subtracted(SignedUnitInterval(1.0), 0.5) == SignedUnitInterval(0.5))
        #expect(subtracted(SignedUnitInterval(1.0), 1.5) == SignedUnitInterval(-0.5))
        #expect(subtracted(SignedUnitInterval(1.0), 2.0) == SignedUnitInterval(-1.0))
        #expect(subtracted(SignedUnitInterval(1.0), 2.1) == SignedUnitInterval(-1.0))

        #expect(subtracted(SignedUnitInterval(0.0), -1.1) == SignedUnitInterval(1.0))
        #expect(subtracted(SignedUnitInterval(0.0), -0.1) == SignedUnitInterval(0.1))
    }

    @Test
    func prefixNegation() {
        #expect(-SignedUnitInterval(-1.0) == SignedUnitInterval(1.0))
        #expect(-SignedUnitInterval(-0.5) == SignedUnitInterval(0.5))
        #expect(-SignedUnitInterval(0.0) == SignedUnitInterval(-0.0))
        #expect(-SignedUnitInterval(0.5) == SignedUnitInterval(-0.5))
        #expect(-SignedUnitInterval(1.0) == SignedUnitInterval(-1.0))
    }
}
