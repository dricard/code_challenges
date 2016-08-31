// day 05: loops
// This "challenge" is to write multiplications tables

// Read the integer representing the multiplication table to print
let n = Int(readLine()!)!

// in this challenge we print muliplication to times 10 max
let max = 10

// Iterate over the table and print the result
for i in 1...max {
	print("\(n) x \(i) = \(n*i)")
}