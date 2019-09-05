import Foundation
/*:
 # A quick playground dedicated to simple features of the language
 It's always nice to have a basic demonstration of tools when discussing code with people
 */

print("Built using Swift 5.0")

/*:
 ## Option Sets
 ### Requirements:
 - needs a constant describing the underlying value (usually an integer)
 - static instances per option
 - unique values (bit shifting helps)
 - values can be combined in groups with their own static declaration
*/

struct WeaponStyle: OptionSet {
    let rawValue: Int
    static let energy = WeaponStyle(rawValue:1<<0)
    static let kinetic = WeaponStyle(rawValue:1<<1)
    static let combined: WeaponStyle = [.energy, .kinetic]
}

struct Mecha {
    let WeaponComplement: WeaponStyle
    let structurePool: Int
}

let wolf = Mecha(WeaponComplement: .energy, structurePool: 100)
let titan = Mecha(WeaponComplement: .combined, structurePool: 500)
