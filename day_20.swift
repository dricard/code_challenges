// Day 20: sorting

/*

Task 
Given an array, a, of size n containing distinct elements , sort array a[0], a[1], ..., a[n-1] in ascending order using the Bubble Sort algorithm above. Once sorted, print the following 3 lines:

 Array is sorted in numSwaps swaps.
where numSwaps is the number of swaps that took place.
 First Element: firstElement
where firstElement is the first element in the sorted array.
 Last Element: lastElement
where lastElement is the last element in the sorted array.


*/

var numSwaps = 0

func bubbleSort(arr: [Int]) -> [Int] {
	
	// mutated copy
	var output = arr
	
	for primaryIndex in 0..<arr.count {
		let passes = (output.count - 1) - primaryIndex
		
		for secondaryIndex in 0..<passes {
			let key = output[secondaryIndex]
			if key > output[secondaryIndex + 1] {
				swap(&output[secondaryIndex], &output[secondaryIndex + 1])
				numSwaps += 1
			}
		}
	}
	return output
}

let n = Int(readLine()!)!
let a = readLine()!.characters.split(" ").map{ Int(String($0))! }

let sorted = bubbleSort(a)

print("Array is sorted in \(numSwaps) swaps.")
print("First Element: \(sorted.first!)")
print("Last Element: \(sorted.last!)")