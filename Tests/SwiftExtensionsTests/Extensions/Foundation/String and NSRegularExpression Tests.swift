//
//  String and NSRegularExpression Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import SwiftExtensions
import Testing

@Suite struct Extensions_Foundation_StringAndNSRegularExpression_Tests {
    @Test
    func regExPattern() async {
        let regPattern = "[0-9]+"
        
        let str = "The 45 turkeys ate 9 sandwiches."
        
        #expect(
            str.regexMatches(pattern: regPattern)
                == ["45", "9"]
        )
    }
    
    @Test
    func regExPattern_ExtendedCharacters() async {
        let regPattern = "[0-9]+"
        
        let str = "Thé 45 smiling 😀 túrkêÿs åte →●₩√【】♞‱ 9 Şandwiches."
        
        #expect(
            str.regexMatches(pattern: regPattern)
                == ["45", "9"]
        )
    }
    
    /// Ensure that using a Substring as the input string works as expected.
    @Test
    func regExPattern_InSubString() async {
        let regPattern = "^([0-9]+)X([0-9]+)$"
        
        let str: String = " 123X456 "
        let range = str.index(str.startIndex, offsetBy: 1) ..< str.index(str.startIndex, offsetBy: 8)
        let subStr: Substring = str[range]
        
        #expect(
            subStr.regexMatches(pattern: regPattern)
                == ["123X456"]
        )
    }
    
    @Test
    func regExPatternReplacement() async {
        let regPattern = "[0-9]+"
        
        let str = "The 45 turkeys ate 9 sandwiches."
        
        #expect(
            str.regexMatches(
                pattern: regPattern,
                replacementTemplate: "$0-some"
            )
                == "The 45-some turkeys ate 9-some sandwiches."
        )
    }
    
    @Test
    func regExPatternReplacement_ExtendedCharacters() async {
        let regPattern = "[0-9]+"
        
        let str = "Thé 45 smiling 😀 túrkêÿs åte →●₩√【】♞‱ 9 Şandwiches."
        
        #expect(
            str.regexMatches(
                pattern: regPattern,
                replacementTemplate: "$0-some"
            )
                == "Thé 45-some smiling 😀 túrkêÿs åte →●₩√【】♞‱ 9-some Şandwiches."
        )
    }
    
    /// Ensure that using a Substring as the input string works as expected.
    @Test
    func regExPatternReplacement_InSubString() async {
        let regPattern = "^([0-9]+)X([0-9]+)$"
        
        let str: String = " 123X456 "
        let range = str.index(str.startIndex, offsetBy: 1) ..< str.index(str.startIndex, offsetBy: 8)
        let subStr: Substring = str[range]
        
        #expect(
            subStr.regexMatches(
                pattern: regPattern,
                replacementTemplate: "A$1B$2C"
            )
                == "A123B456C"
        )
    }
    
    @Test
    func regExCaptureGroups() async {
        let capturePattern = #"""
            ([a-zA-z\s]*)\s([0-9]+)\s([a-zA-z\s]*)\s([0-9]+)\s([a-zA-z\s.]*)
            """#
        
        let str = "The 45 turkeys ate 9 sandwiches."
        
        let matches = str.regexMatches(captureGroupsFromPattern: capturePattern)
        let expectedMatches: [Substring?] = [
            Optional(Substring(str)),
            Optional("The"),
            Optional("45"),
            Optional("turkeys ate"),
            Optional("9"),
            Optional("sandwiches."),
        ]
        #expect(matches == expectedMatches)
    }
    
    @Test
    func regExCaptureGroups_ExtendedCharacters() async {
        let capturePattern = #"^([^\.]*)\.([^\.]*)\.([\d]+)$"#
        
        let str = "Hellõ țhiș is ǎ têst.Śtřįng 😀→●₩√【】♞‱.1234"
        
        let matches = str.regexMatches(captureGroupsFromPattern: capturePattern)
        let expectedMatches: [Substring?] = [
            Optional(Substring(str)),
            Optional("Hellõ țhiș is ǎ têst"),
            Optional("Śtřįng 😀→●₩√【】♞‱"),
            Optional("1234"),
        ]
        #expect(matches == expectedMatches)
    }

    /// Ensure that using a Substring as the input string works as expected.
    @Test
    func regExCaptureGroups_InSubString() async {
        let regPattern = "^([0-9]+)X([0-9]+)$"
        
        let str: String = " 123X456 "
        let range = str.index(str.startIndex, offsetBy: 1) ..< str.index(str.startIndex, offsetBy: 8)
        let subStr: Substring = str[range]
        
        #expect(
            subStr.regexMatches(captureGroupsFromPattern: regPattern)
                == ["123X456", "123", "456"]
        )
    }
}

#endif
