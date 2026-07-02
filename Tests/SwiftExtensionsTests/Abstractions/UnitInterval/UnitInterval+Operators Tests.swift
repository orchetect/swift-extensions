//
//  UnitInterval+Operators Tests.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftExtensions
import Testing

@Suite
struct UnitInterval_Operators_Tests {
    @Test
    func add() {
        #expect(UnitInterval(0.0) + (-0.1 as Double) == UnitInterval(0.0))
        #expect(UnitInterval(0.0) + (0.0 as Double) == UnitInterval(0.0))
        #expect(UnitInterval(0.0) + (0.5 as Double) == UnitInterval(0.5))
        #expect(UnitInterval(0.0) + (1.0 as Double) == UnitInterval(1.0))
        #expect(UnitInterval(0.0) + (1.1 as Double) == UnitInterval(1.0))

        #expect(UnitInterval(1.0) + (-1.1 as Double) == UnitInterval(0.0))
        #expect(UnitInterval(1.0) + (-0.1 as Double) == UnitInterval(0.9))
    }

    @Test
    func subtract() {
        #expect(UnitInterval(1.0) - (-0.1 as Double) == UnitInterval(1.0))
        #expect(UnitInterval(1.0) - (0.0 as Double) == UnitInterval(1.0))
        #expect(UnitInterval(1.0) - (0.5 as Double) == UnitInterval(0.5))
        #expect(UnitInterval(1.0) - (1.0 as Double) == UnitInterval(0.0))
        #expect(UnitInterval(1.0) - (1.1 as Double) == UnitInterval(0.0))

        #expect(UnitInterval(0.0) - (-1.1 as Double) == UnitInterval(1.0))
        #expect(UnitInterval(0.0) - (-0.1 as Double) == UnitInterval(0.1))
    }

    @Test
    func addAssign() {
        func added(_ lhs: UnitInterval, _ rhs: Double) -> UnitInterval {
            var lhs = lhs
            lhs += rhs
            return lhs
        }

        #expect(added(UnitInterval(0.0), -0.1) == UnitInterval(0.0))
        #expect(added(UnitInterval(0.0), 0.0) == UnitInterval(0.0))
        #expect(added(UnitInterval(0.0), 0.5) == UnitInterval(0.5))
        #expect(added(UnitInterval(0.0), 1.0) == UnitInterval(1.0))
        #expect(added(UnitInterval(0.0), 1.1) == UnitInterval(1.0))

        #expect(added(UnitInterval(1.0), -1.1) == UnitInterval(0.0))
        #expect(added(UnitInterval(1.0), -0.1) == UnitInterval(0.9))
    }

    @Test
    func subtractAssign() {
        func subtracted(_ lhs: UnitInterval, _ rhs: Double) -> UnitInterval {
            var lhs = lhs
            lhs -= rhs
            return lhs
        }

        #expect(subtracted(UnitInterval(1.0), -0.1) == UnitInterval(1.0))
        #expect(subtracted(UnitInterval(1.0), 0.0) == UnitInterval(1.0))
        #expect(subtracted(UnitInterval(1.0), 0.5) == UnitInterval(0.5))
        #expect(subtracted(UnitInterval(1.0), 1.0) == UnitInterval(0.0))
        #expect(subtracted(UnitInterval(1.0), 1.1) == UnitInterval(0.0))

        #expect(subtracted(UnitInterval(0.0), -1.1) == UnitInterval(1.0))
        #expect(subtracted(UnitInterval(0.0), -0.1) == UnitInterval(0.1))
    }

    @Test
    func multiply() {
        #expect(UnitInterval(0.0) * (0.0 as Double) == (0.0 as Double))
        #expect(UnitInterval(0.0) * (1.0 as Double) == (0.0 as Double))

        #expect(UnitInterval(0.1) * (2.0 as Double) == (0.2 as Double))
        #expect(UnitInterval(0.25) * (2.0 as Double) == (0.5 as Double))
        #expect(UnitInterval(1.0) * (2.0 as Double) == (2.0 as Double))
        #expect(UnitInterval(1.0) * (-2.0 as Double) == (-2.0 as Double))
    }

    @Test
    func divide() {
        #expect(UnitInterval(0.0) / (1.0 as Double) == (0.0 as Double))
        #expect(UnitInterval(1.0) / (1.0 as Double) == (1.0 as Double))
        #expect(UnitInterval(1.0) / (0.5 as Double) == (2.0 as Double))
        #expect(UnitInterval(1.0) / (0.1 as Double) == (10.0 as Double))
        #expect(UnitInterval(1.0) / (-0.5 as Double) == (-2.0 as Double))
    }

    @Test
    func multiplyAssign() {
        func multiplied(_ lhs: Double, _ rhs: UnitInterval) -> Double {
            var lhs = lhs
            lhs *= rhs
            return lhs
        }

        #expect(multiplied(0.0, UnitInterval(0.0)) == (0.0 as Double))
        #expect(multiplied(1.0, UnitInterval(0.0)) == (0.0 as Double))

        #expect(multiplied(2.0, UnitInterval(0.1)) == (0.2 as Double))
        #expect(multiplied(2.0, UnitInterval(0.25)) == (0.5 as Double))
        #expect(multiplied(2.0, UnitInterval(1.0)) == (2.0 as Double))
        #expect(multiplied(-2.0, UnitInterval(1.0)) == (-2.0 as Double))
    }

    @Test
    func divideAssign() {
        func divided(_ lhs: Double, _ rhs: UnitInterval) -> Double {
            var lhs = lhs
            lhs /= rhs
            return lhs
        }

        #expect(divided(0.0, UnitInterval(1.0)) == (0.0 as Double))
        #expect(divided(1.0, UnitInterval(1.0)) == (1.0 as Double))
        #expect(divided(1.0, UnitInterval(0.5)) == (2.0 as Double))
        #expect(divided(1.0, UnitInterval(0.1)) == (10.0 as Double))
        #expect(divided(-2.0, UnitInterval(0.5)) == (-4.0 as Double))
    }

    @Test
    func prefixNegation() {
        #expect(-UnitInterval(0.0) == -0.0 as Double)
        #expect(-UnitInterval(0.5) == -0.5 as Double)
        #expect(-UnitInterval(1.0) == -1.0 as Double)
    }
}
