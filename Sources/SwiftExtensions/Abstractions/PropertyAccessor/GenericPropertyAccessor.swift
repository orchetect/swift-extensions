//
//  GenericPropertyAccessor.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

/// Generic ``PropertyAccessor`` implementation that takes both a new value closure and a set value closure.
///
/// This is provided as a convenience where creating a custom type to define a property accessor may be overkill.
///
/// For example, first define the property accessor and optionally define a static constructor for convenience:
///
/// ```swift
/// extension MyType: PropertyAccessorSubject {
///     static let statePropertyAccessor = GenericPropertyAccessor(on: Self.self, of: Bool.self) { subject in
///         .newValue(subject.state.toggled())
///     } setValue: { value, subject in
///         subject.state = value
///     }
/// }
///
/// // Static Constructor
/// extension PropertyAccessor where Self == GenericPropertyAccessor<MyType, Bool, Never> {
///     public static var state: Self {
///         MyType.statePropertyAccessor
///     }
/// }
/// ```
///
/// Then the accessor may be used to update the object.
///
/// ```swift
/// var myType = MyType()
/// myType.update(property: .state())
/// ```
public struct GenericPropertyAccessor<Subject: Sendable, Value: Sendable, Failure: Error> {
    public typealias NewValueClosure = @Sendable (_ subject: borrowing Subject) throws(Failure) -> PropertyUpdateResult<Value>
    public typealias SetValueClosure = @Sendable (_ value: consuming Value, _ subject: inout Subject) throws(Failure) -> Void

    public let newValueClosure: NewValueClosure
    public let setValueClosure: SetValueClosure

    public init(
        on subjectType: Subject.Type,
        newValue: @escaping @Sendable (_ subject: borrowing Subject) throws(Failure) -> PropertyUpdateResult<Value>,
        setValue: @escaping @Sendable (_ value: consuming Value, _ subject: inout Subject) throws(Failure) -> Void
    ) {
        self.newValueClosure = newValue
        self.setValueClosure = setValue
    }

    public init(
        on subjectType: Subject.Type,
        of valueType: Value.Type,
        newValue: @escaping @Sendable (_ subject: borrowing Subject) throws(Failure) -> PropertyUpdateResult<Value>,
        setValue: @escaping @Sendable (_ value: consuming Value, _ subject: inout Subject) throws(Failure) -> Void
    ) {
        self.newValueClosure = newValue
        self.setValueClosure = setValue
    }

    public init(
        on subjectType: Subject.Type,
        of valueType: Value.Type,
        throwing errorType: Failure.Type,
        newValue: @escaping @Sendable (_ subject: borrowing Subject) throws(Failure) -> PropertyUpdateResult<Value>,
        setValue: @escaping @Sendable (_ value: consuming Value, _ subject: inout Subject) throws(Failure) -> Void
    ) {
        self.newValueClosure = newValue
        self.setValueClosure = setValue
    }
}

extension GenericPropertyAccessor: PropertyAccessor {
    public func newValue(for subject: borrowing Subject) throws(Failure) -> PropertyUpdateResult<Value> {
        try newValueClosure(subject)
    }
    
    public func set(value: consuming Value, on subject: inout Subject) throws(Failure) {
        try setValueClosure(value, &subject)
    }
}
