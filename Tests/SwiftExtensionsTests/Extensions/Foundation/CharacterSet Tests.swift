//
//  CharacterSet Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import SwiftExtensions
import Testing

@Suite
struct Extensions_Foundation_CharacterSet_Tests {
    @Test
    func initCharactersArray() {
        let chars: [Character] = ["a", "á", "e", "ö", "1", "%", "😄", "👨‍👩‍👦"]

        let cs = CharacterSet(chars)

        #expect(chars.allSatisfy(cs.contains))

        #expect(!cs.contains(.init("é")))
        #expect(!cs.contains(.init("o")))

        #expect("ghijkl234567890âēAÁEÖ_a_á_e_ö_1_%_😄_👨‍👩‍👦".only(cs) == "aáeö1%😄👨‍👩‍👦")
    }

    @Test
    func initCharactersVariadic() {
        let chars: [Character] = ["a", "á", "e", "ö", "1", "%", "😄", "👨‍👩‍👦"]

        // variadic parameter
        let cs = CharacterSet("a", "á", "e", "ö", "1", "%", "😄", "👨‍👩‍👦")

        #expect(chars.allSatisfy(cs.contains))

        #expect(!cs.contains(.init("é")))
        #expect(!cs.contains(.init("o")))

        #expect("ghijkl234567890âēAÁEÖ_a_á_e_ö_1_%_😄_👨‍👩‍👦".only(cs) == "aáeö1%😄👨‍👩‍👦")
    }

    @Test
    func containsCharacter() {
        let charset = CharacterSet.alphanumerics

        let a: Character = "a"
        let one: Character = "1"
        let ds: Character = "$"

        #expect(charset.contains(a))
        #expect(charset.contains(one))
        #expect(!charset.contains(ds))
    }

    @Test
    func operators() {
        // +

        let added: CharacterSet = .letters + .decimalDigits

        #expect(added.contains("a"))
        #expect(added.contains("1"))
        #expect(!added.contains("!"))

        // +=

        var addedInPlace: CharacterSet = .letters
        addedInPlace += .decimalDigits

        #expect(addedInPlace.contains("a"))
        #expect(addedInPlace.contains("1"))
        #expect(!addedInPlace.contains("!"))

        // -

        let subtracted: CharacterSet = .alphanumerics - .decimalDigits

        #expect(subtracted.contains("a"))
        #expect(!subtracted.contains("1"))
        #expect(!subtracted.contains("!"))

        // -=

        var subtractedInPlace: CharacterSet = .alphanumerics
        subtractedInPlace -= .decimalDigits

        #expect(subtractedInPlace.contains("a"))
        #expect(!subtractedInPlace.contains("1"))
        #expect(!subtractedInPlace.contains("!"))
    }

    @Test
    func consonants() {
        // random sampling of test characters
        let matchingChars = "bckmzBCKMZĜǧ"

        #expect(
            matchingChars.allSatisfy(CharacterSet.consonants.contains(_:))
        )

        // random sampling of test characters
        let nonMatchingChars = "aeiouàëïöùAEIOUÀËÏÖÙ"

        #expect(
            !nonMatchingChars.allSatisfy(CharacterSet.consonants.contains(_:))
        )
    }

    @Test
    func vowels() {
        // random sampling of test characters
        let matchingChars = "aeiouàëïöùAEIOUÀËÏÖÙ"

        #expect(
            matchingChars.allSatisfy(CharacterSet.vowels.contains(_:))
        )

        // random sampling of test characters
        let nonMatchingChars = "bckmzBCKMZĜǧ"

        #expect(
            !nonMatchingChars.allSatisfy(CharacterSet.vowels.contains(_:))
        )
    }

    @Test
    func lowercaseVowels() {
        // random sampling of test characters
        let matchingChars = "aeiouàëïöù"

        #expect(
            matchingChars.allSatisfy(CharacterSet.lowercaseVowels.contains(_:))
        )

        // random sampling of test characters
        let nonMatchingChars = "AEIOUÀËÏÖÙ"

        #expect(
            !nonMatchingChars.allSatisfy(CharacterSet.lowercaseVowels.contains(_:))
        )
    }

    @Test
    func uppercaseVowels() {
        // random sampling of test characters
        let matchingChars = "AEIOUÀËÏÖÙ"

        #expect(
            matchingChars.allSatisfy(CharacterSet.uppercaseVowels.contains(_:))
        )

        // random sampling of test characters
        let nonMatchingChars = "aeiouàëïöù"

        #expect(
            !nonMatchingChars.allSatisfy(CharacterSet.uppercaseVowels.contains(_:))
        )
    }
}

#endif
