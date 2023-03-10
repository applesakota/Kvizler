//
//  UserModel.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/9/21.
//

import Foundation

/// User model, containts all functionalities related to one application, user.

class UserModel: JSONSerializable {

    
    // MARK: - Globals
    
    let id: String
    let email: String
    let username: String
    
    
    // MARK: - Init
    
    /// Default Constructor
    required init(email: String, username: String, id: String) {
        self.email = email
        self.username = username
        self.id = id
    }
    
    //MARK: - JSONSerializable
    
    ///JSON Constructor
    /// - Parameter dictionary: NSDictionary representing JSON response from the server side or some other source.
    required init?(_ dictionary: NSDictionary?) {
        guard
            let dictionary = dictionary,
            let email      = dictionary.value(forKey: "email") as? String,
            let username   = dictionary.value(forKey: "username") as? String,
            let id         = dictionary.value(forKey: "_id") as? String
        else {
            return nil
        }
        
        self.id = id
        self.email = email
        self.username = username
    }
    
    /// Function will convert instance to NSDictionary
    /// - Returns: NSDictionary with all key values set to JSON corresponding fields.
    func serialize() -> NSDictionary {
        // Required
        let dictionary: NSDictionary = [
            "_id" : id,
            "email": email,
            "username": username,
        ]
        //return
        return dictionary
    }
    
    
    /// Unique instance identifier
    var storageIdentifier: String { return email }
    
    
    // MARK: - Equatable
    
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.id == rhs.id
    }
}
