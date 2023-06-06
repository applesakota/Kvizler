//
//  QuestionReportViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 7/12/21.
//

import UIKit


class QuestionReportViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {


    //MARK: - Globals
    
    class var identifier: String { return "QuestionReportViewController" }
    

    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var newQuestionView: UIView!
    
    @IBOutlet weak var questionTitleView: UIView!
    @IBOutlet weak var quizlerTextView: QuizlerTextView!
    
    @IBOutlet weak var choseCategoryView: UIView!
    @IBOutlet weak var choseCategoryLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var correctAnswerView: UIView!
    @IBOutlet weak var selectCorrectAnswer: UILabel!
    
    @IBOutlet weak var answerOneContainerView: UIView!
    @IBOutlet weak var answerOneButton: UIButton!
    @IBOutlet weak var answerOneTextField: QuizlerQuestionTextView!
    
    @IBOutlet weak var answerTwoContainerView: UIView!
    @IBOutlet weak var answerTwoButton: UIButton!
    @IBOutlet weak var answerTwoTextField: QuizlerQuestionTextView!
    
    @IBOutlet weak var answerThreeContainerView: UIView!
    @IBOutlet weak var answerThreeButton: UIButton!
    @IBOutlet weak var answerThreeTextField: QuizlerQuestionTextView!
    
    @IBOutlet weak var answerFourContainerView: UIView!
    @IBOutlet weak var answerFourButton: UIButton!
    @IBOutlet weak var answerFourLabel: QuizlerQuestionTextView!
    
    private(set) var selectedSubMode: SubMode?
    private(set) var selectedSubModePath: IndexPath?
    private(set) var submodes: [SubMode] = []
    private(set) var isFirstCorrect: Bool = false
    private(set) var isSecondCorrect: Bool = false
    private(set) var isThirdCorrect: Bool = false
    private(set) var isFourthCorrect: Bool = false
    
    @IBOutlet weak var sendQuestionButton: UIButton!
    @IBOutlet weak var buttonView: UIView!
    
    private var rawSubModes: [SubMode] {
        var array: [SubMode] = []
        array = submodes.filter({ $0.name.localized() != "Lako" || $0.name.localized() != "Teško" || $0.name.localized() != "Srednje" || $0.name.localized() != "Zen" || $0.name.localized() != "Test" || $0.name.localized() != "Maraton" })
        return array
    }

    //MARK: - Init
    
    class func instantiate() -> QuestionReportViewController {
        let viewController = UIStoryboard.main.instantiate(identifier) as! QuestionReportViewController
        viewController.tabBarItem = UITabBarItem(title: "Dodaj", image: #imageLiteral(resourceName: "new"), selectedImage: #imageLiteral(resourceName: "new"))
        return viewController
    }
    
    class func instantiateWithNavigation() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: instantiate())
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.backgroundColor = UIColor.clear
        return navigationController
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareThemeAndLocalization()
        self.prepareNavigationBarTheme()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.apiFetchSubmodes { [weak self] submodes in
            guard let self = self else { return }
            self.submodes = submodes.filter({ $0.name.localized() == "Sport" || $0.name.localized() == "Muzika" || $0.name.localized() == "Istorija" || $0.name.localized() == "Geografija" || $0.name.localized() == "Film" || $0.name.localized() == "Opšte znanje" })
        }
    }

    // MARK: - Utils
    
    func prepareThemeAndLocalization() {
        
        //Theme
        self.navigationItem.title = "Postavi pitanje"
        self.view.backgroundColor = AppTheme.current.scoreboardTableViewBackgroundColor
        self.newQuestionView.backgroundColor = AppTheme.current.scoreboardTableViewBackgroundColor
        self.buttonView.backgroundColor = AppTheme.current.white.withAlphaComponent(0.5)
        self.buttonView.layer.cornerRadius = 10
        self.sendQuestionButton.setTitleColor(AppTheme.current.bodyTextColor.withAlphaComponent(0.5), for: .normal)
        
        self.questionTitleView.backgroundColor = AppTheme.current.white
        self.questionTitleView.layer.cornerRadius = 10
        
        self.choseCategoryView.backgroundColor = AppTheme.current.white
        self.choseCategoryView.layer.cornerRadius = 10
        self.choseCategoryLabel.textColor = AppTheme.current.bodyTextColor
        
        self.correctAnswerView.backgroundColor = AppTheme.current.white
        self.correctAnswerView.layer.cornerRadius = 10
        self.selectCorrectAnswer.textColor = AppTheme.current.bodyTextColor
        

        let titleColor = AppTheme.current.bodyTextColor
        let selectedColor = AppTheme.current.bodyTextColor
        let iconColor = AppTheme.current.bodyTextColor
        
        self.quizlerTextView.configure(with: QuizlerTextView.Config(
            title: "Pitanje",
            countLabel: "0/200",
            numberOfCharacters: 200,
            keyboardAppearance: .default,
            returnKeyType: .done,
            titleColor: titleColor,
            countLabelColor: titleColor,
            backgroundColor: AppTheme.current.scoreboardTableViewBackgroundColor,
            selectedColor: selectedColor,
            iconColor: iconColor,
            textValidationExpression: { text in
                return (text.trimmingAllSpaces().count >= 1, "Pitanje mora biti vece od 1 slova")
            },
            endEditingCallback: { [weak self] in
                guard let self = self else { return }
                self.isButtonHidden()
            }
        ))
                
        self.answerOneTextField.configure(with: QuizlerQuestionTextView.Config(
            title: "Odgovor",
            countLabel: "0/50",
            numberOfCharacters: 50,
            maximumNumberOfLines: 2,
            keyboardAppearance: .default,
            returnKeyType: .done,
            titleColor: titleColor,
            countLabelColor: titleColor,
            backgroundColor: AppTheme.current.scoreboardTableViewBackgroundColor,
            selectedColor: selectedColor,
            iconColor: iconColor,
            textValidationExpression: { text in
                return (text.trimmingAllSpaces().count >= 1, "Pitanje mora biti vece od 1 slova")
            },
            endEditingCallback: { [weak self] in
                guard let self = self else { return }
                self.isButtonHidden()
            }
        ))
        
        self.answerTwoTextField.configure(with: QuizlerQuestionTextView.Config(
            title: "Odgovor",
            countLabel: "0/50",
            numberOfCharacters: 50,
            maximumNumberOfLines: 2,
            keyboardAppearance: .default,
            returnKeyType: .done,
            titleColor: titleColor,
            countLabelColor: titleColor,
            backgroundColor: AppTheme.current.scoreboardTableViewBackgroundColor,
            selectedColor: selectedColor,
            iconColor: iconColor,
            textValidationExpression: { text in
                return (text.trimmingAllSpaces().count >= 1, "Pitanje mora biti vece od 1 slova")
            },
            endEditingCallback: { [weak self] in
                guard let self = self else { return }
                self.isButtonHidden()
            }
        ))
        
        self.answerThreeTextField.configure(with: QuizlerQuestionTextView.Config(
            title: "Odgovor",
            countLabel: "0/50",
            numberOfCharacters: 50,
            maximumNumberOfLines: 2,
            keyboardAppearance: .default,
            returnKeyType: .done,
            titleColor: titleColor,
            countLabelColor: titleColor,
            backgroundColor: AppTheme.current.scoreboardTableViewBackgroundColor,
            selectedColor: selectedColor,
            iconColor: iconColor,
            textValidationExpression: { text in
                return (text.trimmingAllSpaces().count >= 1, "Pitanje mora biti vece od 1 slova")
            },
            endEditingCallback: { [weak self] in
                guard let self = self else { return }
                self.isButtonHidden()
            }
        ))
        
        self.answerFourLabel.configure(with: QuizlerQuestionTextView.Config(
            title: "Odgovor",
            countLabel: "0/50",
            numberOfCharacters: 50,
            maximumNumberOfLines: 2,
            keyboardAppearance: .default,
            returnKeyType: .done,
            titleColor: titleColor,
            countLabelColor: titleColor,
            backgroundColor: AppTheme.current.scoreboardTableViewBackgroundColor,
            selectedColor: selectedColor,
            iconColor: iconColor,
            textValidationExpression: { text in
                return (text.trimmingAllSpaces().count >= 1, "Pitanje mora biti vece od 1 slova")
            },
            endEditingCallback: { [weak self] in
                guard let self = self else { return }
                self.isButtonHidden()
            }
        ))
        
        self.isButtonHidden()
        
    }

    func prepareNavigationBarTheme() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.tintColor = AppTheme.current.bodyTextColor
        self.navigationController?.navigationBar.barTintColor = AppTheme.current.mainColor
        self.navigationController?.navigationBar.backgroundColor = AppTheme.current.containerColor
        self.navigationController?.navigationBar.titleTextAttributes = [
            .font: AppTheme.semiboldFont(ofSize: 17),
            .foregroundColor: AppTheme.current.bodyTextColor
        ]
        self.backgroundView.backgroundColor = AppTheme.current.containerColor
    }
    
    func prepareRequestBody() -> NSDictionary? {
        
        guard
            let questionTitle = self.quizlerTextView.textView.text,
            let answer1       = self.answerOneTextField.textView.text,
            let answer2       = self.answerOneTextField.textView.text,
            let answer3       = self.answerOneTextField.textView.text,
            let answer4       = self.answerOneTextField.textView.text,
            let categoryId    = self.selectedSubMode?.id
        else {
            return nil
        }
        var answers: [NSDictionary] = []

        let answer1Dictionary: NSDictionary = [
            "text": answer1,
            "isCorrect"  : isFirstCorrect
        ]
        let answer2Dictionary: NSDictionary = [
            "text": answer2,
            "isCorrect"  : isSecondCorrect
        ]
        let answer3Dictionary: NSDictionary = [
            "text" : answer3,
            "isCorrect"   : isThirdCorrect,
        ]
        let answer4Dictionary: NSDictionary = [
            "text" : answer4,
            "isCorrect"   : isFourthCorrect
        ]

        answers.append(answer1Dictionary)
        answers.append(answer2Dictionary)
        answers.append(answer3Dictionary)
        answers.append(answer4Dictionary)


        //Required
        let request: NSMutableDictionary = [
            "text": questionTitle,
            "categoryId": categoryId
        ]

        request.setValue(answers, forKeyPath: "answers")
        print(request)
        return request
    }
    
    func apiRequestQuestion() {
        if let body = prepareRequestBody() {
            let loader = LoaderView.create(for: self.view, config: AppGlobals.defaultLoadConfig)
            AppGlobals.herokuRESTManager.requestPostQuestion(body: body) { (result) in
                loader.dismiss()
                switch result {
                case .success:
                    //Present home screen
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Hvala", message: "Vaše pitanje je uspešno poslato", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                            FlowManager.presentMainScreen()
                        })
                        self.present(alert, animated: false)
                    }

                case .failure:
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Greška", message: "Trenutno nije moguće poslati pitanje", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }

            }
        } else {
            print("Failed to prepare request body for registration")
        }
    }
    
    func apiFetchSubmodes(_ callback: @escaping ([SubMode]) -> Swift.Void) {
        let loader = LoaderView.create(for: self.view, config: AppGlobals.defaultLoadConfig)
        AppGlobals.herokuRESTManager.getModes { (result) in
            loader.dismiss()
            switch result {
            case .success(let categories):
                var submodes: [SubMode] = []
                for category in categories {
                    submodes.append(contentsOf: category.submodes)
                }
                callback(submodes)
            case .failure: break
            }
        }
    }
    
    
    //MARK: - User Interaction
    
    @IBAction func correctButton_Tapped(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            self.answerOneButton.isSelected   = true
            self.answerTwoButton.isSelected   = false
            self.answerThreeButton.isSelected = false
            self.answerFourButton.isSelected  = false
            
            self.isFirstCorrect = true
            self.isSecondCorrect = false
            self.isThirdCorrect = false
            self.isFourthCorrect = false
            
            self.isButtonHidden()
        case 2:
            self.answerOneButton.isSelected   = false
            self.answerTwoButton.isSelected   = true
            self.answerThreeButton.isSelected = false
            self.answerFourButton.isSelected  = false
            
            self.isFirstCorrect = false
            self.isSecondCorrect = true
            self.isThirdCorrect = false
            self.isFourthCorrect = false
            
            self.isButtonHidden()
        case 3:
            self.answerOneButton.isSelected   = false
            self.answerTwoButton.isSelected   = false
            self.answerThreeButton.isSelected = true
            self.answerFourButton.isSelected  = false
            
            self.isFirstCorrect = false
            self.isSecondCorrect = false
            self.isThirdCorrect = true
            self.isFourthCorrect = false
            
            self.isButtonHidden()
        case 4:
            self.answerOneButton.isSelected   = false
            self.answerTwoButton.isSelected   = false
            self.answerThreeButton.isSelected = false
            self.answerFourButton.isSelected  = true
            
            self.isFirstCorrect = false
            self.isSecondCorrect = false
            self.isThirdCorrect = false
            self.isFourthCorrect = true
            
            self.isButtonHidden()
        default: return
        }
        
    }
    
    @IBAction func saveQuestionButton_Tapped(_ sender: Any) {
        if isInputValid() {
            self.apiRequestQuestion()
        }
    }
        func isInputValid() -> Bool {
        let flag1 = quizlerTextView.checkTextValidity()
        let flag2 = answerOneTextField.checkTextValidity()
        let flag3 = answerTwoTextField.checkTextValidity()
        let flag4 = answerThreeTextField.checkTextValidity()
        let flag5 = answerFourLabel.checkTextValidity()
        let flag6 = isAnswerChecked()
        let flag7 = isCategorySelected()
        
        return flag1 && flag2 && flag3 && flag4 && flag5 && flag6 && flag7
    }
    
    func isAnswerChecked() -> Bool {
        let flag1 = isFirstCorrect
        let flag2 = isSecondCorrect
        let flag3 = isThirdCorrect
        let flag4 = isFourthCorrect
        
        return flag1 || flag2 || flag3 || flag4
    }
    
    func isCategorySelected() -> Bool {
        return selectedSubMode != nil ? true : false
    }
    
    func isButtonHidden() {
        if isInputValid() {
            sendQuestionButton.isUserInteractionEnabled = true
            buttonView.backgroundColor = AppTheme.current.white
            sendQuestionButton.setTitleColor(AppTheme.current.bodyTextColor, for: .normal)
        } else {
            sendQuestionButton.isUserInteractionEnabled = false
            buttonView.backgroundColor = AppTheme.current.white.withAlphaComponent(0.5)
            sendQuestionButton.setTitleColor(AppTheme.current.bodyTextColor.withAlphaComponent(0.5), for: .normal)
        }
    }
    
    // MARK: - DataSources / Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rawSubModes.isEmpty ? 1 : rawSubModes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectCategoryCollectionViewCell.identifier, for: indexPath) as? SelectCategoryCollectionViewCell else { return UICollectionViewCell() }
        cell.setTheme(for: rawSubModes[indexPath.item])
        if indexPath == selectedSubModePath {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            cell.setupSelectedBackground(isSelected: true)
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSubMode = rawSubModes[indexPath.item]
        selectedSubModePath = indexPath
        self.isButtonHidden()
    }
    
    
}

//MARK: - UICollectionViewCell

class SelectCategoryCollectionViewCell: UICollectionViewCell {
    
    class var identifier: String { return "SelectCategoryCollectionViewCell" }
    @IBOutlet weak var titleLabel: UILabel!
    override var isSelected: Bool {
        didSet {
            setSelectedCell(isSelected: isSelected)
        }
    }
    
    func setTheme(for model: SubMode) {
        self.titleLabel.text = model.name.localized()
        self.backgroundColor = AppTheme.current.containerColor.withAlphaComponent(0.5)
        self.titleLabel.textColor = AppTheme.current.bodyTextColor
        self.layer.cornerRadius = 10
    }
    
    func setSelectedCell(isSelected: Bool) {
        print("isSelected \(isSelected)")
        setupSelectedBackground(isSelected: isSelected)
    }
    
    func setupSelectedBackground(isSelected: Bool) {
        self.backgroundColor = isSelected ? AppTheme.current.mainColor : AppTheme.current.containerColor
        self.titleLabel.textColor = isSelected ? AppTheme.current.white : AppTheme.current.bodyTextColor
        self.layoutIfNeeded()
    }
    
    
}
