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
        var countLabel: String
        var numberOfCharacters: Int
        var keyboardAppearance: UIKeyboardAppearance
        var returnKeyType: UIReturnKeyType
        var titleColor: UIColor
        var countLabelColor: UIColor
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
                countLabel: "",
                numberOfCharacters: 0,
                keyboardAppearance: .default,
                returnKeyType: .default,
                titleColor: .clear,
                countLabelColor: .clear,
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
    @IBOutlet weak var countLabel: UILabel!
    
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
        
        titleLabel.text = config.title
        countLabel.text = config.countLabel
        titleLabel.isHidden = (config.title == nil)
        titleLabel.textColor = config.titleColor
        countLabel.textColor = config.countLabelColor
        textView.returnKeyType = config.returnKeyType
        textView.keyboardAppearance = config.keyboardAppearance
        textView.backgroundColor = config.backgroundColor
        textView.layer.borderColor = config.borderColor
        self.textView.layer.borderWidth = 0.2
    }
    
    //MARK: - Actions
    
    //MARK: - UITextViewDelegate Methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        titleLabel.textColor = config.selectedColor
        self.textView.layer.borderColor = config.borderColor
        self.textView.layer.borderWidth = 0.25
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        titleLabel.textColor = config.titleColor
        self.textView.layer.borderColor = config.borderColor
        self.textView.layer.borderWidth = 0.25
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < config.numberOfCharacters
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.countLabel.text = "\(textView.text.count)/\(config.numberOfCharacters)"
    }
    
    func textView(_ textView: UITextView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return config.shouldBeginEditingCallback?() ?? true
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        config.returnKeyCallback?()
        return true
    }
    
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        config.endEditingCallback?()
        return true
    }
    
    func checkTextValidity() -> Bool {
        if let textValidityExpression = config.textValidationExpression {
            if let text = textView.text {
                let (isValid, errorMessage) = textValidityExpression(text)
                if isValid {
                    return true
                }
            }
            return false
        }
        return true
    }
    
}
