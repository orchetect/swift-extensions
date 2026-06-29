//
//  AsyncPropertyAccessor.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

/// Defines logic relating to a property of an underlying subject to produce a new value and assign a value to a subject.
public protocol AsyncPropertyAccessor<Subject>: Sendable
where Subject: Sendable, Value: Sendable, Failure: Error
{
    associatedtype Subject
    associatedtype Value
    associatedtype Failure

    nonisolated
    func newValue(for subject: borrowing Subject) async throws(Failure) -> PropertyUpdateResult<Value>

    nonisolated
    func set(value: consuming Value, on subject: inout Subject) async throws(Failure)
}
