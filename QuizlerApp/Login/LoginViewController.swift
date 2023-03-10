//
//  LoginViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/15/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Globals
    
    class var identifier: String { return "LoginViewController" }
    
    class func instantiate() -> LoginViewController {
        return UIStoryboard.login.instantiate(identifier) as! LoginViewController
    }
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameTextField: QuizlerTextField!
    @IBOutlet weak var passwordTextField: QuizlerTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareNavigationBarTheme()
        self.prepareThemeAndLocalization()
        
        if AppEnvironment.current == .local {
            self.usernameTextField.textField.text = "Test123"
            self.passwordTextField.textField.text = "Test123!"
        }
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareNavigationBarTheme()
    }
    
    //MARK: - Utils
    func prepareNavigationBarTheme() {
        self.navigationController?.navigationBar.tintColor = AppTheme.current.darkGreyColor
    }
    
    func prepareThemeAndLocalization() {
        loginButton.backgroundColor = AppTheme.current.primary
        loginButton.layer.cornerRadius = AppTheme.current.buttonCornerRadius
        loginButton.setTitleColor(AppTheme.current.blackColor, for: .normal)
        
        registerButton.backgroundColor = .clear
        registerButton.layer.borderWidth = 2
        registerButton.layer.borderColor = AppTheme.current.darkGreyColor.cgColor
        registerButton.setTitleColor(AppTheme.current.blackColor, for: .normal)
        
        let titleColor = AppTheme.current.darkGreyColor
        let selectedColor = AppTheme.current.darkGreyColor
        let iconColor = AppTheme.current.historyColor
        
        usernameTextField.configure(with: QuizlerTextField.Config(
                                        title: "Username",
                                        placeholder: "username",
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
                                            self?.loginButton.sendActions(for: .touchUpInside)
                                        }))
    }
    
    private func isInputValid() -> Bool {
        let flag1 = usernameTextField.checkTextValidity()
        let flag2 = passwordTextField.checkTextValidity()
        
        return flag1 && flag2
    }
    
    func prepareRequestBody() -> NSDictionary? {
        guard let username = usernameTextField.textField.text,
              let password = passwordTextField.textField.text else {
            return nil
        }
        
        // Required
        let dictionary: NSMutableDictionary = [
            "username": username,
            "password": password
        ]
        
        return dictionary
    }
    
    
    //MARK: - User Interaction
    @IBAction func loginButton_onClick(_ sender: Any) {
        if isInputValid() {
//            self.apiLogin()
        }
    }
    
    @IBAction func registrationButton_onClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - API
    
//    private func apiLogin() {
//        if let body = prepareRequestBody() {
//            let loader = LoaderView.create(for: self.view, config: AppGlobals.defaultLoadConfig)
//
//            AppGlobals.herokuRESTManager.postRequestUserLoggin(body: body) { (result) in
//                loader.dismiss()
//                switch result {
//                case .success:
//                    //Present home screen
//
//                    FlowManager.presentMainScreen()
//                case .failure(let error):
//                    DispatchQueue.main.async {
//                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                }
//            }
//        } else {
//            print("Failed to prepare request body for registration")
//        }
//    }
    
}
