//
//  AnyPropertyAccessor.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

enum AnyPropertyAccessor<Object: Sendable> {
    case property(any PropertyAccessor<Object>)
    case asyncProperty(any AsyncPropertyAccessor<Object>)
}
