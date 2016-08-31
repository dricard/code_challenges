let n = Int(readLine()!)!

for step in 0..<n {
	var space = ""
	for i in 1..<(n-step) {
		space += " "
	}
	var steps = ""
	for i in 0...step {
		steps += "#"
	}
	print(space+steps)
}