//
//  PropertyAccessorSubject+Proxy.swift
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
