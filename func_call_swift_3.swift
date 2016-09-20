// testing out things in Swift 3

// So we can do it this way
func doStuff(name: String, age: Int) -> String {
	return "Hello \(name), you are \(age) years old"
}
// and then we need to explicitly put the variable name in the funciton call
print(doStuff(name: "Denis", age: 51))


// Or we can do it this way
func doSomeOtherStuff(_ name: String, age: Int) -> String {
	return "Hello \(name), you are \(age) years old"
}
// and then we don't need to explicitly put the variable name in the funciton call
print(doSomeOtherStuff("Denis", age: 51))

// so in converting to Swift 3, it's easier to use the second method