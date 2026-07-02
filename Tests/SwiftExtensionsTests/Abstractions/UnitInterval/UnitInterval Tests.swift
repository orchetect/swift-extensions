//
//  UnitInterval Tests.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftExtensions
import Testing

@Suite
struct UnitInterval_Tests {
    @Test
    func init_rawValue() {
        #expect(UnitInterval(rawValue: -0.1).rawValue == 0.0)
        #expect(UnitInterval(rawValue: 0.0).rawValue == 0.0)
        #expect(UnitInterval(rawValue: 0.5).rawValue == 0.5)
        #expect(UnitInterval(rawValue: 1.0).rawValue == 1.0)
        #expect(UnitInterval(rawValue: 1.1).rawValue == 1.0)
    }

    @Test
    func init_binaryInteger() {
        #expect(UnitInterval(Int(-1)).rawValue == 0.0)
        #expect(UnitInterval(Int(0)).rawValue == 0.0)
        #expect(UnitInterval(Int(1)).rawValue == 1.0)
        #expect(UnitInterval(Int(2)).rawValue == 1.0)

        #expect(UnitInterval(UInt8(0)).rawValue == 0.0)
        #expect(UnitInterval(UInt8(1)).rawValue == 1.0)
        #expect(UnitInterval(UInt8(2)).rawValue == 1.0)

        #expect(UnitInterval(Int8(-1)).rawValue == 0.0)
        #expect(UnitInterval(Int8(0)).rawValue == 0.0)
        #expect(UnitInterval(Int8(1)).rawValue == 1.0)
        #expect(UnitInterval(Int8(2)).rawValue == 1.0)

        #expect(UnitInterval(UInt16(0)).rawValue == 0.0)
        #expect(UnitInterval(UInt16(1)).rawValue == 1.0)
        #expect(UnitInterval(UInt16(2)).rawValue == 1.0)

        #expect(UnitInterval(Int16(-1)).rawValue == 0.0)
        #expect(UnitInterval(Int16(0)).rawValue == 0.0)
        #expect(UnitInterval(Int16(1)).rawValue == 1.0)
        #expect(UnitInterval(Int16(2)).rawValue == 1.0)

        #expect(UnitInterval(UInt32(0)).rawValue == 0.0)
        #expect(UnitInterval(UInt32(1)).rawValue == 1.0)
        #expect(UnitInterval(UInt32(2)).rawValue == 1.0)

        #expect(UnitInterval(Int32(-1)).rawValue == 0.0)
        #expect(UnitInterval(Int32(0)).rawValue == 0.0)
        #expect(UnitInterval(Int32(1)).rawValue == 1.0)
        #expect(UnitInterval(Int32(2)).rawValue == 1.0)

        #expect(UnitInterval(UInt64(0)).rawValue == 0.0)
        #expect(UnitInterval(UInt64(1)).rawValue == 1.0)
        #expect(UnitInterval(UInt64(2)).rawValue == 1.0)

        #expect(UnitInterval(Int64(-1)).rawValue == 0.0)
        #expect(UnitInterval(Int64(0)).rawValue == 0.0)
        #expect(UnitInterval(Int64(1)).rawValue == 1.0)
        #expect(UnitInterval(Int64(2)).rawValue == 1.0)
    }

    @Test
    func init_binaryFloatingPoint() {
        #expect(UnitInterval(Float(-1.0)).rawValue == 0.0)
        #expect(UnitInterval(Float(0.0)).rawValue == 0.0)
        #expect(UnitInterval(Float(0.5)).rawValue == 0.5)
        #expect(UnitInterval(Float(1.0)).rawValue == 1.0)
        #expect(UnitInterval(Float(1.1)).rawValue == 1.0)
    }

    @Test
    func init_string() {
        #expect(UnitInterval("-1")?.rawValue == 0.0)
        #expect(UnitInterval("0")?.rawValue == 0.0)
        #expect(UnitInterval("1")?.rawValue == 1.0)
        #expect(UnitInterval("2")?.rawValue == 1.0)

        #expect(UnitInterval("-1.0")?.rawValue == 0.0)
        #expect(UnitInterval("0.0")?.rawValue == 0.0)
        #expect(UnitInterval("0.5")?.rawValue == 0.5)
        #expect(UnitInterval("1.0")?.rawValue == 1.0)
        #expect(UnitInterval("2.0")?.rawValue == 1.0)

        // edge cases
        #expect(UnitInterval("")?.rawValue == nil)
        #expect(UnitInterval("abc")?.rawValue == nil)
        #expect(UnitInterval("123abc")?.rawValue == nil)
        #expect(UnitInterval("abc123")?.rawValue == nil)
        #expect(UnitInterval("123 abc")?.rawValue == nil)
    }

    @Test
    func expressibleByFloatLiteral() {
        func interval(_ i: UnitInterval) -> UnitInterval {
            i
        }

        #expect(interval(-1.0).rawValue == 0.0)
        #expect(interval(0.0).rawValue == 0.0)
        #expect(interval(0.5).rawValue == 0.5)
        #expect(interval(1.0).rawValue == 1.0)
        #expect(interval(1.1).rawValue == 1.0)
    }

    @Test
    func equality() {
        #expect(UnitInterval(0.0) == UnitInterval(0.0))
        #expect(UnitInterval(0.0) != UnitInterval(1.0))
    }


    @Test
    func comparable() {
        #expect(!(UnitInterval(0.0) > UnitInterval(0.0)))
        #expect(!(UnitInterval(0.0) < UnitInterval(0.0)))

        #expect(UnitInterval(0.0) < UnitInterval(1.0))
        #expect(!(UnitInterval(0.0) > UnitInterval(1.0)))

        #expect(!(UnitInterval(1.0) < UnitInterval(0.0)))
        #expect(UnitInterval(1.0) > UnitInterval(0.0))
    }

    @Test
    func hashable() {
        #expect(Set([UnitInterval(0.0), UnitInterval(0.0)]).count == 1)
        #expect(Set([UnitInterval(1.0), UnitInterval(1.0)]).count == 1)
        #expect(Set([UnitInterval(0.0), UnitInterval(1.0)]).count == 2)
    }

    @Test
    func codable() throws {
        let interval = UnitInterval(0.5)

        // encode
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(interval)

        // analyze encoded data to ensure it encodes as a single value
        let decodedString = try #require(String(data: encoded, encoding: .utf8))
        #expect(decodedString == "0.5")

        // decode
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(UnitInterval.self, from: encoded)
        #expect(decoded == interval)
    }

    @Test
    func customStringConvertible() throws {
        #expect(UnitInterval(0.0).description == "0.0")
        #expect(UnitInterval(0.5).description == "0.5")
        #expect(UnitInterval(1.0).description == "1.0")
    }

    @Test
    func minMax() {
        #expect(UnitInterval.min == 0.0)
        #expect(UnitInterval.mid == 0.5)
        #expect(UnitInterval.max == 1.0)
        #expect(UnitInterval.range == 0.0 ... 1.0)

        #expect(UnitInterval(rawValue: 0.0) == .min)
        #expect(UnitInterval(rawValue: 0.5) == .mid)
        #expect(UnitInterval(rawValue: 1.0) == .max)
    }

    @Test
    func signedUnitInterval_sign() {
        #expect(UnitInterval(0.0).signedUnitInterval(sign: .plus) == 0.0)
        #expect(UnitInterval(0.5).signedUnitInterval(sign: .plus) == 0.5)
        #expect(UnitInterval(0.5).signedUnitInterval(sign: .minus) == -0.5)
        #expect(UnitInterval(1.0).signedUnitInterval(sign: .plus) == 1.0)
        #expect(UnitInterval(1.0).signedUnitInterval(sign: .minus) == -1.0)
    }

    @Test
    func scaledSignedUnitInterval() {
        #expect(UnitInterval(0.0).scaledSignedUnitInterval == SignedUnitInterval(-1.0))
        #expect(UnitInterval(0.25).scaledSignedUnitInterval == SignedUnitInterval(-0.5))
        #expect(UnitInterval(0.5).scaledSignedUnitInterval == SignedUnitInterval(0.0))
        #expect(UnitInterval(0.75).scaledSignedUnitInterval == SignedUnitInterval(0.5))
        #expect(UnitInterval(1.0).scaledSignedUnitInterval == SignedUnitInterval(1.0))
    }

    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) // for language check
    @Test(.enabled(ifLocaleLanguageCode: .english))
    func localizedPercentageString() {
        #expect(UnitInterval(0.0).localizedPercentageString(fractionLength: 0) == "0%")
        #expect(UnitInterval(0.0).localizedPercentageString(fractionLength: 1) == "0.0%")
        #expect(UnitInterval(1.0).localizedPercentageString(fractionLength: 0) == "100%")
        #expect(UnitInterval(1.0).localizedPercentageString(fractionLength: 1) == "100.0%")
    }

    @Test
    func init_scaling_signedUnitInterval() {
        #expect(UnitInterval(scaling: SignedUnitInterval(-1.0)) == UnitInterval(0.0))
        #expect(UnitInterval(scaling: SignedUnitInterval(-0.5)) == UnitInterval(0.25))
        #expect(UnitInterval(scaling: SignedUnitInterval(0.0)) == UnitInterval(0.5))
        #expect(UnitInterval(scaling: SignedUnitInterval(0.5)) == UnitInterval(0.75))
        #expect(UnitInterval(scaling: SignedUnitInterval(1.0)) == UnitInterval(1.0))
    }
}
