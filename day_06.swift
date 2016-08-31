// day 6: let's review
// the challenge is to print the even-indexed characters in a string, then a space
// then the odd-indexed characters. 0 is defined as even.
// INPUT is an integer representing the number of test cases
// then a string on a line for each test case.

// Read the number of test cases
let numberOfTestCases = Int(readLine()!)!

// this is a utility method to determine if an index is even or odd
func isOdd(n: Int) -> Bool {
	if n == 0 {
		return false
	} else {
		return n % 2 != 0
	}
}

// Here we process each test case
for test in 1...numberOfTestCases {
	// this reads the string and turns it into an array of characters
	let s = readLine()!.characters.map{ String($0) }
	
	var oddPart = ""
	var evenPart = ""
	
	// this iterates over all the element of the array
	// which are the characters, and also gives you access
	// to the index
	// We build the two parts (odd and even) as we
	// pass through the string in a single pass
	for (index, element) in s.enumerate() {
		if isOdd(index) {
			oddPart += element
		} else {
			evenPart += element
		}
	}
	
	print("\(evenPart) \(oddPart)")
}