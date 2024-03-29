//
//  ScoreboardViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 2/17/23.
//

import UIKit

class ScoreboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Globals
    
    class var identifier: String { "ScoreboardViewController" }
    
    @IBOutlet weak var navigationBackgroundView: UIView!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topBackgroundView: UIView!
    
    @IBOutlet weak var categoryBackgroundImageView: UIImageView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryStackView: UIStackView!
    
    @IBOutlet weak var scoreboardBackgroundView: UIView!
    
    @IBOutlet weak var thirdPlaceLabel: UILabel!
    @IBOutlet weak var thirdScoreLabel: UILabel!
    @IBOutlet weak var thirdScoreBackgroundView: UIView!
    
    @IBOutlet weak var secondPlaceLabel: UILabel!
    @IBOutlet weak var secondScoreLabel: UILabel!
    @IBOutlet weak var secondScoreBackgroundView: UIView!
    
    @IBOutlet weak var noInternetConectionContainerView: UIView!
    @IBOutlet weak var noInternetConeectionView: UIView!
    
    @IBOutlet weak var firstPlaceLabel: UILabel!
    @IBOutlet weak var firstScoreLabel: UILabel!
    @IBOutlet weak var firstPlaceBackgroundView: UIView!
    
    var pickerViewDataSource: [SubMode] = []
    var scores: [ScoreModel] = []
    var scoresRawDataSource: [ScoreModel] = []
        
    private(set) var selectedSubMode: SubMode? {
        didSet { DispatchQueue.main.async {
            self.updateUIOnStateChange()
        }}
    }
    
    struct LocalizationStrings {
        static let tabelaText = "scoreboard_screen_tabela_text".localized()
    }
    
    //MARK: - Init
    
    class func instantiate(selectedSubMode: SubMode?) -> ScoreboardViewController {
        let viewController = UIStoryboard.main.instantiate(identifier) as! ScoreboardViewController
        if selectedSubMode != nil {
            viewController.selectedSubMode = selectedSubMode
        }
        viewController.tabBarItem = UITabBarItem(title: LocalizationStrings.tabelaText, image: #imageLiteral(resourceName: "table"), selectedImage: #imageLiteral(resourceName: "table"))
        return viewController
    }
    
    class func instantiateWithNavigation() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: instantiate(selectedSubMode: nil))
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.backgroundColor = UIColor.clear
        return navigationController
    }
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.prepareThemeAndLocalization()
        self.prepareNavigationBarTheme()
        
        self.apiFetchSubmodes { [weak self] submodes in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.pickerViewDataSource = submodes
                self.selectedSubMode = self.pickerViewDataSource.first
            }
        }
        
        self.apiFetchScores { [weak self] scores in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.scores = scores
                self.updateUIOnStateChange()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork {
            self.noInternetConeectionView.isHidden = true
        } else {
            self.noInternetConeectionView.isHidden = false
            self.noInternetConeectionView.backgroundColor = AppTheme.current.backgroundColor.withAlphaComponent(0.3)
        }
    }
    
    
    //MARK: - Utils
    
    func prepareNavigationBarTheme() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.tintColor = AppTheme.current.textColor
        self.navigationController?.navigationBar.barTintColor = AppTheme.current.containerColor
        self.navigationController?.navigationBar.titleTextAttributes = [
            .font: AppTheme.semiboldFont(ofSize: 17),
            .foregroundColor: AppTheme.current.textColor
        ]
        self.navigationBackgroundView.backgroundColor = AppTheme.current.containerColor
        
    }
    
    func prepareThemeAndLocalization() {
        
        self.categoryTextField.backgroundColor = UIColor.clear
        self.categoryTextField.textColor = AppTheme.current.categoryViewTextColor
        self.categoryTextField.isUserInteractionEnabled = false
        self.categoryTextField.borderStyle = .none
        self.categoryView.layer.cornerRadius = 10
        self.categoryView.layer.borderWidth = 1
        self.categoryView.layer.masksToBounds = true
        self.categoryView.layer.borderColor = AppTheme.current.categoryViewTextColor.cgColor
        self.categoryStackView.backgroundColor = AppTheme.current.categoryViewBackgroundColor
        self.categoryImageView.tintColor = AppTheme.current.categoryViewTextColor
        
        self.categoryBackgroundImageView.layer.masksToBounds = true
        self.view.backgroundColor = AppTheme.current.scoreboardTableViewBackgroundColor
        self.topBackgroundView.backgroundColor = AppTheme.current.mainColor
        
        self.scoreboardBackgroundView.layer.cornerRadius = 10
        self.scoreboardBackgroundView.layer.masksToBounds = true
        
        self.thirdPlaceLabel.text = ""
        self.thirdPlaceLabel.superview?.layer.cornerRadius = 10
        self.thirdPlaceLabel.superview?.backgroundColor = .clear
        self.thirdScoreLabel.text = ""
        self.thirdScoreBackgroundView.layer.cornerRadius = 10
        self.thirdScoreBackgroundView.backgroundColor = AppTheme.current.mainColor
        
        self.secondPlaceLabel.text = ""
        self.secondPlaceLabel.superview?.layer.cornerRadius = 10
        self.secondPlaceLabel.superview?.backgroundColor = .clear
        self.secondScoreLabel.text = ""
        self.secondScoreBackgroundView.layer.cornerRadius = 10
        self.secondScoreBackgroundView.backgroundColor = AppTheme.current.mainColor
        
        self.firstPlaceLabel.text = ""
        self.firstPlaceLabel.superview?.layer.cornerRadius = 10
        self.firstPlaceLabel.superview?.backgroundColor = .clear
        self.firstScoreLabel.text = ""
        self.firstPlaceBackgroundView.layer.cornerRadius = 10
        self.firstPlaceBackgroundView.backgroundColor = AppTheme.current.mainColor
        self.noInternetConectionContainerView.layer.cornerRadius = 10
    }
    
    private func updateUIOnStateChange() {
        if selectedSubMode != nil {
            let scores = fetchScores()
            if scores.count >= 3 {
                self.categoryTextField.backgroundColor = UIColor.clear
                self.categoryTextField.textColor = AppTheme.current.categoryViewTextColor
                self.categoryTextField.text = selectedSubMode?.name.localized()
                self.categoryTextField.borderStyle = .none
                self.categoryView.layer.cornerRadius = 10
                self.categoryView.layer.borderWidth = 1
                self.categoryView.layer.borderColor = AppTheme.current.categoryViewTextColor.cgColor
                self.categoryView.layer.masksToBounds = true
                self.categoryImageView.image = UIImage(named: selectedSubMode!.name)!
                self.categoryImageView.tintColor = AppTheme.current.categoryViewTextColor
                self.categoryBackgroundImageView.layer.masksToBounds = true
                
                self.thirdPlaceLabel.text = scores[2].username
                self.thirdPlaceLabel.superview?.layer.cornerRadius = 10
                self.thirdPlaceLabel.superview?.backgroundColor = .clear
                self.thirdScoreLabel.text = String("\(scores[2].score)")
                self.thirdScoreLabel.textColor = UIColor.white
                self.thirdScoreBackgroundView.layer.cornerRadius = 10
                self.thirdScoreBackgroundView.backgroundColor = AppTheme.current.mainColor
                
                self.secondPlaceLabel.text = scores[1].username
                self.secondPlaceLabel.superview?.layer.cornerRadius = 10
                self.secondPlaceLabel.superview?.backgroundColor = .clear
                self.secondScoreLabel.text = String("\(scores[1].score)")
                self.secondScoreLabel.textColor = UIColor.white
                self.secondScoreBackgroundView.layer.cornerRadius = 10
                self.secondScoreBackgroundView.backgroundColor = AppTheme.current.mainColor
                
                self.firstPlaceLabel.text = scores[0].username
                self.firstPlaceLabel.superview?.layer.cornerRadius = 10
                self.firstPlaceLabel.superview?.backgroundColor = .clear
                self.firstScoreLabel.text = String("\(scores[1].score)")
                self.firstScoreLabel.textColor = UIColor.white
                self.firstPlaceBackgroundView.layer.cornerRadius = 10
                self.firstPlaceBackgroundView.backgroundColor = AppTheme.current.mainColor
            }
        }
        //Reload data
        self.tableView.reloadData()
    }
    
    //MARK: - UITableViewDelegate and UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoresRawDataSource.isEmpty ? 1 : scoresRawDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if scoresRawDataSource.count == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Prazna tabela"
            cell.textLabel?.font = AppTheme.regularFont(ofSize: 14)
            cell.backgroundColor = AppTheme.current.scoreCellBackgroundColor
            cell.textLabel?.textAlignment = .center
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ScoreboardTableViewCell.identifier, for: indexPath) as? ScoreboardTableViewCell else { return UITableViewCell() }
            cell.setTheme(for: scoresRawDataSource[indexPath.row], rank: indexPath.row + 4)
            return cell
        }
    }
    
    //MARK: - API
    
    func apiFetchScores(_ callback: @escaping ([ScoreModel])->Swift.Void) {
        let loader = LoaderView.create(for: self.view, config: AppGlobals.defaultLoadConfig)
        AppGlobals.herokuRESTManager.getScores { (result) in
            loader.dismiss()
            switch result {
            case .success(let scores): callback(scores)
            case .failure: break
            }
        }
    }
    
    func apiFetchSubmodes(_ callback: @escaping ([SubMode]) -> Swift.Void) {
        let loader = LoaderView.create(for: self.view, config: AppGlobals.defaultLoadConfig)
        AppGlobals.herokuRESTManager.getModes { (result) in
            loader.dismiss()
            switch result {
            case .success(let categories):
                var submodes: [SubMode] = []
                for category in categories {
                    submodes.append(contentsOf: category.submodes)
                }
                callback(submodes)
            case .failure: break
            }
        }
    }
    
    func fetchScores() -> [ScoreModel] {
        let newScores = scores.filter { model in
            model.mode == selectedSubMode?.id
        }
        let sorted = newScores.sorted(by: {$0.score > $1.score })
        if sorted.count > 3 {
            self.scoresRawDataSource = Array(sorted.dropFirst(3))
        } else {
            self.scoresRawDataSource = []
        }
        return sorted
    }
    

    private func presentLengthScoreboardViewController() {
        let viewController = LengthScoreboardViewController.instantiate(submodes: pickerViewDataSource)
        viewController.delegate = self
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewController.modalPresentationStyle = .automatic
        } else {
            viewController.modalPresentationStyle = .popover
        }
        DispatchQueue.main.async {
            self.present(viewController, animated: false)
        }
    }
    
    //MARK: - DataSources / Delegates
    //MARK: - User Interaction
    
    @IBAction func categoryButtonTapped(_ sender: Any) {
        self.presentLengthScoreboardViewController()
        
    }
    @IBAction func refreshButtonOnClick(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork {
            
            self.apiFetchScores { [weak self] scores in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.scores = scores
                    self.updateUIOnStateChange()
                }
            }
            self.noInternetConeectionView.isHidden = true
        } else {
            self.noInternetConeectionView.isHidden = false
        }
    }
}

extension ScoreboardViewController: LengthScoreboardViewControllerDelegate {
    
    func lengthScoreboardViewController(_ viewController: LengthScoreboardViewController, didSelect subMode: SubMode?) {
        self.selectedSubMode = subMode
        self.updateUIOnStateChange()
        
    }
}
