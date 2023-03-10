//
//  RESTManager.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/22/21.
//

import Foundation

protocol JSONSerializable: Codable {
    
    /// JSON Constructor
    /// - Parameter dictionary: NSDictionary representing JSON response from server side or some other source
    init?(_ dictionary: NSDictionary?)
    
    /// Function will convert instance into NSDictionary.
    /// - Returns: NSDictionary with all key values set to JSON corresponding fields.
    func serialize() -> NSDictionary
    
}

//MARK: - RESTManager namespace

/// Contains all REST logic, networking processing
class RESTManager {
    
    // Globals
    var scheme = "https"
    var host = "quizler-server-instance.herokuapp.com"
    var isCachingEnabled: Bool = true
    
    //Global shared instance
    static let shared = RESTManager()
    
    //Hidden constructro
    private init() {}
    
    var server: String {
        return "\(scheme)://\(host)"
    }
}
