//
//  Clipboard Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

import SwiftExtensions
import Testing

@Suite
struct Global_Clipboard_Tests {
    // no meaningful tests applicable

    @Test
    func emptyTest() {
        #expect(true)
    }
}
