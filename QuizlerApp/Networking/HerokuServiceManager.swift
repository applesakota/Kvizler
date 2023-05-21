//
//  MongoDBServiceManager.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/9/21.
//

import Foundation
import RealmSwift


// Private class that will do all Heroku DB havy lifting for us and wrap functionality in single place.
class HerokuServiceManager: HerokuService {


    //Global shared instance should be used inside application
    static let shared = HerokuServiceManager()
    
    init() {}
    //MARK: - Public API
    

    //Logout implementation
    func executeLogout(_ callback: @escaping (Result<(), Error>) -> Void) {

    }
    
    func executeRefreshToken(_ callback: @escaping (Result<(accessToken: String, refreshToken: String), Error>) -> Void) {
        
    }
    
    ///Question request implementation
    func executePostQuestion(body: NSDictionary, _ callback: @escaping DataCallBack) {
        let url = URL(string: "\(RESTManager.shared.server)/questions")!
        let request = RESTManager.RESTRequest(session: URLSession.shared, url: url, method: .post)
        request.setBody(body: body)
        request.execute(callback)
    }
        
    ///Modes request implementation
    func executeGetModes(_ callback: @escaping DataCallBack) {
        let url = URL(string: "\(RESTManager.shared.server)/modes")!
        let request = RESTManager.RESTRequest(session: URLSession.shared, url: url, method: .get)
        request.execute(callback)
    }
    
    func executeGetQuestions(_ callback: @escaping DataCallBack) {
        let url = URL(string: "\(RESTManager.shared.server)/questions")!
        let request = RESTManager.RESTRequest(session: URLSession.shared, url: url, method: .get)
        request.execute(callback)
    }
    
    func executeGetScores(_ callback: @escaping DataCallBack) {
        let url = URL(string: "\(RESTManager.shared.server)/scores")!
        let request = RESTManager.RESTRequest(session: URLSession.shared, url: url, method: .get)
        request.execute(callback)
    }
    
    func executePostScore(username: String, mode: String, score: Int, _ callback: @escaping DataCallBack) {
        let url = URL(string: "\(RESTManager.shared.server)/scores")!
        let request = RESTManager.RESTRequest(session: URLSession.shared, url: url, method: .post)
        let body: NSMutableDictionary = [
            "username" : username,
            "mode"     : mode,
            "score"    : score
        ]
        request.setBody(body: body)
        request.execute(callback)
    }
    
    func executeGetErrorTypes(_ callback: @escaping DataCallBack) {
        let url = URL(string: "\(RESTManager.shared.server)/report-types")!
        let request = RESTManager.RESTRequest(session: URLSession.shared, url: url, method: .get)
        request.execute(callback)
    }
    
    func executePostError(reportTypeId: String, questionId: String, _ callback: @escaping DataCallBack) {
        let url = URL(string: "\(RESTManager.shared.server)/invalid-question")!
        let request = RESTManager.RESTRequest(session: URLSession.shared, url: url, method: .post)
        let body: NSMutableDictionary = [
            "reportTypeId": reportTypeId,
            "questionId": questionId
        ]
        request.setBody(body: body)
        request.execute(callback)
    }
}
