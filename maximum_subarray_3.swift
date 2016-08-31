// maximum subarray (version 3)

// MARK: - INPUT

let numberOfTestCases = Int(readLine()!)!

var n = [Int]() // array size of each test case
var arr = [[Int]]() // arrays for each test case

for i in 1...numberOfTestCases {
	n.append(Int(readLine()!)!)
	let dataArray: [Int] = readLine()!.characters.split(" ").map{ Int(String($0))! }
	arr.append(dataArray)
}

var nonSum = 0	// this holds the maximum non-contiguous sum

var currentMaxSum = 0 // this holds the max sum of contiguous sequences

var maximumEndingHere = 0	// this holds the current subarray maximum ending at this position

var foundOnePositive = false

// Now we test the sub arrays. For each test we iterate through the index and
// for variable sub array lengths. 
for test in 0..<numberOfTestCases {
	// first we find the maximum non contiguous sum. This is trivial as it's the sum
	// of the positive values in the array.
	foundOnePositive = false
	nonSum = 0	// reset the counter
	for element in arr[test] {
		if element > 0 {
			nonSum += element
			foundOnePositive = true
		}
	}
	// now we check for cases where there are only negative numbers, in this case
	// the nonSum and contiguous sum should be the highest value in the array
	// (least negative)
	if !foundOnePositive {
		// in this case the maximum non-contiguous is the sum of the negatives
		nonSum = arr[test][0]
		for element in arr[test] {
			if element > nonSum {
				nonSum = element
			}
		}
		print("\(nonSum) \(nonSum)")
		
	} else {
	
		// now find the non-contiguous max sum
		currentMaxSum = arr[test][0]	   // reset the counter
		maximumEndingHere = arr[test][0]
		let size = arr[test].count
		for index in 1..<size {
			// now we check for variable lengths of subarray (in odd sizes)
			maximumEndingHere = max(arr[test][index], maximumEndingHere + arr[test][index])
			currentMaxSum = max(currentMaxSum, maximumEndingHere)
		}

		print("\(currentMaxSum) \(nonSum)")
	}
}
