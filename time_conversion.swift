var a = readLine()!

let timeString: String = String(a.characters.dropLast(2))
var time: [Int] = timeString.characters.split(":").map{ Int(String($0))! }

let suffix = String(a.characters.suffix(2))

if suffix == "PM" {
	if time[0] != 12 {
		time[0] += 12
	}
} else {
	if time[0] == 12 {
		time[0] = 0
	}
}

print("\(time[0] < 10 ? "0": "")\(time[0]):\(time[1] < 10 ? "0": "")\(time[1]):\(time[2] < 10 ? "0": "")\(time[2])")