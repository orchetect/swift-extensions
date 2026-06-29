//
//  PropertyAccessorFoo genericNumberPropertyAccessor.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import class Foundation.NSNumber
import SwiftExtensions

// MARK: - Static Constructor

extension PropertyAccessorFoo {
    nonisolated
    public static let genericNumberPropertyAccessor = GenericPropertyAccessor(on: Self.self) { subject in
        .newValue((subject.number?.intValue ?? 0) + 1)
    } setValue: { value, subject in
        subject.number = value as NSNumber
    }
}

// MARK: - Static Constructor

extension PropertyAccessor where Self == GenericPropertyAccessor<PropertyAccessorFoo, Int, Never> {
    nonisolated
    public static var genericNumber: Self {
        PropertyAccessorFoo.genericNumberPropertyAccessor
    }
}
