// Read the ratings

let aliceRating = readLine()!.characters.split(" ").map{ Int(String($0))!}
let bobRating = readLine()!.characters.split(" ").map{ Int(String($0))!}

// Initialize score counters

var aliceScore = 0
var bobScore = 0

// Compare

for i in 0...2 {
	if aliceRating[i] > bobRating[i] {
		aliceScore += 1
	} else if bobRating[i] > aliceRating[i] {
		bobScore += 1
	}
}

print("\(aliceScore) \(bobScore)")