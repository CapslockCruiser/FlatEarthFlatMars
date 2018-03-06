//
//  GridViewController.swift
//  Flat Earth Flat Mars Project
//
//  Created by William Choi on 3/1/18.
//  Copyright © 2018 William Choi. All rights reserved.
//

import UIKit

protocol GridViewControllerDelegate: class {
    func settingsButtonClicked()
    func updateButtonClicked()
}

final class GridViewController: UIViewController {
    
    // MARK: - UI elements
    lazy private var gridCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let minimumSpacing: CGFloat = 8
        layout.minimumInteritemSpacing = minimumSpacing
        let dim = view.frame.width / CGFloat(gridManager.gridSize) - minimumSpacing
        layout.itemSize = CGSize(width: dim, height: dim)
        let cv = UICollectionView(frame: CGRect() , collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        cv.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: gridCellReuseID)
        
        return cv
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Grid Settings", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(settingsButtonClicked), for: .touchUpInside)
        
        return button
    }()
    
    private let updateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Update", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(updateButtonClicked), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func settingsButtonClicked() {
        gridViewControllerDelegate?.settingsButtonClicked()
    }
    
    @objc private func updateButtonClicked() {
        gridViewControllerDelegate?.updateButtonClicked()
    }
    
    // MARK: - Properties
    private let gridManager: GridManager
    private let gridCellReuseID = "GridCellReuseID"
    weak var gridViewControllerDelegate: GridViewControllerDelegate?
    
    // MARK: - Methods
    
    /// Updates grid collection view after grid is updated
    func updateGridCollectionView() {
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                let layout = UICollectionViewFlowLayout()
                let minimumSpacing: CGFloat = 8
                layout.minimumInteritemSpacing = minimumSpacing
                layout.minimumLineSpacing = minimumSpacing
                let dim = strongSelf.view.frame.width / CGFloat(strongSelf.gridManager.gridSize) - minimumSpacing
                layout.itemSize = CGSize(width: dim, height: dim)
                strongSelf.gridCollectionView.reloadData()
                strongSelf.gridCollectionView.collectionViewLayout.invalidateLayout()
                strongSelf.gridCollectionView.setCollectionViewLayout(layout, animated: false)
            }
        }
    }
    
    private func setupGridCV() {
        view.addSubview(gridCollectionView)
        NSLayoutConstraint.activate([
            NSLayoutConstraint.init(item: gridCollectionView, attribute: .height, relatedBy: .equal, toItem: gridCollectionView, attribute: .width, multiplier: 1, constant: 0),
                gridCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                gridCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                gridCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            ])
    }
    
    private func setupUpdateButton() {
        view.addSubview(updateButton)
        updateButton.topAnchor.constraint(equalTo: gridCollectionView.bottomAnchor, constant: 8).isActive = true
        updateButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    private func setupSettingsButton() {
        view.addSubview(settingsButton)
        settingsButton.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 8).isActive = true
        settingsButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    // MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupGridCV()
        setupUpdateButton()
        setupSettingsButton()
    }
    
    // MARK: - Initializer
    init(gridManager: GridManager = GridManager(size: 4)) {
        self.gridManager = gridManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Collection view extension
extension GridViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridManager.numberOfSpaces
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cvCell = gridCollectionView.dequeueReusableCell(withReuseIdentifier: gridCellReuseID, for: indexPath) as? GridCollectionViewCell else { assertionFailure(); return UICollectionViewCell() }
        cvCell.backgroundColor = UIColor.brown
        
        var label = ""
        
        if let rover = gridManager.rover(at: indexPath.row) {
            switch rover.heading {
            case .east:
                label = "➡"
            case .north:
                label = "⬆"
            case .west:
                label = "⬅"
            case .south:
                label = "⬇"
            }

        }
        cvCell.graphicLabel.text = label
        
        return cvCell
    }
    
}

final class GridCollectionViewCell: UICollectionViewCell {
    
    let graphicLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private func addGraphicLabel() {
        contentView.addSubview(graphicLabel)
        
        graphicLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        graphicLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        graphicLabel.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGraphicLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
