//
//  QuizlerTableViewCell.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 2/12/23.
//

import UIKit

class QuizlerTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Globals
    
    class var identifier: String { return "QuizlerTableViewCell" }
    
    @IBOutlet weak var tableViewCellWarningView: UIView!
    @IBOutlet weak var tableViewCellTitleLabel: UILabel!
    @IBOutlet weak var tableViewCellHeaderView: UIView!
    @IBOutlet weak var tableViewCollectionView: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundCellView: UIView!
    
    var dataSource: [SubMode] = []
    var questionsViewModel: QuestionsViewModel?
    
    //MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupCollectionView()
        
    }
    
    private func setupCollectionView() {

        tableViewCollectionView.dataSource = self
        tableViewCollectionView.delegate = self
        let nib = UINib(nibName: HomeCollectionViewCell.identifier, bundle: nil)
        tableViewCollectionView.register(nib, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with title: String, description: String, data: [SubMode]?, questions: QuestionsViewModel?) {
        self.setupCollectionView()
        self.backgroundColor = AppTheme.current.backgroundColor
        self.tableViewCollectionView.backgroundColor = UIColor.clear
        self.tableViewCollectionView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        self.tableViewCellTitleLabel.text = title
        self.tableViewCellTitleLabel.textColor = AppTheme.current.bodyTextColor
        self.tableViewCellHeaderView.backgroundColor = AppTheme.current.cellColor
        self.backgroundCellView.backgroundColor = AppTheme.current.cellBackgroundColor
        self.descriptionLabel.text = description
        self.descriptionLabel.textColor = AppTheme.current.bodyTextColor
        self.tableViewCellWarningView.backgroundColor = .clear
        self.backgroundCellView.layer.cornerRadius = 20
        self.backgroundColor = UIColor.clear
        if let dataSource = data {
            self.dataSource = dataSource
        }
        if let questions = questions {
            self.questionsViewModel = questions
        }
        self.tableViewCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
            
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell {
            cell.setTheme(with: dataSource[indexPath.item])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        
        if model.name == "easy" {
            self.presentQuestionViewController(questions: self.questionsViewModel!.easyQuestions, numberOfQuestions: 20, timePerQuestion: model.timePerQuestion)
        } else if model.name == "medium" {
            DispatchQueue.main.async {
                self.presentQuestionViewController(questions: self.questionsViewModel!.mediumQuestions, numberOfQuestions: model.numberOfQuestions, timePerQuestion: model.timePerQuestion)
            }
        } else if model.name == "hard" {
            DispatchQueue.main.async {
                self.presentQuestionViewController(questions: self.questionsViewModel!.hardQuestions, numberOfQuestions: model.numberOfQuestions, timePerQuestion: model.timePerQuestion)
            }
        } else if model.name == "zen" {
            DispatchQueue.main.async {
                self.presentQuestionViewController(questions: self.questionsViewModel!.fetchZenQuestions(numberOfQuestions: model.numberOfQuestions), numberOfQuestions: model.numberOfQuestions, timePerQuestion: model.timePerQuestion)
            }
        } else if model.name == "exam" {
            DispatchQueue.main.async {
                self.presentQuestionViewController(questions: self.questionsViewModel!.fetchExamQuestions(numberOfQuestions: model.numberOfQuestions), numberOfQuestions: model.numberOfQuestions, timePerQuestion: model.timePerQuestion)
            }
        } else if model.name == "marathon" {
            DispatchQueue.main.async {
                self.presentQuestionViewController(questions: self.questionsViewModel!.fetchMarathonQuestions(numberOfQuestions: model.numberOfQuestions), numberOfQuestions: model.numberOfQuestions, timePerQuestion: model.timePerQuestion)
            }
        }  else {
            DispatchQueue.main.async {
                self.presentQuestionViewController(questions: self.questionsViewModel!.fetchCategoryQuestions(id: model.id), numberOfQuestions: model.numberOfQuestions, timePerQuestion: model.timePerQuestion)
            }
        }
    }
    
    func presentQuestionViewController(questions: [QuestionModel], numberOfQuestions: Int, timePerQuestion: Int) {
        let viewController = QuizViewController.instantiate(questions: questions, numberOfQuestions: numberOfQuestions, timePerQuestion: timePerQuestion)
        self.parentViewController?.navigationController?.pushViewController(viewController, animated: false)
    }

}

