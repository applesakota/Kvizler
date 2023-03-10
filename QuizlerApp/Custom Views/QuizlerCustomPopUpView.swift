//
//  QuizlerCustomPopUpView.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 3/6/23.
//

import UIKit

protocol SendScoreButtonDelegate: AnyObject {
    func sendScore(username: String)
}


class QuizlerCustomPopUpView: UIView {
    
    //MARK: - Globals
    
    class var identifier: String { return "QuizlerCustomPopUpView" }

    @IBOutlet var view: UIView!
    @IBOutlet weak var emojiImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var answersCountLabel: UILabel!
    @IBOutlet weak var usernameTextField: QuizlerTextField!
    @IBOutlet weak var saveUsernameButton: UIButton!
    @IBOutlet weak var saveUsernameLabel: UILabel!
    @IBOutlet weak var returnToTheMainControllerButton: UIButton!
    
    var saveUsername: Bool = false
    weak var delegate: SendScoreButtonDelegate?

    
    //MARK: - Init
    
    struct Config {
        let emojiImage: UIImage
        let title: String
        let answersCount: String
        
        
        static var empty: Config {
            return Config(
                emojiImage: UIImage(),
                title: "",
                answersCount: ""
            )
        }
    }
    
    private(set) var config: Config = Config.empty
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.nibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
    }
    
    
    func nibSetup() {
        backgroundColor = .clear
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        view.isUserInteractionEnabled = true
        insertSubview(view, at: 0)
        
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: QuizlerCustomPopUpView.identifier, bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    func configure(with score: Int, numberOfAnsers: Int, countOfAnswers: Int, mode: String? = nil) {
        
        let titleColor = AppTheme.current.darkGreyColor
        let selectedColor = AppTheme.current.darkGreyColor
        let iconColor = AppTheme.current.historyColor
        
        self.layer.cornerRadius = 10
        
        usernameTextField.configure(with: QuizlerTextField.Config(
            title: "Korisničko ime",
            isSecureTextEntry: false,
            keyboardAppearance: .default,
            returnKeyType: .done,
            titleColor: titleColor,
            backgroundColor: UIColor.clear,
            borderColor: AppTheme.current.cellColor.cgColor,
            selectedColor: selectedColor,
            iconColor: iconColor,
            textValidationExpression: { text in
                return (text.trimmingAllSpaces().count >= 1, "Korisničko ime mora biti vece od 1 slova")
            }
        ))
        
        if score < 10 {
            self.titleLabel.text = "Biće bolje idući put!"
            self.emojiImageView.image = UIImage(named: "emoji-3")
            self.answersCountLabel.text = "Dao/la si tačan odgovor na \(numberOfAnsers) od \(countOfAnswers) pitanja"
            self.returnToTheMainControllerButton.setTitle("Idi na glavni ekran", for: .normal)
            self.returnToTheMainControllerButton.backgroundColor = .clear
            self.returnToTheMainControllerButton.setTitleColor(AppTheme.current.cellColor, for: .normal)

        } else if score > 20 {

            self.titleLabel.text = "Sjajno!"
            self.emojiImageView.image = UIImage(named: "emoji-2")
            self.answersCountLabel.text = "Dao/la si tačan odgovor na \(numberOfAnsers) od \(countOfAnswers) pitanja"
            self.returnToTheMainControllerButton.setTitle("Idi na glavni ekran", for: .normal)
            self.returnToTheMainControllerButton.backgroundColor = .clear
            self.returnToTheMainControllerButton.setTitleColor(AppTheme.current.cellColor, for: .normal)
            
        } else {

            self.titleLabel.text = "Bilo je dobro, probaj opet sledecei put!"
            self.emojiImageView.image = UIImage(named: "emoji")
            self.answersCountLabel.text = "Dao/la si tačan odgovor na \(numberOfAnsers) od \(countOfAnswers) pitanja"
            self.returnToTheMainControllerButton.setTitle("Idi na glavni ekran", for: .normal)
            self.returnToTheMainControllerButton.backgroundColor = .clear
            self.returnToTheMainControllerButton.setTitleColor(AppTheme.current.cellColor, for: .normal)
        }
        
        self.saveUsernameButton.setTitleColor(AppTheme.current.cellColor, for: .normal)
        self.saveUsernameButton.setTitleColor(AppTheme.current.cellColor, for: .selected)
        self.saveUsernameButton.backgroundColor = .clear
        self.saveUsernameButton.superview?.backgroundColor = .clear
        self.returnToTheMainControllerButton.setTitleColor(AppTheme.current.cellColor, for: .normal)
        self.view.backgroundColor = AppTheme.current.popUpColor
        self.view.layer.cornerRadius = 10
        self.view.layer.borderWidth = 0.1
        self.view.showShadow()
        
    }
    
    //
    private func isValidInput() -> Bool {
        return self.usernameTextField.checkTextValidity()
    }
    
    
    
    @IBAction func saveUsernameButtonTouched(_ sender: UIButton) {
        self.saveUsernameButton.isSelected = !self.saveUsernameButton.isSelected
    }
    
    @IBAction func saveUserAndReturnToMainScreenTouched(_ sender: UIButton) {
        self.saveUser()
    }
    
    //MARK: - API
    
    func saveUser() {
        if isValidInput() {
            if saveUsernameButton.isSelected {
                delegate?.sendScore(username: self.usernameTextField.textField.text!)
            } else {
                FlowManager.presentMainScreen()
            }
        } else {
            FlowManager.presentMainScreen()
        }
    }
    

    
    
}
