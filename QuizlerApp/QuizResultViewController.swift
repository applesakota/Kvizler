//
//  QuizResultViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 5/8/23.
//

import UIKit

class QuizResultViewController: UIViewController {
    
    //MARK: - Globals
    
    class var identifier: String { return "QuizResultViewController" }
    
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countScoreLabel: UILabel!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var correctAnswerTitleLabel: UILabel!
    @IBOutlet weak var answersCountLabel: UILabel!
    @IBOutlet weak var usernameTextField: QuizlerTextField!
    @IBOutlet weak var saveUsernameButton: UIButton!
    @IBOutlet weak var saveUsernameLabel: UILabel!
    @IBOutlet weak var returnToTheMainControllerButton: UIButton!
    @IBOutlet weak var saveUsernameView: UIView!
    @IBOutlet weak var buttonBackgroundView: UIView!
    
    private var score: Int = 0
    private var numberOfAnswers: Int = 0
    private var countOfAnswers: Int = 0
    private(set) var mode: String!
    
    class func instantiate(with score: Int, numberOfAnswers: Int, countOfAnswers: Int,  mode: String? = nil) -> QuizResultViewController {
        let viewController = UIStoryboard.utils.instantiate(identifier) as! QuizResultViewController
        viewController.score = score
        viewController.numberOfAnswers = numberOfAnswers
        viewController.countOfAnswers = countOfAnswers
        viewController.mode = mode
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.prepareThemeAndLocalization()
    }
    
    func prepareThemeAndLocalization() {
        
        let titleColor = AppTheme.current.mainColor
        let selectedColor = AppTheme.current.mainColor
        let iconColor = AppTheme.current.mainColor
        
        usernameTextField.configure(with: QuizlerTextField.Config(
            title: "Korisničko ime",
            isSecureTextEntry: false,
            keyboardAppearance: .default,
            returnKeyType: .done,
            titleColor: titleColor,
            backgroundColor: AppTheme.current.white,
            borderColor: AppTheme.current.mainColor.cgColor,
            selectedColor: selectedColor,
            iconColor: iconColor,
            textValidationExpression: { text in
                return (text.trimmingAllSpaces().count >= 1, "Korisničko ime mora biti vece od 1 slova")
            }
        ))
        
        if numberOfAnswers < countOfAnswers / 3 {
            self.titleLabel.text = "Biće bolje idući put!"
            self.countScoreLabel.text = "Osvojio si \(score) poena"
            self.answersCountLabel.text = "\(numberOfAnswers)"
            self.returnToTheMainControllerButton.setTitle("Idi na glavni ekran", for: .normal)

        } else if numberOfAnswers > (countOfAnswers * 2) / 3 {
            // Calculate two-thirds of the total number of questions
            
            self.titleLabel.text = "Sjajno!"
            self.countScoreLabel.text = "Osvojio si \(score) poena"
            self.answersCountLabel.text = "\(numberOfAnswers)"
            self.returnToTheMainControllerButton.setTitle("Idi na glavni ekran", for: .normal)
            
        } else {
            
            self.titleLabel.text = "Bilo je dobro, probaj opet sledeći put!"
            self.countScoreLabel.text = "Osvojio si \(score) poena"
            self.answersCountLabel.text = "\(numberOfAnswers)"
            self.returnToTheMainControllerButton.setTitle("Idi na glavni ekran", for: .normal)
        }
        self.view.backgroundColor = AppTheme.current.scoreboardTableViewBackgroundColor
        
        self.titleLabel.textColor = AppTheme.current.white
        self.countScoreLabel.textColor = AppTheme.current.white
        self.answersCountLabel.textColor = AppTheme.current.mainColor
        
        self.buttonBackgroundView.backgroundColor = AppTheme.current.categoryViewBackgroundColor
        self.buttonBackgroundView.layer.borderWidth = 0.5
        self.buttonBackgroundView.layer.borderColor = AppTheme.current.categoryViewTextColor.cgColor
        self.buttonBackgroundView.layer.cornerRadius = 5
    
        self.imageView.layer.cornerRadius = 5
        self.imageView.layer.masksToBounds = true
        
        self.scoreView.backgroundColor = AppTheme.current.white
        self.scoreView.layer.cornerRadius = 5
        
        self.saveUsernameView.backgroundColor = AppTheme.current.containerColor
        self.saveUsernameView.layer.cornerRadius = 5
        self.saveUsernameView.layer.borderWidth = 0.5
        self.saveUsernameView.layer.borderColor = AppTheme.current.mainColor.cgColor

        self.saveUsernameButton.setTitleColor(AppTheme.current.mainColor, for: .normal)
        self.saveUsernameButton.setTitleColor(AppTheme.current.mainColor, for: .selected)
        self.saveUsernameButton.backgroundColor = .clear
        self.saveUsernameButton.superview?.backgroundColor = .clear
        
        self.returnToTheMainControllerButton.backgroundColor = .clear
        self.returnToTheMainControllerButton.setTitleColor(AppTheme.current.categoryViewTextColor, for: .normal)
    }
    
    //MARK: - User interaction
    
    @IBAction func saveUsernameButtonTouched(_ sender: UIButton) {
        self.saveUsernameButton.isSelected = !self.saveUsernameButton.isSelected
    }
    
    @IBAction func saveUserAndReturnToMainScreenTouched(_ sender: UIButton) {
        self.saveUser()
    }
    
    private func isValidInput() -> Bool {
        return self.usernameTextField.checkTextValidity()
    }
    
    //MARK: - API
    
    func saveUser() {
        if isValidInput() {
            if saveUsernameButton.isSelected {
                sendScore(username: usernameTextField.textField.text!)
            } else {
                FlowManager.presentMainScreen()
            }
        } else {
            FlowManager.presentMainScreen()
        }
    }
    
    func sendScore(username: String) {
        apiPostRequestScore(username: username, mode: mode, score: score) { message in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                    FlowManager.presentMainScreen()
                })
                self.present(alert, animated: false)
            }
        }
    }
    
//MARK: - API
    
    func apiPostRequestScore(username: String, mode: String, score: Int, _ callback: @escaping (String) -> Swift.Void) {
        let loader = LoaderView.create(for: self.view)
        AppGlobals.herokuRESTManager.requestPostScore(username: username, mode: mode, score: score) { result in
            loader.dismiss()
            switch result {
            case .success: callback("Tvoj rezultat je zabelezen")
            case .failure: callback("Greska pri slanju rezultata")
            }
        }
    }

}
