//
//  SplashViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/8/21.
//

import UIKit

class SplashViewController: UIViewController {
    
    //MARK: - Globals
    
    class var identifier: String { return "SplashViewController" }
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var internetConectionContainerView: UIView!
    @IBOutlet weak var internetConectionButton: UIButton!
    @IBOutlet weak var internetConectionDescriptionLabel: UILabel!
    @IBOutlet weak var internetContectionTitleLabel: UILabel!
    @IBOutlet weak var quizlerProgressBarView: QuizlerProgressBarView!
    var newDataSource: QuestionsViewModel?
    
    //MARK: - Init
    //MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareThemeAndLocalization()
    }
    
    struct LocalizationStrings {
        static let internetConnectionTitle = "splash_screen_no_internet_connection_title".localized()
        static let internetConnectionDescription = "splash_screen_no_internet_connection_description_text".localized()
        static let internetConnectionButtonText = "splash_screen_no_internet_conection_button_text".localized()
    }
    
    //MARK: - User interaction
    //MARK: - DataSources / Delegates
    //MARK: - Utils
    
    func prepareThemeAndLocalization() {
        self.logoImageView.image = UIImage(named: "logo_image")
        self.view.backgroundColor = AppTheme.current.mainColor
        internetContectionTitleLabel.text = LocalizationStrings.internetConnectionTitle
        internetConectionDescriptionLabel.text = LocalizationStrings.internetConnectionDescription
        internetConectionButton.setTitle(LocalizationStrings.internetConnectionButtonText, for: .normal)
        self.internetConectionContainerView.layer.cornerRadius = 10
        self.internetConectionButton.layer.cornerRadius = 30
        self.internetConectionContainerView.isHidden = true
        self.logoTransition()
    }

    @IBAction func internetConectionButtonTouched(_ sender: Any) {
        self.showProgressBar()
    }
    
    func apiFetchUserIfAny() {
        FlowManager.presentMainScreen()
    }
    
    
    func logoTransition() {
        UIView.animate(
            withDuration: 0.88,
            delay: 0.5,
            options: [.curveEaseIn],
            animations: { self.logoImageView.alpha = 0.0 },
            completion: { _ in self.showProgressBar() }
        )
    }
            
    func showProgressBar() {
        self.quizlerProgressBarView.isHidden = false
        self.quizlerProgressBarView.setProgress(to: 1)
        perform(#selector(internetCheck), with: nil, afterDelay: 0.7)
    }
    
    @objc func internetCheck() {
        if Reachability.isConnectedToNetwork {
            self.apiFetchUserIfAny()
        } else {
            self.quizlerProgressBarView.setProgress(to: 0)
            self.internetConectionContainerView.isHidden = false
        }

    }
    

}
