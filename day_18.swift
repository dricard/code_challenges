// Day 18: queues and stacks (palindrome)

/*

To solve this challenge, we must first take each character in , enqueue it in a queue, and also push that same character onto a stack. Once that's done, we must dequeue the first character from the queue and pop the top character off the stack, then compare the two characters to see if they are the same; as long as the characters match, we continue dequeueing, popping, and comparing each character until our containers are empty (a non-match means  isn't a palindrome).

Write the following declarations and implementations:

Two instance variables: one for your stack, and one for your queue.
A void pushCharacter(char ch) method that pushes a character onto a stack.
A void enqueueCharacter(char ch) method that enqueues a character in the  instance variable.
A char popCharacter() method that pops and returns the character at the top of the  instance variable.
A char dequeueCharacter() method that dequeues and returns the first character in the  instance variable.

*/

class Solution {

	var stack = [Character]()
	var queue = [Character]()
	
	func pushCharacter(ch: Character) {
		stack.append(ch)
	}
	
	func enqueueCharacter(ch: Character) {
		queue.append(ch)
	}
	
	func popCharacter() -> Character {
		let c = stack.removeAtIndex(0)
		return c
	}
	
	func dequeueCharacter() -> Character {
		let c = queue.removeLast()
		return c
	}
	
}

// read the string s.
let s = readLine()!

// create the Solution class object p.
let obj = Solution()

// push/enqueue all the characters of string s to stack.
for c in s.characters {
	obj.pushCharacter(c)
	obj.enqueueCharacter(c)
}

var isPalindrome = true

// pop the top character from stack.
// dequeue the first character from queue.
// compare both the characters.
for (var i = 0; i < s.characters.count / 2; i++) {
	if obj.popCharacter() != obj.dequeueCharacter() {
		isPalindrome = false
		
		break
	}
}

// finally print whether string s is palindrome or not.
if isPalindrome {
	print("The word, \(s), is a palindrome.")
} else {
	print("The word, \(s), is not a palindrome.")
}

