//
//  LocalCommonRESTService.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 7/21/21.
//

import Foundation

//Private class that will do all Heroku havy lifting for us and wrap functionality in single place
class LocalCommonRESTService: HerokuService {

    

    

    

            
    //MARK: - Globals
    
    //Global shared instance should be used inside application
    static let shared = LocalCommonRESTService()
    
    //MARK: - Init
    
    private init() {
        
    }
    
    //MARK: - API
    
    
    
    
    func executeRegister(body: NSDictionary, _ callback: @escaping DataCallBack) {
        
    }
    
    func executeLogin(body: NSDictionary, _ callback: @escaping DataCallBack) {
        
    }
    
    func executeLogout(_ callback: @escaping (Result<(), Error>) -> Void) {
        
    }
    
    func executeRefreshToken(_ callback: @escaping (Result<(accessToken: String, refreshToken: String), Error>) -> Void) {
        
    }
    
    func executeGetCategories(_ callback: @escaping DataCallBack) {
        
    }
    
    func executeGetDifficulty(_ callback: @escaping DataCallBack) {
        
    }
    
    func executeGetLength(_ callback: @escaping DataCallBack) {
        
    }
    
    func executeRequestQuestion(body: NSDictionary, _ callback: @escaping DataCallBack) {
        
    }
    
    func executeGetModes(_ callback: @escaping DataCallBack) {
        
    }
    
    func executeGetScores(_ callback: @escaping DataCallBack) {
        
    }
    
    func executeGetQuestions(_ callback: @escaping DataCallBack) {
        
        //Create dummy model
//        let dataModel = [
//            QuestionModel(questionTitle: "Prvo pitanje",
//                           answers: [
//                            AnswerModel(answerText: "Prvi odgovor", isCorrect: false),
//                            AnswerModel(answerText: "Drugi odgovoor", isCorrect: true),
//                            AnswerModel(answerText: "Treci odgovor", isCorrect: false),
//                            AnswerModel(answerText: "Cetvrti odgovor", isCorrect: false)
//                           ], categoryId: "istorija", isApproved: false
//            ),
//            QuestionModel(questionTitle: "Drugo pitanje",
//                           answers: [
//                            AnswerModel(answerText: "Prvi odgovor", isCorrect: false),
//                            AnswerModel(answerText: "Drugi odgovoor", isCorrect: false),
//                            AnswerModel(answerText: "Treci odgovor", isCorrect: true),
//                            AnswerModel(answerText: "Cetvrti odgovor", isCorrect: false)
//                           ], categoryId: "istorija", isApproved: false
//            ),
//            QuestionModel(questionTitle: "Trece pitanje",
//                           answers: [
//                            AnswerModel(answerText: "Prvi odgovor", isCorrect: false),
//                            AnswerModel(answerText: "Drugi odgovoor", isCorrect: false),
//                            AnswerModel(answerText: "Treci odgovor", isCorrect: false),
//                            AnswerModel(answerText: "Cetvrti odgovor", isCorrect: true)
//                           ], categoryId: "Neki unique id",isApproved: false
//            ),
//            QuestionModel(questionTitle: "Cetvrto pitanje",
//                           answers: [
//                            AnswerModel(answerText: "Prvi odgovor", isCorrect: true),
//                            AnswerModel(answerText: "Drugi odgovoor", isCorrect: false),
//                            AnswerModel(answerText: "Treci odgovor", isCorrect: false),
//                            AnswerModel(answerText: "Cetvrti odgovor", isCorrect: false)
//                           ], categoryId: "istorija",isApproved: false
//            ),
//            QuestionModel(questionTitle: "Peto pitanje",
//                           answers: [
//                            AnswerModel(answerText: "Prvi odgovor", isCorrect: false),
//                            AnswerModel(answerText: "Drugi odgovoor", isCorrect: true),
//                            AnswerModel(answerText: "Treci odgovor", isCorrect: false),
//                            AnswerModel(answerText: "Cetvrti odgovor", isCorrect: false)
//                           ], categoryId: "istorija",isApproved: false
//            ),
//            QuestionModel(questionTitle: "Sesto pitanje",
//                           answers: [
//                            AnswerModel(answerText: "Prvi odgovor", isCorrect: false),
//                            AnswerModel(answerText: "Drugi odgovoor", isCorrect: false),
//                            AnswerModel(answerText: "Treci odgovor", isCorrect: true),
//                            AnswerModel(answerText: "Cetvrti odgovor", isCorrect: false)
//                           ], categoryId: "istorija",isApproved: false
//            )
//        ]
//
        // Serialize models into dictionary (so we dont need to handle keys
//        let dictionaries = dataModel.map({ $0.serialize() })
        
//        let data = try? JSONSerialization.data(withJSONObject: dictionaries, options: .prettyPrinted)
//        
//        //Create response
//        let result = RESTManager.ResponseResult<RESTManager.DiscardableServerModel>(
//            result: .success(nil),
//            rawData: data,
//            statusCode: 200
//        )
//        
//        callback(result)
    }
    
    func executeGetLengthQuestions(id: String, _ callback: @escaping DataCallBack) {
        
    }
    
    func executeGetDifficultyQuestions(id: String, _ callback: @escaping DataCallBack) {
        
    }
    
    func executeGetScoreboard(userId: String, categoryId: String, _ callback: @escaping DataCallBack) {
        
    }
    
    func executePostScore(username: String, mode: String, score: Int, _ callback: @escaping DataCallBack) {
        
    }
    
    func executeGetErrorTypes(_ callback: @escaping DataCallBack) {
        
    }
    
    func executePostError(reportTypeId: String, questionId: String, _ callback: @escaping DataCallBack) {
    
    }
    
    func executePostQuestion(body: NSDictionary, _ callback: @escaping DataCallBack) {
        
    }
}
