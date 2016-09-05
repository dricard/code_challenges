// Melabrion Zodiac Maze Paths
/* Melabrion Zodiac Maze solution finder */

// THIS IS A DUPLICATE FROM Astro. Remove after insertion in astro.

let constellation_short = [ "Cat", "Healer", "Fox", "Rooster", "Warrior", "Pig", "Centaur", "Mystic", "Maha", "Shredders", "Ancient", "Rat" ]

var step = [[Int]]()

var steps = [Int]()

// Human/undisclosed series

steps = [ 0, 7, 4, 6, 1, 7, 2, 11, 8, 6, 5, 11 ]
step.append(steps)

// dwarf series

steps = [ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]
step.append(steps)

// thoom series

steps = [ 0, 9, 5, 5, 9, 1, 1, 9, 8, 9, 5, 9 ]
step.append(steps)

// zo series

steps = [ 0, 4, 1, 9, 1, 4, 11, 4, 3, 10, 9, 1 ]
step.append(steps)

// fen series

steps = [ 0, 5, 8, 8, 11, 6, 9, 5, 3, 8, 3, 4 ]
step.append(steps)

// sylvan series

steps = [ 0, 11, 10, 8, 5, 9, 6, 1, 2, 4, 7, 3 ]
step.append(steps)

// halfling series

steps = [ 0, 8, 11, 11, 9, 10, 4, 5, 4, 9, 10, 7 ]
step.append(steps)


let start = [ 11, 11, 10, 7, 1, 0, 7 ] // starting zodiac sign (negative) offset by race

// This makes sure that a zodiac sign index is in the 0...11 range
// this assumes (as is the case in this maze solution) that the
// maximum added to an index is 11
func normaliseZodiacIndex(index: Int) -> Int {
	var nIndex = 0
	if index < 0 {
		nIndex = 12 + index
	} else if index > 11 {
		nIndex = index - 12
	} else {
		nIndex = index
	}
	return nIndex
}

// Melabrion's Zodiac maze has the following solution:
// Each of the 7 races has a different starting zodiac sign which depends on
// the current rising zodiac. Once this starting sign is found, each race
// steps through the other 11 signs in steps (dwarves do it in the normal sequence
// of rising zodiacs, other have more complicated steps patterns)
func sayMZMPath(race: String) -> String {
//	let time = clTime()
//	let const = constellationForDay(time.year, dayOfYear: time.dayOfYear)
	let const = 10
	var raceIndex = 0 // default to human
	switch race {
		case "human":
			raceIndex = 0
		case "dwarf":
			raceIndex = 1
		case "thoom":
			raceIndex = 2
		case "zo":
			raceIndex = 3
		case "fen":
			raceIndex = 4
		case "sylvan":
			raceIndex = 5
		case "halfling":
			raceIndex = 6
		default: // all other races introduced after defaults to human sequence
			raceIndex = 0
	}
	var path = [Int]()
	// get the starting zodiac sign for that race's path
	path.append(normaliseZodiacIndex(const - start[raceIndex])) 
	// now complete the path
	for i in 1...11 {
		path.append(normaliseZodiacIndex(path[i-1] + step[raceIndex][i]))
	}
	var pathString = "Path for \(race) is: "
	for i in 0...11 {
		pathString += constellation_short[path[i]]
		if i < 11 {
			pathString += ", "
		} else {
			pathString += "."
		}
	}
	return pathString
}

/* Confirmed path for rising Ancient are (2016-07-26 cl text log)
Path for  human/undisclosed is: Rat, Centaur, Ancient, Warrior, Pig, Cat, Fox, Healer, Shredders, Rooster, Ruknee, Mystic
Path for  thoom is: Cat, Shredders, Fox, Mystic, Warrior, Pig, Centaur, Rooster, Rat, Ruknee, Healer, Ancient
Path for  fen is: Shredders, Fox, Ancient, Centaur, Pig, Rat, Ruknee, Healer, Warrior, Cat, Rooster, Mystic

unconfirmed but same algorithm
Path for  dwarf is: Rat, Cat, Healer, Fox, Rooster, Warrior, Pig, Centaur, Mystic, Ruknee, Shredders, Ancient
Path for  zo is: Rooster, Mystic, Ruknee, Pig, Centaur, Ancient, Shredders, Healer, Warrior, Fox, Rat, Cat
Path for  sylvan is: Ancient, Shredders, Mystic, Rooster, Ruknee, Pig, Rat, Cat, Fox, Centaur, Healer, Warrior
Path for  halfling is: Rooster, Rat, Ancient, Shredders, Centaur, Warrior, Ruknee, Healer, Pig, Fox, Cat, Mystic
*/

print("Rising zodiac: \(constellation_short[10])")
print(sayMZMPath("human"))
print(sayMZMPath("dwarf"))
print(sayMZMPath("thoom"))
print(sayMZMPath("zo"))
print(sayMZMPath("fen"))
print(sayMZMPath("sylvan"))
print(sayMZMPath("halfling"))