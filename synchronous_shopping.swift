// synchronous shopping

import Foundation

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

// the edge class

class Road {
	var neighbor: ShoppingCenter
	var time: Int
	
	init() {
		time = 0
		self.neighbor = ShoppingCenter(id: 0)
	}
}


// the path class maintains objects that comprise the frontier

class Path {
	var total: Int!
	var destination: ShoppingCenter
	var previous: Path!
	
	init() {
		destination = ShoppingCenter(id: 0)
	}
}

// create the canvas class to hold the vertices data
class City {
	var centers: [ShoppingCenter]
	var isDirected: Bool
	
	init() {
		centers = [ShoppingCenter]()
		isDirected = false  // in this case roads are two-way, not one-way
	}
	
	func addShoppingCenter(key: Int) -> ShoppingCenter {
		
		let newShoppingCenter: ShoppingCenter = ShoppingCenter(id: key)
		centers.append(newShoppingCenter)
		
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
	city.centers[i-1].fishes = shopingCenterInfo

}

print("number of roads = \(numberOfRoads)")

// read roads information

for i in 1...numberOfRoads {
	// get the road information (shopping center, shopping center, time)
	let roadsInfo = readLine()!.characters.split(" ").map{ Int(String($0))! }
	// add the the road to our city. This creates the road for both shopping
	// centers since it's not a directed graph
	city.addRoad(city.centers[roadsInfo[0]-1], neighbor: city.centers[roadsInfo[1]-1], time: roadsInfo[2])
}

for center in city.centers {
	print("Shoppint center \(center.id)")
	print(center.fishes)
	for road in center.roads {
		print(road.neighbor.id)
	}
}

class PathHeap {
	
	private var heap: [Path]
	
	init() {
		heap = [Path]()
	}
	
	// the number of frontier items
	var count: Int {
		return self.heap.count
	}
	
	// sort the shortest paths into a min-heap
		
	func enQueue(key: Path) {
		
		heap.append(key)
		
		var childIndex: Float = Float(heap.count) - 1
		var parentIndex: Int! = 0
		
		// calculate parent index
		if childIndex != 0 {
			parentIndex = Int(floorf((childIndex - 1) / 2 ))
		}
		
		var childToUse: Path
		var parentToUse: Path
		
		// use the bottom-up approach
		while childIndex != 0 {
			
			childToUse = heap[Int(childIndex)]
			parentToUse = heap[parentIndex]
			
			// swap child and parent position if necessary
			if childToUse.total < parentToUse.total {
				swap(&heap[parentIndex], &heap[Int(childIndex)])
			}
			
			// rest indices
			childIndex = Float(parentIndex)
			
			if childIndex != 0 {
				parentIndex = Int(floorf((childIndex - 1) / 2 ))
			}
		}
		
	}
	
	func deQueue() {
		if heap.count > 0 {
			heap.removeAtIndex(0)
		}
	}

	func peek() -> Path! {
		
		if heap.count > 0 {
			return heap[0]	// return shortest path
		} else {
			return nil
		}
	}

}



// Implement DIJKSTRA algorithm

func findMinimumTime(source: ShoppingCenter, destination: ShoppingCenter) -> Path? {

	let frontier: PathHeap = PathHeap()
	let finalPaths: PathHeap = PathHeap()
	
	// use the source roads to create the frontier
	for road in source.roads {
		
		let newPath: Path = Path()
		
		newPath.destination = road.neighbor
		newPath.previous = nil
		newPath.total = road.time
		
		// add new path to the frontier
		frontier.enQueue(newPath)
	}
	
	
	// construct the best path
	
	var bestPath: Path = Path()
	
	while frontier.count != 0 {
		
		// support changes using greedy approach
		bestPath = Path()
		bestPath = frontier.peek()
		
		//enumerate the bestPath roads
		for road in bestPath.destination.roads {
			
			let newPath: Path = Path()
			
			newPath.destination = road.neighbor
			newPath.previous = bestPath
			newPath.total = bestPath.total + road.time
			
			// add the new path to the frontier
			frontier.enQueue(newPath)
		}
	
		// preserve the bestPaths that match destionation
		if bestPath.destination.id == destination.id {
			finalPaths.enQueue(bestPath)
		}
	
		
		// remove the bestPath from the Frontier
		frontier.deQueue()
		
	} // end of while
	
	// obtain de shortest path from the heap
	var shortestPath: Path! = Path()
	shortestPath = finalPaths.peek()
	
	return shortestPath
}

let p = findMinimumTime(city.centers[0], destination: city.centers[city.centers.count-1])
print("Shortest path is :")
print(p)