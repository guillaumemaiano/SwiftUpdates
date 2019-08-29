import Foundation

// https://www.hackingwithswift.com/articles/188/improving-your-swift-code-using-value-objects

// Value objects are custom types that are small, precise types that represent one piece of our application.
// Like value types value objects should be both immutable and equatable, but they also add in validation as part of their creation.

// Fake example of EAN 13 (because it's a serious thing to code for real)

struct EAN13: Equatable {
    
    // fake structure analysis
    // nota: the first digit matters much to readers, as it infers what coding the next 6 elements will use visually!
    private static func checkEANStructure(eanString: String) -> Bool {
        // first two or three characters are country or product category (eg, 978/979 are Bookland, 977 are paper media, but 37 is France, 00 to 13 are either USA or Canada, 400 is Germany, 020 to O29 are internal codification, etc...)
        // next four or five characters are company
        // next four or five characters are product
        // last character is luhn-key
        let key = eanString.suffix(1)
        print("\(key)")
        // build key with eanString.prefix(12) characters and check it -- fake it
        return true
    }
    
    let value: String
    init?(string: String) {
        // remove whitespace and check length
        guard string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 13 else {
            return nil
        }
        
        // check structure
        guard EAN13.checkEANStructure(eanString: string) else {
            return nil
        }
        
        self.value = string
    }
}

/// Note: contrary to typealias, value objects are compiler-enforced
/// therefore, a non-nil object is valid
// A bottle that was lying around lending its barcode to science
let aniosGelBottle = EAN13(string: "3597610273360")

// this is a bit verbose, so let's use ExpressibleByStringLiteral to improve conciseness
// however, fatalError should not make it to production code, so this extension will only exist in Unit Test realm...
// other option: init could be modified to throw...
extension EAN13: ExpressibleByStringLiteral {
    
    init(stringLiteral value: StringLiteralType) {
        if let ean = EAN13(string: value) {
            self = ean
        } else {
            fatalError("Invalid EAN: \(value)")
        }
    }
}
