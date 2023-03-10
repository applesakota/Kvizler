//
//  CategoryModel.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 7/15/21.
//

import Foundation

class CategoryModel: JSONSerializable, Equatable {

    //MARK: - Globals

    let id: String
    let name: String
    let submodes: [SubMode]
    
    //MARK: - Init
    
    /// Default constructor
    init(id: String, name: String, submodes: [SubMode]) {
        self.id = id
        self.name = name
        self.submodes = submodes
    }
 
    // MARK: - JSONSerializable
    
    ///JSON Constructor
    /// - Parameter dictionary: NSDictionary representing JSON response from server side or other source
    required init?(_ dictionary: NSDictionary?) {
        // Required
        guard
            let dictionary         = dictionary,
            let id                 = dictionary.value(forKeyPath: "_id") as? String,
            let name               = dictionary.value(forKeyPath: "name") as? String,
            let submodesDictionary = dictionary.value(forKeyPath: "submodes") as? [NSDictionary]
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.submodes = submodesDictionary.compactMap({ SubMode($0) })
    }
    
    
    ///Function will convert instance int NSDictionary
    /// - Returns: NSDictionary with all key values set to JSON corresponding fields.
    func serialize() -> NSDictionary {
        // Required
        let dictionary: NSDictionary = [
            "_id" : id,
            "name" : name
        ]
        
        return dictionary
    }
    
    
    static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.id == rhs.id
    }
}
