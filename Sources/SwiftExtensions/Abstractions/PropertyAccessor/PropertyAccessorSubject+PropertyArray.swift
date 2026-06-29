//
//  PropertyAccessorSubject+PropertyArray.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// MARK: - Mutating Update Property

extension PropertyAccessorSubject {
    /// Update `self` in-place.
    /// The property updates are applied in order, incrementally updating `self`.
    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    nonisolated
    public mutating func updateSerially(properties: [any PropertyAccessor<Self>]) throws -> Void {
        for property in properties {
            try property.update(subject: &self)
        }
    }

    /// Update `self` in-place.
    /// The property updates are applied in order, incrementally updating `self`.
    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    @concurrent nonisolated
    public mutating func updateSeriallyInBackground(properties: [any PropertyAccessor<Self>]) async throws -> Void {
        for property in properties {
            try property.update(subject: &self)
        }
    }

    /// Update `self` in-place.
    /// The property updates are applied in parallel, where each property update is unaware of the others.
    ///
    /// > Warning:
    /// >
    /// > Do not use this method if any included property updates rely on updated state as a result of another
    /// > property update within the same call to this method.
    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    nonisolated
    public mutating func updateConcurrently(properties: [any PropertyAccessor<Self>]) async throws -> Void {
        self = try await withThrowingTaskGroup(
            of: (@Sendable (inout Self) throws -> Void).self,
            returning: Self.self
        ) { group in
            for property in properties {
                group.addTask { [self] in
                    try property.deferredUpdate(for: self)
                }
            }

            var copy = self
            for try await result in group {
                try result(&copy)

            }
            return copy
        }
    }

    /// Update `self` in-place.
    /// The property updates are applied in parallel, where each property update is unaware of the others.
    ///
    /// > Warning:
    /// >
    /// > Do not use this method if any included property updates rely on updated state as a result of another
    /// > property update within the same call to this method.
    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    @concurrent nonisolated
    public mutating func updateConcurrentlyInBackground(properties: [any PropertyAccessor<Self>]) async throws -> Void {
        self = try await withThrowingTaskGroup(
            of: (@Sendable (inout Self) throws -> Void).self,
            returning: Self.self
        ) { group in
            for property in properties {
                group.addTask { [self] in
                    try property.deferredUpdate(for: self)
                }
            }

            var copy = self
            for try await result in group {
                try result(&copy)

            }
            return copy
        }
    }
}

// MARK: - Non-Mutating Update Property

extension PropertyAccessorSubject {
    /// Return a new copy of `self` with the specified updates applied.
    /// The property updates are applied in order, incrementally updating new instance.
    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    nonisolated
    public func updatedSerially(properties: [any PropertyAccessor<Self>]) async throws -> Self {
        var copy = self
        for property in properties {
            try property.update(subject: &copy)
        }
        return copy
    }

    /// Return a new copy of `self` with the specified updates applied.
    /// The property updates are applied in order, incrementally updating new instance.
    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    @concurrent nonisolated
    public func updatedSeriallyInBackground(properties: [any PropertyAccessor<Self>]) async throws -> Self {
        var copy = self
        for property in properties {
            try property.update(subject: &copy)
        }
        return copy
    }

    /// Return a new copy of `self` with the specified updates applied.
    /// The property updates are applied in parallel, where each property update is unaware of the others.
    ///
    /// > Warning:
    /// >
    /// > Do not use this method if any included property updates rely on updated state as a result of another
    /// > property update within the same call to this method.
    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    nonisolated
    public func updatedConcurrently(properties: [any PropertyAccessor<Self>]) async throws -> Self {
        try await withThrowingTaskGroup(
            of: (@Sendable (inout Self) throws -> Void).self,
            returning: Self.self
        ) { group in
            for property in properties {
                group.addTask { [self] in
                    try property.deferredUpdate(for: self)
                }
            }

            var copy = self
            for try await result in group {
                try result(&copy)

            }
            return copy
        }
    }

    /// Return a new copy of `self` with the specified updates applied.
    /// The property updates are applied in parallel, where each property update is unaware of the others.
    ///
    /// > Warning:
    /// >
    /// > Do not use this method if any included property updates rely on updated state as a result of another
    /// > property update within the same call to this method.
    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    @concurrent nonisolated
    public func updatedConcurrentlyInBackground(properties: [any PropertyAccessor<Self>]) async throws -> Self {
        try await withThrowingTaskGroup(
            of: (@Sendable (inout Self) throws -> Void).self,
            returning: Self.self
        ) { group in
            for property in properties {
                group.addTask { [self] in
                    try property.deferredUpdate(for: self)
                }
            }

            var copy = self
            for try await result in group {
                try result(&copy)

            }
            return copy
        }
    }
}
