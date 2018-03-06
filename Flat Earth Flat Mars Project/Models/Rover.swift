//
//  Rover.swift
//  Flat Earth Flat Mars Project
//
//  Created by William Choi on 3/1/18.
//  Copyright © 2018 William Choi. All rights reserved.
//

import Foundation

final class Rover {
    var position: Index
    var heading: Direction
    var commands: [Command]
    
    func turnLeft() {
        heading.turnLeft()
    }
    
    func turnRight() {
        heading.turnRight()
    }
    
    /// Initializes a rover
    ///
    /// - Parameters:
    ///   - position: initial position guess
    ///   - heading: heading of rover
    ///   - commands: array of commands
    init(position: Index, heading: Direction = Direction.random(), commands: [Command] = Command.generateRandom(length: 500)) {
        self.position = position
        self.heading = heading
        self.commands = commands
    }
    
    func generateRandomCommands(length: Int) {
        self.commands = Command.generateRandom(length: length)
    }
    
    /// Generates a number of rovers given a grid size
    ///
    /// - Parameters:
    ///   - number: number of rovers to be created
    ///   - gridSize: one dimensional grid size
    /// - Returns: an array of rovers
    static func generateRandomRovers(number: Int, gridSize: Int) -> [Rover] {
        var rovers: [Rover] = []
        for _ in 0 ..< number {
            // Initial position. Grid manager will ensure no two rovers are placed in the same spot
            let position = Index.random(gridSize: gridSize)
            
            rovers.append(Rover(position: position))
        }
        return rovers
    }
}

enum Command: Int {
    case L
    case R
    case F
}

extension Command {
    static func generateRandom(length: Int) -> [Command] {
        var commands: [Command] = []
        for _ in 0 ..< length {
            commands.append(Command.generateRandom())
        }
        return commands
    }
    
    static func generateRandom() -> Command {
        let randValue = arc4random_uniform(3)
        return Command(rawValue: Int(randValue))!
    }
}

enum Direction: Int {
    case north
    case east
    case south
    case west
    
    static func random() -> Direction {
        let randVal = arc4random_uniform(4)
        let direction = Direction(rawValue: Int(randVal))
        
        return direction!
    }
    
    mutating func turnLeft() {
        var val = self.rawValue - 1
        if val == -1 {
            val = 3
        }
        self = Direction(rawValue: val)!
    }
    
    mutating func turnRight() {
        var val = self.rawValue + 1
        if val == 4 {
            val = 0
        }
        self = Direction(rawValue: val)!
    }
}
