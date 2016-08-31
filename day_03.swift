// day 3 challenge: conditional

let number = Int(readLine()!)!

if number % 2 != 0 {
	// number is odd - weird
	print("Weird")
} else if number >= 2 && number <= 5 || number > 20 {
	// even and in the 2...5 or > 20 range - not weird
	print("Not Weird")
} else {
	// even and in the 6...20 range - weird
	print("Weird")
}