//
//  DifficultyScoreboardViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 10/14/21.
//

import UIKit

class DifficultyScoreboardViewController: UIViewController {
    
    //MARK: - Globals
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbarContainerView: UIView!
    
    @IBOutlet weak var duzinaButton: UIButton!
    @IBOutlet weak var kategorijaButton: UIButton!
    @IBOutlet weak var tezinaButton: UIButton!
    
    class var identifier: String { return "DifficultyScoreboardViewController" }
    
    
    //MARK: - Init
    class func instantiate() -> DifficultyScoreboardViewController {
        let viewController = UIStoryboard.main.instantiate(identifier) as! DifficultyScoreboardViewController
        return viewController
    }
    
    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

}
