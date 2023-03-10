//
//  QuestionReportViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 7/12/21.
//

import UIKit


class QuestionReportViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: - Globals
    
    class var identifier: String { return "QuestionReportViewController" }
    
    @IBOutlet weak var questionTextView: QuizlerTextView!
    @IBOutlet weak var choseCategoryLabel: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var value1Label: UILabel!
    @IBOutlet weak var value2Label: UILabel!
    @IBOutlet weak var value4Label: UILabel!
    @IBOutlet weak var value3Label: UILabel!
    
    @IBOutlet weak var answer1Label: QuizlerTextField!
    @IBOutlet weak var answer2Label: QuizlerTextField!
    @IBOutlet weak var answer3label: QuizlerTextField!
    @IBOutlet weak var answer4Label: QuizlerTextField!
    
    @IBOutlet weak var button1Outlet: UIButton!
    @IBOutlet weak var button2Outlet: UIButton!
    @IBOutlet weak var button3Outlet: UIButton!
    @IBOutlet weak var button4Outlet: UIButton!
    
    var dataSource: [CategoryModel] = []
    var selectedCategory: CategoryModel?
    
    var isAnswer1Correct: Bool = true
    var isAnswer2Correct: Bool = false
    var isAnswer3Correct: Bool = false
    var isAnswer4Correct: Bool = false
    
    
    
    //MARK: - Init
    
    class func instantiate() -> QuestionReportViewController {
        let viewController = UIStoryboard.main.instantiate(identifier) as! QuestionReportViewController
        return viewController
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.choseCategoryLabel.delegate = self
        self.prepareThemeAndLocalization()
        self.prepareNavigationBarTheme()
//
//        self.apiFetchCategories { dataSource in
//            DispatchQueue.main.async {
//                self.dataSource = dataSource
//                self.setupPickerView()
//            }
//        }
        
    }
    
    // MARK: - Utils
    
    func prepareThemeAndLocalization() {
        
        //Theme
        self.view.backgroundColor = AppTheme.current.white
        self.choseCategoryLabel.backgroundColor = UIColor.clear
        
        self.button1Outlet.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        self.button2Outlet.setImage(UIImage(systemName: "circle"), for: .normal)
        self.button3Outlet.setImage(UIImage(systemName: "circle"), for: .normal)
        self.button4Outlet.setImage(UIImage(systemName: "circle"), for: .normal)
        
        let titleColor = AppTheme.current.darkGreyColor
        let selectedColor = AppTheme.current.darkGreyColor
        let iconColor = AppTheme.current.historyColor
        
        questionTextView.configure(with: QuizlerTextView.Config(
            title: "Question",
            keyboardAppearance: .default,
            returnKeyType: .next,
            titleColor: titleColor,
            backgroundColor: UIColor.clear,
            borderColor: AppTheme.current.primary.cgColor,
            selectedColor: selectedColor,
            iconColor: iconColor,
            textValidationExpression: { text in
                return (text.count >= 1, "Pitanje mora biti vece od 3 slova")
            },
            returnKeyCallback: {[weak self] in
                self?.choseCategoryLabel.becomeFirstResponder()
            }
        ))
        
        answer1Label.configure(with: QuizlerTextField.Config(
            title: nil,
            placeholder: "Answer A",
            isSecureTextEntry: false,
            keyboardAppearance: .default,
            returnKeyType: .next,
            titleColor: titleColor,
            backgroundColor: UIColor.clear,
            borderColor: AppTheme.current.primary.cgColor,
            selectedColor: selectedColor,
            iconColor: iconColor,
            textValidationExpression: { text in
                return (text.count >= 1, "Odgovor mora biti veci od 3 slova")
            },
            returnKeyCallback: { [weak self] in
                self?.answer2Label.textField.becomeFirstResponder()
            }
        ))
        
        answer2Label.configure(with: QuizlerTextField.Config(
            title: nil,
            placeholder: "Answer B",
            isSecureTextEntry: false,
            keyboardAppearance: .default,
            returnKeyType: .next,
            titleColor: titleColor,
            backgroundColor: UIColor.clear,
            borderColor: AppTheme.current.primary.cgColor,
            selectedColor: selectedColor,
            iconColor: iconColor,
            textValidationExpression: { text in
                return (text.count >= 1, "Odgovor mora biti veci od 3 slova")
            },
            returnKeyCallback: { [weak self] in
                self?.answer3label.textField.becomeFirstResponder()
            }
        ))
        
        answer3label.configure(with: QuizlerTextField.Config(
            title: nil,
            placeholder: "Answer C",
            isSecureTextEntry: false,
            keyboardAppearance: .default,
            returnKeyType: .next,
            titleColor: titleColor,
            backgroundColor: UIColor.clear,
            borderColor: AppTheme.current.primary.cgColor,
            selectedColor: selectedColor,
            iconColor: iconColor,
            textValidationExpression: { text in
                return (text.count >= 1, "Odgovor mora biti veci od 3 slova")
            },
            returnKeyCallback: { [weak self] in
                self?.answer4Label.textField.becomeFirstResponder()
            }
        ))
        
        answer4Label.configure(with: QuizlerTextField.Config(
            title: nil,
            placeholder: "Answer D",
            isSecureTextEntry: false,
            keyboardAppearance: .default,
            returnKeyType: .next,
            titleColor: titleColor,
            backgroundColor: UIColor.clear,
            borderColor: AppTheme.current.primary.cgColor,
            selectedColor: selectedColor,
            iconColor: iconColor,
            textValidationExpression: { text in
                return (text.count >= 1, "Odgovor mora biti veci od 3 slova")
            },
            returnKeyCallback: { [weak self] in
                self?.answer2Label.textField.becomeFirstResponder()
            }
        ))
        
    }
    private func setupPickerView() {
        let categoryPicker = UIPickerView()
        choseCategoryLabel.inputView = categoryPicker
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        choseCategoryLabel.text = dataSource[0].name
    }
    
    
    func prepareNavigationBarTheme() {
    }
    
    func prepareRequestBody() -> NSDictionary? {
        
        guard
            let questionTitle = questionTextView.textView.text,
            let answer1       = answer1Label.textField.text,
            let answer2       = answer2Label.textField.text,
            let answer3       = answer3label.textField.text,
            let answer4       = answer4Label.textField.text,
            let categoryId    = selectedCategory?.id
        else {
            return nil
        }
        var answers: [NSDictionary] = []
        
        let answer1Dictionary: NSDictionary = [
            "text": answer1,
            "isCorrect"  : self.isAnswer1Correct
        ]
        let answer2Dictionary: NSDictionary = [
            "text": answer2,
            "isCorrect"  : self.isAnswer2Correct
        ]
        let answer3Dictionary: NSDictionary = [
            "text" : answer3,
            "isCorrect"   : self.isAnswer3Correct
        ]
        let answer4Dictionary: NSDictionary = [
            "text" : answer4,
            "isCorrect"   : self.isAnswer4Correct
        ]
        
        answers.append(answer1Dictionary)
        answers.append(answer2Dictionary)
        answers.append(answer3Dictionary)
        answers.append(answer4Dictionary)
        
        
        //Required
        let request: NSMutableDictionary = [
            "text": questionTitle,
            "category_id": categoryId
        ]
        
        request.setValue(answers, forKeyPath: "answers")
        print(request)
        return request
    }
    
//    func apiRequestQuestion() {
//        if let body = prepareRequestBody() {
//            let loader = LoaderView.create(for: self.view, config: AppGlobals.defaultLoadConfig)
//            AppGlobals.herokuRESTManager.postRequestQuestion(body: body) { (result) in
//                loader.dismiss()
//                switch result {
//                case .success:
//                    //Present home screen
//                    FlowManager.presentMainScreen()
//
//                case .failure(let error):
//                    DispatchQueue.main.async {
//                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                }
//
//            }
//        } else {
//            print("Failed to prepare request body for registration")
//        }
//    }
    
    
    //MARK: - User Interaction
    
    @IBAction func correctButton_Tapped(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            self.button1Outlet.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            self.button2Outlet.setImage(UIImage(systemName: "circle"), for: .normal)
            self.button3Outlet.setImage(UIImage(systemName: "circle"), for: .normal)
            self.button4Outlet.setImage(UIImage(systemName: "circle"), for: .normal)
            self.isAnswer1Correct = true
            self.isAnswer2Correct = false
            self.isAnswer3Correct = false
            self.isAnswer4Correct = false
        case 2:
            self.button1Outlet.setImage(UIImage(systemName: "circle"), for: .normal)
            self.button2Outlet.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            self.button3Outlet.setImage(UIImage(systemName: "circle"), for: .normal)
            self.button4Outlet.setImage(UIImage(systemName: "circle"), for: .normal)
            self.isAnswer1Correct = false
            self.isAnswer2Correct = true
            self.isAnswer3Correct = false
            self.isAnswer4Correct = false
        case 3:
            self.button1Outlet.setImage(UIImage(systemName: "circle"), for: .normal)
            self.button2Outlet.setImage(UIImage(systemName: "circle"), for: .normal)
            self.button3Outlet.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            self.button4Outlet.setImage(UIImage(systemName: "circle"), for: .normal)
            self.isAnswer1Correct = false
            self.isAnswer2Correct = false
            self.isAnswer3Correct = true
            self.isAnswer4Correct = false
        case 4:
            self.button1Outlet.setImage(UIImage(systemName: "circle"), for: .normal)
            self.button2Outlet.setImage(UIImage(systemName: "circle"), for: .normal)
            self.button3Outlet.setImage(UIImage(systemName: "circle"), for: .normal)
            self.button4Outlet.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            self.isAnswer1Correct = false
            self.isAnswer2Correct = false
            self.isAnswer3Correct = false
            self.isAnswer4Correct = true
        default: return
        }
        
    }
    
    @IBAction func saveQuestionButton_Tapped(_ sender: Any) {
        if isInputValid() {
//            self.apiRequestQuestion()
        }
    }
    
    func isInputValid() -> Bool {
        let flag1 = questionTextView.checkTextValidity()
        let flag2 = answer1Label.checkTextValidity()
        let flag3 = answer2Label.checkTextValidity()
        let flag4 = answer3label.checkTextValidity()
        let flag5 = answer4Label.checkTextValidity()
        
        
        return flag1 && flag2 && flag3 && flag4 && flag5
    }
    
    
    // MARK: - DataSources / Delegates
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row].name
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let category = dataSource[row]
        choseCategoryLabel.text = category.name
        selectedCategory = category
    }
    
    //MARK: Api
    
//    private func apiFetchCategories(_ callback: @escaping ([CategoryModel])->Swift.Void) {
//        let loader = LoaderView.create(for: self.view, config: AppGlobals.defaultLoadConfig)
//
//        AppGlobals.herokuRESTManager.getCategories { (result) in
//            loader.dismiss()
//            switch result {
//            case .success(let dataSource): callback(dataSource)
//            case .failure: break
//            }
//        }
//    }
    
    
}
//MARK: - UITextFieldDelegate

extension QuestionReportViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.choseCategoryLabel.layer.borderColor = AppTheme.current.primary.cgColor
        self.choseCategoryLabel.layer.borderWidth = 2.0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.choseCategoryLabel.layer.borderWidth = 0.0
    }
}
