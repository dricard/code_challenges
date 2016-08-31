// read parameters

let params = readLine()!.characters.split(" ").map{ Int(String($0))! }
let n = params[0]
var k = params[1]
let q = params[2]

// handle cases where k is ≥ n (rotating n times gives the same array)

if k >= n {
	k = k % n
}

// handle cases where k > n / 2 (it's then faster to rotate left instead of right)

let rotateRight = k < n / 2

// read array

var arr = readLine()!.characters.split(" ").map{ Int(String($0))! }

// apply circular rotation
if k > 0 {
	if rotateRight {
		for i in 1...k {
			arr.insert(arr.removeAtIndex(n-1), atIndex: 0)
		}
	} else {
		k = n - k
		for i in (1...k).reverse() {
			arr.insert(arr.removeAtIndex(0), atIndex: n-1)
		}
	}
}

// perform queries and build answer array at the same time

var answers = [Int]()

for query in 1...q {
	let m = Int(readLine()!)!
	// assume m is valid as per problem statement, otherwise check here
	answers.append(arr[m])
}

// print answers to queries

for answer in answers {
	print(answer)
}