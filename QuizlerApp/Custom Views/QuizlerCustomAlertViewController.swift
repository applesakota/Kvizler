//
//  QuizlerCustomAlertViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 3/27/23.
//

import UIKit

class QuizlerCustomAlertViewController: UIViewController {

    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var alertDescriptionLabel: UILabel!
    @IBOutlet weak var alertNoButton: UIButton!
    @IBOutlet weak var alertYesButton: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareThemeAndLocalization()
    }


    init() {
        super.init(nibName: "QuizlerCustomAlertViewController", bundle: Bundle(for: QuizlerCustomAlertViewController.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func show() {
        if #available(iOS 13, *) {
            UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
        } else {
            UIApplication.shared.keyWindow?.rootViewController!.present(self, animated: true, completion: nil)
        }
    }
    
    func prepareThemeAndLocalization() {
        
        view.backgroundColor = AppTheme.current.backgroundColor.withAlphaComponent(0.6)
        self.alertView.layer.cornerRadius = 10
        self.alertImageView.image = UIImage(named: "exit-2")
        self.alertTitleLabel.text = "Napusti kviz"
        self.alertTitleLabel.textColor = AppTheme.current.bodyTextColor
        self.alertDescriptionLabel.text = "Da li sigurno želiš da napustiš kviz?"
        self.alertDescriptionLabel.textColor = AppTheme.current.bodyTextColor
        self.alertNoButton.setTitle("Ne", for: .normal)
        self.alertNoButton.setTitleColor(AppTheme.current.bodyTextColor, for: .normal)
        self.alertYesButton.setTitle("Da", for: .normal)
        self.alertYesButton.setTitleColor(AppTheme.current.bodyTextColor, for: .normal)
        self.alertView.layer.borderWidth = 0.2
        self.alertView.backgroundColor = AppTheme.current.containerColor
        self.alertView.showShadow()
    }
    
    //MARK: - User Interaction
    
    @IBAction func noButtonTouched(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func yesButtonTouched(_ sender: Any) {
        FlowManager.presentMainScreen()
    }
}
