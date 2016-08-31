//
//  main.swift
//  EightQueens
//
//  Created by Denis Ricard on 2015-06-12.
//  Copyright (c) 2015 Denis Ricard. All rights reserved.
//

import Foundation

var solutionsFound = 0
var positionsTested = 0

class Queen {

	var row: Int
	var colomn: Int
	
	init(forRow: Int) {
		row = forRow
		colomn = 0
	}
}

// create eight Queen objects for each row of the checkboard
let myQueens = (0...7).map{ Queen(forRow: $0) }

func isSafe(currentRow : Int, currentColumn : Int) -> Bool {
	positionsTested += 1
	
	// we iterate on all queens in *previous* rows
	for previousRow in 0..<currentRow {
		// check vertical : are we trying to place a queen at the same column as a previous queen?
		if myQueens[previousRow].colomn == currentColumn {
			return false
		}
		
		// check diagonal : is there a queen in one of the two diagonals from this position?
		let differenceInRow = currentRow - previousRow
		let differenceInColumn = currentColumn - myQueens[previousRow].colomn
		if (differenceInRow == differenceInColumn) || (differenceInRow == -differenceInColumn) {
			return false
		}
	}
	// it's safe! we set the location of the queen at that location
	myQueens[currentRow].colomn = currentColumn
	return true
}

func moveQueenAcrossRow( row : Int) {
	for column in 0...7 {
		// move the queen column by column, checking if it's safe
		if isSafe(row, currentColumn: column) {
			// if we placed the 8th queen we've found a solution
			if row == 7 {
				solutionsFound += 1
				printAnswer()
			} else {
				// recursive call -- move the queen on the next row
				moveQueenAcrossRow(row+1)
			}
		 }
	}
}

func printAnswer() {
	print("Solution number: \(solutionsFound).")
	print()
	
	for currentRow in (0...7).reverse() {
		// print row number with chess numbering (1-8)
		print(currentRow+1, terminator:"")
		for currentColumn in 0...7 {
			if myQueens[currentRow].colomn == currentColumn {
				print(" Q ", terminator:"")
			} else {
				print(" - ", terminator:"")
			}
		}
		print()
	}
	print("  A  B  C  D  E  F  G  H")
	print()
}

moveQueenAcrossRow(0)
print("Positions tested: \(positionsTested)")