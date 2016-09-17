// Day 22: binary search tree height

// Start of Node class
class Node {
	var data: Int
	var left: Node?
	var right: Node?
	
	init(d : Int) {
		data  = d
	}
} // End of Node class

// Start of Tree class
class Tree {
	func insert(root: Node?, data: Int) -> Node? {
		if root == nil {
			return Node(d: data)
		}
		
		if data <= root?.data {
			root?.left = insert(root?.left, data: data)
		} else {
			root?.right = insert(root?.right, data: data)
		}
			
		return root
	}
	
	func getHeight(root: Node?) -> Int {
		let height = -1 	// in cases where there is only the root element, the height will be 0
		
		// check the case where there are no nodes (root == nil)
		// I'd return -1 in this case but the challenge doesn't specify so 0
		guard root != nil else {
			return 0
		}
		
		
		
	}	 // End of getHeight function
} // End of Tree class

var root: Node?
var tree = Tree()

var t = Int(readLine()!)!

while t > 0 {
	root = tree.insert(root, data: Int(readLine()!)!)
	t = t - 1
}

print(tree.getHeight(root))