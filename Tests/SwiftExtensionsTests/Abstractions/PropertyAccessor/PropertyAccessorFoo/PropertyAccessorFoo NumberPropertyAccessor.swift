//
//  PropertyAccessorFoo AsyncNumberPropertyAccessor.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import class Foundation.NSNumber
import typealias Foundation.TimeInterval
import SwiftExtensions

extension PropertyAccessorFoo {
    public struct NumberPropertyAccessor: PropertyAccessor {
        public let delay: TimeInterval?

        public init(delay: TimeInterval? = nil) {
            self.delay = delay
        }

        nonisolated
        public func newValue(for subject: borrowing PropertyAccessorFoo) -> PropertyUpdateResult<NSNumber?> {
            if let delay {
                print("Getting new value for number")
                defer { print("Done getting new value for number") }
                sleep(delay)
            }
            let number: NSNumber? = ((subject.number?.intValue ?? 0) + 1) as NSNumber
            return .newValue(number)
        }

        nonisolated
        public func set(value: consuming NSNumber?, on subject: inout PropertyAccessorFoo) {
            subject.number = value
        }
    }
}

// MARK: - Static Constructor

extension PropertyAccessor where Self == PropertyAccessorFoo.NumberPropertyAccessor {
    nonisolated
    public static func number(delay: TimeInterval? = nil) -> Self {
        PropertyAccessorFoo.NumberPropertyAccessor(delay: delay)
    }
}
