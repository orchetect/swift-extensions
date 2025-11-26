//
//  Result.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// Generic alias for any `Result<,>` type.
public typealias AnyResult = Result<Any, Error>

extension Result {
    /// If `success` case, returns associated value unwrapped.
    @_disfavoredOverload
    public var successValue: Success? {
        guard case let .success(value) = self else { return nil }
        return value
    }
    
    /// If `failure` case, returns associated value unwrapped.
    @_disfavoredOverload
    public var failureValue: Failure? {
        guard case let .failure(value) = self else { return nil }
        return value
    }
    
    /// Returns `true` if `success` case.
    /// Returns `false` if `failure` case.
    @_disfavoredOverload
    public var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
}
