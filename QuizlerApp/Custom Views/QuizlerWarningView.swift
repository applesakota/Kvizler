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
    private var reportTypeId: String = ""
    
    
    struct Config {
        let title: String
        let wariningColor: UIColor
        let warinngDescription: String
        let reportTypes: [ReportTypeModel]
        var questionId: String
        
        static var empty: Config {
            return Config(
                title: "",
                wariningColor: UIColor.clear,
                warinngDescription: "",
                reportTypes: [],
                questionId: ""
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
        
        firstLabel.text = config.reportTypes[0].type.localized()
        secondLabel.text = config.reportTypes[1].type.localized()
        thirdLabel.text = config.reportTypes[2].type.localized()
        fourthLabel.text = config.reportTypes[3].type.localized()
        
        self.view.layer.cornerRadius = 5
        
        self.isButtonHidden()
        
        self.closeButton.backgroundColor = AppTheme.current.mainColor
        self.closeButton.imageView?.tintColor = AppTheme.current.containerColor
        self.closeButton.layer.cornerRadius = closeButton.layer.bounds.width / 2
        self.closeButton.clipsToBounds = true
        
    }
    
    //MARK: - User Interaction
    
    @IBAction func firstButtonOnClick(_ sender: UIButton) {
        self.firstButton.isSelected = !self.firstButton.isSelected
        self.isButtonHidden()
        self.reportTypeId = config.reportTypes[0].id
    }
    
    @IBAction func secondButtonOnClick(_ sender: UIButton) {
        self.secondButton.isSelected = !self.secondButton.isSelected
        self.isButtonHidden()
        self.reportTypeId = config.reportTypes[1].id
    }
    
    @IBAction func thirdButtonOnClick(_ sender: UIButton) {
        self.thirdButton.isSelected = !self.thirdButton.isSelected
        self.isButtonHidden()
        self.reportTypeId = config.reportTypes[2].id
    }
    
    @IBAction func fourthButtonOnClick(_ sender: UIButton) {
        self.fourthButton.isSelected = !self.fourthButton.isSelected
        self.isButtonHidden()
        self.reportTypeId = config.reportTypes[3].id
    }
    
    @IBAction func returnToQuizOnClick(_ sender: UIButton) {
        if isValidInput() {
            sendReport(reportTypeId: reportTypeId, questionId: config.questionId)
        } else {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Info", message: "message", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                    self.window?.rootViewController?.dismiss(animated: true)
                })
                self.window?.rootViewController?.present(alert, animated: false)
            }
        }
    }
    
    @IBAction func closeButtonOnClick(_ sender: UIButton) {
        delegate?.returnToQuiz()
    }
    
    func isButtonHidden() {
        if isValidInput() {
            returnToQuizButton.isUserInteractionEnabled = true
            returnToQuizView.backgroundColor = AppTheme.current.categoryViewBackgroundColor
            returnToQuizView.layer.borderWidth = 0.5
            returnToQuizView.layer.borderColor = AppTheme.current.categoryViewTextColor.cgColor
            returnToQuizButton.setTitleColor(AppTheme.current.categoryViewTextColor, for: .normal)
        } else {
            returnToQuizButton.isUserInteractionEnabled = false
            returnToQuizView.backgroundColor = AppTheme.current.categoryViewBackgroundColor.withAlphaComponent(0.5)
            returnToQuizView.layer.borderWidth = 0.5
            returnToQuizView.layer.borderColor = AppTheme.current.categoryViewTextColor.withAlphaComponent(0.5).cgColor
            returnToQuizButton.setTitleColor(AppTheme.current.categoryViewTextColor.withAlphaComponent(0.5), for: .normal)
        }
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

    
    func sendReport(reportTypeId: String, questionId: String) {
        apiPostRequestError(reportTypeId: reportTypeId, questionId: questionId) { message in
            DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                        self.delegate?.returnToQuiz()
                    })
                self.window?.rootViewController?.present(alert, animated: false)
            }
        }
    }
    

    
    
    //MARK: - API
    
    func apiPostRequestError(reportTypeId: String, questionId: String, _ callback: @escaping (String) -> Swift.Void) {
        let loader = LoaderView.create(for: self.view)
        AppGlobals.herokuRESTManager.requestPostError(reportTypeId: reportTypeId, questionId: questionId) { result in
            loader.dismiss()
            switch result {
            case .success: callback("Hvala. Tvoja prijava je zabeležena")
            case .failure: callback("Greska pri slanju prijave")
            }
        }
    }
    
    
    
    
}
