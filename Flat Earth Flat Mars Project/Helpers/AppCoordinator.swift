//
//  AppCoordinator.swift
//  Flat Earth Flat Mars Project
//
//  Created by William Choi on 3/1/18.
//  Copyright © 2018 William Choi. All rights reserved.
//

import UIKit

final class AppCoordinator {
    
    // MARK: - Properties
    private let navController: UINavigationController
    private let gridManager: GridManager
    private let gridVC: GridViewController
    private let gridSettingsVC: GridSettingsViewController
    
    // MARK: - Methods
    /// Starts the app coordinator. In a bigger application, the start method would spawn off child coordinators depending on things like whether the user is authenticated or not. In our case, it first shows the grid view controller then modally presents the grid settings view controller.
    func start() {
        showGridVC()
        showGridSettingsVC(animated: false)
    }
    
    /// Presents the grid settings view controller
    private func showGridSettingsVC(animated: Bool) {
        DispatchQueue.main.async { [unowned self] in
            self.navController.present(self.gridSettingsVC, animated: animated, completion: nil)
        }
    }
    
    private func showGridVC() {
        DispatchQueue.main.async { [unowned self] in
            self.navController.show(self.gridVC, sender: self)
        }
    }
    
    // MARK: - Initializers
    init(with navigationController: UINavigationController, gridManager: GridManager = GridManager(size: 2)) {
        self.navController = navigationController
        self.gridManager = gridManager
        self.gridVC = GridViewController(gridManager: gridManager)
        self.gridSettingsVC = UIStoryboard(name: "GridSettingsStoryboard", bundle: nil).instantiateInitialViewController() as! GridSettingsViewController
        gridVC.gridViewControllerDelegate = self
        gridSettingsVC.gridSettingsVCDelegate = self
        
        let rovers = Rover.generateRandomRovers(number: 4, gridSize: gridManager.gridSize)
        gridManager.placeRovers(rovers: rovers)
    }
}

extension AppCoordinator: GridViewControllerDelegate {
    func settingsButtonClicked() {
        showGridSettingsVC(animated: true)
    }
    
    func updateButtonClicked() {
        gridManager.update()
        gridVC.updateGridCollectionView()
    }

}

extension AppCoordinator: GridSettingsVCDelegate {
    func userClickedCancel() {
        navController.dismiss(animated: true, completion: nil)
    }
    
    func userClickedDone(gridSize: Int) {
        gridManager.setupGrid(size: gridSize)
        gridManager.placeRovers(rovers: Rover.generateRandomRovers(number: 4, gridSize: gridManager.gridSize))
        gridVC.updateGridCollectionView()
        navController.dismiss(animated: true, completion: nil)
    }
}
