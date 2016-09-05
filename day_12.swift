// Day 12 challenge



// MARK: - Provided Person class

// Class Person
class Person {
	var firstName: String
	var lastName: String
	var id: Int
	
	// Initializer
	init(firstName: String, lastName: String, identification: Int) {
		self.firstName = firstName
		self.lastName = lastName
		self.id = identification
	}
	
	// Print person data
	func printPerson() {
		print("Name: \(self.lastName), \(self.firstName)")
		print("ID: \(self.id)")
	}
} // End of class Person

// MARK: - Response code

// Class Student

class Student: Person {
	var testScores: [Int]
	
	// Write the Student class initializer
	init(firstName: String, lastName: String, identification: Int, scores: [Int]) {
		self.testScores = scores
		super.init(firstName: firstName, lastName: lastName, identification: identification)
	}
	
	
	// Write the calculate method
	func calculate() -> Character {
		var sum = 0
		for score in testScores {
			sum += score
		}
		let average = Double(sum) / Double(testScores.count)
		switch average {
			case 0.0..<40.0:
				return "T"
			case 40.0..<55.0:
				return "D"
			case 55.0..<70.0:
				return "P"
			case 70.0..<80.0:
				return "A"
			case 80.0..<90.0:
				return "E"
			case 90.0...100.0:
				return "O"
			default:
				return " "
		}
	}
	
} // End of class Student




// MARK: - Provided INPUT and OUTPUT code


let nameAndID = readLine()!.characters.split(" ").map{String($0)}
let scoreCount = readLine()
let scores = readLine()!.characters.split(" ").map{Int(String($0))!}

let s = Student(firstName: nameAndID[0], lastName: nameAndID[1], identification: Int(nameAndID[2])!, scores: scores)

s.printPerson()

print("Grade: \(s.calculate())")

