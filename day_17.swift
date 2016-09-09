// Day 17: more exceptions

/*

Write a Calculator class with a single method: int power(int,int). The power method takes two integers,  and , as parameters and returns the integer result of . If either  or  is negative, then the method must throw an exception with the message: n and p should be non-negative.

Note: Do not use an access modifier (e.g.: public) in the declaration for your Calculator class.

*/

import Darwin

// Defining enum for throwing error
// throw RangeError.NotInRange... is used to throw the error
enum RangeError : ErrorType {
	case NotInRange(String)
}

// Start of class Calculator
class Calculator {
	// Start of function power
	func power(n: Int, p: Int) throws -> Int {
		if n < 0 || p < 0 {
			throw(RangeError.NotInRange("n and p should be non-negative")) 
		} else {
			let answer = pow(Double(n), Double(p))
			return Int(answer)
		}		
	} // End of function power
} // End of class Calculator

let myCalculator = Calculator()
var t = Int(readLine()!)!

while (t > 0) {
	let np = readLine()!.characters.split(" ").map(String.init)
	
	do {
		let ans = try myCalculator.power(Int(np[0])!, p: Int(np[1])!)
		print(ans)
	} catch RangeError.NotInRange(let errorMsg) {
		print(errorMsg)
	}
	t -= 1
}