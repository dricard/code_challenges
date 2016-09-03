// Day 11: 2D array

// Calculate the hourglass sum for every hourglass in a 6 x 6 2D array, then print the maximum hourglass sum.
// An hourglass is:
//	a b c
//	  d
//	e f g

// MARK: - INPUT

var matrix = [[Int]]()

for i in 0...5 {
	let row = readLine()!.characters.split(" ").map{ Int(String($0))! }
	matrix.append(row)
}

// MARK: - Utility

// Given the coordinate of the element 'a' in an hourglass,
// return the hourglass sum. i is column, j is row
func sumHourGlass(i: Int, j: Int) -> Int {
	var sum = 0
	for x in i...i+2 {
		sum += matrix[j][x]
		sum += matrix[j+2][x]
	}
	sum += matrix[j+1][i+1]
	return sum
}

// MARK: - SOLUTION

// Now we scan the matrix for hourglasses. There are 16 in total.
// we scan from the 'a' element in the hourglass.

// values are -9 <= A[i][j] <= 9 so the minimum possible sum is -63 (7 x -9)
var maxSum = -64

for i in 0...3 {
	for j in 0...3 {
		let hourglassSum = sumHourGlass(i, j: j)
		if hourglassSum > maxSum {
			maxSum = hourglassSum
		}
	}
}

print(maxSum)