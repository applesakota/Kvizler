//
//  ScorebardTableViewCell.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 10/14/21.
//

import UIKit

class ScoreboardTableViewCell: UITableViewCell {
    
    class var identifier: String { return "ScoreboardTableViewCell" }
    
    //MARK: - Globals
    
    @IBOutlet weak var medalImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var scoreBackgroundView: UIView!
    @IBOutlet weak var scoreRankLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    //Set theme
    func setTheme(for model: ScoreModel, rank: Int) {
        medalImageView.image = UIImage(named: "coin")
        usernameLabel.text = model.username
        scoreLabel.text = model.scoreAsString
        scoreBackgroundView.layer.cornerRadius = scoreBackgroundView.layer.bounds.width / 2
        scoreBackgroundView.clipsToBounds = true
        scoreRankLabel.text = String(rank)
        containerView.backgroundColor = AppTheme.current.scoreCellBackgroundColor
        containerView.layer.cornerRadius = 10
        scoreBackgroundView.backgroundColor = AppTheme.current.scoreBackgroundColor
    }
}
