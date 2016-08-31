// Day 08: Phone a friend - Dictionaries and maps

// MARK: - INPUT

// read number of entries in phone book

let n = Int(readLine()!)!

// read phone book entries

var phoneBook = [String:String]()

var count = 1

while count <= n {
	let data: String? = readLine()
	if let data = data {
		let entry = data.characters.split(" ").map{ String($0) }
		phoneBook[entry[0]] = entry[1]
		count += 1
	} else {
		break
	}
}

// MARK: - read queries and output answers

var queries = [String]()
var stillGettingQueries = true

// read queries until empty query (carriage return)

repeat {
	let query = readLine()
    if let query = query {
		if let phone = phoneBook[query] {
			print("\(query)=\(phone)")
		} else {
			print("Not found")
		}
	} else {
		stillGettingQueries = false
	}
} while stillGettingQueries

