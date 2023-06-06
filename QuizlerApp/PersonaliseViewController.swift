//
//  PersonaliseViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 5/30/23.
//

import UIKit

class PersonaliseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    //MARK: - Globals
    class var identifier: String { "PersonaliseViewController" }
    
    @IBOutlet weak var navigationBackgroundView: UIView!
    @IBOutlet weak var personalizeHomeContinerView: UIView!
    @IBOutlet weak var personalizeQuizContinerView: UIView!
    
    @IBOutlet weak var personalizeHomeTitleLabel: UILabel!
    @IBOutlet weak var personalizeHomeCollectionView: UICollectionView!
    
    @IBOutlet weak var navigationBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var personalizeQuizTitleLabel: UILabel!
    @IBOutlet weak var personalizeQuizCollectionView: UICollectionView!
    
    private(set) var dataSource: [PersonalizeViewModel] = []
    private(set) var selectedHomePath: HomeViewModel? {
        didSet { DispatchQueue.main.async { self.updateUI() } }
    }
    private(set) var selectedHomeIndexPath: IndexPath?
    
    private(set) var selectedQuizPath: IndexPath?
    private(set) var selectedQuizModel: HomeViewModel? {
        didSet { DispatchQueue.main.async { self.updateUI() } }
    }
    
    private var homeDataSource: [HomeViewModel] = [
        HomeViewModel(name: "Green", image: UIImage(named: "green")!, color: AppTheme.current.mainColor),
        HomeViewModel(name: "Purple", image: UIImage(named: "purpleHome")!, color: AppTheme.current.purpleBackgroundColor),
        HomeViewModel(name: "Grey", image: UIImage(named: "grey")!, color: AppTheme.current.scoreboardTableViewBackgroundColor),
        HomeViewModel(name: "Yellow", image: UIImage(named: "yellowHome")!, color: AppTheme.current.yellowBackgroundColor),
        HomeViewModel(name: "Pink", image: UIImage(named: "pinkHome")!, color: AppTheme.current.categoryViewBackgroundColor)
    ]
    
    private var quizlerDataSource: [HomeViewModel] = [
        HomeViewModel(name: "Green", image: UIImage(named: "kvizlerContainer")!, color: AppTheme.current.containerColor),
        HomeViewModel(name: "PurpleKviz", image: UIImage(named: "purpleKviz")!, color: AppTheme.current.purpleBackgroundColor),
        HomeViewModel(name: "Grey", image: UIImage(named: "kvizlerLight")!, color: AppTheme.current.scoreboardTableViewBackgroundColor),
        HomeViewModel(name: "YellowKviz", image: UIImage(named: "yellowKviz")!, color: AppTheme.current.yellowBackgroundColor),
        HomeViewModel(name: "Pink", image: UIImage(named: "pinkKviz")!, color: AppTheme.current.categoryViewBackgroundColor)
    ]
    
    class func instantiate() -> PersonaliseViewController {
        let viewController = UIStoryboard.main.instantiate(identifier) as! PersonaliseViewController
        return viewController
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUI()
        
        self.personalizeHomeCollectionView.dataSource = self
        self.personalizeHomeCollectionView.delegate = self
        
        self.personalizeQuizCollectionView.dataSource = self
        self.personalizeQuizCollectionView.delegate = self
                
        let nib = UINib(nibName: PersonaliseCollectionViewCell.identifier, bundle: nil)
        personalizeQuizCollectionView.register(nib, forCellWithReuseIdentifier: PersonaliseCollectionViewCell.identifier)
        personalizeHomeCollectionView.register(nib, forCellWithReuseIdentifier: PersonaliseCollectionViewCell.identifier)
        
        self.navigationBarButtonItem.tintColor = AppTheme.current.mainColor
        
        self.prepareNavigationBarTheme()
        self.prepareThemeAndLocalization()
    }
    
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
        self.view.backgroundColor = AppTheme.current.scoreboardTableViewBackgroundColor
        self.personalizeHomeContinerView.layer.cornerRadius = 10
        self.personalizeHomeContinerView.backgroundColor = AppTheme.current.white
        
        self.personalizeQuizContinerView.layer.cornerRadius = 10
        self.personalizeQuizContinerView.backgroundColor = AppTheme.current.white
        
        self.personalizeHomeTitleLabel.textColor = AppTheme.current.bodyTextColor
        self.personalizeQuizTitleLabel.textColor = AppTheme.current.bodyTextColor
        
        
    }
    
    
    private func updateUI() {
        if isValidInput() {
            self.navigationBarButtonItem.tintColor = AppTheme.current.mainColor
            self.navigationBarButtonItem.isEnabled = true
        } else {
            self.navigationBarButtonItem.tintColor = AppTheme.current.mainColor.withAlphaComponent(0.5)
            self.navigationBarButtonItem.isEnabled = false
        }
    }
        
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == personalizeHomeCollectionView {
            return homeDataSource.count
        } else {
            return quizlerDataSource.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == personalizeHomeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonaliseCollectionViewCell.identifier, for: indexPath) as? PersonaliseCollectionViewCell else { return UICollectionViewCell() }
            cell.setupTheme(for: homeDataSource[indexPath.row])
            return cell
        } else if collectionView == personalizeQuizCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonaliseCollectionViewCell.identifier, for: indexPath) as? PersonaliseCollectionViewCell else { return UICollectionViewCell() }
            cell.setupTheme(for: quizlerDataSource[indexPath.row])
            return cell
        }
//        cell.setupTheme()
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        if collectionView == personalizeHomeCollectionView {
            
            if let cell = collectionView.cellForItem(at: indexPath) as? PersonaliseCollectionViewCell {
                if selectedHomeIndexPath == indexPath {
                    selectedHomeIndexPath = nil
                    selectedHomePath = nil
                    cell.setUnselectedCell(isSelected: false)
                } else {
                    cell.setSelectedCell(isSelected: true)
                    selectedHomePath = homeDataSource[indexPath.item]
                    selectedHomeIndexPath = indexPath
                }
            }
            
        } else {
            
            if let cell = collectionView.cellForItem(at: indexPath) as? PersonaliseCollectionViewCell {
                if selectedQuizPath == indexPath {
                    selectedQuizPath = nil
                    selectedQuizModel = nil
                    cell.setUnselectedCell(isSelected: false)
                } else {
                    cell.setSelectedCell(isSelected: true)
                    selectedQuizModel = quizlerDataSource[indexPath.item]
                    selectedQuizPath = indexPath
                }
            }
            
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == personalizeHomeCollectionView {
            if let cell = collectionView.cellForItem(at: indexPath) as? PersonaliseCollectionViewCell {
                cell.setUnselectedCell(isSelected: false)
                selectedHomePath = nil
                selectedHomeIndexPath = nil
            }
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as? PersonaliseCollectionViewCell {
                cell.setUnselectedCell(isSelected: false)
                selectedQuizModel = nil
                selectedQuizPath = nil
            }
        }
    }
    

    func isValidInput() -> Bool {
        let flag1 = selectedHomePath  != nil ? true : false
        let flag2 = selectedQuizModel != nil ? true : false
        
        return flag1 || flag2
    }
    
    @IBAction func navigationBarButtonItemTouched(_ sender: Any) {
        if isValidInput() {
            if let selectedHomePath = selectedHomePath,
               let selectedHomeColorData = try? NSKeyedArchiver.archivedData(withRootObject: selectedHomePath.color, requiringSecureCoding: false) {
                AppGlobals.standardLocalStorage.save(codable: selectedHomeColorData, key: "SELECTED_HOME_COLOR")
                
            } else {
                print("error saving color")
            }
            
            if let selectedQuizModel = selectedQuizModel,
               let selectedQuizColorData = try? NSKeyedArchiver.archivedData(withRootObject: selectedQuizModel.color, requiringSecureCoding: false) {
                AppGlobals.standardLocalStorage.save(codable: selectedQuizColorData, key: "SELECTED_QUIZ_COLOR")
            } else {
                print("error saving quiz color")
            }
            
            
            
            self.navigationController?.popViewController(animated: true)
        }
        
        
        
    }
    
}
