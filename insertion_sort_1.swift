// insertion sort part 1: sort last entry in an otherwise sorted array

// read the array size

let n = Int(readLine()!)!

// read the array

var arr = readLine()!.characters.split(" ").map{ Int(String($0))! }

// keep the value to be inserted at the right position in the array

let v = arr[n-1]

// convinience method to print out the array in the expected format

func printArray(arr: [Int]) {
	var output = ""
	for element in arr {
		output += "\(element) "
	}
	print(output)
}

// insertion method

var i = n-1

while i >= 1 && v < arr[i-1] {
	arr[i] = arr[i-1]
	i -= 1
	printArray(arr)
}

arr[i] = v
printArray(arr)

