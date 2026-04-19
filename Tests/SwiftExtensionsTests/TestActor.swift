//
//  TestActor.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

/// Dedicated actor for concurrency-related unit tests.
@globalActor
actor TestActor {
    static let shared = TestActor()
}
