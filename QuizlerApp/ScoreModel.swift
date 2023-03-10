//
//  ScoreModel.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 10/15/21.
//

import Foundation


class ScoreModel: JSONSerializable, Equatable {

    // MARK: - Globals
    
    //Required
    let id: String
    let username: String
    let score: Int
    let mode: String
    
    
    //Default Constructor
    init(id: String, username: String, score: Int, mode: String) {
        self.id = id
        self.username = username
        self.score = score
        self.mode = mode
    }
    
    // MARK: - JSONSerializable
    
    ///JSON Constructor
    /// - Parameter dictionary: NSDictionary representing JSON response from server side or other source
    required init?(_ dictionary: NSDictionary?) {
        guard
              let dictionary = dictionary,
              let id         = dictionary.value(forKeyPath: "_id") as? String,
              let username   = dictionary.value(forKeyPath: "username") as? String,
              let score      = dictionary.value(forKeyPath: "score") as? Int,
              let mode       = dictionary.value(forKeyPath: "mode") as? String
        else {
            return nil
        }
        
        self.id = id
        self.username = username
        self.score = score
        self.mode = mode
    }
    
    func serialize() -> NSDictionary {
        // Required
        let dictionary: NSDictionary = [
            "username": username,
            "score": score
        ]
        
        
        return dictionary
    }
    
    var scoreAsString: String {
        return "\(score)"
    }
    
    //MARK: - Equatable
    static func == (lhs: ScoreModel, rhs: ScoreModel) -> Bool {
        return lhs.username == rhs.username
    }
    
}
