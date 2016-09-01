// synchronous shopping

class ShoppingCenter {
	var id: Int
	var fishes: [Int]
	var roads: [(Int, Int)] // (roadTo, time)
	
	init(id: Int, fishes: [Int], roads: [(Int, Int)]) {
		self.id = id
		self.fishes = fishes
		self.roads = roads
	}
}

// MARK: - INPUTS

let params = readLine()!.characters.split(" ").map{ Int( String( $0 ) )! }

let numberOfShopingCenters = params[0]

let numberOfRoads = params[1]

let numberOfFishes = params[2]

var fishByShopingCenter = [[Int]]()

var roadsInformation = [[(Int, Int)]]() // an array (1...numberOfShoppingCenter) of (roadTo, time) tuples

var center = [ShoppingCenter]()

// Read fishes sold information

for i in 1...numberOfShopingCenters {
	
	// get the number of fishes sold here and the list of fishes
	var shopingCenterInfo = readLine()!.characters.split(" ").map{ Int(String($0))! }
	// remove the number of fishes, keep only the list of fishes sold
	let numOfFishesHere = shopingCenterInfo.removeAtIndex(0)
	// add this to an array so we'll be able to build our shoppingCenter object
	fishByShopingCenter.append(shopingCenterInfo)
	// Create the array of roads information for that shopping center
	roadsInformation.append([(Int, Int)]())
}

print("number of roads = \(numberOfRoads)")
// read roads information

for i in 1...numberOfRoads {
	print("i = \(i)")
	// get the road information (shopping center, shopping center, time)
	let roadsInfo = readLine()!.characters.split(" ").map{ Int(String($0))! }
	// add the tuple to the roadsInformation array for the first shopping center
	roadsInformation[roadsInfo[0]].append((roadsInfo[1], roadsInfo[2]))
	// and the reciprocal for the second
	roadsInformation[roadsInfo[1]].append((roadsInfo[0], roadsInfo[2]))

}

// Now build the shopping centers objects

for i in 1...numberOfShopingCenters {
	
	center[i] = ShoppingCenter(id: i, fishes: fishByShopingCenter[i], roads: roadsInformation[i])
	
}

print(center)