let data = [5, 4, 7, 12]

let sum = data.reduce(0, combine: {(x, y) in x + y} )

print(sum)