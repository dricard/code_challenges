// Day 16: Exceptions - String to Integer

/*
 * Define an ErrorType
 */
enum StringToIntTypecastingError: ErrorType {
	case BadString
}

/*
 * If typecasting is not possible, throw exception, otherwise return the Integer value
 */
func stringToInt(inputString: String) throws -> Int {
	let integerValue = Int(inputString)
	
	guard integerValue != nil else {
		throw StringToIntTypecastingError.BadString
	}
	
	return integerValue!
}


/*
 * Read the input
 */
let inputString = readLine()!

// You can use the do...catch block, it will look similar to following:
 do {
    try print(stringToInt(inputString))
 } catch StringToIntTypecastingError.BadString {
     print("Bad String")
 }
