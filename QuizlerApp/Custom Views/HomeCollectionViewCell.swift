//
//  HomeCollectionViewCell.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 2/13/23.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Global
    
    class var identifier: String { return "HomeCollectionViewCell" }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var iconImageView: UIView!
    @IBOutlet weak var numberOfQuestionsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func setTheme(with model: SubMode) {
        self.backgroundColor = AppTheme.current.collectionViewBackground
        self.layer.cornerRadius = 10
        self.iconImageView.layer.cornerRadius = 10
        self.iconImageView.tintColor = AppTheme.current.mainColor
        self.titleLabel.text = model.name
        self.imageView.image = UIImage(named: model.name)
        self.titleLabel.text = model.name.localized()
        self.titleLabel.textColor = AppTheme.current.textColor
        self.numberOfQuestionsLabel.text = "\(model.numberOfQuestions) pitanja"
        self.numberOfQuestionsLabel.textColor = AppTheme.current.textColor
    }
    
    
    func addShadow() {
        self.contentView.layer.cornerRadius = 40
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
