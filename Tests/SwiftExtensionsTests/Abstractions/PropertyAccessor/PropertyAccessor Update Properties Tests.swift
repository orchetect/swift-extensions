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

    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    @Test
    func updateSeriallyPropertiesSync() /* NOT ASYNC */ throws {
        var t = PropertyAccessorFoo(name: "NAME")

        // .number() // can't include this; requires await
        #if compiler(>=6.2)
        try t.updateSerially(properties: [.name(), .number()])
        #else
        // Xcode 16.4 compiler crashes when using static constructors (`.name()`, etc.)
        try t.update(properties: [PropertyAccessorFoo.NamePropertyAccessor(), PropertyAccessorFoo.NumberPropertyAccessor()])
        #endif

        #expect(t.name == "NAME.")
        #expect(t.number == 1)
    }

    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    @MainActor @Test
    func updateSeriallyPropertiesSync_MainActor() /* NOT ASYNC */ throws {
        var t = PropertyAccessorFoo(name: "NAME")

        // .number() // can't include this; requires await
        #if compiler(>=6.2)
        try t.updateSerially(properties: [.name(), .number()])
        #else
        // Xcode 16.4 compiler crashes when using static constructors (`.name()`, etc.)
        try t.updateSerially(properties: [PropertyAccessorFoo.NamePropertyAccessor(), PropertyAccessorFoo.NumberPropertyAccessor()])
        #endif

        #expect(t.name == "NAME.")
        #expect(t.number == 1)
    }

    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    @Test
    func updateSeriallyPropertiesASync() async throws {
        var t = PropertyAccessorFoo(name: "NAME")

        #if compiler(>=6.2)
        try await t.updateSerially(properties: [.asyncNumber()])
        #else
        try await t.updateSerially(properties: [PropertyAccessorFoo.AsyncNumberPropertyAccessor()])
        #endif

        #expect(t.name == "NAME")
        #expect(t.number == 1)
    }

    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    @MainActor @Test
    func updateSeriallyPropertiesASync_MainActor() async throws {
        var t = PropertyAccessorFoo(name: "NAME")

        #if compiler(>=6.2)
        try await t.updateSerially(properties: [.asyncNumber()])
        #else
        try await t.updateSerially(properties: [PropertyAccessorFoo.AsyncNumberPropertyAccessor()])
        #endif

        #expect(t.name == "NAME")
        #expect(t.number == 1)
    }

    // MARK: Properties Builder

    @Test(arguments: 0 ... 10) // fuzz test by running multiple times
    func updateSeriallyPropertiesAsync(iteration: Int) async throws {
        var t = PropertyAccessorFoo(name: "NAME")

        try await t.updateSerially { properties in
            properties.add(.name(delay: .random(in: 0.1 ... 0.3)))
            properties.add(.number(delay: .random(in: 0.1 ... 0.3)))
            properties.add(.asyncNumber(delay: .random(in: 0.1 ... 0.3)))
        }

        #expect(t.name == "NAME.")
        #expect(t.number == 2)
    }

    @MainActor @Test(arguments: 0 ... 10) // fuzz test by running multiple times
    func updateSeriallyPropertiesAsync_MainActor(iteration: Int) async throws {
        var t = PropertyAccessorFoo(name: "NAME")

        try await t.updateSerially { properties in
            properties.add(.name(delay: .random(in: 0.1 ... 0.3)))
            properties.add(.number(delay: .random(in: 0.1 ... 0.3)))
            properties.add(.asyncNumber(delay: .random(in: 0.1 ... 0.3)))
        }

        #expect(t.name == "NAME.")
        #expect(t.number == 2)
    }

    @Test(arguments: 0 ... 10) // fuzz test by running multiple times
    func updateConcurrentlyInBackgroundPropertiesAsync(iteration: Int) async throws {
        var t = PropertyAccessorFoo(name: "NAME")

        try await t.updateConcurrentlyInBackground { properties in
            properties.add(.name(delay: .random(in: 0.1 ... 0.3)))
            properties.add(.number(delay: .random(in: 0.1 ... 0.3)))
            properties.add(.asyncNumber(delay: .random(in: 0.1 ... 0.3)))
        }

        #expect(t.name == "NAME.")
        // not 2, because properties all generate new values from the same subject in parallel
        #expect(t.number == 1)
    }

    @MainActor @Test(arguments: 0 ... 10) // fuzz test by running multiple times
    func updateConcurrentlyInBackgroundPropertiesAsync_MainActor(iteration: Int) async throws {
        var t = PropertyAccessorFoo(name: "NAME")

        try await t.updateConcurrentlyInBackground { properties in
            properties.add(.name(delay: .random(in: 0.1 ... 0.3)))
            properties.add(.number(delay: .random(in: 0.1 ... 0.3)))
            properties.add(.asyncNumber(delay: .random(in: 0.1 ... 0.3)))
        }

        #expect(t.name == "NAME.")
        // not 2, because properties all generate new values from the same subject in parallel
        #expect(t.number == 1)
    }
}

#if !GITHUB_ACTIONS
@Suite(.serialized)
struct PropertyAccessor_Update_Properties_Performance_Tests {
    /// Checks that all properties update concurrently, not serially.
    @Test
    func updateConcurrentlyPropertiesAsync_performanceCheck() async throws {
        try await Task(priority: .userInitiated) { // raise task priority to increase timing precision
            var t = PropertyAccessorFoo(name: "NAME")

            let inTime = Date()
            try await t.updateConcurrently { properties in
                properties.add(.asyncNumber(delay: 1.0))
                properties.add(.asyncNumber(delay: 1.0))
                properties.add(.asyncNumber(delay: 1.0))
            }
            let outTime = Date()

            let duration = outTime.timeIntervalSince(inTime)
            print("Updates too \(duration) seconds")
            #expect(duration >= 1.0)
            #expect(duration < 3.0) // Note: This can be flakey on slow/crowded CI pipelines

            // not 3, because properties all generate new values from the same subject in parallel
            #expect(t.number == 1)
        }.value
    }

    /// Checks that all properties update concurrently, not serially.
    @Test
    func updateConcurrentlyInBackgroundPropertiesAsync_performanceCheck() async throws {
        try await Task(priority: .userInitiated) { // raise task priority to increase timing precision
            var t = PropertyAccessorFoo(name: "NAME")

            let inTime = Date()
            try await t.updateConcurrentlyInBackground { properties in
                properties.add(.asyncNumber(delay: 1.0))
                properties.add(.asyncNumber(delay: 1.0))
                properties.add(.asyncNumber(delay: 1.0))
            }
            let outTime = Date()

            let duration = outTime.timeIntervalSince(inTime)
            print("Updates too \(duration) seconds")
            #expect(duration >= 1.0)
            #expect(duration < 1.25) // allow +0.25 second margin

            // not 3, because properties all generate new values from the same subject in parallel
            #expect(t.number == 1)
        }.value
    }
}
#endif
