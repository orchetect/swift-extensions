//
//  String Title Case Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import SwiftExtensions
import Testing

@Suite struct Abstractions_StringTitleCase_Tests {
    @Test
    func titleCasedProperty() async {
        #expect("this".titleCased == "This")
        #expect("THIs".titleCased == "This")
        #expect("THIS".titleCased == "THIS") // preserve all-uppercase words by default
        
        #expect("this thing".titleCased == "This Thing")
        
        #expect("this is a test".titleCased == "This is a Test")
        #expect("tHis is A test".titleCased == "This is A Test") // force lowercase after first character of each word by default
        #expect("THIS is A test".titleCased == "THIS is A Test") // preserve all-uppercase words by default
        
        #expect(" this   is a  test  ".titleCased == "This is a Test")
    }
    
    @Test
    func titleCased() {
        func cased(_ string: String) -> String {
            string.titleCased(firstCharacterOfWordsOnly: false, preserveUppercaseWords: false)
        }
        
        #expect(cased("") == "")
        #expect(cased(" ") == "")
        #expect(cased("a") == "A")
        #expect(cased("A") == "A")
        #expect(cased("b") == "B")
        #expect(cased("B") == "B")
        #expect(cased("a b c") == "A B C")
        #expect(cased("c b a") == "C B A")
        #expect(cased("a-b-c") == "A-B-C")
        #expect(cased("c-b-a") == "C-B-A")
        
        #expect(cased("this") == "This")
        #expect(cased("THIs") == "This")
        #expect(cased("THIS") == "This")
        
        #expect(cased("this is a test") == "This is a Test")
        #expect(cased("tHis iS A test") == "This is a Test")
        #expect(cased("THIS is A test") == "This is a Test")
        #expect(cased("THIS is B test") == "This is B Test")
        #expect(cased("this IS a TEST") == "This is a Test")
        
        #expect(cased("this-is-a-test") == "This-is-a-Test")
        #expect(cased("this-is a-test") == "This-is a-Test")
        #expect(cased("this-is-a-test") == "This-is-a-Test")
        #expect(cased("this-iS-a-test") == "This-is-a-Test")
        #expect(cased("THIS-is-a-BIG-test") == "This-is-a-Big-Test")
        #expect(cased("THis-Is-a-BIG-test") == "This-is-a-Big-Test")
        
        #expect(cased(" this   is a  test  ") == "This is a Test")
        
        #expect(cased("a matrix") == "A Matrix")
        #expect(cased("the matrix") == "The Matrix")
        #expect(cased("tHe matrix") == "The Matrix")
        #expect(cased("THE matrix") == "The Matrix")
        #expect(cased("enter a matrix") == "Enter a Matrix")
        #expect(cased("enter the matrix") == "Enter the Matrix")
        #expect(cased("enter tHe matrix") == "Enter the Matrix")
        #expect(cased("enter THE matrix") == "Enter the Matrix")
    }
    
    @Test
    func titleCased_firstCharacterOfWordsOnly() async {
        func cased(_ string: String) -> String {
            string.titleCased(firstCharacterOfWordsOnly: true, preserveUppercaseWords: false)
        }
        
        #expect(cased("") == "")
        #expect(cased(" ") == "")
        #expect(cased("a") == "A")
        #expect(cased("A") == "A")
        #expect(cased("b") == "B")
        #expect(cased("B") == "B")
        #expect(cased("a b c") == "A B C")
        #expect(cased("c b a") == "C B A")
        #expect(cased("a-b-c") == "A-B-C")
        #expect(cased("c-b-a") == "C-B-A")
        
        #expect(cased("this") == "This")
        #expect(cased("THIs") == "THIs")
        #expect(cased("THIS") == "THIS")
        
        #expect(cased("this is a test") == "This is a Test")
        #expect(cased("tHis iS A test") == "THis is a Test")
        #expect(cased("THIS is A test") == "THIS is a Test")
        #expect(cased("THIS is B test") == "THIS is B Test")
        #expect(cased("this IS a TEST") == "This is a TEST")
        
        #expect(cased("this-is-a-test") == "This-is-a-Test")
        #expect(cased("this-is a-test") == "This-is a-Test")
        #expect(cased("this-is-a-test") == "This-is-a-Test")
        #expect(cased("this-iS-a-test") == "This-is-a-Test")
        #expect(cased("THIS-is-a-BIG-test") == "THIS-is-a-BIG-Test")
        #expect(cased("THis-Is-a-BIG-test") == "THis-is-a-BIG-Test")
        
        #expect(cased(" this   is a  test  ") == "This is a Test")
        
        #expect(cased("a matrix") == "A Matrix")
        #expect(cased("the matrix") == "The Matrix")
        #expect(cased("tHe matrix") == "THe Matrix")
        #expect(cased("THE matrix") == "THE Matrix")
        #expect(cased("enter a matrix") == "Enter a Matrix")
        #expect(cased("enter the matrix") == "Enter the Matrix")
        #expect(cased("enter tHe matrix") == "Enter the Matrix")
        #expect(cased("enter THE matrix") == "Enter the Matrix")
    }
    
    @Test
    func titleCased_preserveUppercaseWords() async {
        func cased(_ string: String) -> String {
            string.titleCased(firstCharacterOfWordsOnly: false, preserveUppercaseWords: true)
        }
        
        #expect(cased("") == "")
        #expect(cased(" ") == "")
        #expect(cased("a") == "A")
        #expect(cased("A") == "A")
        #expect(cased("b") == "B")
        #expect(cased("B") == "B")
        #expect(cased("a b c") == "A B C")
        #expect(cased("c b a") == "C B A")
        #expect(cased("a-b-c") == "A-B-C")
        #expect(cased("c-b-a") == "C-B-A")
        
        #expect(cased("this") == "This")
        #expect(cased("THIs") == "This")
        #expect(cased("THIS") == "THIS")
        
        #expect(cased("this is a test") == "This is a Test")
        #expect(cased("tHis iS A test") == "This is A Test")
        #expect(cased("THIS is A test") == "THIS is A Test")
        #expect(cased("THIS is B test") == "THIS is B Test")
        #expect(cased("this IS a TEST") == "This IS a TEST")
        
        #expect(cased("this-is-a-test") == "This-is-a-Test")
        #expect(cased("this-is a-test") == "This-is a-Test")
        #expect(cased("this-is-a-test") == "This-is-a-Test")
        #expect(cased("this-iS-a-test") == "This-is-a-Test")
        #expect(cased("THIS-is-a-BIG-test") == "THIS-is-a-BIG-Test")
        #expect(cased("THis-Is-a-BIG-test") == "This-is-a-BIG-Test")
        
        #expect(cased(" this   is a  test  ") == "This is a Test")
        
        #expect(cased("a matrix") == "A Matrix")
        #expect(cased("the matrix") == "The Matrix")
        #expect(cased("tHe matrix") == "The Matrix")
        #expect(cased("THE matrix") == "THE Matrix")
        #expect(cased("enter a matrix") == "Enter a Matrix")
        #expect(cased("enter the matrix") == "Enter the Matrix")
        #expect(cased("enter tHe matrix") == "Enter the Matrix")
        #expect(cased("enter THE matrix") == "Enter THE Matrix")
    }
    
    @Test
    func titleCased_firstCharacterOfWordsOnly_preserveUppercaseWords() async {
        func cased(_ string: String) -> String {
            string.titleCased(firstCharacterOfWordsOnly: true, preserveUppercaseWords: true)
        }
        
        #expect(cased("") == "")
        #expect(cased(" ") == "")
        #expect(cased("a") == "A")
        #expect(cased("A") == "A")
        #expect(cased("b") == "B")
        #expect(cased("B") == "B")
        #expect(cased("a b c") == "A B C")
        #expect(cased("c b a") == "C B A")
        #expect(cased("a-b-c") == "A-B-C")
        #expect(cased("c-b-a") == "C-B-A")
        
        #expect(cased("this") == "This")
        #expect(cased("THIs") == "THIs")
        #expect(cased("THIS") == "THIS")
        
        #expect(cased("this is a test") == "This is a Test")
        #expect(cased("tHis iS A test") == "THis is A Test")
        #expect(cased("THIS is A test") == "THIS is A Test")
        #expect(cased("THIS is B test") == "THIS is B Test")
        #expect(cased("this IS a TEST") == "This IS a TEST")
        
        #expect(cased("this-is-a-test") == "This-is-a-Test")
        #expect(cased("this-is a-test") == "This-is a-Test")
        #expect(cased("this-is-a-test") == "This-is-a-Test")
        #expect(cased("this-iS-a-test") == "This-is-a-Test")
        #expect(cased("THIS-is-a-BIG-test") == "THIS-is-a-BIG-Test")
        #expect(cased("THis-Is-a-BIG-test") == "THis-is-a-BIG-Test")
        
        #expect(cased(" this   is a  test  ") == "This is a Test")
        
        #expect(cased("a matrix") == "A Matrix")
        #expect(cased("the matrix") == "The Matrix")
        #expect(cased("tHe matrix") == "THe Matrix")
        #expect(cased("THE matrix") == "THE Matrix")
        #expect(cased("enter a matrix") == "Enter a Matrix")
        #expect(cased("enter the matrix") == "Enter the Matrix")
        #expect(cased("enter tHe matrix") == "Enter the Matrix")
        #expect(cased("enter THE matrix") == "Enter THE Matrix")
    }
    
    // MARK: - StringProtocol.lowercaseFirstCharacter / lowercasingFirstCharacter
    
    @Test
    func lowercaseFirstCharacter() async {
        #expect({ var s = ""; s.lowercaseFirstCharacter(); return s }() == "")
        #expect({ var s = " "; s.lowercaseFirstCharacter(); return s }() == " ")
        #expect({ var s = "a"; s.lowercaseFirstCharacter(); return s }() == "a")
        #expect({ var s = "A"; s.lowercaseFirstCharacter(); return s }() == "a")
        #expect({ var s = "a "; s.lowercaseFirstCharacter(); return s }() == "a ")
        #expect({ var s = "A "; s.lowercaseFirstCharacter(); return s }() == "a ")
        #expect({ var s = " a"; s.lowercaseFirstCharacter(); return s }() == " a")
        #expect({ var s = " A"; s.lowercaseFirstCharacter(); return s }() == " A")
        #expect({ var s = "-a"; s.lowercaseFirstCharacter(); return s }() == "-a")
        #expect({ var s = "-A"; s.lowercaseFirstCharacter(); return s }() == "-A")
        #expect({ var s = "1a"; s.lowercaseFirstCharacter(); return s }() == "1a")
        #expect({ var s = "1A"; s.lowercaseFirstCharacter(); return s }() == "1A")
        #expect({ var s = "The"; s.lowercaseFirstCharacter(); return s }() == "the")
        #expect({ var s = "THE"; s.lowercaseFirstCharacter(); return s }() == "tHE")
        #expect({ var s = "tHE"; s.lowercaseFirstCharacter(); return s }() == "tHE")
    }
    
    @Test
    func lowercasingFirstCharacter() async {
        #expect("".lowercasingFirstCharacter() == "")
        #expect(" ".lowercasingFirstCharacter() == " ")
        #expect("a".lowercasingFirstCharacter() == "a")
        #expect("A".lowercasingFirstCharacter() == "a")
        #expect("a ".lowercasingFirstCharacter() == "a ")
        #expect("A ".lowercasingFirstCharacter() == "a ")
        #expect(" a".lowercasingFirstCharacter() == " a")
        #expect(" A".lowercasingFirstCharacter() == " A")
        #expect("-a".lowercasingFirstCharacter() == "-a")
        #expect("-A".lowercasingFirstCharacter() == "-A")
        #expect("1a".lowercasingFirstCharacter() == "1a")
        #expect("1A".lowercasingFirstCharacter() == "1A")
        #expect("The".lowercasingFirstCharacter() == "the")
        #expect("THE".lowercasingFirstCharacter() == "tHE")
        #expect("tHE".lowercasingFirstCharacter() == "tHE")
    }
    
    // MARK: - StringProtocol.uppercaseFirstCharacter / uppercasingFirstCharacter
    
    @Test
    func uppercaseFirstCharacter() async {
        #expect({ var s = ""; s.uppercaseFirstCharacter(); return s }() == "")
        #expect({ var s = " "; s.uppercaseFirstCharacter(); return s }() == " ")
        #expect({ var s = "a"; s.uppercaseFirstCharacter(); return s }() == "A")
        #expect({ var s = "A"; s.uppercaseFirstCharacter(); return s }() == "A")
        #expect({ var s = "a "; s.uppercaseFirstCharacter(); return s }() == "A ")
        #expect({ var s = "A "; s.uppercaseFirstCharacter(); return s }() == "A ")
        #expect({ var s = " a"; s.uppercaseFirstCharacter(); return s }() == " a")
        #expect({ var s = " A"; s.uppercaseFirstCharacter(); return s }() == " A")
        #expect({ var s = "-a"; s.uppercaseFirstCharacter(); return s }() == "-a")
        #expect({ var s = "-A"; s.uppercaseFirstCharacter(); return s }() == "-A")
        #expect({ var s = "1a"; s.uppercaseFirstCharacter(); return s }() == "1a")
        #expect({ var s = "1A"; s.uppercaseFirstCharacter(); return s }() == "1A")
        #expect({ var s = "The"; s.uppercaseFirstCharacter(); return s }() == "The")
        #expect({ var s = "THE"; s.uppercaseFirstCharacter(); return s }() == "THE")
        #expect({ var s = "tHE"; s.uppercaseFirstCharacter(); return s }() == "THE")
    }
    
    @Test
    func uppercasingFirstCharacter() async {
        #expect("".uppercasingFirstCharacter() == "")
        #expect(" ".uppercasingFirstCharacter() == " ")
        #expect("a".uppercasingFirstCharacter() == "A")
        #expect("A".uppercasingFirstCharacter() == "A")
        #expect("a ".uppercasingFirstCharacter() == "A ")
        #expect("A ".uppercasingFirstCharacter() == "A ")
        #expect(" a".uppercasingFirstCharacter() == " a")
        #expect(" A".uppercasingFirstCharacter() == " A")
        #expect("-a".uppercasingFirstCharacter() == "-a")
        #expect("-A".uppercasingFirstCharacter() == "-A")
        #expect("1a".uppercasingFirstCharacter() == "1a")
        #expect("1A".uppercasingFirstCharacter() == "1A")
        #expect("The".uppercasingFirstCharacter() == "The")
        #expect("THE".uppercasingFirstCharacter() == "THE")
        #expect("tHE".uppercasingFirstCharacter() == "THE")
    }
}
