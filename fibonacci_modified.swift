// Fibonacci modified

import Foundation

let parameters = readLine()!.characters.split(" ").map{ Int(String($0))! }

let t0: Double = Double(parameters[0])
let t1: Double = Double(parameters[1])

var sequence: [Double] = [ t0, t1 ]

let n = parameters[2]

for i in 2..<n {
	print(i)
	let term = sequence[ i-2 ] + sequence[ i-1 ] * sequence[ i-1 ]
	sequence.append(term)
}

print("\(sequence[n-1])")
