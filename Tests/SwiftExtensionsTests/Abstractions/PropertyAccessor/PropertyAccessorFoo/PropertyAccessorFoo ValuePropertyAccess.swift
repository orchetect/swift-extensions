//
//  PropertyAccessorFoo ValuePropertyAccessor.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftExtensions

extension PropertyAccessorFoo {
    nonisolated
    public struct ValuePropertyAccessor: PropertyAccessor {
        public let increment: Int
        public let isDelayed: Bool

        public init(increment: Int = 1, delay isDelayed: Bool = false) {
            self.increment = increment
            self.isDelayed = isDelayed
        }

        nonisolated
        public func newValue(for subject: borrowing PropertyAccessorFoo) -> PropertyUpdateResult<Int> {
            if isDelayed {
                print("Getting new value for value")
                defer { print("Done getting new value for value") }
                sleep(1)
            }
            return .newValue(subject.value + 1)
        }

        nonisolated
        public func set(value: consuming Int, on subject: inout PropertyAccessorFoo) {
            subject.value = value
        }
    }
}

// MARK: - Static Constructor

extension PropertyAccessor where Self == PropertyAccessorFoo.ValuePropertyAccessor {
    nonisolated
    public static func value(increment: Int = 1, delay isDelayed: Bool = false) -> Self {
        PropertyAccessorFoo.ValuePropertyAccessor(increment: increment, delay: isDelayed)
    }
}
