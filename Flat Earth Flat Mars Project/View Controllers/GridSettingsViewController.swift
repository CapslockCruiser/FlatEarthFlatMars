//
//  GridSettingsViewController.swift
//  Flat Earth Flat Mars Project
//
//  Created by William Choi on 3/1/18.
//  Copyright © 2018 William Choi. All rights reserved.
//

import UIKit

protocol GridSettingsVCDelegate: class {
    func userClickedDone(gridSize: Int)
    func userClickedCancel()
}

final class GridSettingsViewController: UIViewController {
    
    // MARK: - UI elements
    @IBOutlet weak var gridSizeLabel: UILabel!
    
    @IBAction func decreaseSizeButtonClicked(_ sender: UIButton) {
        decreaseGridSize()
    }
    
    @IBAction func increaseSizeButtonClicked(_ sender: UIButton) {
        increaseGridSize()
    }
    
    @IBAction func createButtonClicked(_ sender: UIButton) {
        gridSettingsVCDelegate?.userClickedDone(gridSize: gridSize)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        gridSettingsVCDelegate?.userClickedCancel()
    }
    
    // MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setGridSizeLabel()
    }
    
    // MARK: - Properties
    private var gridSize = 4 {
        didSet {
            setGridSizeLabel()
        }
    }
    weak var gridSettingsVCDelegate: GridSettingsVCDelegate?
    
    // MARK: - Methods
    private func setGridSizeLabel() {
        gridSizeLabel.text = "\(gridSize) x \(gridSize)"
    }
    
    private func increaseGridSize() {
        if gridSize < 10 {
            gridSize += 1
        }
    }
    
    private func decreaseGridSize() {
        if gridSize > 2 {
            gridSize -= 1
        }
    }
    
}
