//
//  NSFont Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) && !targetEnvironment(macCatalyst)

import AppKit
@testable import SwiftExtensions
import Testing

@Suite struct Extensions_AppKit_NSFont_Tests {
    @Test
    func cgFont() {
        let nsFont = NSFont.systemFont(ofSize: 10)
        
        let cgFont = nsFont.cgFont
        
        // not much we can test here, but a few properties seem testable
        
        #expect(nsFont.numberOfGlyphs == cgFont.numberOfGlyphs)
        
        if let nsPSN = nsFont.fontDescriptor.postscriptName,
           let cgPSN = cgFont.postScriptName as String?
        {
            #expect(cgPSN.hasPrefix(nsPSN))
        }
    }
}

#endif
