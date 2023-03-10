//
//  DifficultyModel.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 7/15/21.
//

import Foundation

class DifficultyModel: JSONSerializable, Equatable {

    //MARK: - Globals

    let id: String
    let name: String
    let numberOfQuestions: Int
    let timePerQuestion: Int
    let numberOfHints: Int
    
    
    //MARK: - Init
    
    /// Default constructor
    init(id: String, name: String, numberOfQuestions: Int, timePerQuestion: Int, numberOfHints: Int) {
        self.id = id
        self.name = name
        self.numberOfQuestions = numberOfQuestions
        self.timePerQuestion = timePerQuestion
        self.numberOfHints = numberOfHints
    }
 
    // MARK: - JSONSerializable
    
    ///JSON Constructor
    /// - Parameter dictionary: NSDictionary representing JSON response from server side or other source
    required init?(_ dictionary: NSDictionary?) {
        // Required
        guard
            let dictionary        = dictionary,
            let id                = dictionary.value(forKeyPath: "_id") as? String,
            let name              = dictionary.value(forKeyPath: "name") as? String,
            let numberOfQuestions = dictionary.value(forKeyPath: "numOfQuestions") as? Int,
            let timePerQuestion   = dictionary.value(forKeyPath: "timePerQuestion") as? Int,
            let numberOfHints     = dictionary.value(forKeyPath: "numOfHints") as? Int
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.numberOfQuestions = numberOfQuestions
        self.timePerQuestion = timePerQuestion
        self.numberOfHints = numberOfHints
    }
    
    
    ///Function will convert instance int NSDictionary
    /// - Returns: NSDictionary with all key values set to JSON corresponding fields.
    func serialize() -> NSDictionary {
        // Required
        let dictionary: NSDictionary = [
            "_id" : id,
            "name" : name,
            "numOfQuestions": numberOfQuestions,
            "timePerQuestion": timePerQuestion,
            "numOfHints": numberOfHints,
        ]
        
        return dictionary
    }
    
    //MARK: - Equatable
    
    static func == (lhs: DifficultyModel, rhs: DifficultyModel) -> Bool {
        return lhs.id == rhs.id
    }
}
