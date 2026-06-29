//
//  GenericPropertyAccessor Tests.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if compiler(>=6.2)

import Foundation
@testable import SwiftExtensions
import Testing

// MARK: - .updated { }

@Suite
struct GenericPropertyAccessor_Tests {
    @Test
    func updatedClosureSync() /* NOT ASYNC */ {
        let t = PropertyAccessorFoo(name: "NAME")

        let copy = t.updated { updater in
            updater.update(.genericNumber)
            // updater.update(.asyncGenericNumber) // can't call this; requires await
        }

        #expect(t.name == "NAME")
        #expect(t.number == nil)

        #expect(copy.name == "NAME")
        #expect(copy.number == 1)
    }

    @MainActor @Test
    func updatedClosureSync_MainActor() /* NOT ASYNC */ {
        let t = PropertyAccessorFoo(name: "NAME")

        let copy = t.updated { updater in
            MainActor.shared.assertIsolated()
            updater.update(.genericNumber)
            // updater.update(.asyncGenericNumber) // can't call this; requires await
        }

        #expect(t.name == "NAME")
        #expect(t.number == nil)

        #expect(copy.name == "NAME")
        #expect(copy.number == 1)
    }
}

#endif
