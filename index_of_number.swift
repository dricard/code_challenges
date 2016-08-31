// assumes a sorted array: find the index of the input number

let v = Int(readLine()!)!	// number to find in array. assumed to be present, and only once

let n = Int(readLine()!)!	// size of the array

let ar = readLine()!.characters.split(" ").map{ Int(String($0))! }

// Since the array is sorted we'll use a binary search

var min = 0
var max = n
var mid = n / 2

while ar[mid] != v {
	if v < ar[mid] {
		max = mid
	} else {
		min = mid
	}
	mid = (max + min) / 2
}
print(mid)
