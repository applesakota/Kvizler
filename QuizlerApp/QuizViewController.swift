//
//  QuizViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 7/7/21.
//

import UIKit
import ProgressHUD


class QuizViewController: UIViewController {
    
    //MARK: - Globals
    
    class var identifier: String { return "QuizViewController" }
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var countProgresView: UIProgressView!
    @IBOutlet weak var quizlerPopUpContainerView: UIView!
    @IBOutlet weak var quizlerPopUpView: QuizlerCustomPopUpView!
    
    @IBOutlet weak var coinView: UIView!
    @IBOutlet weak var coinResultLabel: UILabel!
    @IBOutlet weak var coinImageView: UIImageView!
    
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerValueLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    
    @IBOutlet weak var reportButton: UIButton!
    
    
    var colorTheme: UIColor? = AppTheme.current.cellColor
    var categoryId: String?
    
    let shapeLayer = CAShapeLayer()
    var timer = Timer()
    var timerCount = 15
    var timePerQuestion = 15
    private var id: String!
    private var countNumberOfCorrectAnswers = 0
    private var fibiCount = 0
    var counter: Int = 0
    var score = 0 {
        didSet {
            DispatchQueue.main.async {
                self.updateUIOnStateChange()
            }
        }
    }
    var name: String!
    
    private var questions: [QuestionModel] = []
    var numberOfQuestions: Int = 20
    var mode: String!
    
    //MARK: - Init
    
    class func instantiate(questions: [QuestionModel], numberOfQuestions: Int, timePerQuestion: Int, mode: String) -> QuizViewController {
        let viewController = UIStoryboard.utils.instantiate(identifier) as! QuizViewController
        viewController.questions = questions
        viewController.timePerQuestion = timePerQuestion
        viewController.numberOfQuestions = numberOfQuestions
        viewController.mode = mode
        return viewController
    }
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareNavigationView()
        self.prepareThemeAndLocalization()
        self.countProgresView.progress = 0.0
        self.countProgresView.progressTintColor = AppTheme.current.mainColor
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.headerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 30)
        self.answer1Button.layer.cornerRadius = answer1Button.layer.bounds.height / 2
        self.answer2Button.layer.cornerRadius = answer1Button.layer.bounds.height / 2
        self.answer3Button.layer.cornerRadius = answer1Button.layer.bounds.height / 2
        self.answer4Button.layer.cornerRadius = answer4Button.layer.bounds.height / 2
    }
        
    //MARK: - User Interaction
    
    @IBAction func answerButton_Click(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            timer.invalidate()
            self.timerView.pauseAnimation()
            isAnswerRight(button: sender)
            sender.backgroundColor = AppTheme.current.cardOrange
            showRightAnswer()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { self.prepareNewQuestion() }
        case 2:
            timer.invalidate()
            self.timerView.pauseAnimation()
            isAnswerRight(button: sender)
            sender.backgroundColor = AppTheme.current.cardOrange
            showRightAnswer()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { self.prepareNewQuestion() }
        case 3:
            timer.invalidate()
            self.timerView.pauseAnimation()
            isAnswerRight(button: sender)
            sender.backgroundColor = AppTheme.current.cardOrange
            showRightAnswer()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { self.prepareNewQuestion() }
        case 4:
            timer.invalidate()
            self.timerView.pauseAnimation()
            isAnswerRight(button: sender)
            sender.backgroundColor = AppTheme.current.cardOrange
            showRightAnswer()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { self.prepareNewQuestion() }
        default: return
        }
    }
    
    @IBAction func closeButton_onClick(_ sender: Any) {
        let customAlert = QuizlerCustomAlertViewController()
        customAlert.show()
    }
    
    //MARK: - Utils
    
    func prepareNavigationView() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func prepareThemeAndLocalization() {
        self.view.backgroundColor = AppTheme.current.mainColor
        
        self.questionTitleLabel.text = questions[counter].questionTitle
        self.questionTitleLabel.textColor = AppTheme.current.bodyTextColor
        self.headerView.backgroundColor = AppTheme.current.containerColor
        
        self.answer1Button.backgroundColor = AppTheme.current.containerColor
        self.answer1Button.setTitle(questions[counter].answers[0].answerText, for: .normal)
        self.answer1Button.setTitleColor(AppTheme.current.bodyTextColor, for: .normal)
        self.answer1Button.layer.cornerRadius = answer1Button.layer.bounds.height / 2
        self.answer1Button.isExclusiveTouch = true
        
        self.answer2Button.backgroundColor = AppTheme.current.containerColor
        self.answer2Button.setTitle(questions[counter].answers[1].answerText, for: .normal)
        self.answer2Button.setTitleColor(AppTheme.current.bodyTextColor, for: .normal)
        self.answer2Button.layer.cornerRadius = answer2Button.layer.bounds.height / 2
        self.answer2Button.isExclusiveTouch = true
        
        self.answer3Button.backgroundColor = AppTheme.current.containerColor
        self.answer3Button.setTitle(questions[counter].answers[2].answerText, for: .normal)
        self.answer3Button.setTitleColor(AppTheme.current.bodyTextColor, for: .normal)
        self.answer3Button.layer.cornerRadius = answer3Button.layer.bounds.height / 2
        self.answer3Button.isExclusiveTouch = true
        
        if questions[counter].answers.count <= 3 { self.answer4Button.isHidden = true } else {
            self.answer4Button.isHidden = false
            self.answer4Button.backgroundColor = AppTheme.current.containerColor
            self.answer4Button.setTitle(questions[counter].answers[3].answerText, for: .normal)
            self.answer4Button.setTitleColor(AppTheme.current.bodyTextColor, for: .normal)
            self.answer4Button.layer.cornerRadius = answer4Button.layer.bounds.height / 2
            self.answer4Button.isExclusiveTouch = true
        }
        
        self.view.isUserInteractionEnabled = true
        self.timerCount = timePerQuestion
        self.timerValueLabel.text = "\(timerCount)"
        self.timerValueLabel.textColor = AppTheme.current.bodyTextColor
        self.view.makeCircleLayer(onView: timerView, withShapeLayer: shapeLayer, label: timerValueLabel, defaultTimeRemaining: timerCount, timeRemaining: timerCount)
        self.closeButton.backgroundColor = AppTheme.current.mainColor
        self.closeButton.imageView?.tintColor = AppTheme.current.containerColor
        self.closeButton.layer.cornerRadius = closeButton.layer.bounds.width / 2
        self.closeButton.clipsToBounds = true
        self.coinView.layer.cornerRadius = 10
        self.coinView.backgroundColor = .clear
        self.coinResultLabel.text = "\(score)"
        self.coinResultLabel.textColor = AppTheme.current.bodyTextColor
        self.quizlerPopUpView.isHidden = true
        self.quizlerPopUpContainerView.isHidden = true
        
        self.timerView.backgroundColor = UIColor.clear
        timer.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(QuizViewController.timerClass),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func timerClass() {
        timerCount -= 1
        timerValueLabel.text = String(timerCount)
        
        if timerCount == 0 {
            timer.invalidate()
            self.showRightAnswer()
            self.fibiCount = 0
            self.score += calculateScore(numCorrectAnswers: fibiCount)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { self.prepareNewQuestion() }
        }
    }
    
    func showRightAnswer() {

        if questions[counter].answers.count <= 3 {
            let buttons: [UIButton] = [answer1Button, answer2Button, answer3Button]
            let answers: [AnswerModel] = [questions[counter].answers[0], questions[counter].answers[1], questions[counter].answers[2]]
            let indexOfTrueAnswer = answers.firstIndex{$0.isCorrect == true}
            for (index, button) in buttons.enumerated() {
                if index == indexOfTrueAnswer { button.backgroundColor = AppTheme.current.geographyColor }
            }
        } else {
            let buttons: [UIButton] = [answer1Button, answer2Button, answer3Button, answer4Button]
            let answers: [AnswerModel] = [questions[counter].answers[0], questions[counter].answers[1], questions[counter].answers[2], questions[counter].answers[3]]
            let indexOfTrueAnswer = answers.firstIndex{ $0.isCorrect == true }
            for (index, button) in buttons.enumerated() {
                if index == indexOfTrueAnswer { button.backgroundColor = AppTheme.current.geographyColor }
            }
        }
        
        self.view.isUserInteractionEnabled = false
        counter += 1
    }
    
    func isAnswerRight(button: UIButton) {
        
        if !questions.isEmpty {
            if questions[counter].answers.count <= 3 {
                let answers: [AnswerModel] = [questions[counter].answers[0], questions[counter].answers[1], questions[counter].answers[2]]
                guard let rightAnswer = answers.filter({ $0.isCorrect == true }).first else { return }
                if button.titleLabel?.text == rightAnswer.answerText {
                    ProgressHUD.showSucceed()
                    self.countNumberOfCorrectAnswers += 1
                    self.fibiCount += 1
                    self.score += calculateScore(numCorrectAnswers: self.fibiCount)
                } else {
                    ProgressHUD.showFailed()
                    self.fibiCount = 0
                    self.score += calculateScore(numCorrectAnswers: fibiCount)
                }
            } else {
                let answers: [AnswerModel] = [questions[counter].answers[0], questions[counter].answers[1], questions[counter].answers[2], questions[counter].answers[3]]
                guard let rightAnswer = answers.filter({ $0.isCorrect == true }).first else { return }
                if button.titleLabel?.text == rightAnswer.answerText {
                    ProgressHUD.showSucceed()
                    self.countNumberOfCorrectAnswers += 1
                    self.fibiCount += 1
                    self.score += calculateScore(numCorrectAnswers: self.fibiCount)
                } else {
                    ProgressHUD.showFailed()
                    self.fibiCount = 0
                    self.score += calculateScore(numCorrectAnswers: fibiCount)
                }
            }
            
        }
    }
    
    private func updateUIOnStateChange() {
        self.coinResultLabel.text = "\(score)"
        self.setUpProgressView(for: counter)
    }
    
    func setUpProgressView(for countValue: Int) {
        countProgresView.setProgress(Float(countValue) / Float(numberOfQuestions), animated: true)
    }
    
    func prepareNewQuestion() {
        if !questions.isEmpty {
            if counter == questions.count {
                DispatchQueue.main.async {
                    self.view.isUserInteractionEnabled = true
                    self.quizlerPopUpView.configure(with: self.score, numberOfAnsers: self.countNumberOfCorrectAnswers, countOfAnswers: self.numberOfQuestions, mode: self.questions.first?.categoryId)
                    self.quizlerPopUpView.isHidden = false
                    self.quizlerPopUpContainerView.isHidden = false
                    self.quizlerPopUpContainerView.backgroundColor = AppTheme.current.backgroundColor.withAlphaComponent(0.7)
                    self.quizlerPopUpView.delegate = self
                }
            } else {
                self.prepareThemeAndLocalization()
            }
        }
    }
    
    func calculateScore(numCorrectAnswers: Int) -> Int {
        if numCorrectAnswers == 0 {      return 0 }
        else if numCorrectAnswers == 1 { return 1 }
        
        var fib1 = 0
        var fib2 = 1
        var currentFib = 1
        
        for _ in 2...numCorrectAnswers {
            currentFib = fib1 + fib2
            fib1 = fib2
            fib2 = currentFib
        }
        
        return currentFib
    }
    
    // MARK: - User Interaction
    
    @IBAction func reportButtonTouched(_ sender: Any) {
        print("Dugme stisnuto bajo")
    }
}

//MARK: - SendScoreButtonDelegate
extension QuizViewController: SendScoreButtonDelegate {
    
    func sendScore(username: String) {
        apiPostRequestScore(username: username, mode: mode, score: score) { message in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                    FlowManager.presentMainScreen()
                })
                self.present(alert, animated: false)
            }
        }
    }
    
//MARK: - API
    
    func apiPostRequestScore(username: String, mode: String, score: Int, _ callback: @escaping (String) -> Swift.Void) {
        let loader = LoaderView.create(for: self.view)
        AppGlobals.herokuRESTManager.requestPostScore(username: username, mode: mode, score: score) { result in
            loader.dismiss()
            switch result {
            case .success: callback("Tvoj rezultat je zabelezen")
            case .failure: callback("Greska pri slanju rezultata")
            }
        }
    }
}


