//
//  PropertyAccessorFoo asyncGenericNumberPropertyAccessor.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftExtensions

// MARK: - Static Constructor

extension PropertyAccessorFoo {
    nonisolated
    public static let asyncGenericNumberPropertyAccessor = GenericAsyncPropertyAccessor(on: Self.self) { subject in
        .newValue(await subject.getNumber() + 1)
    } setValue: { value, subject in
        await subject.setNumber(value)
    }
}

// MARK: - Static Constructor

extension AsyncPropertyAccessor where Self == GenericAsyncPropertyAccessor<PropertyAccessorFoo, Int, Never> {
    nonisolated
    public static var asyncGenericNumber: Self {
        PropertyAccessorFoo.asyncGenericNumberPropertyAccessor
    }
}
