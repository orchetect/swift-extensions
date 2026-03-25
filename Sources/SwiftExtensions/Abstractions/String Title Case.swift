//
//  String Title Case.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - Title Case

extension StringProtocol {
    /// Used by ``titleCased``.
    /// Private array of title case particles to leave as lowercase
    private static var titleCasedParticles: [Self] {
        [
            "a", "an", "the",              // articles
            "and", "but", "for",           // coordinating conjunctions
            "at", "by", "of", "in", "on",  // prepositions
            "to", "with",
            "is"
        ]
    }
    
    /// Returns a representation of the string in title case capitalization style.
    ///
    /// Example:
    ///
    /// ```swift
    /// "the astRoNaut worked At NASA".titleCased
    /// // "The Astronaut Worked at NASA"
    /// ```
    ///
    /// (English localization only at this time.)
    @available(macOS 10.11, *)
    @_disfavoredOverload
    public var titleCased: String {
        titleCased(firstCharacterOfWordsOnly: false, preserveUppercaseWords: true)
    }
    
    /// Returns a representation of the string in title case capitalization style.
    ///
    /// Example:
    ///
    /// ```swift
    /// let string = "the astRoNaut worked At NASA"
    ///
    /// string.titleCased(firstCharacterOfWordsOnly: false, preserveUppercaseWords: false)
    /// // "The Astronaut Worked at Nasa"
    ///
    /// string.titleCased(firstCharacterOfWordsOnly: false, preserveUppercaseWords: true)
    /// // "The Astronaut Worked at NASA"
    ///
    /// string.titleCased(firstCharacterOfWordsOnly: true, preserveUppercaseWords: false)
    /// // "The AstRoNaut Worked at Nasa"
    ///
    /// string.titleCased(firstCharacterOfWordsOnly: true, preserveUppercaseWords: true)
    /// // "The AstRoNaut Worked at NASA"
    /// ```
    ///
    /// (English localization only at this time.)
    ///
    /// - Parameters:
    ///   - firstCharacterOfWordsOnly: When `true`, only modify the case of the first character
    ///     of each non-particle word. The existing case is preserved for all characters following
    ///     the first character.
    ///   - preserveUppercaseWords: When `true`, any words (including particles) that are entirely
    ///     uppercase will be preserved as-is and not modified. This allows preserving acronyms, for example.
    @available(macOS 10.11, *)
    @_disfavoredOverload
    public func titleCased(
        firstCharacterOfWordsOnly: Bool,
        preserveUppercaseWords: Bool
    ) -> String {
        let wordsSplitByHyphens: [Word] = String(self)
            .split(separator: "-")
            .map { Word.word(String($0)) }
        let wordsWithHyphens = wordsSplitByHyphens.map { [$0] }
            .joined(separator: [Word.hyphen])
            .compactMap(\.self)
        var words: [Word] = wordsWithHyphens
            .flatMap { w -> [Word] in
                switch w {
                case .hyphen:
                    [w]
                case let .word(string):
                    string
                        .split(separator: " ")
                        .map { .word(String($0)) }
                }
            }
        
        for index in words.indices {
            guard case let .word(word) = words[index] else { continue }
            
            if preserveUppercaseWords {
                guard !word.isUppercase(ignoreWhitespace: false, ignoreNonCased: true) else {
                    // leave word as-is
                    continue
                }
            }
            let lowercaseWord = word.localizedLowercase
            let isParticle = String.titleCasedParticles.contains(lowercaseWord)
            
            if isParticle {
                if index == words.startIndex || index == words.indices.last { // first or last word?
                    if firstCharacterOfWordsOnly {
                        words[index].replace(with: word.uppercasingFirstCharacter())
                    } else {
                        words[index].replace(with: word.localizedCapitalized)
                    }
                } else { // between the first word and the last word
                    words[index].replace(with: lowercaseWord)
                }
            } else { // not a particle
                if firstCharacterOfWordsOnly {
                    words[index].replace(with: word.uppercasingFirstCharacter())
                } else {
                    words[index].replace(with: word.localizedCapitalized)
                }
            }
        }
        
        return words
            .joined(separator: " ")
    }
}

private enum Word: Equatable {
    case hyphen
    case word(String)
    
    var string: String {
        switch self {
        case .hyphen: "-"
        case let .word(string): string
        }
    }
    
    mutating func replace(with string: String) {
        self = .word(string)
    }
    
    mutating func modify(_ block: (_ string: String) -> String) {
        let newString = block(string)
        
        switch newString {
        case "-": self = .hyphen
        default: self = .word(newString)
        }
    }
}

extension Collection<Word> {
    func joined(separator: String = "") -> String {
        var output: String = ""
        for index in indices {
            switch self[index] {
            case .hyphen: 
                output += "-"
            case let .word(string):
                if let lastChar = output.last, lastChar != "-" { output += separator }
                output += string
            }
        }
        return output
    }
}

// MARK: - First Character Casing

extension StringProtocol {
    /// Returns a copy of the string with the first character lowercased.
    @_disfavoredOverload
    public func lowercasingFirstCharacter() -> String {
        guard !isEmpty else { return "" }
        var copy = String(self)
        copy.lowercaseFirstCharacter()
        return copy
    }
    
    /// Returns a copy of the string with the first cased character lowercased.
    @_disfavoredOverload
    public func lowercasingFirstCasedCharacter() -> String {
        guard !isEmpty else { return "" }
        var copy = String(self)
        copy.lowercaseFirstCasedCharacter()
        return copy
    }
    
    /// Returns a copy of the string with the first character uppercased.
    @_disfavoredOverload
    public func uppercasingFirstCharacter() -> String {
        guard !isEmpty else { return "" }
        var copy = String(self)
        copy.uppercaseFirstCharacter()
        return copy
    }
}

extension String {
    /// Lowercases the first character in-place.
    @_disfavoredOverload
    public mutating func lowercaseFirstCharacter() {
        guard !isEmpty,
              let firstChar = first
        else { return }
        let lowercasedChar = String(firstChar).localizedLowercase
        
        replaceSubrange(startIndex ... startIndex, with: lowercasedChar)
    }
    
    /// Lowercases the first cased character in-place.
    @_disfavoredOverload
    public mutating func lowercaseFirstCasedCharacter() {
        guard !isEmpty,
              let index = firstIndex(where: { $0.isCased })
        else { return }
        let lowercasedChar = String(self[index]).localizedLowercase
        
        replaceSubrange(index ... index, with: lowercasedChar)
    }
    
    /// Uppercases the first character in-place.
    @_disfavoredOverload
    public mutating func uppercaseFirstCharacter() {
        guard !isEmpty,
              let firstChar = first
        else { return }
        let uppercasedChar = String(firstChar).localizedUppercase
        
        replaceSubrange(startIndex ... startIndex, with: uppercasedChar)
    }
}
