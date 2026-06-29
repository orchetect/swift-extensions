//
//  PropertyAccessorFoo.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import class Foundation.NSNumber
import SwiftExtensions

public struct PropertyAccessorFoo {
    public var name: String
    public var number: NSNumber?

    public func getNumber() async -> Int { Int(truncating: number ?? 0) }
    public mutating func setNumber(_ newValue: Int) async { number = newValue as NSNumber }

    public init(name: String = "", number: Int? = nil) {
        self.name = name
        self.number = number as NSNumber?
    }
}

extension PropertyAccessorFoo: Equatable { }

extension PropertyAccessorFoo: Hashable { }

extension PropertyAccessorFoo: Sendable { }

extension PropertyAccessorFoo: PropertyAccessorSubject { }
