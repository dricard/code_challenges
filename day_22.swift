// Day 22: binary search tree height

// Start of Node class
class Node<D: Comparable> {
	var data: D
	var left: Node?
	var right: Node?
	
	init(d : D) {
		data  = d
	}
} // End of Node class

// Start of Tree class
class Tree<D: Comparable> {
	func insert(root: Node<D>?, data: D) -> Node<D>? {
		if root == nil {
			return Node(d: data)
		}
		
		if data <= root!.data {
			root!.left = insert(root: root!.left, data: data)
		} else {
			root!.right = insert(root: root!.right, data: data)
		}
			
		return root
	}
	
	func getHeight(root: Node<D>?) -> Int {
		var height = -1 	// in cases where there is only the root element, the height will be 0
		
		// check the case where there are no nodes (root == nil)
		// I'd return -1 in this case but the challenge doesn't specify so 0
		guard root != nil else {
			return 0
		}
		
		func checkChildren(root: Node<D>?) -> Int {
			
			guard let root = root else {
				return 0
			}
			if root.left == nil && root.right == nil {
				return 0
			} else {
				if root.left != nil {
					return 1 + checkChildren(root: root.left)
				} else {
					return 1 + checkChildren(root: root.right)
				}
			}
		}
				
		height = checkChildren(root: root)
		
		return height
		
	}	 // End of getHeight function
} // End of Tree class


var t = Int(readLine()!)!

let rootData = Int(readLine()!)!

var root = Node(d: rootData)
t = t - 1

var tree = Tree<Int>()

while t > 0 {
	root = tree.insert(root: root, data: Int(readLine()!)!)!
	t = t - 1
}

print(tree.getHeight(root: root))