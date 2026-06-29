//
//  PropertyAccessor Updated Property Tests.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftExtensions
import Testing

// MARK: - .updated(property:)

@Suite
struct PropertyAccessor_Updated_Property_Tests {
    @Test
    func updatedPropertySync() /* NOT ASYNC */ {
        let t = PropertyAccessorFoo(name: "NAME")

        let a = t.updated(property: .name())
        let b = a.updated(property: .number())
        // let c = b.updated(property: .asyncNumber()) // can't call this; requires await

        #expect(b.name == "NAME.")
        #expect(b.number == 1)
    }

    @MainActor @Test
    func updatedPropertySync_MainActor() /* NOT ASYNC */ {
        let t = PropertyAccessorFoo(name: "NAME")

        let a = t.updated(property: .name())
        let b = a.updated(property: .number())
        // let c = b.updated(property: .asyncNumber()) // can't call this; requires await

        #expect(b.name == "NAME.")
        #expect(b.number == 1)
    }

    @Test
    func updatedPropertyAsync() async throws {
        let t = PropertyAccessorFoo(name: "NAME")

        let a = t.updated(property: .name())
        let b = a.updated(property: .number())
        let c = try await b.updated(property: .asyncNumber())

        #expect(c.name == "NAME.")
        #expect(c.number == 2)
    }

    @MainActor @Test
    func updatedPropertyAsync_MainActor() async throws {
        let t = PropertyAccessorFoo(name: "NAME")

        let a = t.updated(property: .name())
        let b = a.updated(property: .number())
        let c = try await b.updated(property: .asyncNumber())

        #expect(c.name == "NAME.")
        #expect(c.number == 2)
    }

    @Test
    func updatedInBackgroundPropertyAsync() async throws {
        let t = PropertyAccessorFoo(name: "NAME")

        let a = await t.updatedInBackground(property: .name())
        let b = await a.updatedInBackground(property: .number())
        let c = try await b.updatedInBackground(property: .asyncNumber())

        #expect(c.name == "NAME.")
        #expect(c.number == 2)
    }

    @MainActor @Test
    func updatedInBackgroundPropertyAsync_MainActor() async throws {
        let t = PropertyAccessorFoo(name: "NAME")

        let a = await t.updatedInBackground(property: .name())
        let b = await a.updatedInBackground(property: .number())
        let c = try await b.updatedInBackground(property: .asyncNumber())

        #expect(c.name == "NAME.")
        #expect(c.number == 2)
    }
}
