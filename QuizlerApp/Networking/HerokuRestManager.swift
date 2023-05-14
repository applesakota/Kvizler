//
//  HerokuRestManager.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 7/2/21.
//

import Foundation


class HerokuRestManager {
    
    //MARK: Globals
    
    static let shared = HerokuRestManager(service: HerokuServiceManager.shared, storage: AppGlobals.standardLocalStorage)
    
    private let service: HerokuService
    private let storage: LocalStorage
    private var isCachingEnabled = true
    
    //MARK: - Init
    
    //Constructor
    init(service: HerokuService, storage: LocalStorage) {
        self.service = service
        self.storage = storage
    }
    
    
    //MARK: Public API
    

    
    func executeRefreshToken(_ callback: @escaping (Result<(), Error>) -> Swift.Void) {

    }
    func executeLogout(_ callback: @escaping (Result<(), Error>) -> Void) {

    }

    func getQuestions(_ callback: @escaping (Result<([QuestionModel]), Error>) -> Swift.Void) {
        
        if isCachingEnabled, let models: [QuestionModel] = loadModelFromLocalStorageIfAny(hashKey: "all_questions") {
            callback(.success(models))
            print("fetched questions from local storage")
            return
        }
        
        //Execute api request
        service.executeGetQuestions { (result: RESTManager.ResponseResult<RESTManager.DiscardableServerModel>) in
            switch result.result {
            case .success:
                if let dictionary = result.rawData?.toDictionaries() {
                    let models = dictionary.compactMap { QuestionModel($0) }
                    self.storage.save(codable: models, key: "all_questions")
                    print("Successfuly fethced questions from server side")
                    callback(.success(models))
                }
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    
    func getModes(_ callback: @escaping (Result<[CategoryModel], Error>) -> Swift.Void) {
        
        if isCachingEnabled, let models: [CategoryModel] = loadModelFromLocalStorageIfAny(hashKey: "all_categories") {
            callback(.success(models))
            print("fetched categories from local storage")
            return
        }
        
        //Execute api request
        service.executeGetModes { (result: RESTManager.ResponseResult<RESTManager.DiscardableServerModel>) in
            switch result.result {
            case .success:
                if let dictionary = result.rawData?.toDictionaries() {
                    let models = dictionary.compactMap { CategoryModel($0) }
                    self.storage.save(codable: models, key: "all_categories")
                    print("Successfuly fethced questions from server side")
                    callback(.success(models))
                }
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    
    func getReportTypes(_ callback: @escaping (Result<[ReportTypeModel], Error>)->Swift.Void) {
        if isCachingEnabled, let models: [ReportTypeModel] = loadModelFromLocalStorageIfAny(hashKey: "all_report_types") {
            callback(.success(models))
            print("Seccessfuly fetchet report types from local storage")
            return
        }
        
        //Execute api request
        service.executeGetErrorTypes { (result: RESTManager.ResponseResult<RESTManager.DiscardableServerModel>) in
            switch result.result {
            case .success:
                if let dictionary = result.rawData?.toDictionaries() {
                    let models = dictionary.compactMap { ReportTypeModel($0) }
                    self.storage.save(codable: models, key: "all_report_types")
                    print("Seccessfuly fetched report types from server side")
                    callback(.success(models))
                }
            case .failure(let error):
                callback(.failure(error))
            }
        }
        
    }
    
    func getScores(_ callback: @escaping (Result<[ScoreModel], Error>)->Swift.Void) {
        // Execute api request
        service.executeGetScores { (result: RESTManager.ResponseResult<RESTManager.DiscardableServerModel>) in
            switch result.result {
            case .success:
                if let dictionary = result.rawData?.toDictionaries() {
                    let models = dictionary.compactMap({ ScoreModel($0) })
                    print("Seccessfuly fetchd scores from server side")
                    callback(.success(models))
                }
            case .failure(let error):
                callback(.failure(error))
            }
        }
        
    }
    
    func requestPostScore(username: String, mode: String, score: Int, _ callback: @escaping (Result<(), Error>)->Swift.Void ) {
        service.executePostScore(username: username, mode: mode, score: score) { (result: RESTManager.ResponseResult<RESTManager.DiscardableServerModel>) in
            switch result.result {
            case .success:
                callback(.success( ()) )
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    

    private func loadModelFromLocalStorageIfAny<T: Codable>(hashKey: String) -> T? {
        
        let model: T? = storage.loadCodable(hashKey)
        return model
    }
}
