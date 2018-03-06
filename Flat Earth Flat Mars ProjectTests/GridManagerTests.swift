//
//  GridManagerTests.swift
//  Flat Earth Flat Mars ProjectTests
//
//  Created by William Choi on 3/2/18.
//  Copyright © 2018 William Choi. All rights reserved.
//

import XCTest
@testable import Flat_Earth_Flat_Mars_Project

class GridManagerTests: XCTestCase {
    
    var rovers: [Rover] = []
    var gridManager: GridManager!
    
    override func setUp() {
        super.setUp()
        let command1: [Command] = [.R, .F, .F, .F, .F, .F, .R, .F]
        rovers.append(Rover(position: Index(row: 0, column: 0), heading: Direction.east, commands: command1))
        gridManager = GridManager(size: 4)
    }
    
    override func tearDown() {
        rovers = []
        gridManager = nil
        super.tearDown()
    }
    
    func testRover() {
        gridManager.placeRovers(rovers: rovers)
        
        XCTAssert(gridManager.rovers.count == 1)
        
//        XCTAssert(gridManager.grid[rovers[0].position]?.rover != nil)
        
        XCTAssert(gridManager.rovers[0].heading == .east)
        
        gridManager.update()
        
        XCTAssert(gridManager.rovers[0].heading == .south)
        
        gridManager.update()
        gridManager.update()
        gridManager.update()
        gridManager.update()
        gridManager.update()
        gridManager.update()
        gridManager.update()
        
        XCTAssert(gridManager.rovers[0].position == Index(row: 3, column: 0))
    }
    
    func testGridProperties() {
        XCTAssert(gridManager.gridSize == 4)
        
        gridManager.setupGrid(size: 5)
        
        XCTAssert(gridManager.gridSize == 5)
    }
    
    func testHeading() {
        var heading = Direction.north
        
        XCTAssert(heading.rawValue == 0)
        
        heading.turnLeft()
        
        XCTAssert(heading == .west)
        
        heading.turnRight()
        
        XCTAssert(heading != .east)
        XCTAssert(heading == .north)
        
        var heading2 = Direction.east
        
        XCTAssert(heading2.rawValue == 1)
        
        heading2.turnRight()
        
        XCTAssert(heading2.rawValue == 2)
        
        heading2.turnRight()
        
        XCTAssert(heading2.rawValue == 3)
        
        heading2.turnLeft()
        
        XCTAssert(heading2.rawValue == 2)
    }
}

