// day 09: recursion

// MARK: - INPUT

let x = Int(readLine()!)!

// MARK: - recursive function

func factorial(n: Int) -> Int {
	if n <= 1 {
		return 1
	} else {
		return n * factorial(n-1)
	}
}

print(factorial(x))