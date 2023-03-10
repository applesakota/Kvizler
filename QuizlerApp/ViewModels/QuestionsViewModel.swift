//
//  QuestionsViewModel.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 3/8/23.
//

import Foundation

/// Class for creating view model from the QuestionModel
public class QuestionsViewModel {
    
    //MARK: - Globals
    let questions: [QuestionModel]
    
    init(questions: [QuestionModel]) {
        self.questions = questions
    }
    
    var easyQuestions: [QuestionModel] {
        return setDataSource(dataSource: questions.filter({ $0.percentage < 33 }), numberOfQuestions: 20)
    }
    
    var hardQuestions: [QuestionModel] {
        return setDataSource(dataSource: questions.filter({ $0.percentage > 66 }), numberOfQuestions: 20)
    }
    
    var mediumQuestions: [QuestionModel] {
        return setDataSource(dataSource: questions.filter({ $0.percentage > 33 && $0.percentage < 66 }), numberOfQuestions: 20)
    }
    
    func fetchCategoryQuestions(id: String) -> [QuestionModel] {
        return setDataSource(dataSource: questions.filter({ $0.categoryId == id }), numberOfQuestions: 20)
    }
    
    func fetchZenQuestions(numberOfQuestions: Int) -> [QuestionModel] {
        return setDataSource(dataSource: questions, numberOfQuestions: numberOfQuestions)
    }
    
    func fetchExamQuestions(numberOfQuestions: Int) -> [QuestionModel] {
        return setDataSource(dataSource: questions, numberOfQuestions: numberOfQuestions)
    }
    
    func fetchMarathonQuestions(numberOfQuestions: Int) -> [QuestionModel] {
        return setDataSource(dataSource: questions, numberOfQuestions: numberOfQuestions)
    }
    
    private func setDataSource(dataSource: [QuestionModel], numberOfQuestions: Int) -> [QuestionModel] {
        if dataSource.count < numberOfQuestions {
            return Array(questions.shuffled().prefix(numberOfQuestions))
        } else if dataSource.count >= numberOfQuestions {
            return Array(dataSource.shuffled().prefix(numberOfQuestions))
        }
        return Array(questions.shuffled().prefix(numberOfQuestions))
        
    }
    
}
