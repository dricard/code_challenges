var n = Int(readLine()!)!

var arr: [[Int]] = []

for i in 0..<n {
	arr.append(readLine()!.characters.split(" ").map{ Int(String($0))! })
}

var primary = 0
var secondary = 0

for i in 0..<n {
	primary += arr[i][i]
	secondary += arr[i][n-1-i]
}

print(abs(primary - secondary))
