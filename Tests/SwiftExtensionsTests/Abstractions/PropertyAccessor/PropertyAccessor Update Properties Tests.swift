//
//  PropertyAccessor Update Properties Tests.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftExtensions
import Testing

// MARK: - .update(properties:)

@Suite
struct PropertyAccessor_Update_Properties_Tests {
    // MARK: Homogenous Properties

    @available(iOS 16, watchOS 9, tvOS 16, *)
    @Test
    func updatePropertiesSync() /* NOT ASYNC */ throws {
        var t = PropertyAccessorFoo(name: "NAME", value: 1)

        try t.update(properties: [.name(), .value()]) // .number() // can't include this; requires await
        #expect(t.name == "NAME.")
        #expect(t.value == 2)
    }

    @available(iOS 16, watchOS 9, tvOS 16, *)
    @MainActor @Test
    func updatePropertiesSync_MainActor() /* NOT ASYNC */ throws {
        var t = PropertyAccessorFoo(name: "NAME", value: 1)

        try t.update(properties: [.name(), .value()]) // .number() // can't include this; requires await
        #expect(t.name == "NAME.")
        #expect(t.value == 2)
    }

    @available(iOS 16, watchOS 9, tvOS 16, *)
    @Test
    func updatePropertiesASync() async throws {
        var t = PropertyAccessorFoo(name: "NAME", value: 1)

        try await t.update(properties: [.number()])
        #expect(t.name == "NAME")
        #expect(t.value == 1)
        #expect(t.number == 123)
    }

    @available(iOS 16, watchOS 9, tvOS 16, *)
    @MainActor @Test
    func updatePropertiesASync_MainActor() async throws {
        var t = PropertyAccessorFoo(name: "NAME", value: 1)

        try await t.update(properties: [.number()])
        #expect(t.name == "NAME")
        #expect(t.value == 1)
        #expect(t.number == 123)
    }

    // MARK: Properties Builder

    @Test
    func updatePropertiesAsync() async throws {
        var t = PropertyAccessorFoo(name: "NAME", value: 1)

        try await t.update { properties in
            properties.add(.name())
            properties.add(.value())
            properties.add(.number())
        }

        #expect(t.name == "NAME.")
        #expect(t.value == 2)
        #expect(t.number == 123)
    }

    @MainActor @Test
    func updatePropertiesAsync_MainActor() async throws {
        var t = PropertyAccessorFoo(name: "NAME", value: 1)

        try await t.update { properties in
            properties.add(.name())
            properties.add(.value())
            properties.add(.number())
        }

        #expect(t.name == "NAME.")
        #expect(t.value == 2)
        #expect(t.number == 123)
    }

    @Test
    func updateInBackgroundPropertiesAsync() async throws {
        var t = PropertyAccessorFoo(name: "NAME", value: 1)

        try await t.updateInBackground { properties in
            properties.add(.name())
            properties.add(.value())
            properties.add(.number())
        }

        #expect(t.name == "NAME.")
        #expect(t.value == 2)
        #expect(t.number == 123)
    }

    @MainActor @Test
    func updateInBackgroundPropertiesAsync_MainActor() async throws {
        var t = PropertyAccessorFoo(name: "NAME", value: 1)

        try await t.updateInBackground { properties in
            properties.add(.name())
            properties.add(.value())
            properties.add(.number())
        }

        #expect(t.name == "NAME.")
        #expect(t.value == 2)
        #expect(t.number == 123)
    }
}
