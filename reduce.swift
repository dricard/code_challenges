// These are some examples of the use of reduce

let data = [5, 4, 7, 12]

let sum = data.reduce(0, combine: {(x, y) in x + y} )

print(sum)

let names = [ "James", "Tim", "John" ]
let count = names.reduce(0) { $0 + $1.characters.count }
print(count)
