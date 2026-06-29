//
//  PropertyAccessorFoo AsyncNumberPropertyAccessor.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import class Foundation.NSNumber
import typealias Foundation.TimeInterval
import SwiftExtensions

extension PropertyAccessorFoo {
    nonisolated
    public struct AsyncNumberPropertyAccessor: AsyncPropertyAccessor {
        public enum NumberError: Error, Sendable {
            case error
        }

        public let delay: TimeInterval?

        public init(delay: TimeInterval? = nil) {
            self.delay = delay
        }

        nonisolated
        public func newValue(for subject: borrowing PropertyAccessorFoo) async throws(NumberError) -> PropertyUpdateResult<NSNumber?> {
            if let delay {
                print("Getting new value for number (async)")
                defer { print("Done getting new value for number (async)") }
                try? await Task.sleep(for: .seconds(delay))
            }
            let number: NSNumber? = ((subject.number?.intValue ?? 0) + 1) as NSNumber
            return .newValue(number)
        }

        nonisolated
        public func set(value: consuming NSNumber?, on subject: inout PropertyAccessorFoo) async throws(NumberError) {
            subject.number = value
        }
    }
}

// MARK: - Static Constructor

extension AsyncPropertyAccessor where Self == PropertyAccessorFoo.AsyncNumberPropertyAccessor {
    nonisolated
    public static func asyncNumber(delay: TimeInterval? = nil) -> Self {
        PropertyAccessorFoo.AsyncNumberPropertyAccessor(delay: delay)
    }
}
