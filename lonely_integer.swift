// Code Challenge: Lonely integer

/*

Consider an array of  integers, , where all but one of the integers occur in pairs. In other words, every element in  occurs exactly twice except for one unique element.

Given , find and print the unique element.

Input Format

The first line contains a single integer, , denoting the number of integers in the array. 
The second line contains  space-separated integers describing the respective values in .

Constraints


It is guaranteed that  is an odd number.
, where .
Output Format

Print the unique number that occurs only once in  on a new line.

*/

// we read the size of the array (guaranteed to be an odd number)
// we don't need that number in Swift
let n = Int(readLine()!)!

// we read the array
let arr = readLine()!.characters.split(" ").map{ Int(String($0))! }

// we create an empty dictionary
var dict = [Int:Int]()

// now for each element in the array we create an dictionay entry
// if it already exist, then we make it nil. This way, each pair
// of integer will cancel each other and we'll be left with only
// the lonely integer
for element in arr {
	if dict[element] == nil {
		dict[element] = element
	} else {
		dict[element] = nil
	}
}

// Print the lonely integer. It's normally the only
// element in the dictionay
for (key, element) in dict {
	print(element)
}