// Note that the *to:* is EXCLUSIVE like 1..<4

for i in 1.stride(to: 4, by: 2) {
	print("i: \(i)")
}

// this prints
// i: 1
// i: 3
print()

for i in 1.stride(to: 3, by: 2) {
	print("i: \(i)")
}

// this prints
// i: 1
