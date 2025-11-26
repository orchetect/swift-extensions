//
//  CharacterSet.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

extension CharacterSet {
    /// Initialize a `CharacterSet` from one or more `Character`.
    @_disfavoredOverload
    public init(_ characters: Character...) {
        self.init(characters)
    }
    
    /// Initialize a `CharacterSet` from one or more `Character`.
    @_disfavoredOverload
    public init(_ characters: [Character]) {
        self.init()

        for character in characters {
            character.unicodeScalars.forEach { insert($0) }
        }
    }
}

extension CharacterSet {
    /// Returns true if the `CharacterSet` contains the given `Character`.
    @_disfavoredOverload
    public func contains(_ character: Character) -> Bool {
        // TODO: this may not be correct, it could match scalars non-sequentially
        character
            .unicodeScalars
            .allSatisfy(contains(_:))
    }
}

extension CharacterSet {
    /// Same as `lhs.union(rhs)`.
    @_disfavoredOverload
    public static func + (lhs: Self, rhs: Self) -> Self {
        lhs.union(rhs)
    }
    
    /// Same as `lhs.formUnion(rhs)`.
    @_disfavoredOverload
    public static func += (lhs: inout Self, rhs: Self) {
        lhs.formUnion(rhs)
    }
    
    /// Same as `lhs.subtracting(rhs)`.
    @_disfavoredOverload
    public static func - (lhs: Self, rhs: Self) -> Self {
        lhs.subtracting(rhs)
    }
    
    /// Same as `lhs.subtract(rhs)`.
    @_disfavoredOverload
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs.subtract(rhs)
    }
}

extension CharacterSet {
    /// English consonant letters, omitting vowels.
    @_disfavoredOverload
    public static let consonants = CharacterSet.letters.subtracting(Self.vowels)
    
    /// English vowel letters (a, e, i, o, u) including all cases and diacritic variants.
    @_disfavoredOverload
    public static let vowels = lowercaseVowels.union(uppercaseVowels)
    
    /// English lowercase vowel letters (a, e, i, o, u) including diacritic variants.
    @_disfavoredOverload
    public static let lowercaseVowels = CharacterSet(charactersIn:
        "aàáâäæãåā" + "ª" + "ăąǟǻȁȃȧᵃḁạảấầẩẫậắằẳẵặ"
            + "eèéêëēėę" + "ĕėěȅȇȩᵉḕḗḙḛḝẹẻẽếềểễệ"
            + "iîïíīįì" + "ĩĭįıǐȉȋᵢḭḯỉịⁱ"
            + "oôöòóœøōõ" + "ŏőơǒǫǭȍȏȫȭȯȱᵒṍṏṑṓọỏốồổỗộ"
            + "uûüùúū" + "ũŭůűųưǔǖǘǚǜȕȗᵘᵤṳṵṷṹṻụủứừửữự"
    )
    
    /// English uppercase vowel letters (a, e, i, o, u) including diacritic variants.
    @_disfavoredOverload
    public static let uppercaseVowels = CharacterSet(charactersIn:
        "AÀÁÂÄÆÃÅĀ" + "ĂĄǞǺȀȂȦᴬḀẠẢẤẦẨẪẬẮẰẲẴẶ"
            + "EÈÉÊËĒĖĘ" + "ĔĖĚȄȆȨᴱḔḖḘḚḜẸẺẼẾỀỀỂỄỆ"
            + "IÎÏÍĪĮÌ" + "ĨĬĮİǏȈȊᴵḬḮỈỊ"
            + "OÔÖÒÓŒØŌÕ" + "ŎŐƠǑǪǬȌȎȪȬȮȰᴼṌṎṐṒỌỎỐỒỔỖỘỚ"
            + "UÛÜÙÚŪ" + "ŨŬŮŰŲƯǓǕǗǙǛȔȖᵁṲṴṶṸṺỤỦỨỪỬỮỰ"
    )
}

#endif
