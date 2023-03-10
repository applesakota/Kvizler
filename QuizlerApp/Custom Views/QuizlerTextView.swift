//
//  QuizlerTextView.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 7/13/21.
//

import UIKit

class QuizlerTextView: UIView, UITextViewDelegate {


class var nibName: String { return "QuizlerTextView" }

@IBOutlet var view: UIView!

struct Config {
    var title: String?
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
@IBOutlet weak var textView: UITextView!
@IBOutlet weak var errorLabel: UILabel!
@IBOutlet weak var iconImageView: UIImageView!

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
    textView.delegate = self
    
    insertSubview(view, at: 0)
}


private func loadViewFromNib() -> UIView {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: QuizlerTextView.nibName, bundle: bundle)
    let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
    return nibView
}

func configure(with config: Config) {
    self.config = config
    
    iconImageView.isHidden = true
    
    titleLabel.text = config.title
    titleLabel.isHidden = (config.title == nil)
    titleLabel.textColor = config.titleColor
    textView.returnKeyType = config.returnKeyType
    textView.keyboardAppearance = config.keyboardAppearance
    textView.backgroundColor = config.backgroundColor
    textView.layer.borderColor = config.borderColor
    self.textView.layer.borderColor = UIColor.lightGray.cgColor
    self.textView.layer.borderWidth = 0.25
}

//MARK: - Actions

//MARK: - UITextViewDelegate Methods
    
func textViewDidBeginEditing(_ textView: UITextView) {
    titleLabel.textColor = config.selectedColor
    self.textView.layer.borderColor = config.borderColor
    self.textView.layer.borderWidth = 2.0
}

func textViewDidEndEditing(_ textView: UITextView) {
    titleLabel.textColor = config.titleColor
    self.textView.layer.borderColor = UIColor.lightGray.cgColor
    self.textView.layer.borderWidth = 0.25
}

func textView(_ textView: UITextView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    iconImageView.isHidden = true
    errorLabel.isHidden = true
    return true
}
func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return config.shouldBeginEditingCallback?() ?? true
}
    
func textViewShouldReturn(_ textView: UITextView) -> Bool {
    config.returnKeyCallback?()
    return true
}


func checkTextValidity() -> Bool {
    if let textValidityExpression = config.textValidationExpression {
        if let text = textView.text {
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
                titleLabel.isHidden = true
            }
        }
        return false
    }
    return true
}

}
