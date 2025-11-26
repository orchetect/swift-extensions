//
//  Result Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import SwiftExtensions
import Testing

@Suite struct Extensions_Swift_Result_Tests {
    /// Enum for test
    fileprivate enum PasswordError: Error, Equatable {
        case short
        case obvious
        case simple
    }
    
    /// Func for test
    fileprivate func doStuff(_ trigger: Bool) -> Result<String, PasswordError> {
        trigger
            ? .success("we succeeded")
            : .failure(.short)
    }
    
    @Test
    func resultSuccessValue() {
        #expect(doStuff(true).successValue == "we succeeded")
        #expect(doStuff(true).successValue != "blah blah")
    }
    
    @Test
    func resultFailureValue() {
        #expect(doStuff(false).failureValue == .short)
        #expect(doStuff(false).failureValue != .simple)
    }
    
    @Test
    func resultIsSuccess() {
        #expect(doStuff(true).isSuccess)
        #expect(!doStuff(false).isSuccess)
    }
}
