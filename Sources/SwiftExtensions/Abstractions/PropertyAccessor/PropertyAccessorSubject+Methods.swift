//
//  PropertyAccessorSubject+Methods.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// MARK: - Mutating Update Closure

#if compiler(>=6.2)
extension PropertyAccessorSubject {
    /// Update `self` in-place.
    nonisolated
    public mutating func update<E>(
        _ block: (_ updater: consuming PropertyAccessorProxy<Self>) throws(E) -> Void
    ) throws(E) -> Void {
        try block(PropertyAccessorProxy(updating: &self))
    }

    /// Update `self` in-place.
    /// Does the work on the calling actor.
    public mutating func update<E>(
        isolation: isolated (any Actor)? = #isolation,
        _ block: (_ updater: consuming sending PropertyAccessorProxy<Self>) async throws(E) -> Void
    ) async throws(E) -> Void {
        try await block(PropertyAccessorProxy(updating: &self))
    }

    /// Update `self` in-place.
    /// Does the work concurrently on a background actor.
    @concurrent
    public mutating func updateInBackground<E>(
        _ block: sending (_ updater: consuming PropertyAccessorProxy<Self>) async throws(E) -> Void
    ) async throws(E) -> Void {
        try await block(PropertyAccessorProxy(updating: &self))
    }
}
#endif

// MARK: - Non-Mutating Update Closure

#if compiler(>=6.2)
extension PropertyAccessorSubject {
    /// Return a new copy of `self` with the specified updates applied.
    nonisolated
    public func updated<E>(
        _ block: (_ updater: consuming PropertyAccessorProxy<Self>) throws(E) -> Void
    ) throws(E) -> Self {
        var copy = self
        try block(PropertyAccessorProxy(updating: &copy))
        return copy
    }

    /// Return a new copy of `self` with the specified updates applied.
    /// Does the work on the calling actor.
    public func updated<E>(
        isolation: isolated (any Actor)? = #isolation,
        _ block: (_ updater: consuming sending PropertyAccessorProxy<Self>) async throws(E) -> Void
    ) async throws(E) -> Self {
        var copy = self
        try await block(PropertyAccessorProxy(updating: &copy))
        return copy
    }

    /// Return a new copy of `self` with the specified updates applied.
    @concurrent nonisolated
    public func updatedInBackground<E>(
        _ block: sending (_ updater: consuming PropertyAccessorProxy<Self>) async throws(E) -> Void
    ) async throws(E) -> Self {
        var copy = self
        try await block(PropertyAccessorProxy(updating: &copy))
        return copy
    }
}
#endif

// MARK: - Mutating Update Property

extension PropertyAccessorSubject {
    // MARK: Non-Async Property

    /// Update `self` in-place.
    nonisolated
    public mutating func update<P: PropertyAccessor<Self>>(property: P) throws(P.Failure) -> Void {
        try property.update(subject: &self)
    }

    /// Update `self` in-place.
    @concurrent nonisolated
    public mutating func updateInBackground<P: PropertyAccessor<Self>>(property: P) async throws(P.Failure) -> Void {
        try property.update(subject: &self)
    }

    // MARK: Async Property

    /// Update `self` in-place.
    nonisolated
    public mutating func update<P: AsyncPropertyAccessor<Self>>(property: P) async throws(P.Failure) -> Void {
        try await property.update(subject: &self)
    }

    /// Update `self` in-place.
    @concurrent nonisolated
    public mutating func updateInBackground<P: AsyncPropertyAccessor<Self>>(property: P) async throws(P.Failure) -> Void {
        try await property.update(subject: &self)
    }

    // MARK: Any Properties

    /// Update `self` in-place.
    nonisolated
    public mutating func update(
        properties: sending (_ properties: inout PropertyAccessorBuilder<Self>) -> Void
    ) async throws -> Void {
        var builder = PropertyAccessorBuilder<Self>()
        properties(&builder)

        for anyProperty in builder.anyProperties {
            switch anyProperty {
            case let .property(property):
                try property.update(subject: &self)
            case let .asyncProperty(property):
                try await property.update(subject: &self)
            }
        }
    }

    /// Update `self` in-place.
    @concurrent nonisolated
    public mutating func updateInBackground(
        properties: sending (_ properties: inout PropertyAccessorBuilder<Self>) -> Void
    ) async throws -> Void {
        var builder = PropertyAccessorBuilder<Self>()
        properties(&builder)

        self = try await withThrowingTaskGroup { group in
            for anyProperty in builder.anyProperties {
                group.addTask { [self] in
                    switch anyProperty {
                    case let .property(property):
                        try property.deferredUpdate(for: self)
                    case let .asyncProperty(property):
                        try await property.deferredUpdate(for: self)
                    }
                }
            }

            var copy = self
            for try await result in group {
                try await result(&copy)

            }
            return copy
        }
    }

    // MARK: Non-Async Properties

    /// Update `self` in-place.
    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    nonisolated
    public mutating func update(properties: [any PropertyAccessor<Self>]) throws -> Void {
        for property in properties {
            try property.update(subject: &self)
        }
    }

    /// Update `self` in-place.
    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    @concurrent nonisolated
    public mutating func updateInBackground(properties: [any PropertyAccessor<Self>]) async throws -> Void {
        self = try await withThrowingTaskGroup { group in
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

    // MARK: Async Properties

    /// Update `self` in-place.
    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    nonisolated
    public mutating func update(properties: [any AsyncPropertyAccessor<Self>]) async throws -> Void {
        self = try await withThrowingTaskGroup { group in
            for property in properties {
                group.addTask { [self] in
                    try await property.deferredUpdate(for: self)
                }
            }

            var copy = self
            for try await result in group {
                try await result(&copy)

            }
            return copy
        }
    }

    /// Update `self` in-place.
    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    @concurrent nonisolated
    public mutating func updateInBackground(properties: [any AsyncPropertyAccessor<Self>]) async throws -> Void {
        self = try await withThrowingTaskGroup { group in
            for property in properties {
                group.addTask { [self] in
                    try await property.deferredUpdate(for: self)
                }
            }

            var copy = self
            for try await result in group {
                try await result(&copy)

            }
            return copy
        }
    }
}

// MARK: - Non-Mutating Update Property

extension PropertyAccessorSubject {
    // MARK: Non-Async Property

    /// Return a new copy of `self` with the specified updates applied.
    nonisolated
    public func updated<P: PropertyAccessor<Self>>(property: P) throws(P.Failure) -> Self {
        var copy = self
        try copy.update(property: property)
        return copy
    }

    /// Return a new copy of `self` with the specified updates applied.
    @concurrent nonisolated
    public func updatedInBackground<P: PropertyAccessor<Self>>(property: P) async throws(P.Failure) -> Self {
        var copy = self
        try copy.update(property: property)
        return copy
    }

    // MARK: Async Property

    /// Return a new copy of `self` with the specified updates applied.
    nonisolated
    public func updated<P: AsyncPropertyAccessor<Self>>(property: P) async throws(P.Failure) -> Self {
        var copy = self
        try await copy.update(property: property)
        return copy
    }

    /// Return a new copy of `self` with the specified updates applied.
    @concurrent nonisolated
    public func updatedInBackground<P: AsyncPropertyAccessor<Self>>(property: P) async throws(P.Failure) -> Self {
        var copy = self
        try await copy.update(property: property)
        return copy
    }

    // MARK: Any Properties

    /// Return a new copy of `self` with the specified updates applied.
    nonisolated
    public func updated(
        properties: sending (_ properties: inout PropertyAccessorBuilder<Self>) -> Void
    ) async throws -> Self {
        var builder = PropertyAccessorBuilder<Self>()
        properties(&builder)

        return try await withThrowingTaskGroup { group in
            for anyProperty in builder.anyProperties {
                group.addTask { [self] in
                    switch anyProperty {
                    case let .property(property):
                        try property.deferredUpdate(for: self)
                    case let .asyncProperty(property):
                        try await property.deferredUpdate(for: self)
                    }
                }
            }

            var copy = self
            for try await result in group {
                try await result(&copy)

            }
            return copy
        }
    }

    /// Update `self` in-place.
    @concurrent nonisolated
    public func updatedInBackground(
        properties: sending (_ properties: inout PropertyAccessorBuilder<Self>) -> Void
    ) async throws -> Self {
        var builder = PropertyAccessorBuilder<Self>()
        properties(&builder)

        return try await withThrowingTaskGroup { group in
            for anyProperty in builder.anyProperties {
                group.addTask { [self] in
                    switch anyProperty {
                    case let .property(property):
                        try property.deferredUpdate(for: self)
                    case let .asyncProperty(property):
                        try await property.deferredUpdate(for: self)
                    }
                }
            }

            var copy = self
            for try await result in group {
                try await result(&copy)

            }
            return copy
        }
    }

    // MARK: Non-Async Properties

    /// Return a new copy of `self` with the specified updates applied.
    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    nonisolated
    public func updated(properties: [any PropertyAccessor<Self>]) async throws -> Self {
        try await withThrowingTaskGroup { group in
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
    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    @concurrent nonisolated
    public func updatedInBackground(properties: [any PropertyAccessor<Self>]) async throws -> Self {
        try await withThrowingTaskGroup { group in
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

    // MARK: Async Properties

    /// Return a new copy of `self` with the specified updates applied.
    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    nonisolated
    public func updated(properties: [any AsyncPropertyAccessor<Self>]) async throws -> Self {
        try await withThrowingTaskGroup { group in
            for property in properties {
                group.addTask { [self] in
                    try await property.deferredUpdate(for: self)
                }
            }

            var copy = self
            for try await result in group {
                try await result(&copy)

            }
            return copy
        }
    }

    /// Update `self` in-place.
    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    @concurrent nonisolated
    public func updatedInBackground(properties: [any AsyncPropertyAccessor<Self>]) async throws -> Self {
        try await withThrowingTaskGroup { group in
            for property in properties {
                group.addTask { [self] in
                    try await property.deferredUpdate(for: self)
                }
            }

            var copy = self
            for try await result in group {
                try await result(&copy)

            }
            return copy
        }
    }
}
