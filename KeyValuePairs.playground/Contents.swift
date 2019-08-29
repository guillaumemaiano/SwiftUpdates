import Foundation
/*: [Paul Hudson article](https://www.hackingwithswift.com/example-code/language/what-are-keyvaluepairs)
 *Previously known as*:
 < Swift 5.0, _KeyValuePairs_ were _DictionaryLiteral_
 
 ## Pros:
  * No 'keys conform con form to _Hashable_' requirement
  * Duplicate keys allowed
  * Order is preserved
 
 ## Cons:
 * No fast lookup O(n) rather than O(1)
*/

let games: KeyValuePairs = ["Sid Meier": "Civilization", "Warren Spector": "Deus Ex", "Sid Meier": "Call To Power"]
let game = games[2]
print("\(game.key.capitalized)'s \(game.value)")

for awesomegame in games {
    
    print("\(awesomegame.key.capitalized)'s \(awesomegame.value)")
}
