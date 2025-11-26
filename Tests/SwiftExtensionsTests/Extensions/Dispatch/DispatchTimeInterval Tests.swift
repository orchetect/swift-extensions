//
//  DispatchTimeInterval Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Dispatch)

import Dispatch
@testable import SwiftExtensions
import Testing

@Suite struct Extensions_Dispatch_DispatchTimeInterval_Tests {
    @Test
    func dispatchTimeInterval_Microseconds() async {
        #expect(
            DispatchTimeInterval.seconds(2).microseconds
                == 2_000_000
        )
        
        #expect(
            DispatchTimeInterval.milliseconds(2000).microseconds
                == 2_000_000
        )
        
        #expect(
            DispatchTimeInterval.microseconds(2_000_000).microseconds
                == 2_000_000
        )
        
        #expect(
            DispatchTimeInterval.nanoseconds(2_000_000_000).microseconds
                == 2_000_000
        )
        
        // only asserts in debug builds. only testable with Xcode 26+ on macOS.
        #if os(macOS) && DEBUG && compiler(>=6.2)
        await #expect(processExitsWith: .failure) {
            _ = DispatchTimeInterval.never.microseconds
        }
        #endif
    }
}

#endif
