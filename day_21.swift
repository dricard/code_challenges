// Day 21: Generics

/*

Task 
Write a single generic function named printArray; this function must take an array of generic elements as a parameter (the exception to this is C++, which takes a vector). The locked Solution class in your editor tests your function.


*/

struct Printer<type> {

	func printArray<T>(arr: [T]) {
		for element in arr {
			print("\(element)")
		}
	}
	
} // End of struct Printer

let vInt = [1, 2, 3]
let vString = ["Hello", "World"]

Printer<Int>().printArray(vInt)
Printer<String>().printArray(vString)