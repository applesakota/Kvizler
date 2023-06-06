//
//  PersonaliseCollectionViewCell.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 5/31/23.
//

import UIKit

class PersonaliseCollectionViewCell: UICollectionViewCell {
    //MARK: - Globals
    
    class var identifier: String { return "PersonaliseCollectionViewCell" }
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonBackgroundView: UIView!
    @IBOutlet weak var selectedButton: UIButton!
    
    func setupTheme(for model: HomeViewModel) {
        self.containerView.backgroundColor = model.color
        self.imageContainerView.backgroundColor = model.color
        self.buttonBackgroundView.backgroundColor = AppTheme.current.containerColor
        self.imageView.image = model.image
        self.layer.cornerRadius = 10
    }
    
    func setSelectedCell(isSelected: Bool) {
        self.selectedButton.isSelected = isSelected
    }
    
    func setUnselectedCell(isSelected: Bool) {
        self.selectedButton.isSelected = isSelected
    }
}

