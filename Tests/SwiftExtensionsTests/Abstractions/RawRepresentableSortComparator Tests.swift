//
//  RawRepresentableSortComparator Tests.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
import SwiftExtensions
import Testing

@Suite struct RawRepresentableSortComparator_Tests {
    @Test
    func sortedUsing() {
        enum Foo: Int {
            case one = 1
            case two = 2
            case three = 3
        }
        let array: [Foo] = [.three, .one, .two]

        // comparator used directly
        let sortedForward = array.sorted(using: RawRepresentableSortComparator())
        #expect(sortedForward == [.one, .two, .three])
    }
}

#endif
