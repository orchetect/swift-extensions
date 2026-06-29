//
//  PropertyAccessorFoo.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import class Foundation.NSNumber
import SwiftExtensions

public struct PropertyAccessorFoo {
    public var name: String
    public var value: Int
    public var number: NSNumber?

    public init(name: String = "", value: Int = 0, number: NSNumber? = nil) {
        self.name = name
        self.value = value
        self.number = number
    }
}

extension PropertyAccessorFoo: Equatable { }

extension PropertyAccessorFoo: Hashable { }

extension PropertyAccessorFoo: Sendable { }

extension PropertyAccessorFoo: PropertyAccessorSubject { }
