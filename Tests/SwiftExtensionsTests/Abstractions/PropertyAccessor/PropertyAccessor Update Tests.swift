//
//  PropertyAccessor Update Tests.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if compiler(>=6.2)

import Foundation
@testable import SwiftExtensions
import Testing

// MARK: - .update { }

@Suite
struct PropertyAccessor_Update_Tests {
    @Test
    func updateClosureSync() /* NOT ASYNC */ {
        var t = PropertyAccessorFoo(name: "NAME", value: 1)

        t.update { updater in
            updater.update(.name())
            updater.update(.value())
            // updater.update(.number()) // can't call this; requires await
        }

        #expect(t.name == "NAME.")
        #expect(t.value == 2)
    }

    @MainActor @Test
    func updateClosureSync_MainActor() /* NOT ASYNC */ {
        var t = PropertyAccessorFoo(name: "NAME", value: 1)

        t.update { updater in
            MainActor.shared.assertIsolated()
            updater.update(.name())
            updater.update(.value())
            // updater.update(.number()) // can't call this; requires await
        }

        #expect(t.name == "NAME.")
        #expect(t.value == 2)
    }

    @Test
    func updateClosureAsync() async throws {
        var t = PropertyAccessorFoo(name: "NAME", value: 1)

        try await t.update { updater in
            updater.update(.name())
            updater.update(.value())
            try await updater.update(.number())
        }

        #expect(t.name == "NAME.")
        #expect(t.value == 2)
        #expect(t.number == 123)
    }

    @MainActor @Test
    func updateClosureAsync_MainActor() async throws {
        var t = PropertyAccessorFoo(name: "NAME", value: 1)

        MainActor.shared.assertIsolated()

        try await t.update { updater in
            MainActor.shared.assertIsolated()
            updater.update(.name())
            updater.update(.value())
            try await updater.update(.number())
        }

        #expect(t.name == "NAME.")
        #expect(t.value == 2)
        #expect(t.number == 123)
    }

    @Test
    func updateInBackgroundClosureAsync() async throws {
        var t = PropertyAccessorFoo(name: "NAME", value: 1)

        try await t.updateInBackground { updater in
            updater.update(.name())
            updater.update(.value())
            try await updater.update(.number())
        }

        #expect(t.name == "NAME.")
        #expect(t.value == 2)
        #expect(t.number == 123)
    }

    @MainActor @Test
    func updateInBackgroundClosureAsync_MainActor() async throws {
        var t = PropertyAccessorFoo(name: "NAME", value: 1)

        MainActor.shared.assertIsolated()

        try await t.updateInBackground { updater in
            #expect(#isolation != MainActor.self)
            #expect(#isolation == nil)
            updater.update(.name())
            updater.update(.value())
            try await updater.update(.number())
        }

        #expect(t.name == "NAME.")
        #expect(t.value == 2)
        #expect(t.number == 123)
    }
}

#endif
