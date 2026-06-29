//
//  PropertyAccessorFoo NamePropertyAccessor.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import typealias Foundation.TimeInterval
import SwiftExtensions

extension PropertyAccessorFoo {
    public struct NamePropertyAccessor: PropertyAccessor {
        public let delay: TimeInterval?

        public init(delay: TimeInterval? = nil) {
            self.delay = delay
        }

        nonisolated
        public func newValue(for subject: borrowing PropertyAccessorFoo) -> PropertyUpdateResult<String> {
            if let delay {
                print("Getting new value for name")
                defer { print("Done getting new value for name") }
                sleep(delay)
            }
            return .newValue(subject.name + ".")
        }

        nonisolated
        public func set(value: consuming String, on subject: inout PropertyAccessorFoo) {
            subject.name = value
        }
    }
}

// MARK: - Static Constructor

extension PropertyAccessor where Self == PropertyAccessorFoo.NamePropertyAccessor {
    nonisolated
    public static func name(delay: TimeInterval? = nil) -> Self {
        PropertyAccessorFoo.NamePropertyAccessor(delay: delay)
    }
}
