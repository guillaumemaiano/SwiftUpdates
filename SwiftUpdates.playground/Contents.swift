#if swift(>=5.1)
print("Already at 5.1 or over")
#else
print("Not yet 5.1")
#endif
/// SE_0235
/// Hacking With Swift (adapted with my own examples)

// Result
import Foundation

enum RobotError: Error {
    case badInstruction // Instructions must follow the three laws of robotics
}

// Parenthesis and argument positioning
struct RobotInstruction {

}

func interpretInstructions(instructions: [String]) -> [RobotInstruction]? {
    // Fakey a-fakey, interprets orders into a set of robot instructions - lol
    // note: would need to use contains.where with some actual parsing to deal with Kill Someone/Kill the lights etc, but this is a demo of Result/Result with throwing closure, not a real serious whatever with ROBOTS.
    if instructions.contains("Kill")
        || instructions.contains("Hurt") {
        return nil
    } else {
        // so fake ^^
        return [RobotInstruction()]
    }

}

func runRobotInstructions(
    instructions: [RobotInstruction],
    onCompletion: Void) {
    // Fakey a-fakey, run a set of robot instructions - lol
}

func executeInstructions(
    set: [String],
    onCompletion: @escaping ( Result<String, RobotError>) -> Void) {

    guard let instructionSet = interpretInstructions(instructions: set)
        else {
            onCompletion(.failure(.badInstruction))
            return
    }
    runRobotInstructions(instructions: instructionSet,
                         onCompletion: onCompletion(.success("Your Will Be Done")))
}

/// # Result demonstrated
executeInstructions(set: [ "Say hi", "Kill" ]) { result in
    switch result {
    case .success(let message):
        print(message)
    case .failure(let error):
        print("Problem occured while interpreting instructions with message: \(error.localizedDescription)")
    }

    /// # Result converted into regular throwing call
    /// This works using the get() method of Result
    executeInstructions(set: ["Make bread"]) { result in
        if let response = try? result.get() {
            print("Robot responds: '\(response)'")
        }
    }
    /// # Result may take a throwing closure at init
    enum BreadRobotError: Error {
        case stale
    }
    func bakeBread() throws -> BreadRobotError {
        throw BreadRobotError.stale
    }
    let breadbotResponse = Result {
        try bakeBread()
    }
    do {
        try breadbotResponse.get()
    } catch let error {
        print("An error occured during bread baking: \(error)")
    }
}
/// It's expected most uses of Result will use Swift.Error as the error type argument (loses safety of typed throws, gain variety of error enums -- GEM: but could also inherit errors form domain errors...)


/// SE_0200
// Raw strings allow in-string quote signs
let goodMovie = #"My Fair Lady is a good movie that seems "dated" nowadays"#
// as well as backslashes
let salute = #"Hail honorable warrior \o/"#
// Reminder - this version of print adds a single space between text displayed
print(goodMovie,"\n", salute)
// String interpolation in a raw string
let injectedString = "sharp sign"
let interpolator = #"We need a \#(injectedString) to interpolate in a raw string"#
print(interpolator)
// Raw strings can be metaed by using multiple sharp signs
let neo = ##"Obligatory Matrix Quote: "Wake up Neo."#Classic"##
print(neo)
/// Raw strings can still multiline
let basho = #"""
In the colza field
Birds are pretending
To gaze at the flowers
"""#
// Note: very useful for pattern matching --> matches \Fighter.callsign
let regex1 = "\\\\[A-Z]+[A-Za-z]+\\.[a-z]+"
// turns into, much more readable (and here, saves on keystroke...)
let regex2 = #"\\[A-Z]+[A-Za-z]+\.[a-z]+"#
// so I find Maverick faster and my F14 gets backup... lol.

// SE_0228

/// By default, Swift prints the struct name followed by all its properties... but only for structs
struct Planet {
    var name: String
    var role: String
    var sector: String
    var id: Int
    var priority: Int
}

let terra = Planet(name: "Terra", role: "ThroneWorld", sector: "Solar", id: 1, priority: 1)
// default print displays: Planet(name: "Terra", role: "ThroneWorld", sector: "Solar", id: 1, priority: 1)
print(terra)
// Basic interpolation
print("\(terra)")

// use interpolation to extend print's behavior -- note: no different from just implementing the CustomStringConvertible protocol
extension String.StringInterpolation {
    mutating func appendInterpolation(_ aster: Planet) {
        appendInterpolation("Planet \(aster.name) serves as \(aster.role) in Segmentum \(aster.sector).")
    }
}
// Now, print displays:
print(terra)
// Fancy interpolation
print("\(terra)")

// More power: use supplementary parameters
extension String.StringInterpolation {
    mutating func appendInterpolation(_ fancyPrintAster: Planet, style: NumberFormatter.Style) {
        // Reminder: The NumberFormatter class has a number of styles, including currency ($72.83), ordinal (1st, 12th), and spell out (five, forty-three).
        let formatter = NumberFormatter()
        formatter.numberStyle = style

        appendInterpolation("Extended information brief -- \nPlanet \(fancyPrintAster.name) serves as \(fancyPrintAster.role) in Segmentum \(fancyPrintAster.sector).")
        if let planetaryId = formatter.string(from: fancyPrintAster.id as NSNumber) {
            appendLiteral(" It is denominated as \(fancyPrintAster.sector) \(planetaryId.capitalized).")
        }
        if let planetaryPriority = formatter.string(from: fancyPrintAster.priority as NSNumber) {
            appendLiteral(" It holds priority \(planetaryPriority).")
        } else {
            appendLiteral(" It has unknown priority.")
        }
    }
}
print(terra)
print("\(terra, style: .spellOut)")

// Note: we could easily build a morse interpolator ^^

// Reminders about @autoclosure for what comes next
// https://www.hackingwithswift.com/example-code/language/what-is-the-autoclosure-attribute
// Nutshell: applied to a closure parameter for a function, and automatically creates a closure from an expression you pass in
// *used inside Swift wherever code needs to be passed in and executed only if conditions are right*
// --> the && operator uses @autoclosure to allow short-circuit evaluation
// --> the assert() function uses it so that the assertion isn’t checked outside of debug mode

func printTest2(_ result: @autoclosure () -> Void) {
    print("Before")
    result()
    print("After")
}
// No need for braces, not very readable...
printTest2(print("Hello"))

print("\n ------- \n")

// More powerful power! -- interpolate an array's contents and execute passed-in code if array is empty

extension String.StringInterpolation {
    mutating func appendInterpolation(_ planets: [Planet], empty defaultValue:@autoclosure () -> String) {
        if planets.count == 0 {
            // executes the code passed in as an autoclosure
            // via the defaultValue argument to build the interpolated litteral
            appendLiteral(defaultValue())
        } else {
            appendLiteral("Planets in study: \n")
            for planet in planets {
                appendLiteral("--> \(planet.name) in Sector \(planet.sector) serving as \(planet.role)\n")
            }
        }
    }
}

let annihilatedSystems: [Planet] = []
let loop: () -> String = { var empty = ""
for _ in 1...3 {
    empty.append("No planets available...")
}
    return empty
}
print("\(annihilatedSystems, empty: loop())")
print("\(annihilatedSystems, empty: "None")")


let favoredSystems = [Planet(name: "Terra", role: "ThroneWorld", sector: "Solar", id: 1, priority: 1),
                      Planet(name: "Maccrage", role: "Chapter HomeWorld", sector: "Ultima", id: 1, priority: 1)
]

print("\(favoredSystems, empty: "None")")

// SE_0195
// Make Swift more script-like
// declare the presence of a "subscript dynamic member" (required declaration)
@dynamicMemberLookup
struct Rocket {
    // the dynamic member defined through a string array
    // Note: no dash in property names
    subscript(dynamicMember member:String) -> String {
        let properties = ["booster": "built", "hydroponics": "researched", "habitation": "in study"]
        return properties[member, default: ""]
    }
    subscript(dynamicMember member:String) -> Int {
        let properties = ["liftoff": 360, "attack-angle": 14]
        return properties[member, default: 0]
    }
}
let astre = Rocket()
let advancement: String = astre.booster
print(advancement)
let liftoffDurationSeconds: Int = astre.liftoff
print(liftoffDurationSeconds)

@dynamicMemberLookup
struct Book {
    subscript(dynamicMember member:String) -> String {
        let properties = ["title": "The Longest Winter", "ISBN": "12345678901234567890"]
        return properties[member, default: ""]
    }
}
let book = Book()
print(book.title)
// request absent property -- returns empty string, but doesn't compile if multiple subscript!
print(book.banana)


// if there was only ONE set of dynamic members, I could even print directly
//print(astre.hydroponics)
//print(astre.habitation)

/// Keypaths combine with @dynamicMemberLookup
/// https://www.avanderlee.com/swift/dynamic-member-lookup/
/// Flavored by use of an array
/// Swift 5.1
#if swift(>=5.1)
print("Keypath lookup")

struct Regiment {
    let troops: Int
    let type: String
    let identifier: String
}

@dynamicMemberLookup
struct Posting {
    let location: String
    let regiment: Regiment

    subscript<T>(dynamicMember keyPath: KeyPath<Regiment, T>) -> T {
        return regiment[keyPath: keyPath]
    }
}

let spartansRegiment = Regiment(troops: 500, type: "Pikemen", identifier: "The Spartans")
let posting = Posting(location: "Gloucester", regiment: spartansRegiment)
print(posting.identifier)

@dynamicMemberLookup
struct Army {
    let name: String
    let regiment: [Regiment]

    subscript<T>(dynamicMember keyPath: KeyPath<Regiment, T>) -> T {
        return regiment[keyPath: keyPath]
    }
}
#else
print("Not yet 5.1, cannot demo keypath lookup ")
#endif

// Hacking With Swift's example
@dynamicMemberLookup
struct Person {
    subscript(dynamicMember member: String) -> (_ input: String) -> Void {
        return {
            print("Hello! I live at the address \($0).")
        }
    }
}

let taylor = Person()
// any name I want which takes a string responds (yuck)
// taylor.stupidName("here") works as well!
taylor.printAddress("555 Taylor Swift Avenue")

// closure-returning subscript
@dynamicMemberLookup
struct GEMBluetoothLightManager {
    private var status = false
    private mutating func changeStatus() -> String {
        status = !status
        if status {
            return "on"
        } else {
            return "off"
        }
    }

    subscript(dynamicMember member: String) -> () -> Void {
        return {
            // https://stackoverflow.com/questions/57595689/call-to-my-struct-dynamic-member-causes-an-infinite-loop-within-my-closure
            //            let newStatus: String = self.changeStatus()
            //            print("Turn lights \(newStatus)")
        }
    }
}
let bedroomLights = GEMBluetoothLightManager()
bedroomLights.doStuff()

// Healthy reminder, in Swift, Int.max +1 crashes...
// let number = Int.max
// let higher = number + 1

// Chris Lattner's example of navigation through JSON:
@dynamicMemberLookup
enum JSON {
    case intValue(Int)
    case stringValue(String)
    case arrayValue(Array<JSON>)
    case dictionaryValue(Dictionary<String, JSON>)

    var stringValue: String? {
        if case .stringValue(let str) = self {
            return str
        }
        return nil
    }

    subscript(index: Int) -> JSON? {
        if case .arrayValue(let arr) = self {
            return index < arr.count ? arr[index] : nil
        }
        return nil
    }

    subscript(key: String) -> JSON? {
        if case .dictionaryValue(let dict) = self {
            return dict[key]
        }
        return nil
    }

    subscript(dynamicMember member: String) -> JSON? {
        if case .dictionaryValue(let dict) = self {
            return dict[member]
        }
        return nil
    }
}


/// Memberwise initializers for structs

// earlier versions: automatically accept parameters matching properties of struct

