// day 10: Binary number

/* Given a base- integer, , convert it to binary (base-2). Then find and print the base- integer denoting the maximum number of consecutive 's in 's binary representation */

import Foundation

// MARK: - INPUT

let n = Int(readLine()!)!

// MARK: - Solution

/* the solution is to use recursivity to build string of base-2 digits and build the 
	the longest series of '1' at the same time. */

// this is the maximum power of 2 that we need to consider
var maxPow: Int = 0

// this will stop just after the power that we need...
while Int(pow(2.0, Double(maxPow))) <= n {
	maxPow += 1
} 
// ... so we substract one
maxPow -= 1

var maxConsecutive = 0
var currentMax = 0

// this is a recursive function that finds the binary representation of the decimal number
// it also finds the solution to the longest series of '1' at the same time
func binaryNumber(n: Int, p: Int) -> String {
	if p < 0 {
		return ""
	} else {
		let m = Int(pow(2.0, Double(p)))
		if n >= m {
			currentMax += 1
			return binaryNumber(n % m, p: p - 1) + "1"
		} else {
			if currentMax > maxConsecutive { maxConsecutive = currentMax }
			currentMax = 0
			return binaryNumber(n, p: p - 1) + "0"
		}
	}
}

// Note that in the case of a binary with only '1's, currentMax will hold the correct
// answer, so we return the max of those two variables.

let binary = binaryNumber(n, p: maxPow)
print(max(maxConsecutive, currentMax))
