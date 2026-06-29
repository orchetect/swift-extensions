//
//  PropertyAccessorFoo NamePropertyAccessor.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftExtensions

extension PropertyAccessorFoo {
    nonisolated
    public struct NamePropertyAccessor: PropertyAccessor {
        public let isDelayed: Bool

        public init(delay isDelayed: Bool = false) {
            self.isDelayed = isDelayed
        }

        nonisolated
        public func newValue(for subject: borrowing PropertyAccessorFoo) -> PropertyUpdateResult<String> {
            if isDelayed {
                print("Getting new value for name")
                defer { print("Done getting new value for name") }
                sleep(1)
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
    public static func name(delay isDelayed: Bool = false) -> Self {
        PropertyAccessorFoo.NamePropertyAccessor(delay: isDelayed)
    }
}
