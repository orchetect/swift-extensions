//
//  PropertyAccessorProxy.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if compiler(>=6.2)

/// Property update proxy.
///
/// This type is not constructible. Rather, this type is vended in update closures and may be used within the current scope
/// to update the underlying subject.
public struct PropertyAccessorProxy<Subject: PropertyAccessorSubject>: ~Escapable, ~Copyable {
    private let pointer: UnsafeMutablePointer<Subject>

    @_lifetime(&subject)
    init(updating subject: inout Subject) {
        let a = withUnsafeMutableBytes(of: &subject) { $0.baseAddress! }
        self.pointer = a.assumingMemoryBound(to: Subject.self)
    }
}

// MARK: - Manual Value Get/Set

extension PropertyAccessorProxy {
    /// Returns the new value for the specified property without updating the subject.
    public func newValue<P: PropertyAccessor<Subject>>(for property: P) throws(P.Failure) -> PropertyUpdateResult<P.Value> {
        try property.newValue(for: pointer.pointee)
    }

    /// Returns the new value for the specified property without updating the subject.
    public func newValue<P: AsyncPropertyAccessor<Subject>>(for property: P) async throws(P.Failure) -> PropertyUpdateResult<P.Value> {
        try await property.newValue(for: pointer.pointee)
    }

    /// Sets a new value for the specified property.
    public func set<P: PropertyAccessor<Subject>>(value: P.Value, for property: P) throws(P.Failure) {
        try property.set(value: value, on: &pointer.pointee)
    }

    /// Sets a new value for the specified property.
    public func set<P: AsyncPropertyAccessor<Subject>>(value: P.Value, for property: P) async throws(P.Failure) {
        try await property.set(value: value, on: &pointer.pointee)
    }
}

// MARK: - Update Single Property

extension PropertyAccessorProxy {
    /// Updates the specified property for the subject.
    public func update<P: PropertyAccessor<Subject>>(_ property: P) throws(P.Failure) {
        try property.update(subject: &pointer.pointee)
    }

    /// Updates the specified property for the subject.
    public func update<P: AsyncPropertyAccessor<Subject>>(_ property: P) async throws(P.Failure) {
        try await property.update(subject: &pointer.pointee)
    }
}

// MARK: - Update Multiple Properties

extension PropertyAccessorProxy {
    /// Updates the specified property for the subject serially.
    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    public func update(_ properties: [any PropertyAccessor<Subject>]) throws {
        for property in properties {
            try property.update(subject: &pointer.pointee)
        }
    }

    /// Updates the specified property for the subject serially.
    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    public func update(_ properties: [any AsyncPropertyAccessor<Subject>]) async throws {
        for property in properties {
            try await property.update(subject: &pointer.pointee)
        }
    }
}

#endif
