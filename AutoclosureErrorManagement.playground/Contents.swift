import Foundation
// Autoclosure is nice for error management

// some setup: define an error
struct MyError: Error {

}

struct Wrapped {
}

extension Optional {
    func unwrapOrThrow() throws -> Wrapped {
        guard let value = self else {
            throw MyError()
        }
        return value
    }
}
// only evaluate error expression when needed
// TODO: code an example that does compile
// let name = try argument(at: 1).unwrapOrThrow(ArgumentError.missingName)

/// Cool technique for extracting optional data
/// from Dictionary, db, userdefaults....
// instead of let coins = (dictionary["numberOfCoins"] as? Int) ?? 100
// use a more readable form:
//
// let coins = dictionary.value(forKey: "numberOfCoins", defautValue: 100)
// via an extension with autoclosures:
extension Dictionary where Value == Any {
    func value<T>(forKey key: Key, defaultValue: @autoclosure () -> T) -> T {
        guard let value = self[key] as? T else {
            return defaultValue()
        }
    return value
    }
}
