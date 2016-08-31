// day 7: Arrays

// print an array in reverse order

let n = Int(readLine()!)!

let arr = readLine()!.characters.split(" ").map{ Int(String($0))! }

for i in (0..<n).reverse() {
	print("\(arr[i]) ", terminator: "")
}

print()