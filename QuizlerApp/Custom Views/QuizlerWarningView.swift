//
//  QuizlerWarningView.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 2/6/23.
//

import UIKit


protocol QuizlerWarningViewDelegate: AnyObject {
    func returnToQuiz()
}


class QuizlerWarningView: UIView {
    
    //MARK: - Globals
    
    class var identifier: String { return "QuizlerWarningView" }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var warningDescription: UILabel!
    @IBOutlet weak var imageView: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var firstButtonLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var returnToQuizView: UIView!
    @IBOutlet weak var returnToQuizButton: UIButton!
    
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    
    weak var delegate: QuizlerWarningViewDelegate?
    
    struct Config {
        let title: String
        let wariningColor: UIColor
        let warinngDescription: String
        let reportTypes: [ReportTypeModel]
        
        static var empty: Config {
            return Config(
                title: "",
                wariningColor: UIColor.clear,
                warinngDescription: "",
                reportTypes: []
            )
        }
    }
    
    
    private (set) var config: Config = Config.empty
    
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
    
    func nibSetup() {
        backgroundColor = .clear
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        insertSubview(view, at: 0)
        
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: QuizlerWarningView.identifier, bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    
    func configure(with config: Config) {
        self.config = config
        
        titleLabel.text = config.title
        warningView.backgroundColor = config.wariningColor
        warningDescription.text = config.warinngDescription
        returnToQuizView.backgroundColor = AppTheme.current.categoryViewBackgroundColor
        returnToQuizView.layer.borderWidth = 0.5
        returnToQuizView.layer.borderColor = AppTheme.current.categoryViewTextColor.cgColor
        returnToQuizButton.setTitleColor(AppTheme.current.categoryViewTextColor, for: .normal)
        self.view.layer.cornerRadius = 5
        
        self.closeButton.backgroundColor = AppTheme.current.mainColor
        self.closeButton.imageView?.tintColor = AppTheme.current.containerColor
        self.closeButton.layer.cornerRadius = closeButton.layer.bounds.width / 2
        self.closeButton.clipsToBounds = true
        
    }
    
    //MARK: - User Interaction
    
    @IBAction func firstButtonOnClick(_ sender: UIButton) {
        self.firstButton.isSelected = !self.firstButton.isSelected
    }
    
    @IBAction func secondButtonOnClick(_ sender: UIButton) {
        self.secondButton.isSelected = !self.secondButton.isSelected
    }
    
    @IBAction func thirdButtonOnClick(_ sender: UIButton) {
        self.thirdButton.isSelected = !self.thirdButton.isSelected
    }
    
    @IBAction func fourthButtonOnClick(_ sender: UIButton) {
        self.fourthButton.isSelected = !self.fourthButton.isSelected
    }
    
    @IBAction func returnToQuizOnClick(_ sender: UIButton) {
        print(isValidInput())
    }
    
    @IBAction func closeButtonOnClick(_ sender: UIButton) {
        delegate?.returnToQuiz()
    }
    
    
    func isValidInput() -> Bool {
        let flag1 = firstButton.isSelected
        let flag2 = secondButton.isSelected
        let flag3 = thirdButton.isSelected
        let flag4 = fourthButton.isSelected
        
        if flag1 || flag2 || flag3 || flag4 {
            return true
        } else {
            return false
        }
        
        
        
    }
    
}
