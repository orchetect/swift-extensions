//
//  PropertyAccessorBuilder.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

/// Property collection builder.
///
/// This type is not publicly constructible. Rather, it is vended by property accessor update methods
/// within a closure.
public struct PropertyAccessorBuilder<Object: Sendable>: ~Copyable {
    var anyProperties: [AnyPropertyAccessor<Object>] = []

    init() { }
}

extension PropertyAccessorBuilder {
    /// Add a property to the collection.
    public mutating func add(_ property: some PropertyAccessor<Object>) {
        anyProperties.append(.property(property))
    }

    /// Add a property to the collection.
    public mutating func add(_ property: some AsyncPropertyAccessor<Object>) {
        anyProperties.append(.asyncProperty(property))
    }
}
