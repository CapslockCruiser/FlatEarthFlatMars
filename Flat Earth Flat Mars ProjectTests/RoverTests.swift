//
//  RoverTests.swift
//  Flat Earth Flat Mars ProjectTests
//
//  Created by William Choi on 3/4/18.
//  Copyright © 2018 William Choi. All rights reserved.
//

import XCTest
@testable import Flat_Earth_Flat_Mars_Project

class RoverTests: XCTestCase {
    
    func testRoverCommands() {
        let rover = Rover.generateRandomRovers(number: 1, gridSize: 2)[0]
        
        rover.generateRandomCommands(length: 16)
        
        XCTAssert(rover.commands.count == 16)
    }
    
    func testRoverGeneration() {
        let number = 4
        let gridSize = 4
        let rovers = Rover.generateRandomRovers(number: number, gridSize: gridSize)
        
        XCTAssert(rovers.count == 4)
        
        for i in 0..<number {
            XCTAssert(rovers[i].position.column < gridSize && rovers[i].position.row < gridSize)
        }
    }
    
}
