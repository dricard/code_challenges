let n = Int(readLine()!)!

let data = readLine()!.characters.split(" ").map{ Int(String($0))! }

var positive = 0
var negative = 0
var zeroes = 0

for element in data {
	if element > 0 {
		positive += 1
	} else if element < 0 {
		negative += 1
	} else {
		zeroes += 1
	}
}

print(Double(positive)/Double(n))
print(Double(negative)/Double(n))
print(Double(zeroes)/Double(n))
