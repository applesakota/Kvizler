//
//  SettingsTableViewCell.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 5/29/23.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    class var identifier: String { return "SettingsTableViewCell" }
    
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    func setupTheme(with model: SettingsActionModel) {
        imageBackgroundView.backgroundColor = UIColor.clear
        self.logoImageView.image = model.icon
        self.logoImageView.tintColor = AppTheme.current.mainColor
        self.titleLabel.text = model.name
        self.titleLabel.textColor = AppTheme.current.bodyTextColor
    }
}
