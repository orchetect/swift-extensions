//
//  PropertyAccessorFoo NumberPropertyAccessor.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import class Foundation.NSNumber
import SwiftExtensions

extension PropertyAccessorFoo {
    nonisolated
    public struct NumberPropertyAccessor: AsyncPropertyAccessor {
        public let isDelayed: Bool

        public init(delay isDelayed: Bool = false) {
            self.isDelayed = isDelayed
        }

        public enum NumberError: Error, Sendable {
            case error
        }

        nonisolated
        public func newValue(for subject: borrowing PropertyAccessorFoo) async throws(NumberError) -> PropertyUpdateResult<NSNumber> {
            if isDelayed {
                print("Getting new value for image")
                defer { print("Done getting new value for image") }
                sleep(1)
            }
            let number = NSNumber(123)
            return .newValue(number)
        }

        nonisolated
        public func set(value: consuming NSNumber, on subject: inout PropertyAccessorFoo) async throws(NumberError) {
            subject.number = value
        }
    }
}

// MARK: - Static Constructor

extension AsyncPropertyAccessor where Self == PropertyAccessorFoo.NumberPropertyAccessor {
    nonisolated
    public static func number(delay isDelayed: Bool = false) -> Self {
        PropertyAccessorFoo.NumberPropertyAccessor(delay: isDelayed)
    }
}
