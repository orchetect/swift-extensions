//
//  Data Readers Test Utilities.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

extension ArraySlice<UInt8> {
    static func == (lhs: Self, rhs: some Sequence<UInt8>) -> Bool {
        lhs.elementsEqual(rhs)
    }
}

extension Sequence<UInt8> {
    static func == (lhs: Self, rhs: ArraySlice<UInt8>) -> Bool {
        lhs.elementsEqual(rhs)
    }
}

#endif
