//
//  AsyncPropertyAccessor+Methods.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

extension AsyncPropertyAccessor {
    /// Fetches a new value for the property and sets the value on the subject.
    /// Returns `true` if the operation resulted in a change to the subject.
    @discardableResult
    public func update(subject: inout Subject) async throws(Failure) -> Bool {
        let result = try await newValue(for: subject)
        switch result {
        case .unchanged:
            return false
        case let .newValue(value):
            try await set(value: value, on: &subject)
            return true
        }
    }
}

// MARK: - Deferred Update

extension AsyncPropertyAccessor {
    public typealias DeferredUpdate = @Sendable (_ subject: inout Subject) async throws -> Void

    /// Retrieves a new value but defers setting the value on the subject until the returned closure
    /// is called.
    nonisolated
    public func deferredUpdate(
        for subject: borrowing Subject
    ) async throws -> sending DeferredUpdate {
        let value = try await newValue(for: subject)
        return { subject in
            switch value {
            case .unchanged:
                break
            case let .newValue(value):
                try await self.set(value: value, on: &subject)
            }
        }
    }
}
