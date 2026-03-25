//
//  String Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import SwiftExtensions
import Testing

@Suite struct Extensions_Swift_String_Tests {
    @Test
    func stringConstants() {
        _ = String.quote
        _ = String.tab
        _ = String.space
        _ = String.newLine
        _ = String.null
    }
    
    @Test
    func characterConstants() {
        _ = Character.quote
        _ = Character.tab
        _ = Character.space
        _ = Character.newLine
        _ = Character.null
    }
    
    @Test
    func stringFunctionalAppendConstants() {
        // .newLined
        
        #expect("test".newLined == "test\n")
        
        // .tabbed
        
        #expect("test".tabbed == "test\t")
        
        // .newLine()
        
        var strNL = "test"
        strNL.newLine()
        #expect(strNL == "test\n")
        
        // .tab()
        
        var strTab = "test"
        strTab.tab()
        #expect(strTab == "test\t")
    }
    
    @Test
    func repeating() {
        // String
        
        #expect("AB".repeating(0) == "")
        #expect("AB".repeating(1) == "AB")
        #expect("AB".repeating(5) == "ABABABABAB")
        
        // Substring
        
        let substring = "ABCD".suffix(2)
        #expect(substring.repeating(0) == "")
        #expect(substring.repeating(1) == "CD")
        #expect(substring.repeating(5) == "CDCDCDCDCD")
        
        // Character
        
        #expect(Character("A").repeating(0) == "")
        #expect(Character("A").repeating(1) == "A")
        #expect(Character("A").repeating(5) == "AAAAA")
    }
    
    @Test
    func trim() {
        // .trim()
        
        var str = "    string    "
        str.trim()
        
        #expect(str == "string")
    }
    
    @Test
    func removingPrefix() {
        // .removingPrefix
        
        let str = "///Users/user"
        
        #expect(str.removingPrefix("") == "///Users/user")
        #expect(str == "///Users/user")
        
        #expect(str.removingPrefix("nonexisting") == "///Users/user")
        #expect(str == "///Users/user")
        
        #expect(str.removingPrefix("/") == "//Users/user")
        #expect(str == "///Users/user")
        
        #expect(str.removingPrefix("/") == "//Users/user")
        #expect(str == "///Users/user")
        
        #expect(str.removingPrefix("zz") == "///Users/user")
        #expect(str == "///Users/user")
    }
    
    @Test
    func removePrefix() {
        // .removePrefix
        
        var str = "///Users/user"
        
        str.removePrefix("")
        #expect(str == "///Users/user")
        
        str.removePrefix("nonexisting")
        #expect(str == "///Users/user")
        
        str.removePrefix("/")
        #expect(str == "//Users/user")
        
        str.removePrefix("/")
        #expect(str == "/Users/user")
        
        str.removePrefix("/")
        #expect(str == "Users/user")
        
        str.removePrefix("/")
        #expect(str == "Users/user")
    }
    
    @Test
    func removeSuffix() {
        var str = "file:///Users/user///"
        
        // .removingSuffix
        
        #expect(str.removingSuffix("/") == "file:///Users/user//")
        #expect(str == "file:///Users/user///")
        
        #expect(str.removingSuffix("/") == "file:///Users/user//")
        #expect(str == "file:///Users/user///")
        
        #expect(str.removingSuffix("zz") == "file:///Users/user///")
        #expect(str == "file:///Users/user///")
        
        // .removeSuffix
        
        str.removeSuffix("/")
        #expect(str == "file:///Users/user//")
        
        str.removeSuffix("/")
        #expect(str == "file:///Users/user/")
        
        str.removeSuffix("/")
        #expect(str == "file:///Users/user")
        
        str.removeSuffix("/")
        #expect(str == "file:///Users/user")
    }
    
    @Test
    func isASCII() {
        let asciiString = (0 ... 127)
            .map { UnicodeScalar($0)! }
            .map { "\($0)" }
            .joined()
        
        #expect(asciiString.isASCII)
        
        // edge cases
        
        #expect("".isASCII)
        #expect(!"ABCD👍".isASCII)
        #expect(!"👍".isASCII)
    }
    
    @Test
    func isLowercase() {
        // ignoreWhitespace == false, ignoreNonCased == false
        #expect("".isLowercase(ignoreWhitespace: false, ignoreNonCased: false)) // empty always == true
        #expect(!" ".isLowercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect("a".isLowercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!"a ".isLowercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!" a".isLowercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect("abc".isLowercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!"a b c".isLowercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!"a-b-c".isLowercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!"abc123".isLowercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!"123".isLowercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!"A".isLowercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!"Abc".isLowercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!"ABC".isLowercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!"👍".isLowercase(ignoreWhitespace: false, ignoreNonCased: false))
        
        // ignoreWhitespace == true, ignoreNonCased == false
        #expect("".isLowercase(ignoreWhitespace: true, ignoreNonCased: false)) // empty always == true
        #expect(" ".isLowercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect("a".isLowercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect("a ".isLowercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect(" a".isLowercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect("abc".isLowercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect("a b c".isLowercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect(!"a-b-c".isLowercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect(!"abc123".isLowercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect(!"123".isLowercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect(!"A".isLowercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect(!"Abc".isLowercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect(!"ABC".isLowercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect(!"👍".isLowercase(ignoreWhitespace: true, ignoreNonCased: false))
        
        // ignoreWhitespace == false, ignoreNonCased == true
        #expect("".isLowercase(ignoreWhitespace: false, ignoreNonCased: true)) // empty always == true
        #expect(!" ".isLowercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect("a".isLowercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect(!"a ".isLowercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect(!" a".isLowercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect("abc".isLowercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect(!"a b c".isLowercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect("a-b-c".isLowercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect("abc123".isLowercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect("123".isLowercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect(!"A".isLowercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect(!"Abc".isLowercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect(!"ABC".isLowercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect("👍".isLowercase(ignoreWhitespace: false, ignoreNonCased: true))
        
        // ignoreWhitespace == true, ignoreNonCased == true
        #expect("".isLowercase(ignoreWhitespace: true, ignoreNonCased: true)) // empty always == true
        #expect(" ".isLowercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect("a".isLowercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect("a ".isLowercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect(" a".isLowercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect("abc".isLowercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect("a b c".isLowercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect("a-b-c".isLowercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect("abc123".isLowercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect("123".isLowercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect(!"A".isLowercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect(!"Abc".isLowercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect(!"ABC".isLowercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect("👍".isLowercase(ignoreWhitespace: true, ignoreNonCased: true))
    }
    
    @Test
    func isUppercase() {
        // ignoreWhitespace == false, ignoreNonCased == false
        #expect("".isUppercase(ignoreWhitespace: false, ignoreNonCased: false)) // empty always == true
        #expect(!" ".isUppercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect("A".isUppercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!"A ".isUppercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!" A".isUppercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect("ABC".isUppercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!"A B C".isUppercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!"A-B-C".isUppercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!"ABC123".isUppercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!"123".isUppercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!"a".isUppercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!"aBC".isUppercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!"abc".isUppercase(ignoreWhitespace: false, ignoreNonCased: false))
        #expect(!"👍".isUppercase(ignoreWhitespace: false, ignoreNonCased: false))
        
        // ignoreWhitespace == true, ignoreNonCased == false
        #expect("".isUppercase(ignoreWhitespace: true, ignoreNonCased: false)) // empty always == true
        #expect(" ".isUppercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect("A".isUppercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect("A ".isUppercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect(" A".isUppercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect("ABC".isUppercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect("A B C".isUppercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect(!"A-B-C".isUppercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect(!"ABC123".isUppercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect(!"123".isUppercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect(!"a".isUppercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect(!"aBC".isUppercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect(!"abc".isUppercase(ignoreWhitespace: true, ignoreNonCased: false))
        #expect(!"👍".isUppercase(ignoreWhitespace: true, ignoreNonCased: false))
        
        // ignoreWhitespace == false, ignoreNonCased == true
        #expect("".isUppercase(ignoreWhitespace: false, ignoreNonCased: true)) // empty always == true
        #expect(!" ".isUppercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect("A".isUppercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect(!"A ".isUppercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect(!" A".isUppercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect("ABC".isUppercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect(!"A B C".isUppercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect("A-B-C".isUppercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect("ABC123".isUppercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect("123".isUppercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect(!"a".isUppercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect(!"aBC".isUppercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect(!"abc".isUppercase(ignoreWhitespace: false, ignoreNonCased: true))
        #expect( "👍".isUppercase(ignoreWhitespace: false, ignoreNonCased: true))
        
        // ignoreWhitespace == true, ignoreNonCased == true
        #expect("".isUppercase(ignoreWhitespace: true, ignoreNonCased: true)) // empty always == true
        #expect(" ".isUppercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect("A".isUppercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect("A ".isUppercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect(" A".isUppercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect("ABC".isUppercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect("A B C".isUppercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect("A-B-C".isUppercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect("ABC123".isUppercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect("123".isUppercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect(!"a".isUppercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect(!"aBC".isUppercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect(!"abc".isUppercase(ignoreWhitespace: true, ignoreNonCased: true))
        #expect("👍".isUppercase(ignoreWhitespace: true, ignoreNonCased: true))
    }
    
    @Test
    func optionalString() {
        #expect(
            SwiftExtensions.optionalString(
                describing: Int(exactly: 123),
                ifNil: "0"
            )
                == "123"
        )
        
        #expect(
            SwiftExtensions.optionalString(
                describing: Int(exactly: 123.4),
                ifNil: "0"
            )
                == "0"
        )
    }
    
    @Test
    func stringInterpolationIfNil() {
        #expect("\(Int(exactly: 123), ifNil: "0")" == "123")
        
        #expect("\(Int(exactly: 123.4), ifNil: "0")" == "0")
    }
    
    @Test
    func stringInterpolationRadix() {
        #expect("\("7F", radix: 16)" == "127")
        #expect("\("7F", radix: 2)" == "nil")
    }
    
    @Test
    func substringToString() {
        let str = "123"
        
        // form Substring
        
        let subStr = str.prefix(3)
        #expect(String(describing: type(of: subStr)) == "Substring")
        
        // .string
        
        let toStr = subStr.string
        
        #expect(toStr == String("123"))
        #expect(String(describing: type(of: toStr)) == "String")
    }
    
    @Test
    func characterToString() {
        let char = Character("1")
        
        // .string
        
        let toStr = char.string
        
        #expect(toStr == String("1"))
        #expect(String(describing: type(of: toStr)) == "String")
    }
    
    // MARK: Collections tests
    // the following tests are using methods from Collections.swift
    // but specifically testing their implementation on String/StringProtocol here
    
    @Test
    func startIndexOffsetBy() {
        // .startIndex(offsetBy:)
        
        let str = "1234567890"
        
        #expect(
            str.startIndex(offsetBy: 0)
                == str.startIndex
        )
        
        #expect(
            str.startIndex(offsetBy: 1)
                == str.index(str.startIndex, offsetBy: 1)
        )
    }
    
    @Test
    func endIndexOffsetBy() {
        // .endIndex(offsetBy:)
        
        let str = "1234567890"
        
        #expect(
            str.endIndex(offsetBy: 0)
                == str.endIndex
        )
        
        #expect(
            str.endIndex(offsetBy: -1)
                == str.index(str.endIndex, offsetBy: -1)
        )
    }
    
    @Test
    func subscriptPosition_OffsetIndex() {
        // String
        
        #expect("abc123"[position: 2] == "c")
        
        // Substring
        
        let substring = "abc123".suffix(4)
        #expect(substring[position: 2] == "2")
    }
    
    @Test
    func subscriptPosition_ClosedRange() {
        // String
        
        #expect("abc123"[position: 1 ... 3] == "bc1")
        
        // Substring
        
        let substring = "abc123".suffix(4)
        #expect(substring[position: 1 ... 3] == "123")
    }
    
    @Test
    func subscriptPosition_Range() {
        // String
        
        #expect("abc123"[position: 1 ..< 3] == "bc")
        
        // Substring
        
        let substring = "abc123".suffix(4)
        #expect(substring[position: 1 ..< 3] == "12")
    }
    
    @Test
    func subscriptPosition_PartialRangeFrom() {
        // String
        
        #expect("abc123"[position: 2...] == "c123")
        
        // Substring
        
        let substring = "abc123".suffix(4)
        #expect(substring[position: 2...] == "23")
    }
    
    @Test
    func subscriptPosition_PartialRangeThrough() {
        // String
        
        #expect("abc123"[position: ...3] == "abc1")
        
        // Substring
        
        let substring = "abc123".suffix(4)
        #expect(substring[position: ...3] == "c123")
    }
    
    @Test
    func subscriptPosition_PartialRangeUpTo() {
        // String
        
        #expect("abc123"[position: ..<3] == "abc")
        
        // Substring
        
        let substring = "abc123".suffix(4)
        #expect(substring[position: ..<3] == "c12")
    }
}
