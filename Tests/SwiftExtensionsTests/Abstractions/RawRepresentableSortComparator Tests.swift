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

        // using type inference
        do {
            let sortedForward = array.sorted(using: RawRepresentableSortComparator())
            #expect(sortedForward == [.one, .two, .three])

            let sortedReverse = array.sorted(using: RawRepresentableSortComparator(order: .reverse))
            #expect(sortedReverse == [.three, .two, .one])
        }

        // supplying type explicitly
        do {
            let sortedForward = array.sorted(using: RawRepresentableSortComparator(type: Foo.self))
            #expect(sortedForward == [.one, .two, .three])
        }

        do {
            let sortedReverse = array.sorted(using: RawRepresentableSortComparator(type: Foo.self, order: .reverse))
            #expect(sortedReverse == [.three, .two, .one])
        }
    }

    @Test
    func sortedUsing_wrapping() {
        enum Foo: String {
            case one = "a"
            case two = "A"
            case three = "b"
        }
        let array: [Foo] = [.three, .two, .one]

        // using type inference
        do {
            let sortedForward = array.sorted(using: RawRepresentableSortComparator(wrapping: .localized))
            #expect(sortedForward == [.one, .two, .three])

            let sortedReverse = array.sorted(using: RawRepresentableSortComparator(wrapping: .localized, order: .reverse))
            #expect(sortedReverse == [.one, .two, .three])
        }

        // supplying type explicitly
        do {
            let sortedForward = array.sorted(using: RawRepresentableSortComparator(type: Foo.self, wrapping: .localized))
            #expect(sortedForward == [.one, .two, .three])

            let sortedReverse = array.sorted(using: RawRepresentableSortComparator(type: Foo.self, wrapping: .localized, order: .reverse))
            #expect(sortedReverse == [.one, .two, .three])
        }
    }
}

#endif
