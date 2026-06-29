//
//  PropertyAccessor Updated Tests.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if compiler(>=6.2)

import Foundation
@testable import SwiftExtensions
import Testing

// MARK: - .updated { }

@Suite
struct PropertyAccessor_Updated_Tests {
    @Test
    func updatedClosureSync() /* NOT ASYNC */ {
        let t = PropertyAccessorFoo(name: "NAME")
        
        let copy = t.updated { updater in
            updater.update(.name())
            updater.update(.number())
            // updater.update(.asyncNumber()) // can't call this; requires await
        }
        
        #expect(t.name == "NAME")
        #expect(t.number == nil)

        #expect(copy.name == "NAME.")
        #expect(copy.number == 1)
    }
    
    @MainActor @Test
    func updatedClosureSync_MainActor() /* NOT ASYNC */ {
        let t = PropertyAccessorFoo(name: "NAME")
        
        let copy = t.updated { updater in
            MainActor.shared.assertIsolated()
            updater.update(.name())
            updater.update(.number())
            // updater.update(.asyncNumber()) // can't call this; requires await
        }
        
        #expect(t.name == "NAME")
        #expect(t.number == nil)

        #expect(copy.name == "NAME.")
        #expect(copy.number == 1)
    }
    
    @Test
    func updatedClosureAsync() async throws {
        let t = PropertyAccessorFoo(name: "NAME")
        
        let copy = try await t.updated { updater in
            updater.update(.name())
            updater.update(.number())
            try await updater.update(.asyncNumber())
        }
        
        #expect(t.name == "NAME")
        #expect(t.number == nil)
        #expect(t.number == nil)

        #expect(copy.name == "NAME.")
        #expect(copy.number == 2)
    }
    
    @MainActor @Test
    func updatedClosureAsync_MainActor() async throws {
        let t = PropertyAccessorFoo(name: "NAME")
        
        let copy = try await t.updated { updater in
            MainActor.shared.assertIsolated()
            updater.update(.name())
            updater.update(.number())
            try await updater.update(.asyncNumber())
        }
        
        #expect(t.name == "NAME")
        #expect(t.number == nil)
        #expect(t.number == nil)

        #expect(copy.name == "NAME.")
        #expect(copy.number == 2)
    }
    
    @Test
    func updatedInBackgroundClosureAsync() async throws {
        let t = PropertyAccessorFoo(name: "NAME")
        
        let copy = try await t.updatedInBackground { updater in
            updater.update(.name())
            updater.update(.number())
            try await updater.update(.asyncNumber())
        }
        
        #expect(t.name == "NAME")
        #expect(t.number == nil)
        #expect(t.number == nil)

        #expect(copy.name == "NAME.")
        #expect(copy.number == 2)
    }
    
    @MainActor @Test
    func updatedInBackgroundClosureAsync_MainActor() async throws {
        let t = PropertyAccessorFoo(name: "NAME")
        
        MainActor.shared.assertIsolated()
        
        let copy = try await t.updatedInBackground { updater in
            #expect(#isolation != MainActor.self)
            #expect(#isolation == nil)
            updater.update(.name())
            updater.update(.number())
            try await updater.update(.asyncNumber())
        }
        
        #expect(t.name == "NAME")
        #expect(t.number == nil)
        #expect(t.number == nil)
        
        #expect(copy.name == "NAME.")
        #expect(copy.number == 2)
    }
}

#endif
