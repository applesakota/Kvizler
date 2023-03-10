//
//  LoginViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/10/21.
//

import UIKit

class RegisterViewController: UIViewController {
    
    //MARK: - Globals
    
    class var identifier: String { return "RegisterViewController" }
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: QuizlerTextField!
    @IBOutlet weak var passwordTextField: QuizlerTextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: QuizlerTextField!
    
    //MARK: - Init
    
    class func instantiate() -> RegisterViewController {
        return UIStoryboard.login.instantiate(identifier) as! RegisterViewController
    }
    
    class func instantiateWithNavigation() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: instantiate())
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        return navigationController
    }
    
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareThemeAndLocalization()
        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK: - User interaction
    
    @IBAction func registerButton_onClikc(_ sender: Any) {
        if isInputValid() {
            self.apiRegistration()
        }
    }
    
    @IBAction func loginButton_onClick(_ sender: Any) {
        let viewController = LoginViewController.instantiate()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - Utils
    
    private func prepareThemeAndLocalization() {
        //Theme
        self.view.backgroundColor = AppTheme.current.white
        self.registerButton.backgroundColor = AppTheme.current.primary
        self.registerButton.setTitleColor(AppTheme.current.blackColor, for: .normal)
        self.registerButton.layer.cornerRadius = AppTheme.current.buttonCornerRadius
        
        self.loginButton.backgroundColor = UIColor.clear
        self.loginButton.layer.borderWidth = 2
        self.loginButton.layer.borderColor = AppTheme.current.darkGreyColor.cgColor
        self.loginButton.setTitleColor(AppTheme.current.blackColor, for: .normal)
        
        let titleColor = AppTheme.current.darkGreyColor
        let selectedColor = AppTheme.current.darkGreyColor
        let iconColor = AppTheme.current.historyColor
        
        emailTextField.configure(with: QuizlerTextField.Config(
            title: "Email",
            placeholder: "example@example.com",
            isSecureTextEntry: false,
            keyboardAppearance: .default,
            returnKeyType: .next,
            titleColor: titleColor,
            backgroundColor: UIColor.clear,
            borderColor: AppTheme.current.primary.cgColor,
            selectedColor: selectedColor,
            iconColor: iconColor,
            textValidationExpression: { text in
                return (text.isValidEmail, "Email not valid")
            },
            returnKeyCallback: { [weak self] in
                self?.passwordTextField.textField.becomeFirstResponder()
            }
        ))
        
        usernameTextField.configure(with: QuizlerTextField.Config(
                                        title: "Username",
                                        placeholder: "username",
                                        isSecureTextEntry: false,
                                        keyboardAppearance: .default,
                                        returnKeyType: .continue,
                                        titleColor: titleColor,
                                        backgroundColor: UIColor.clear,
                                        borderColor: AppTheme.current.primary.cgColor,
                                        selectedColor: selectedColor,
                                        iconColor: iconColor,
                                        textValidationExpression: { text in
                                            return (text.count >= 3, "Username mora biti veci od 3 slova")
                                        },
                                        returnKeyCallback: { [weak self] in
                                            self?.emailTextField.textField.becomeFirstResponder()
                                            
                                        }))
        
        
        passwordTextField.configure(with: QuizlerTextField.Config(
                                        title: "Password",
                                        placeholder: "password",
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
    
    func prepareRequestBody() -> NSDictionary? {
        guard let email = emailTextField.textField.text,
              let username = usernameTextField.textField.text,
              let password = passwordTextField.textField.text else {
            return nil
        }
        
        // Required
        let dictionary: NSMutableDictionary = [
            "username": username,
            "email": email,
            "password": password
        ]
        
        return dictionary
    }
    
    func prepareNavigationBarTheme() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    func isInputValid() -> Bool {
        let flag1 = emailTextField.checkTextValidity()
        let flag2 = passwordTextField.checkTextValidity()
        let flag3 = usernameTextField.checkTextValidity()
        
        return flag1 && flag2 && flag3
    }
    
    //MARK: - Api
    
    func apiRegistration() {
        FlowManager.presentMainScreen()
//        if let body = prepareRequestBody() {
//            let loader = LoaderView.create(for: self.view, config: AppGlobals.defaultLoadConfig)
//            AppGlobals.herokuRESTManager.postRequestUserRegistration(body: body) { (result) in
//                loader.dismiss()
//                switch result {
//                case .success:
//                    //Present home screen
//
//                    FlowManager.presentMainScreen()
//
//                case .failure(let error):
//
//                    DispatchQueue.main.async {
//                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                }
//
//            }
//
//        } else {
//            print("Failed to prepare request body for registration")
//        }
        
    }
}
