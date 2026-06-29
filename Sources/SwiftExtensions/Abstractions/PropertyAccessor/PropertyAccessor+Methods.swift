//
//  PropertyAccessor+Methods.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

extension PropertyAccessor {
    /// Fetches a new value for the property and sets the value on the subject.
    /// Returns `true` if the operation resulted in a change to the subject.
    @discardableResult
    public func update(subject: inout Subject) throws(Failure) -> Bool {
        let result = try newValue(for: subject)
        switch result {
        case .unchanged:
            return false
        case let .newValue(value):
            try set(value: value, on: &subject)
            return true
        }
    }
}

// MARK: - Deferred Update

extension PropertyAccessor {
    public typealias DeferredUpdate = @Sendable (_ subject: inout Subject) throws -> Void

    /// Retrieves a new value but defers setting the value on the subject until the returned closure
    /// is called.
    nonisolated
    public func deferredUpdate(
        for subject: borrowing Subject
    ) throws -> sending DeferredUpdate {
        let value = try newValue(for: subject)
        return { subject in
            switch value {
            case .unchanged:
                break
            case let .newValue(value):
                try self.set(value: value, on: &subject)
            }
        }
    }
}
