//
//  NSPoint Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) && !targetEnvironment(macCatalyst)

import AppKit
@testable import SwiftExtensions
import Testing

@Suite struct Extensions_Foundation_NSPoint_Tests {
    /// This method used to test the swift-extensions property `cgPoint` which was removed in swift-extensions 1.7.9.
    @Test
    func cgPoint() {
        // just to confirm that the compiler sees both types as the same
        let cgPoint: CGPoint = NSPoint(x: 1.23, y: 2.5) // .cgPoint
        
        #expect(cgPoint.x == 1.23)
        #expect(cgPoint.y == 2.5)
    }
}

#endif
