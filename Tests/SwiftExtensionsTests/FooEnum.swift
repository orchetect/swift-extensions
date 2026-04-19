//
//  FooEnum.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// MARK: - Shared constants and objects for tests

/// Test enum for use in unit tests
enum FooEnum {
    case foo(Int) // each Int has a different hash
    case fooB(Int) // identical hash regardless of Int
    case one
    case two
    case three
}

extension FooEnum: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.internalHash == rhs.internalHash
    }
}

extension FooEnum: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(internalHash)
    }

    private var internalHash: Int {
        switch self {
        case let .foo(val): val << 5 // each Int has different hash
        case .fooB: 0b01000 // identical hash regardless of Int
        case .one: 0b00010
        case .two: 0b00100
        case .three: 0b01000
        }
    }
}

extension FooEnum: CustomStringConvertible {
    var description: String {
        switch self {
        case let .foo(val): "foo(\(val))"
        case let .fooB(val): "fooB(\(val))"
        case .one: "one"
        case .two: "two"
        case .three: "three"
        }
    }
}
