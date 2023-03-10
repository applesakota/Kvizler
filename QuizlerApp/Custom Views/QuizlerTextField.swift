//
//  QuizlerTextField.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/9/21.
//

import UIKit
import SwiftUI

class QuizlerTextField: UIView, UITextFieldDelegate {

    
    class var nibName: String { return "QuizlerTextField" }
 
    @IBOutlet var view: UIView!
    
    struct Config {
        var title: String?
        var placeholder: String?
        var text: String?
        var isSecureTextEntry: Bool
        var keyboardAppearance: UIKeyboardAppearance
        var returnKeyType: UIReturnKeyType
        var titleColor: UIColor
        var backgroundColor: UIColor
        var borderColor: CGColor?
        var selectedColor: UIColor
        var iconColor: UIColor
        var textValidationExpression: ((String) -> (Bool, String?))? = nil
        var shouldBeginEditingCallback: (()->Bool)? = nil
        var endEditingCallback: (()->Swift.Void)? = nil
        var returnKeyCallback: (()->Swift.Void)? = nil
        
        static var empty: Config {
            return Config(
                title: "",
                placeholder: "",
                isSecureTextEntry: false,
                keyboardAppearance: .default,
                returnKeyType: .default,
                titleColor: .clear,
                backgroundColor: .clear,
                borderColor: UIColor.clear.cgColor,
                selectedColor: .clear,
                iconColor: .clear
            )
        }
    }
    
    private (set) var config: Config = Config.empty
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var revealPasswordButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
    }
    
    convenience init(frame: CGRect, config: Config) {
        self.init(frame: frame)
        self.configure(with: config)
    }
    
    
    private func nibSetup() {
        backgroundColor = .clear

        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        textField.delegate = self
        insertSubview(view, at: 0)
    }
    
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: QuizlerTextField.nibName, bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    func configure(with config: Config) {
        self.config = config
        
        iconImageView.isHidden = true
        revealPasswordButton.isHidden = !config.isSecureTextEntry
        revealPasswordButton.tintColor = config.iconColor
        
        titleLabel.text = config.title
        titleLabel.isHidden = (config.title == nil)
        titleLabel.textColor = config.titleColor
        textField.placeholder = config.placeholder
        textField.isSecureTextEntry = config.isSecureTextEntry
        textField.returnKeyType = config.returnKeyType
        textField.keyboardAppearance = config.keyboardAppearance
        textField.backgroundColor = config.backgroundColor
        textField.layer.borderColor = config.borderColor
        textField.text = config.text
    }
    
    //MARK: - Actions
    
    @IBAction func revealPasswordButton_onClick(_ sender: Any) {
        self.textField.isSecureTextEntry = !self.textField.isSecureTextEntry
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        titleLabel.textColor = config.selectedColor
        self.textField.layer.borderColor = config.borderColor
        self.textField.layer.borderWidth = 2.0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        titleLabel.textColor = config.titleColor
        self.textField.layer.borderWidth = 0.0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        iconImageView.isHidden = true
        errorLabel.isHidden = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        config.returnKeyCallback?()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        config.endEditingCallback?()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return config.shouldBeginEditingCallback?() ?? true
    }
    
    @IBAction func didEnd(_ sender: Any) {
        titleLabel.textColor = config.titleColor
        self.textField.layer.borderWidth = 0.0
    }
    
    func checkTextValidity() -> Bool {
        if let textValidityExpression = config.textValidationExpression {
            if let text = textField.text {
                let (isValid, errorMessage) = textValidityExpression(text)
                if isValid {
                    iconImageView.tintColor = config.iconColor
                    iconImageView.image = UIImage(systemName: "checkmark")
                    iconImageView.isHidden = false
                    errorLabel.isHidden = true
                    errorLabel.text = nil
                    return true
                } else {
                    iconImageView.tintColor = UIColor.red
                    iconImageView.image = UIImage(systemName: "xmark")
                    iconImageView.isHidden = false
                    errorLabel.isHidden = false
                    errorLabel.textColor = UIColor.red
                    errorLabel.text = errorMessage
                }
            }
            return false
        }
        return true
    }

}
