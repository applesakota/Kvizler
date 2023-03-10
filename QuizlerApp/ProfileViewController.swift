//
//  ProfileViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 9/17/21.
//

import UIKit

class ProfileViewController: UIViewController {

    //MARK: - Globals
    @IBOutlet weak var logOutBarButton: UIBarButtonItem!
    @IBOutlet weak var changeSettingsBarButton: UIBarButtonItem!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: QuizlerTextField!
    @IBOutlet weak var passwordTextField: QuizlerTextField!
    
    class var identifier: String { return "ProfileViewController" }
    
    var user: UserModel!
    
    //MARK: - Init
    
    class func instantiate(user: UserModel) -> ProfileViewController {
        let viewController = UIStoryboard.main.instantiateViewController(withIdentifier: self.identifier) as! ProfileViewController
        viewController.user = user
        return viewController
    }
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareThemeAndLocalization()
    }
    

    //MARK: - Utils
    
    func prepareNavigationBar() {
        
    }
    
    func prepareThemeAndLocalization() {
        self.view.isUserInteractionEnabled = false
        let titleColor = AppTheme.current.darkGreyColor
        let selectedColor = AppTheme.current.darkGreyColor
        let iconColor = AppTheme.current.historyColor
        
        usernameTextField.configure(with: QuizlerTextField.Config(
                                        title: "Username",
                                        text: AppGlobals.currentUser?.username,
                                        isSecureTextEntry: false,
                                        keyboardAppearance: .default,
                                        returnKeyType: .next,
                                        titleColor: titleColor,
                                        backgroundColor: UIColor.clear,
                                        borderColor: AppTheme.current.primary.cgColor,
                                        selectedColor: selectedColor,
                                        iconColor: iconColor,
                                        textValidationExpression: { text in
                                            return (text.count >= 3, "Username mora biti veci od 3 slova")
                                        },
                                        returnKeyCallback: {
                                            self.passwordTextField.textField.becomeFirstResponder()
                                        }))
        
        
        passwordTextField.configure(with: QuizlerTextField.Config(
                                        title: "Password",
                                        placeholder: "Add your password",
                                        isSecureTextEntry: true,
                                        keyboardAppearance: .default,
                                        returnKeyType: .continue,
                                        titleColor: titleColor,
                                        backgroundColor: UIColor.clear,
                                        borderColor: AppTheme.current.primary.cgColor,
                                        selectedColor: selectedColor,
                                        iconColor: iconColor,
                                        textValidationExpression: { text in
                                            return (text.isValidPassword, "Password not valid")
                                        },
                                        returnKeyCallback: { [weak self] in
                                            self?.passwordTextField.textField.resignFirstResponder()
                                        }))
    }
    
    //MARK: - User Interaction
    
    @IBAction func changeSettingsBarButton_Tapped(_ sender: Any) {
        self.view.isUserInteractionEnabled = !self.view.isUserInteractionEnabled
    }

    @IBAction func logOutBarButton_Tapped(_ sender: Any) {

    }

}
