//
//  GridManager.swift
//  Flat Earth Flat Mars Project
//
//  Created by William Choi on 3/1/18.
//  Copyright © 2018 William Choi. All rights reserved.
//

import Foundation

protocol GridManagerDelegate: class {
    func gridChanged()
}

final class GridManager {
    
    // MARK: - Properties
    weak var gridManagerDelegate: GridManagerDelegate?
    
    private var iteration: Int = 0
    
    fileprivate var grid: Grid
    
    /// One dimensional size of grid
    var gridSize: Int {
        return grid.size
    }
    
    /// Number of all spaces
    var numberOfSpaces: Int {
        return grid.numberOfSpaces
    }
    
    var rovers: [Rover] = []
    
    // MARK: - Methods
    /// Updates grid according to grid rules and then calls delegate's gridChanged function
    func update() {
        for rover in grid.rovers {
            if rover.commands.count > iteration {
                switch rover.commands[iteration] {
                case .L:
                    rover.turnLeft()
                case .R:
                    rover.turnRight()
                case .F:
                    moveRover(rover: rover)
                    break
                }
            }
        }
        iteration += 1
        gridManagerDelegate?.gridChanged()
    }
    
    /// Sets up an empty grid at size x size dimensions
    ///
    /// - Parameter size: length / width of grid
    func setupGrid(size: Int) {
        grid.spaces = Array(repeating: Array(repeating: Space(rover: nil), count: size), count: size)
        iteration = 0
    }
    
    /// Places an array of rovers at their index
    ///
    /// - Parameter rovers: array of rovers
    func placeRovers(rovers: [Rover]) {
        self.rovers = rovers
        for rover in rovers {
            while grid[rover.position]?.rover != nil {
                rover.position = Index.random(gridSize: grid.size)
            }
            grid[rover.position]?.rover = rover
        }
    }
    
    /// returns rover if one is present at index
    ///
    /// - Parameter at: index
    /// - Returns: optional rover
    func rover(at index: Int) -> Rover? {
        return grid[index]?.rover
    }
    
    private func moveRover(rover: Rover) {
        var destination = rover.position
        switch rover.heading {
        case .east:
            let possibleDestination = Index(row: destination.row, column: destination.column + 1)
            if isLegalDestination(position: possibleDestination) {
                destination = possibleDestination
            }
        case .west:
            let possibleDestination = Index(row: destination.row, column: destination.column - 1)
            if isLegalDestination(position: possibleDestination) {
                destination = possibleDestination
            }
        case .north:
            let possibleDestination = Index(row: destination.row - 1, column: destination.column)
            if isLegalDestination(position: possibleDestination) {
                destination = possibleDestination
            }
        case .south:
            let possibleDestination = Index(row: destination.row + 1, column: destination.column)
            if isLegalDestination(position: possibleDestination) {
                destination = possibleDestination
            }
        }
        
        grid[rover.position]?.rover = nil
        rover.position = destination
        grid[destination]?.rover = rover
    }
    
    private func isLegalDestination(position: Index) -> Bool {
        var isLegal = false
        
        if position.column >= 0  && position.column < gridSize && position.row >= 0 && position.row < gridSize && grid[position]?.rover == nil {
            isLegal = true
        }
        return isLegal
    }
    
    // MARK: - Initializers
    
    /// Initializes grid with given size
    ///
    /// - Parameter size: size x size
    init(size: Int) {
        grid = Grid()
        setupGrid(size: size)
    }
}

fileprivate struct Grid {
    var spaces: [[Space]] = [[]]
    
    var rovers: [Rover] {
        return spaces.flatMap { $0.flatMap( { $0.rover }) }
    }
    
    var numberOfSpaces: Int {
        return spaces.count * spaces[0].count
    }
    
    var size: Int {
        return spaces.count
    }
    
    subscript(_ index: Index) -> Space? {
        get {
            guard index.column >= 0 && index.row >= 0 else { return nil }
            if index.column >= size || index.row >= size {
                return nil
            }
            return spaces[index.row][index.column]
        }
        set {
            guard let newValue = newValue else { return }
            spaces[index.row][index.column] = newValue
        }
    }
    
    
    /// subscript function for collection view or table view
    ///
    /// - Parameter index: index in integer format
    subscript(_ index: Int) -> Space? {
        get {
            guard index < numberOfSpaces else { assertionFailure(); return nil }
            let row = index / size
            let column = index % size
            return spaces[row][column]
        }
    }
}
