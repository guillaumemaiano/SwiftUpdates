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
