//
//  ScoreboardViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 2/17/23.
//

import UIKit

class ScoreboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: - Globals
    
    class var identifier: String { "ScoreboardViewController" }
    
    @IBOutlet weak var navigationBackgroundView: UIView!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var scoreboardBackgroundView: UIView!
    
    @IBOutlet weak var thirdPlaceLabel: UILabel!
    @IBOutlet weak var thirdPlaceBackgroundView: UIView!
    @IBOutlet weak var thirdScoreBackgroundView: UIView!
    @IBOutlet weak var thirdScoreLabel: UILabel!
    
    @IBOutlet weak var secondPlaceLabel: UILabel!
    @IBOutlet weak var secondPlaceBackgroundView: UIView!
    @IBOutlet weak var secondScoreBackgroundView: UIView!
    @IBOutlet weak var secondScoreLabel: UILabel!
    @IBOutlet weak var noInternetConectionContainerView: UIView!
    @IBOutlet weak var noInternetConeectionView: UIView!
    
    @IBOutlet weak var firstPlaceLabel: UILabel!
    @IBOutlet weak var firstPlaceBackgroundView: UIView!
    @IBOutlet weak var firstScoreBackgroundView: UIView!
    @IBOutlet weak var firstScoreLabel: UILabel!
    
    var pickerViewDataSource: [SubMode] = []
    var scores: [ScoreModel] = []
    var scoresRawDataSource: [ScoreModel] = []
    
    var pickerView: UIPickerView? {
        return categoryTextField.inputView as? UIPickerView
    }
    
    private(set) var selectedSubMode: SubMode? {
        didSet { DispatchQueue.main.async {
            self.updateUIOnStateChange()
            self.tableView.reloadData()
        }}
    }
    
    
    
    //MARK: - Init
    
    class func instantiate() -> ScoreboardViewController {
        let viewController = UIStoryboard.main.instantiate(identifier) as! ScoreboardViewController
        viewController.tabBarItem = UITabBarItem(title: "Tabela", image: #imageLiteral(resourceName: "table"), selectedImage: #imageLiteral(resourceName: "table"))
        return viewController
    }
    
    class func instantiateWithNavigation() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: instantiate())
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.backgroundColor = UIColor.clear
        return navigationController
    }
    
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
                self.setupPickerView()
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
        self.navigationController?.navigationBar.tintColor = AppTheme.current.blackColor
        self.navigationController?.navigationBar.barTintColor = AppTheme.current.secondPlaceColor
        self.navigationController?.navigationBar.titleTextAttributes = [
            .font: AppTheme.semiboldFont(ofSize: 17)
        ]
        self.navigationBackgroundView.backgroundColor = AppTheme.current.secondPlaceColor
        
    }
    
    func prepareThemeAndLocalization() {
        self.categoryTextField.backgroundColor = AppTheme.current.cellColor
        self.categoryTextField.textColor = AppTheme.current.white
        self.categoryTextField.layer.cornerRadius = 30
        
        self.thirdPlaceLabel.text = ""
        self.thirdPlaceLabel.superview?.layer.cornerRadius = 10
        self.thirdPlaceLabel.superview?.backgroundColor = AppTheme.current.thirdPlaceColor
        self.thirdPlaceBackgroundView.backgroundColor = AppTheme.current.thirdPlaceColor
        self.thirdScoreBackgroundView.backgroundColor = AppTheme.current.thirdScoreBackgroundColor
        self.thirdScoreBackgroundView.layer.cornerRadius = 10
        self.thirdScoreLabel.text = ""
        
        self.secondPlaceLabel.text = ""
        self.secondPlaceLabel.superview?.layer.cornerRadius = 10
        self.secondPlaceLabel.superview?.backgroundColor = AppTheme.current.secondPlaceColor
        self.secondPlaceBackgroundView.backgroundColor = AppTheme.current.secondPlaceColor
        self.secondScoreBackgroundView.backgroundColor = AppTheme.current.secondScoreBackgroundColor
        self.secondScoreBackgroundView.layer.cornerRadius = 10
        self.secondScoreLabel.text = ""
        
        self.firstPlaceLabel.text = ""
        self.firstPlaceLabel.superview?.layer.cornerRadius = 10
        self.firstPlaceLabel.superview?.backgroundColor = AppTheme.current.firstPlaceColor
        self.firstPlaceBackgroundView.backgroundColor = AppTheme.current.firstPlaceColor
        self.firstScoreBackgroundView.backgroundColor = AppTheme.current.firstScoreBackgroundColor
        self.firstScoreBackgroundView.layer.cornerRadius = 10
        self.firstScoreLabel.text = ""
        self.noInternetConectionContainerView.layer.cornerRadius = 10
    }
    
    private func updateUIOnStateChange() {
        if selectedSubMode != nil {
            let scores = fetchScores()
            if scores.count >= 3 {
                self.categoryTextField.backgroundColor = AppTheme.current.cellColor
                self.categoryTextField.textColor = AppTheme.current.white
                self.categoryTextField.layer.cornerRadius = 30
                
                self.thirdPlaceLabel.text = scores[2].username
                self.thirdPlaceLabel.superview?.layer.cornerRadius = 10
                self.thirdPlaceLabel.superview?.backgroundColor = AppTheme.current.thirdPlaceColor
                self.thirdPlaceBackgroundView.backgroundColor = AppTheme.current.thirdPlaceColor
                self.thirdScoreBackgroundView.backgroundColor = AppTheme.current.thirdScoreBackgroundColor
                self.thirdScoreBackgroundView.layer.cornerRadius = 10
                self.thirdScoreLabel.text = String("\(scores[2].score)")
                
                self.secondPlaceLabel.text = scores[1].username
                self.secondPlaceLabel.superview?.layer.cornerRadius = 10
                self.secondPlaceLabel.superview?.backgroundColor = AppTheme.current.secondPlaceColor
                self.secondPlaceBackgroundView.backgroundColor = AppTheme.current.secondPlaceColor
                self.secondScoreBackgroundView.backgroundColor = AppTheme.current.secondScoreBackgroundColor
                self.secondScoreBackgroundView.layer.cornerRadius = 10
                self.secondScoreLabel.text = String("\(scores[1].score)")
                
                self.firstPlaceLabel.text = scores[0].username
                self.firstPlaceLabel.superview?.layer.cornerRadius = 10
                self.firstPlaceLabel.superview?.backgroundColor = AppTheme.current.firstPlaceColor
                self.firstPlaceBackgroundView.backgroundColor = AppTheme.current.firstPlaceColor
                self.firstScoreBackgroundView.backgroundColor = AppTheme.current.firstScoreBackgroundColor
                self.firstScoreBackgroundView.layer.cornerRadius = 10
                self.firstScoreLabel.text = String("\(scores[0].score)")
            }
        }
        
    }
    
    //MARK: - UIPickerViewDelegate and UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewDataSource.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewDataSource[row].name.localized()
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let submode = pickerViewDataSource[row]
        categoryTextField.text = submode.name.localized()
        selectedSubMode = submode
    }
    
    private func setupPickerView() {
        let categoryPicker = UIPickerView()
        categoryTextField.inputView = categoryPicker
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryTextField.text = selectedSubMode?.name.localized()
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ScoreboardTableViewCell.identifier, for: indexPath) as? ScoreboardTableViewCell else {
                return UITableViewCell()
            }
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
    
    
    //MARK: - User Interaction
    
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


