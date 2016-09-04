// synchronous shopping

// the edge class

class Road {
	var neighbor: ShoppingCenter
	var time: Int
	
	init() {
		time = 0
		self.neighbor = ShoppingCenter()
	}
}

// the vertex class

class ShoppingCenter {
	var id: Int
	var fishes: [Int]
	var roads: [Road]
	
	init(id: Int) {
		self.id = id
		self.fishes = [Int]()
		self.roads = [Road]()
	}
}

// the path class maintains objects that comprise the frontier

class Path {
	var total: Int!
	var destination: ShoppingCenter
	var previous: Path!
	
	init() {
		destination = ShoppingCenter()
	}
}

// create the canvas class to hold the vertices data
class City {
	var center: [ShoppingCenter]
	var isDirected: Bool
	
	init() {
		center = [ShoppingCenter]()
		isDirected = false  // in this case roads are two-way, not one-way
	}
	
	func addShoppingCenter(key: Int) -> ShoppingCenter {
		
		let newShoppingCenter: ShoppingCenter = ShoppingCenter(key)
		center.append(newShoppingCenter)
		
		return newShoppingCenter
	}
	
	func addRoad(source: ShoppingCenter, neighbor: ShoppingCenter, time: Int) {
		
		let newRoad = Road()
		
		newRoad.neighbor = neighbor
		newRoad.time = time
		source.roads.append(newRoad)
		
		// if not isDirected than roads are two-way
		if !isDirected {
			
			// create the reverse connection
			let reverseRoad = Road()
			
			reverseRoad.neighbor = source
			reverseRoad.time = time
			
			neighbor.roads.append(reverseRoad)
		}
	}
}


// MARK: - INPUTS

// The first line returns the number of vertices (shopping centers), 
// the number of edges (roads) and the number of fishes

let params = readLine()!.characters.split(" ").map{ Int( String( $0 ) )! }

let numberOfShopingCenters = params[0]

let numberOfRoads = params[1]

let numberOfFishes = params[2]

// Now we create our city object which will hold the shopping centers and roads
// information which we'll add as we read the data

var city = City()

// add the number of shopping centers to our city
//  and read fishes sold at each shopping center information

for i in 1...numberOfShopingCenters {
	
	// create a shopping center object
	city.addShoppingCenter(i)

	// get the number of fishes sold here and the list of fishes
	var shopingCenterInfo = readLine()!.characters.split(" ").map{ Int(String($0))! }
	// remove the number of fishes (1st number), keep only the list of fishes sold
	let numOfFishesHere = shopingCenterInfo.removeAtIndex(0)
	// add this to an array so we'll be able to build our shoppingCenter object
	city.center[i].fishes = shopingCenterInfo

}

print("number of roads = \(numberOfRoads)")

// read roads information

for i in 1...numberOfRoads {
	print("i = \(i)")
	// get the road information (shopping center, shopping center, time)
	let roadsInfo = readLine()!.characters.split(" ").map{ Int(String($0))! }
	// add the the road to our city. This creates the road for both shopping
	// centers since it's not a directed graph
	city.addRoad(city.center[roadsInfo[0]], neighbor: city.center[roadsInfo[1]], time: city.center[roadsInfo[2]])
}

print(center)