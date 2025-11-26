//
//  URL and AppKit Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) && !targetEnvironment(macCatalyst)

import AppKit
@testable import SwiftExtensions
import Testing

@Suite struct Extensions_AppKit_URLAndAppKit_Tests {
    @Test
    func urlIcon() {
        // on most, if not all, systems this should produce a value
        
        let url = URL(fileURLWithPath: "/")
        let fileIcon = url.fileIcon
        #expect(fileIcon != nil)
    }
}

#endif
