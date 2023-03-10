//
//  QuestionModel.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 7/14/21.
//

import Foundation


class QuestionModel: JSONSerializable, Equatable {

    //Required
    let numberOfTimesReported: Int
    let id: String
    let questionTitle: String
    let countAnsweredCorrect: Int
    let countAnsweredWrong: Int
    let answers: [AnswerModel]
    let categoryId: String
    let isApproved: Bool
    
    
    //MARK: - Init
    ///Default constructor
    
    init(numberOfTimesReported: Int, id: String, questionTitle: String, countAnsweredCorrect: Int, countAnsweredWrong: Int, answers: [AnswerModel], categoryId: String, isApproved: Bool) {
        self.numberOfTimesReported = numberOfTimesReported
        self.id = id
        self.questionTitle = questionTitle
        self.countAnsweredCorrect = countAnsweredCorrect
        self.countAnsweredWrong = countAnsweredWrong
        self.answers = answers
        self.categoryId = categoryId
        self.isApproved = isApproved
    }
    
    //MARK: - JSONSerializable
    
    /// JSON Constructor
    /// - Parameter dictionary: NSDictionary representing JSON response from the server side or some other source.
    required init?(_ dictionary: NSDictionary?) {
        guard
            let dictionary             = dictionary,
            let numberOfTimeesReported = dictionary.value(forKeyPath: "numberOfTimesReported") as? Int,
            let id                     = dictionary.value(forKeyPath: "_id") as? String,
            let questionTitle          = dictionary.value(forKeyPath: "text") as? String,
            let isApproved             = dictionary.value(forKeyPath: "isApproved") as? Bool,
            let countAnsweredCorrect   = dictionary.value(forKeyPath: "countAnsweredCorrect") as? Int,
            let countAnsweredWrong     = dictionary.value(forKeyPath: "countAnsweredWrong") as? Int,
            let answerDictionaries     = dictionary.value(forKeyPath: "answers") as? [NSDictionary],
            let categoryId             = dictionary.value(forKeyPath: "categoryId") as? String
            
        else {
            return nil
        }
        
        self.numberOfTimesReported = numberOfTimeesReported
        self.id = id
        self.questionTitle = questionTitle
        self.isApproved    = isApproved
        self.countAnsweredCorrect = countAnsweredCorrect
        self.countAnsweredWrong = countAnsweredWrong
        self.answers       = answerDictionaries.compactMap({ AnswerModel($0) })
        self.categoryId    = categoryId
        
    }
    
    
    /// Function will convert instance into NSDictionary.
    /// - Returns: NSDictionary with all key values set to JSON corresponding fields.
    func serialize() -> NSDictionary {
        // Required
        let dictionary: NSMutableDictionary = [
            "text"      : questionTitle,
            "answers"   : answers.serialize(),
            "categoryId": categoryId,
            "isApproved": isApproved
        ]
        return dictionary
    }
    
    // MARK: - Equatable
    
    static func == (lhs: QuestionModel, rhs: QuestionModel) -> Bool {
        return lhs.questionTitle == rhs.questionTitle
    }
    
    var percentage: Double {
        return Double(countAnsweredCorrect) / Double(countAnsweredWrong) * 100
    }
    
}

class AnswerModel: JSONSerializable, Equatable {

    let answerText: String
    let isCorrect: Bool
    let id: String
    
    
    // MARK: Init
        
    /// Default constructor
    init(answerText: String, isCorrect: Bool, id: String) {
        self.answerText = answerText
        self.isCorrect = isCorrect
        self.id = id
    }
    
    // MARK: - JSONSerializable
    
    /// JSON Constructor
    /// - Parameter dictionary: NSDictionary representing JSON response from the server side or some other source.
    required init?(_ dictionary: NSDictionary?) {
        //Required
        guard
            let dictionary = dictionary,
            let answerText = dictionary.value(forKeyPath: "text")      as? String,
            let isCorrect  = dictionary.value(forKeyPath: "isCorrect") as? Bool,
            let id         = dictionary.value(forKeyPath: "_id") as? String
        else {
            return nil
        }
        
        self.answerText = answerText
        self.isCorrect = isCorrect
        self.id = id
    }
    
    func serialize() -> NSDictionary {
        // Required
        let dictionary: NSMutableDictionary = [
            "text"      : answerText,
            "isCorrect" : isCorrect
        ]
        //return
        return dictionary
    }
    
    // MARK: - Equatable
    
    static func == (lhs: AnswerModel, rhs: AnswerModel) -> Bool {
        return lhs.answerText == rhs.answerText
    }

    
}
