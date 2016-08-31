// day 4 challenge: Class vs Instance

import Foundation

class Person {
	var age: Int = 0

	init (initialAge: Int) {
		// Add some more code to run some checks on initialAge  
		if initialAge < 0 {
			print("Age is not valid, setting age to 0.")
			self.age = 0
		}  else {
			self.age = initialAge
		}
	}

	func amIOld () {
		// Do some computations in here and print out the correct statement to the console
		switch self.age {
			case 0...12:
				print("You are young.")
			case 13...17:
				print("You are a teenager.")
			default:
				print("You are old.")
		}
	}

	func yearPasses() {
		// Increment the age of the person in here
		self.age += 1
	}
}

var t = Int(readLine(stripNewline: true)!)!

while t > 0 {
	let age = Int(readLine(stripNewline: true)!)!
	var p = Person(initialAge: age)
	p.amIOld()

	for i in 1 ... 3 {
		p.yearPasses()
	}

	p.amIOld()
	print("")
	
	t = t - 1 // decrement t
}