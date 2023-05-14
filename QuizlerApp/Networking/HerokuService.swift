//
//  MongoDBService.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/9/21.
//

import Foundation

/// MongoDBService Provider definitions
/// Contains all requered interface methods that need to be provided by mongo db service provieder
protocol HerokuService {
    
    // Calback function that will be async executed once request is done
    typealias DataCallBack = (RESTManager.ResponseResult<RESTManager.DiscardableServerModel>) -> Void
        
    ///Function that should fetch and return all question categories
    /// - Parameter callback: Callback function that will be async executed once request is done.
    func executeGetModes(_ callback: @escaping DataCallBack)
    
    ///Function that should fetch and reeturn all questions
    /// - Parameter callback: Callback function that will be async executed once request is done
    func executeGetQuestions(_ callback: @escaping DataCallBack)
    
    ///Function that should fetch and reeturn all questions
    /// - Parameter callback: Callback function that will be async executed once request is done
    func executeGetScores(_ callback: @escaping DataCallBack)
    
    
    /// Function that should send request to post score for specific user
    /// - Parameters:
    ///    - username: username
    ///    - mode: Mode of the quiz
    ///    - score: Score of the quiz
    ///    - callback: Callback function that will be async executed once request is done
    func executePostScore(username: String, mode: String, score: Int, _ callback: @escaping DataCallBack )
    
    /// Function that should fetch and return all error types
    /// - Parameter:
    ///   - callback: Callback function that will be async executed once request is done.
    func executeGetErrorTypes(_ callback: @escaping DataCallBack)
    
    
    /// Function that should send request to post report type error for specific question
    /// - Parameters:
    ///    - reportTypeId: id of the report type
    ///    - questionId: Id of the specific question
    ///    - callback: Callback function that will be async executed once request is done
    func executePostError(reportTypeId: String, questionId: String, _ callback: @escaping DataCallBack)

}
