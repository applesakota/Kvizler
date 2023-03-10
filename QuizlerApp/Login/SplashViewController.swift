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
    
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    @IBOutlet weak var internetConectionContainerView: UIView!
    @IBOutlet weak var internetConectionButton: UIButton!
    @IBOutlet weak var internetConectionDescriptionLabel: UILabel!
    @IBOutlet weak var internetContectionTitleLabel: UILabel!
    
    var newDataSource: QuestionsViewModel?
    
    //MARK: - Init
    //MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareThemeAndLocalization()
        if Reachability.isConnectedToNetwork {
            self.apiFetchUserIfAny()
        }
    }
    
    //MARK: - User interaction
    //MARK: - DataSources / Delegates
    //MARK: - Utils
    
    func prepareThemeAndLocalization() {
        self.view.backgroundColor = AppTheme.current.zenOrange
        appNameLabel.textColor = AppTheme.current.blackColor
        appVersionLabel.textColor = AppTheme.current.blackColor
        internetContectionTitleLabel.text = "Nema internet konekcije"
        internetConectionDescriptionLabel.text = "Potrebna je internet konekcija radi osvežavanja podataka."
        internetConectionButton.setTitle("Pokušaj ponovo", for: .normal)
        setBackgroundImage()
        self.internetConectionContainerView.layer.cornerRadius = 10
        self.internetConectionButton.layer.cornerRadius = 30
        
        self.internetConectionContainerView.isHidden = Reachability.isConnectedToNetwork
        //Data
        appNameLabel.text = "Quizler"
        appVersionLabel.text = "1.01"
    }
    
    @IBAction func internetConectionButtonTouched(_ sender: Any) {
        if Reachability.isConnectedToNetwork {
            self.apiFetchUserIfAny()
        }
    }
    func apiFetchUserIfAny() {
        FlowManager.presentMainScreen()
    }
    
    func setBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFit
        self.view.insertSubview(backgroundImage, at: 0)
    }
    

    

}
