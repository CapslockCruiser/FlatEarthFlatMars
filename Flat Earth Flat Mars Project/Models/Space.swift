//
//  Space.swift
//  Flat Earth Flat Mars Project
//
//  Created by William Choi on 3/1/18.
//  Copyright © 2018 William Choi. All rights reserved.
//

import Foundation

struct Space {
    // If a space in a grid has another feature like an "Obstacle" object, this struct will hold a reference to that, but for now, the only thing that can "occupy" a space is a rover.
    weak var rover: Rover?
}

struct Index: Equatable {
    var row: Int
    var column: Int
    
    static func == (lhs: Index, rhs: Index) -> Bool {
        if lhs.column == rhs.column && lhs.row == rhs.row {
            return true
        }
        return false
    }
    
    /// Creates a random index given size of grid
    ///
    /// - Parameter gridSize: one dimensional size of grid
    /// - Returns: random index that fits within grid
    static func random(gridSize: Int) -> Index {
        let row = Int(arc4random_uniform(UInt32(gridSize)))
        let column = Int(arc4random_uniform(UInt32(gridSize)))
        
        return Index(row: row, column: column)
    }
}
