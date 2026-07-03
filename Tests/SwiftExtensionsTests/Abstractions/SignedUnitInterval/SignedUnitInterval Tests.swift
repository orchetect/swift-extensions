//
//  SignedUnitInterval Tests.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftExtensions
import Testing

@Suite
struct SignedUnitInterval_Tests {
    @Test
    func init_rawValue() {
        #expect(SignedUnitInterval(rawValue: -1.1).rawValue == -1.0)
        #expect(SignedUnitInterval(rawValue: -1.0).rawValue == -1.0)
        #expect(SignedUnitInterval(rawValue: -0.5).rawValue == -0.5)
        #expect(SignedUnitInterval(rawValue: 0.0).rawValue == 0.0)
        #expect(SignedUnitInterval(rawValue: 0.5).rawValue == 0.5)
        #expect(SignedUnitInterval(rawValue: 1.0).rawValue == 1.0)
        #expect(SignedUnitInterval(rawValue: 1.1).rawValue == 1.0)

        // edge cases
        #expect(SignedUnitInterval(rawValue: 0.0000005).rawValue == 0.0000005)
        #expect(SignedUnitInterval(rawValue: -0.0000005).rawValue == -0.0000005)
    }

    @Test
    func init_binaryInteger() {
        #expect(SignedUnitInterval(Int(-2)).rawValue == -1.0)
        #expect(SignedUnitInterval(Int(-1)).rawValue == -1.0)
        #expect(SignedUnitInterval(Int(0)).rawValue == 0.0)
        #expect(SignedUnitInterval(Int(1)).rawValue == 1.0)
        #expect(SignedUnitInterval(Int(2)).rawValue == 1.0)

        #expect(SignedUnitInterval(UInt8(0)).rawValue == 0.0)
        #expect(SignedUnitInterval(UInt8(1)).rawValue == 1.0)
        #expect(SignedUnitInterval(UInt8(2)).rawValue == 1.0)

        #expect(SignedUnitInterval(Int8(-2)).rawValue == -1.0)
        #expect(SignedUnitInterval(Int8(-1)).rawValue == -1.0)
        #expect(SignedUnitInterval(Int8(0)).rawValue == 0.0)
        #expect(SignedUnitInterval(Int8(1)).rawValue == 1.0)
        #expect(SignedUnitInterval(Int8(2)).rawValue == 1.0)

        #expect(SignedUnitInterval(UInt16(0)).rawValue == 0.0)
        #expect(SignedUnitInterval(UInt16(1)).rawValue == 1.0)
        #expect(SignedUnitInterval(UInt16(2)).rawValue == 1.0)

        #expect(SignedUnitInterval(Int16(-2)).rawValue == -1.0)
        #expect(SignedUnitInterval(Int16(-1)).rawValue == -1.0)
        #expect(SignedUnitInterval(Int16(0)).rawValue == 0.0)
        #expect(SignedUnitInterval(Int16(1)).rawValue == 1.0)
        #expect(SignedUnitInterval(Int16(2)).rawValue == 1.0)

        #expect(SignedUnitInterval(UInt32(0)).rawValue == 0.0)
        #expect(SignedUnitInterval(UInt32(1)).rawValue == 1.0)
        #expect(SignedUnitInterval(UInt32(2)).rawValue == 1.0)

        #expect(SignedUnitInterval(Int32(-2)).rawValue == -1.0)
        #expect(SignedUnitInterval(Int32(-1)).rawValue == -1.0)
        #expect(SignedUnitInterval(Int32(0)).rawValue == 0.0)
        #expect(SignedUnitInterval(Int32(1)).rawValue == 1.0)
        #expect(SignedUnitInterval(Int32(2)).rawValue == 1.0)

        #expect(SignedUnitInterval(UInt64(0)).rawValue == 0.0)
        #expect(SignedUnitInterval(UInt64(1)).rawValue == 1.0)
        #expect(SignedUnitInterval(UInt64(2)).rawValue == 1.0)

        #expect(SignedUnitInterval(Int64(-2)).rawValue == -1.0)
        #expect(SignedUnitInterval(Int64(-1)).rawValue == -1.0)
        #expect(SignedUnitInterval(Int64(0)).rawValue == 0.0)
        #expect(SignedUnitInterval(Int64(1)).rawValue == 1.0)
        #expect(SignedUnitInterval(Int64(2)).rawValue == 1.0)
    }

    @Test
    func init_binaryFloatingPoint() {
        #expect(SignedUnitInterval(Float(-1.1)).rawValue == -1.0)
        #expect(SignedUnitInterval(Float(-1.0)).rawValue == -1.0)
        #expect(SignedUnitInterval(Float(-0.5)).rawValue == -0.5)
        #expect(SignedUnitInterval(Float(0.0)).rawValue == 0.0)
        #expect(SignedUnitInterval(Float(0.5)).rawValue == 0.5)
        #expect(SignedUnitInterval(Float(1.0)).rawValue == 1.0)
        #expect(SignedUnitInterval(Float(1.1)).rawValue == 1.0)
    }

    @Test
    func init_string() {
        #expect(SignedUnitInterval("-2")?.rawValue == -1.0)
        #expect(SignedUnitInterval("-1")?.rawValue == -1.0)
        #expect(SignedUnitInterval("0")?.rawValue == 0.0)
        #expect(SignedUnitInterval("1")?.rawValue == 1.0)
        #expect(SignedUnitInterval("2")?.rawValue == 1.0)

        #expect(SignedUnitInterval("-2.0")?.rawValue == -1.0)
        #expect(SignedUnitInterval("-1.0")?.rawValue == -1.0)
        #expect(SignedUnitInterval("-0.5")?.rawValue == -0.5)
        #expect(SignedUnitInterval("0.0")?.rawValue == 0.0)
        #expect(SignedUnitInterval("0.5")?.rawValue == 0.5)
        #expect(SignedUnitInterval("1.0")?.rawValue == 1.0)
        #expect(SignedUnitInterval("2.0")?.rawValue == 1.0)

        // edge cases
        #expect(SignedUnitInterval("")?.rawValue == nil)
        #expect(SignedUnitInterval("abc")?.rawValue == nil)
        #expect(SignedUnitInterval("123abc")?.rawValue == nil)
        #expect(SignedUnitInterval("abc123")?.rawValue == nil)
        #expect(SignedUnitInterval("123 abc")?.rawValue == nil)
    }

    @Test
    func expressibleByFloatLiteral() {
        func interval(_ i: SignedUnitInterval) -> SignedUnitInterval {
            i
        }

        #expect(interval(-1.1).rawValue == -1.0)
        #expect(interval(-1.0).rawValue == -1.0)
        #expect(interval(-0.5).rawValue == -0.5)
        #expect(interval(0.0).rawValue == 0.0)
        #expect(interval(0.5).rawValue == 0.5)
        #expect(interval(1.0).rawValue == 1.0)
        #expect(interval(1.1).rawValue == 1.0)
    }

    @Test
    func equality() {
        #expect(SignedUnitInterval(0.0) == SignedUnitInterval(0.0))
        #expect(SignedUnitInterval(0.0) != SignedUnitInterval(1.0))
    }

    @Test
    func comparable() {
        #expect(!(SignedUnitInterval(0.0) > SignedUnitInterval(0.0)))
        #expect(!(SignedUnitInterval(0.0) < SignedUnitInterval(0.0)))

        #expect(SignedUnitInterval(0.0) < SignedUnitInterval(1.0))
        #expect(!(SignedUnitInterval(0.0) > SignedUnitInterval(1.0)))

        #expect(!(SignedUnitInterval(1.0) < SignedUnitInterval(0.0)))
        #expect(SignedUnitInterval(1.0) > SignedUnitInterval(0.0))
    }

    @Test
    func hashable() {
        #expect(Set([SignedUnitInterval(0.0), SignedUnitInterval(0.0)]).count == 1)
        #expect(Set([SignedUnitInterval(1.0), SignedUnitInterval(1.0)]).count == 1)
        #expect(Set([SignedUnitInterval(0.0), SignedUnitInterval(1.0)]).count == 2)
    }

    @Test
    func codable() throws {
        let interval = SignedUnitInterval(-0.5)

        // encode
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(interval)

        // analyze encoded data to ensure it encodes as a single value
        let decodedString = try #require(String(data: encoded, encoding: .utf8))
        #expect(decodedString == "-0.5")

        // decode
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(SignedUnitInterval.self, from: encoded)
        #expect(decoded == interval)
    }

    @Test
    func customStringConvertible() throws {
        #expect(SignedUnitInterval(-0.5).description == "-0.5")
        #expect(SignedUnitInterval(0.0).description == "0.0")
        #expect(SignedUnitInterval(1.0).description == "1.0")
    }

    @Test
    func minMax() {
        #expect(SignedUnitInterval.min == -1.0)
        #expect(SignedUnitInterval.mid == 0.0)
        #expect(SignedUnitInterval.max == 1.0)
        #expect(SignedUnitInterval.range == -1.0 ... 1.0)

        #expect(SignedUnitInterval(rawValue: -1.0) == .min)
        #expect(SignedUnitInterval(rawValue: 0.0) == .mid)
        #expect(SignedUnitInterval(rawValue: 1.0) == .max)
    }

    @Test
    func sign() {
        #expect(SignedUnitInterval(-1.0).sign == .minus)
        #expect(SignedUnitInterval(-0.5).sign == .minus)
        #expect(SignedUnitInterval(-0.0).sign == .minus)
        #expect(SignedUnitInterval(0.0).sign == .plus)
        #expect(SignedUnitInterval(0.5).sign == .plus)
        #expect(SignedUnitInterval(1.0).sign == .plus)
    }

    @Test
    func absoluteUnitInterval() {
        #expect(SignedUnitInterval(-1.0).absoluteUnitInterval == UnitInterval(1.0))
        #expect(SignedUnitInterval(-0.5).absoluteUnitInterval == UnitInterval(0.5))
        #expect(SignedUnitInterval(-0.0).absoluteUnitInterval == UnitInterval(0.0))
        #expect(SignedUnitInterval(0.0).absoluteUnitInterval == UnitInterval(0.0))
        #expect(SignedUnitInterval(0.5).absoluteUnitInterval == UnitInterval(0.5))
        #expect(SignedUnitInterval(1.0).absoluteUnitInterval == UnitInterval(1.0))
    }

    @Test
    func scaledUnitInterval() {
        #expect(SignedUnitInterval(-1.0).scaledUnitInterval == UnitInterval(0.0))
        #expect(SignedUnitInterval(-0.5).scaledUnitInterval == UnitInterval(0.25))
        #expect(SignedUnitInterval(0.0).scaledUnitInterval == UnitInterval(0.5))
        #expect(SignedUnitInterval(0.5).scaledUnitInterval == UnitInterval(0.75))
        #expect(SignedUnitInterval(1.0).scaledUnitInterval == UnitInterval(1.0))
    }

    @Test
    func negate() {
        func negated(_ interval: SignedUnitInterval) -> SignedUnitInterval {
            var copy = interval
            copy.negate()
            return copy
        }

        #expect(negated(SignedUnitInterval(-1.0)) == SignedUnitInterval(1.0))
        #expect(negated(SignedUnitInterval(-0.5)) == SignedUnitInterval(0.5))
        #expect(negated(SignedUnitInterval(-0.0)) == SignedUnitInterval(0.0))
        #expect(negated(SignedUnitInterval(0.0)) == SignedUnitInterval(-0.0))
        #expect(negated(SignedUnitInterval(0.5)) == SignedUnitInterval(-0.5))
        #expect(negated(SignedUnitInterval(1.0)) == SignedUnitInterval(-1.0))
    }

    @Test
    func negated() {
        #expect(SignedUnitInterval(-1.0).negated == SignedUnitInterval(1.0))
        #expect(SignedUnitInterval(-0.5).negated == SignedUnitInterval(0.5))
        #expect(SignedUnitInterval(-0.0).negated == SignedUnitInterval(0.0))
        #expect(SignedUnitInterval(0.0).negated == SignedUnitInterval(-0.0))
        #expect(SignedUnitInterval(0.5).negated == SignedUnitInterval(-0.5))
        #expect(SignedUnitInterval(1.0).negated == SignedUnitInterval(-1.0))
    }

    @Test
    func init_scaling_unitInterval() {
        #expect(SignedUnitInterval(scaling: UnitInterval(0.0)) == SignedUnitInterval(-1.0))
        #expect(SignedUnitInterval(scaling: UnitInterval(0.25)) == SignedUnitInterval(-0.5))
        #expect(SignedUnitInterval(scaling: UnitInterval(0.5)) == SignedUnitInterval(0.0))
        #expect(SignedUnitInterval(scaling: UnitInterval(0.75)) == SignedUnitInterval(0.5))
        #expect(SignedUnitInterval(scaling: UnitInterval(1.0)) == SignedUnitInterval(1.0))
    }
}
