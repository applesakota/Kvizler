//
//  ScoreboardViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 10/2/21.
//

import UIKit

class CategoryScoreboardViewController: UIViewController {
    
    //MARK: - Globals
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbarContainerView: UIView!
    
    @IBOutlet weak var duzinaButton: UIButton!
    @IBOutlet weak var kategorijaButton: UIButton!
    @IBOutlet weak var tezinaButton: UIButton!
    
    class var identifier: String { return "CategoryScoreboardViewController" }

    //MARK: - Init
    
    class func instantiate() -> CategoryScoreboardViewController {
        let viewController = UIStoryboard.main.instantiate(identifier) as! CategoryScoreboardViewController
        return viewController
    }
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}


