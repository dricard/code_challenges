// Day 22B: binary search tree height

// this is another implementation which is simpler as it stores the tree
// in an array

import Foundation

class Tree<D> {
	
	var root: Node<D>
	
	init(root: D) {
		self.root = root
	}
	
	func rightChildIndex(of parent: Int) -> Int {
		return parent * 2 + 1
	}
	
	func leftChildIndex(of parent: Int) -> Int {
		return parent * 2
	}
	
	func parentIndex(of child: Int) -> Int {
		return Int(floor(Double(child)))
	}
	
	func add(child: D) {
		
	}
}