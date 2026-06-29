//
//  PropertyAccessorSubject+PropertyBuilder.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// MARK: - Mutating Update Property

extension PropertyAccessorSubject {
    /// Update `self` in-place.
    /// The property updates are applied in order, incrementally updating `self`.
    nonisolated
    public mutating func updateSerially(
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
    /// The property updates are applied in order, incrementally updating `self`.
    @concurrent nonisolated
    public mutating func updateSeriallyInBackground(
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
    /// The property updates are applied in parallel, where each property update is unaware of the others.
    ///
    /// > Warning:
    /// >
    /// > Do not use this method if any included property updates rely on updated state as a result of another
    /// > property update within the same call to this method.
    nonisolated
    public mutating func updateConcurrently(
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

    /// Update `self` in-place.
    /// The property updates are applied in parallel, where each property update is unaware of the others.
    ///
    /// > Warning:
    /// >
    /// > Do not use this method if any included property updates rely on updated state as a result of another
    /// > property update within the same call to this method.
    @concurrent nonisolated
    public mutating func updateConcurrentlyInBackground(
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
}

// MARK: - Non-Mutating Update Property

extension PropertyAccessorSubject {
    // MARK: Property Builder
    
    /// Return a new copy of `self` with the specified updates applied.
    /// The property updates are applied in order, incrementally updating new instance.
    nonisolated
    public func updatedSerially(
        properties: sending (_ properties: inout PropertyAccessorBuilder<Self>) -> Void
    ) async throws -> Self {
        var builder = PropertyAccessorBuilder<Self>()
        properties(&builder)
        
        var copy = self
        for anyProperty in builder.anyProperties {
            switch anyProperty {
            case let .property(property):
                try property.update(subject: &copy)
            case let .asyncProperty(property):
                try await property.update(subject: &copy)
            }
        }
        return copy
    }
    
    /// Return a new copy of `self` with the specified updates applied.
    /// The property updates are applied in order, incrementally updating new instance.
    @concurrent nonisolated
    public func updatedSeriallyInBackground(
        properties: sending (_ properties: inout PropertyAccessorBuilder<Self>) -> Void
    ) async throws -> Self {
        var builder = PropertyAccessorBuilder<Self>()
        properties(&builder)
        
        var copy = self
        for anyProperty in builder.anyProperties {
            switch anyProperty {
            case let .property(property):
                try property.update(subject: &copy)
            case let .asyncProperty(property):
                try await property.update(subject: &copy)
            }
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
    nonisolated
    public func updatedConcurrently(
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
    
    /// Return a new copy of `self` with the specified updates applied.
    /// The property updates are applied in parallel, where each property update is unaware of the others.
    ///
    /// > Warning:
    /// >
    /// > Do not use this method if any included property updates rely on updated state as a result of another
    /// > property update within the same call to this method.
    @concurrent nonisolated
    public func updatedConcurrentlyInBackground(
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
}
