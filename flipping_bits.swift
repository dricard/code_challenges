// Flipping bits

/* 

You will be given a list of 32 bits unsigned integers. You are required to output the list of the unsigned integers you get by flipping bits in its binary representation (i.e. unset bits must be set, and set bits must be unset).

*/

let n = Int(readLine()!)!

for i in 1...n {
	let number: UInt32 = UInt32(readLine()!)!
	// to flip the bits we use the bitwise NOT operator ~
	let flipped = ~number
	print(flipped)
}