// Day 14: scope


class Difference {
	private var elements = [Int]()
	var maximumDifference : Int!
	
	init(a: [Int]) {
		self.elements = a
	}
	
	func computeDifference() {
		var max = -1
		for i in 0..<elements.count-2 {
			for j in i+1...elements.count-1 {
				let diff = abs(elements[i]-elements[j])
				if diff > max { max = diff }
			}
		}
		maximumDifference = max
	}
	
} // End of Difference class

	let n = Int(readLine()!)!
	let a = readLine()!.characters.split(" ").map(String.init).map{Int($0)!}

	let d = Difference(a: a)

	d.computeDifference()

	print(d.maximumDifference)