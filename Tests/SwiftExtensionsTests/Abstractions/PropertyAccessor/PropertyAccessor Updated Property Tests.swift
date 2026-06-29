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
        let t = PropertyAccessorFoo(name: "NAME", value: 1)

        let a = t.updated(property: .name())
        let b = a.updated(property: .value())
        // let c = b.updated(property: .number()) // can't call this; requires await

        #expect(b.name == "NAME.")
        #expect(b.value == 2)
    }

    @MainActor @Test
    func updatedPropertySync_MainActor() /* NOT ASYNC */ {
        let t = PropertyAccessorFoo(name: "NAME", value: 1)

        let a = t.updated(property: .name())
        let b = a.updated(property: .value())
        // let c = b.updated(property: .number()) // can't call this; requires await

        #expect(b.name == "NAME.")
        #expect(b.value == 2)
    }

    @Test
    func updatedPropertyAsync() async throws {
        let t = PropertyAccessorFoo(name: "NAME", value: 1)

        let a = t.updated(property: .name())
        let b = a.updated(property: .value())
        let c = try await b.updated(property: .number())

        #expect(c.name == "NAME.")
        #expect(c.value == 2)
        #expect(c.number == 123)
    }

    @MainActor @Test
    func updatedPropertyAsync_MainActor() async throws {
        let t = PropertyAccessorFoo(name: "NAME", value: 1)

        let a = t.updated(property: .name())
        let b = a.updated(property: .value())
        let c = try await b.updated(property: .number())

        #expect(c.name == "NAME.")
        #expect(c.value == 2)
        #expect(c.number == 123)
    }

    @Test
    func updatedInBackgroundPropertyAsync() async throws {
        let t = PropertyAccessorFoo(name: "NAME", value: 1)

        let a = await t.updatedInBackground(property: .name())
        let b = await a.updatedInBackground(property: .value())
        let c = try await b.updatedInBackground(property: .number())

        #expect(c.name == "NAME.")
        #expect(c.value == 2)
        #expect(c.number == 123)
    }

    @MainActor @Test
    func updatedInBackgroundPropertyAsync_MainActor() async throws {
        let t = PropertyAccessorFoo(name: "NAME", value: 1)

        let a = await t.updatedInBackground(property: .name())
        let b = await a.updatedInBackground(property: .value())
        let c = try await b.updatedInBackground(property: .number())

        #expect(c.name == "NAME.")
        #expect(c.value == 2)
        #expect(c.number == 123)
    }
}
