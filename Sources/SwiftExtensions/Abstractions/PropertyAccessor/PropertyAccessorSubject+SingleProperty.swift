//
//  PropertyAccessorSubject+SingleProperty.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

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
}
