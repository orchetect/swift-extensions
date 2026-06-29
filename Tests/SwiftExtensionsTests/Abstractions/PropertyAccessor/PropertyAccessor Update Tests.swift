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
        var t = PropertyAccessorFoo(name: "NAME")

        t.update { updater in
            updater.update(.name())
            updater.update(.number())
            // updater.update(.asyncNumber()) // can't call this; requires await
        }

        #expect(t.name == "NAME.")
        #expect(t.number == 1)
    }

    @MainActor @Test
    func updateClosureSync_MainActor() /* NOT ASYNC */ {
        var t = PropertyAccessorFoo(name: "NAME")

        t.update { updater in
            MainActor.shared.assertIsolated()
            updater.update(.name())
            updater.update(.number())
            // updater.update(.asyncNumber()) // can't call this; requires await
        }

        #expect(t.name == "NAME.")
        #expect(t.number == 1)
    }

    @Test
    func updateClosureAsync() async throws {
        var t = PropertyAccessorFoo(name: "NAME")

        try await t.update { updater in
            updater.update(.name())
            updater.update(.number())
            try await updater.update(.asyncNumber())
        }

        #expect(t.name == "NAME.")
        #expect(t.number == 2)
    }

    @MainActor @Test
    func updateClosureAsync_MainActor() async throws {
        var t = PropertyAccessorFoo(name: "NAME")

        MainActor.shared.assertIsolated()

        try await t.update { updater in
            MainActor.shared.assertIsolated()
            updater.update(.name())
            updater.update(.number())
            try await updater.update(.asyncNumber())
        }

        #expect(t.name == "NAME.")
        #expect(t.number == 2)
    }

    @Test
    func updateInBackgroundClosureAsync() async throws {
        var t = PropertyAccessorFoo(name: "NAME")

        try await t.updateInBackground { updater in
            updater.update(.name())
            updater.update(.number())
            try await updater.update(.asyncNumber())
        }

        #expect(t.name == "NAME.")
        #expect(t.number == 2)
    }

    @MainActor @Test
    func updateInBackgroundClosureAsync_MainActor() async throws {
        var t = PropertyAccessorFoo(name: "NAME")

        MainActor.shared.assertIsolated()

        try await t.updateInBackground { updater in
            #expect(#isolation != MainActor.self)
            #expect(#isolation == nil)
            updater.update(.name())
            updater.update(.number())
            try await updater.update(.asyncNumber())
        }

        #expect(t.name == "NAME.")
        #expect(t.number == 2)
    }
}

#endif
