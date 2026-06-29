//
//  PropertyAccessor Update Property Tests.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftExtensions
import Testing

// MARK: - .update(property:)

@Suite
struct PropertyAccessor_Update_Property_Tests {
    // MARK: Non-Async Property

    @Test
    func updatePropertySync() /* NOT ASYNC */ {
        var t = PropertyAccessorFoo(name: "NAME")
        
        t.update(property: .name())
        t.update(property: .number())
        // t.update(property: .asyncNumber()) // can't call this; requires await

        #expect(t.name == "NAME.")
        #expect(t.number == 1)
    }
    
    @MainActor @Test
    func updatePropertySync_MainActor() /* NOT ASYNC */ {
        var t = PropertyAccessorFoo(name: "NAME")
        
        t.update(property: .name())
        t.update(property: .number())
        // t.update(property: .asyncNumber()) // can't call this; requires await

        #expect(t.name == "NAME.")
        #expect(t.number == 1)
    }
    
    @Test
    func updatePropertyAsync() async throws {
        var t = PropertyAccessorFoo(name: "NAME")
        
        t.update(property: .name())
        t.update(property: .number())
        try await t.update(property: .asyncNumber())

        #expect(t.name == "NAME.")
        #expect(t.number == 2)
    }
    
    @MainActor @Test
    func updatePropertyAsync_MainActor() async throws {
        var t = PropertyAccessorFoo(name: "NAME")
        
        t.update(property: .name())
        t.update(property: .number())
        try await t.update(property: .asyncNumber())

        #expect(t.name == "NAME.")
        #expect(t.number == 2)
    }
    
    @Test
    func updateInBackgroundPropertyAsync() async throws {
        var t = PropertyAccessorFoo(name: "NAME")
        
        await t.updateInBackground(property: .name())
        await t.updateInBackground(property: .number())
        try await t.updateInBackground(property: .asyncNumber())

        #expect(t.name == "NAME.")
        #expect(t.number == 2)
    }
    
    @MainActor @Test
    func updateInBackgroundPropertyAsync_MainActor() async throws {
        var t = PropertyAccessorFoo(name: "NAME")
        
        await t.updateInBackground(property: .name())
        await t.updateInBackground(property: .number())
        try await t.updateInBackground(property: .asyncNumber())

        #expect(t.name == "NAME.")
        #expect(t.number == 2)
    }
}
