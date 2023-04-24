//
//  LengthScoreboardViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 10/14/21.
//

import UIKit

protocol LengthScoreboardViewControllerDelegate: AnyObject {
    func lengthScoreboardViewController(_ viewController: LengthScoreboardViewController, didSelect subMode: SubMode?)
}

class LengthScoreboardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    //MARK: - Globals
    
    @IBOutlet weak var toolbarContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var duzinaButton: UIButton!
    @IBOutlet weak var kategorijaButton: UIButton!
    @IBOutlet weak var tezinaButton: UIButton!
    
    class var identifier: String { return "LengthScoreboardViewController" }
    
    weak var delegate: LengthScoreboardViewControllerDelegate?
    
    private(set) var submodes: [SubMode] = []
    private(set) var rawSubModes: [SubMode] = []
    
    struct LocalizationStrings {
        static let duzinaButtonText = "length_screen_duzina_button_text".localized()
        static let kategorijaButtonText = "length_screen_kategorija_button_text".localized()
        static let tezinaButtonText = "length_screen_tezina_button_text".localized()
    }
    
    //MARK: - Init
    class func instantiate(submodes: [SubMode]) -> LengthScoreboardViewController {
        let viewController = UIStoryboard.main.instantiate(identifier) as! LengthScoreboardViewController
        viewController.submodes = submodes
        return viewController
    }
    
    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareThemeAndLocalization()
    }
    
    //MARK: - Utils
    
    func prepareThemeAndLocalization() {
        
        self.toolbarContainerView.backgroundColor = AppTheme.current.secondPlaceColor
        
        self.duzinaButton.setTitle(LocalizationStrings.duzinaButtonText, for: .normal)
        self.kategorijaButton.setTitle(LocalizationStrings.kategorijaButtonText, for: .normal)
        self.tezinaButton.setTitle(LocalizationStrings.tezinaButtonText, for: .normal)
        
        onUnselectButton(duzinaButton)
        onUnselectButton(kategorijaButton)
        onUnselectButton(tezinaButton)
        
        self.prepareAndReloadCollectionViewDataSource()
    }
    
    func onSelectButton(_ button: UIButton) {
        button.tintColor = AppTheme.current.cellColor
        button.setTitleColor(AppTheme.current.cellColor, for: .normal)
        button.backgroundColor = UIColor.clear
        (button.superview as? UIStackView)?.arrangedSubviews.last?.backgroundColor = AppTheme.current.cellColor
    }
    
    func onUnselectButton(_ button: UIButton) {
        button.tintColor = AppTheme.current.blackColor
        button.setTitleColor(AppTheme.current.blackColor, for: .normal)
        button.backgroundColor = UIColor.clear
        (button.superview as? UIStackView)?.arrangedSubviews.last?.backgroundColor = UIColor.clear
    }
    
    
    //MARK: - User Interaction
    
    @IBAction func kategorijaButton_onClick(_ sender: UIButton) {
        // Check is selected
        sender.isSelected = !sender.isSelected
        // Update button dressing
        sender.isSelected ? onSelectButton(sender) : onUnselectButton(sender)
        // Prepare data
        self.prepareAndReloadCollectionViewDataSource()
        
    }
    @IBAction func tezinaButton_onClick(_ sender: UIButton) {
        // Check is selected
        sender.isSelected = !sender.isSelected
        // Update button dressing
        sender.isSelected ? onSelectButton(sender) : onUnselectButton(sender)
        // Prepare data
        self.prepareAndReloadCollectionViewDataSource()
    }
    
    @IBAction func duzinaButton_onClick(_ sender: UIButton) {
        // Check is selected
        sender.isSelected = !sender.isSelected
        // Update button dressing
        sender.isSelected ? onSelectButton(sender) : onUnselectButton(sender)
        // Prepare data
        self.prepareAndReloadCollectionViewDataSource()
    }
    
    // Prepare data
    func prepareAndReloadCollectionViewDataSource() {
        self.rawSubModes = self.prepareCategoryDataSource(submodes)
        self.collectionView.isHidden = self.rawSubModes.isEmpty
        self.collectionView.reloadData()
    }
    
    func prepareCategoryDataSource(_ dataSource: [SubMode]) -> [SubMode] {
        // Array of submodes
        var result: [SubMode] = []
        
        if showAll {
            result = submodes
        } else {
            //Check is tezina is selected
            if tezinaButton.isSelected {
                result.append(contentsOf: dataSource.filter({
                    $0.name.localized() == "Lako" || $0.name.localized() == "Srednje" || $0.name.localized() == "Teško"
                }))
            }
            //Check is lategorija is selected
            if kategorijaButton.isSelected {
                result.append(contentsOf: dataSource.filter({
                    $0.name.localized() == "Sport" || $0.name.localized() == "Muzika" || $0.name.localized() == "Istorija" || $0.name.localized() == "Geografija" || $0.name.localized() == "Film" || $0.name.localized() == "Opšte znanje"
                }))
            }
            
            //Check is duzina is selected
            if duzinaButton.isSelected {
                result.append(contentsOf: dataSource.filter({
                    $0.name.localized() == "Zen" || $0.name.localized() == "Test" || $0.name.localized() == "Maraton"
                }))
            }
        }
        
        return result
    }
    
    private var showAll: Bool {
        let flag1 = kategorijaButton.isSelected && tezinaButton.isSelected && duzinaButton.isSelected
        let flag2 = !kategorijaButton.isSelected && !tezinaButton.isSelected && !duzinaButton.isSelected
        return flag1 || flag2
    }
    
    
    //MARK: - API
        
    //MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rawSubModes.count
    }
            
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubModeCollectionViewCell.identifier, for: indexPath) as? SubModeCollectionViewCell {
            cell.setTheme(with: rawSubModes[indexPath.item])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fullWidth = (collectionView.bounds.width - 32) / 3.0
        let fullHeight = fullWidth
        
        return CGSize(width: fullWidth, height: fullHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSubMode = rawSubModes[indexPath.item]
        saveSelectedMode(selectedSubMode: selectedSubMode)
    }
    
    private func saveSelectedMode(selectedSubMode: SubMode) {
        delegate?.lengthScoreboardViewController(self, didSelect: selectedSubMode)
        self.dismiss(animated: true)
    }
    
}

//MARK: - UICollectionViewCell

class SubModeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var subModeImageView: UIImageView!
    @IBOutlet weak var subModeTitleLabel: UILabel!
    
    class var identifier: String { return "SubModeCollectionViewCell" }
    
    func setTheme(with model: SubMode) {
        self.backgroundColor = AppTheme.current.cellColor.withAlphaComponent(0.5)
        self.subModeImageView.alpha = 0.5
        self.layer.cornerRadius = self.layer.bounds.width / 2
        self.subModeImageView.image = UIImage(named: model.name)
        self.subModeTitleLabel.text = model.name.localized()
    }
}
