// day 3 challenge: total meal cost

import Foundation

let mealCost = Double(readLine()!)!

let tipPercent = Int(readLine()!)!

let taxPercent = Int(readLine()!)!

let tip = Double(tipPercent) / 100.0 * mealCost

let tax = Double(taxPercent) / 100.0 * mealCost

let totalCost = Int(round(mealCost + tip + tax))

print("The total meal cost is \(totalCost) dollars.")