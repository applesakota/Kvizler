//
//  LengthScoreboardViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 10/14/21.
//

import UIKit

class LengthScoreboardViewController: UIViewController {
    
    //MARK: - Globals
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbarContainerView: UIView!
    
    @IBOutlet weak var duzinaButton: UIButton!
    @IBOutlet weak var kategorijaButton: UIButton!
    @IBOutlet weak var tezinaButton: UIButton!
    
    class var identifier: String { return "LengthScoreboardViewController" }
    
    let scoreboard: [ScoreModel] = []
    
    //MARK: - Init
    class func instantiate() -> CategoryScoreboardViewController {
        let viewController = UIStoryboard.main.instantiate(identifier) as! CategoryScoreboardViewController
        return viewController
    }
    
    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareThemeAndLocalization()
    }
    
    //MARK: - Utils
    
    func prepareThemeAndLocalization() {
        
        duzinaButton.tintColor = AppTheme.current.primary
        duzinaButton.setTitleColor(AppTheme.current.primary, for: .normal)
        duzinaButton.backgroundColor = UIColor.clear
        (duzinaButton.superview as? UIStackView)?.arrangedSubviews.last?.backgroundColor = AppTheme.current.primary

        kategorijaButton.tintColor = AppTheme.current.blackColor
        kategorijaButton.setTitleColor(AppTheme.current.blackColor, for: .normal)
        kategorijaButton.backgroundColor = UIColor.clear
        (kategorijaButton.superview as? UIStackView)?.arrangedSubviews.last?.backgroundColor = UIColor.clear
        
        tezinaButton.tintColor = AppTheme.current.blackColor
        tezinaButton.setTitleColor(AppTheme.current.blackColor, for: .normal)
        tezinaButton.backgroundColor = UIColor.clear
        (tezinaButton.superview as? UIStackView)?.arrangedSubviews.last?.backgroundColor = UIColor.clear
    }
    
    
    //MARK: - User Interaction
    
    @IBAction func kategorijaButton_onClick(_ sender: Any) {
        
        
    }
    
    
    @IBAction func tezinaButton_onClick(_ sender: Any) {
        
    }
    
    //MARK: - API
    
    
    func getLengthScoreboard(_ callback: @escaping ([ScoreModel]) -> Swift.Void) {
        let loaderView = LoaderView.create(for: self.view, config: AppGlobals.defaultLoadConfig)
        
//        AppGlobals.herokuRESTManager.getScoreboard(userId: <#T##String#>, categoryId: <#T##String#>, <#T##callback: (Result<([ScoreModel]), Error>) -> Void##(Result<([ScoreModel]), Error>) -> Void#>)
    }
    
    
}
