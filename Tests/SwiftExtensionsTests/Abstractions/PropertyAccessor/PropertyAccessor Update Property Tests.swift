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
        var t = PropertyAccessorFoo(name: "NAME", value: 1)
        
        t.update(property: .name())
        t.update(property: .value())
        // t.update(property: .number()) // can't call this; requires await
        #expect(t.name == "NAME.")
        #expect(t.value == 2)
    }
    
    @MainActor @Test
    func updatePropertySync_MainActor() /* NOT ASYNC */ {
        var t = PropertyAccessorFoo(name: "NAME", value: 1)
        
        t.update(property: .name())
        t.update(property: .value())
        // t.update(property: .number()) // can't call this; requires await
        #expect(t.name == "NAME.")
        #expect(t.value == 2)
    }
    
    @Test
    func updatePropertyAsync() async throws {
        var t = PropertyAccessorFoo(name: "NAME", value: 1)
        
        t.update(property: .name())
        t.update(property: .value())
        try await t.update(property: .number())
        
        #expect(t.name == "NAME.")
        #expect(t.value == 2)
        #expect(t.number == 123)
    }
    
    @MainActor @Test
    func updatePropertyAsync_MainActor() async throws {
        var t = PropertyAccessorFoo(name: "NAME", value: 1)
        
        t.update(property: .name())
        t.update(property: .value())
        try await t.update(property: .number())
        
        #expect(t.name == "NAME.")
        #expect(t.value == 2)
        #expect(t.number == 123)
    }
    
    @Test
    func updateInBackgroundPropertyAsync() async throws {
        var t = PropertyAccessorFoo(name: "NAME", value: 1)
        
        await t.updateInBackground(property: .name())
        await t.updateInBackground(property: .value())
        try await t.updateInBackground(property: .number())
        
        #expect(t.name == "NAME.")
        #expect(t.value == 2)
        #expect(t.number == 123)
    }
    
    @MainActor @Test
    func updateInBackgroundPropertyAsync_MainActor() async throws {
        var t = PropertyAccessorFoo(name: "NAME", value: 1)
        
        await t.updateInBackground(property: .name())
        await t.updateInBackground(property: .value())
        try await t.updateInBackground(property: .number())
        
        #expect(t.name == "NAME.")
        #expect(t.value == 2)
        #expect(t.number == 123)
    }
}
