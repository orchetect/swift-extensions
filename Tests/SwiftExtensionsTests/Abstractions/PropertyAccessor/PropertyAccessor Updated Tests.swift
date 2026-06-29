//
//  PropertyAccessor Updated Tests.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import SwiftExtensions
import Testing

// MARK: - .updated { }

@Suite
struct PropertyAccessor_Updated_Tests {
    @Test
    func updatedClosureSync() /* NOT ASYNC */ {
        let t = PropertyAccessorFoo(name: "NAME", value: 1)
        
        let copy = t.updated { updater in
            updater.update(.name())
            updater.update(.value())
            // updater.update(.number()) // can't call this; requires await
        }
        
        #expect(t.name == "NAME")
        #expect(t.value == 1)
        
        #expect(copy.name == "NAME.")
        #expect(copy.value == 2)
    }
    
    @MainActor @Test
    func updatedClosureSync_MainActor() /* NOT ASYNC */ {
        let t = PropertyAccessorFoo(name: "NAME", value: 1)
        
        let copy = t.updated { updater in
            MainActor.shared.assertIsolated()
            updater.update(.name())
            updater.update(.value())
            // updater.update(.number()) // can't call this; requires await
        }
        
        #expect(t.name == "NAME")
        #expect(t.value == 1)
        
        #expect(copy.name == "NAME.")
        #expect(copy.value == 2)
    }
    
    @Test
    func updatedClosureAsync() async throws {
        let t = PropertyAccessorFoo(name: "NAME", value: 1)
        
        let copy = try await t.updated { updater in
            updater.update(.name())
            updater.update(.value())
            try await updater.update(.number())
        }
        
        #expect(t.name == "NAME")
        #expect(t.value == 1)
        #expect(t.number == nil)

        #expect(copy.name == "NAME.")
        #expect(copy.value == 2)
        #expect(copy.number == 123)
    }
    
    @MainActor @Test
    func updatedClosureAsync_MainActor() async throws {
        let t = PropertyAccessorFoo(name: "NAME", value: 1)
        
        let copy = try await t.updated { updater in
            MainActor.shared.assertIsolated()
            updater.update(.name())
            updater.update(.value())
            try await updater.update(.number())
        }
        
        #expect(t.name == "NAME")
        #expect(t.value == 1)
        #expect(t.number == nil)

        #expect(copy.name == "NAME.")
        #expect(copy.value == 2)
        #expect(copy.number == 123)
    }
    
    @Test
    func updatedInBackgroundClosureAsync() async throws {
        let t = PropertyAccessorFoo(name: "NAME", value: 1)
        
        let copy = try await t.updatedInBackground { updater in
            updater.update(.name())
            updater.update(.value())
            try await updater.update(.number())
        }
        
        #expect(t.name == "NAME")
        #expect(t.value == 1)
        #expect(t.number == nil)

        #expect(copy.name == "NAME.")
        #expect(copy.value == 2)
        #expect(copy.number == 123)
    }
    
    @MainActor @Test
    func updatedInBackgroundClosureAsync_MainActor() async throws {
        let t = PropertyAccessorFoo(name: "NAME", value: 1)
        
        MainActor.shared.assertIsolated()
        
        let copy = try await t.updatedInBackground { updater in
            #expect(#isolation != MainActor.self)
            #expect(#isolation == nil)
            updater.update(.name())
            updater.update(.value())
            try await updater.update(.number())
        }
        
        #expect(t.name == "NAME")
        #expect(t.value == 1)
        #expect(t.number == nil)
        
        #expect(copy.name == "NAME.")
        #expect(copy.value == 2)
        #expect(copy.number == 123)
    }
}
