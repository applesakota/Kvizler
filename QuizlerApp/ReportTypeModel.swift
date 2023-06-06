//
//  ReportTypeModel.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 5/13/23.
//

import Foundation

class ReportTypeModel: JSONSerializable, Equatable {

    // Required
    let id: String
    let type: String
    
    //Default Constructor
    init(id: String, type: String) {
        self.id = id
        self.type = type
    }
    
    // MARK: - JSONSerializable
    
    ///JSON Constructor
    /// - Parameter dictionary: NSDictionary representing JSON response from server side or other source
    required init?(_ dictionary: NSDictionary?) {
        guard
            let dictionary = dictionary,
            let id         = dictionary.value(forKeyPath: "_id") as? String,
            let type       = dictionary.value(forKeyPath: "type") as? String
        else {
            return nil
        }
        
        self.id = id
        self.type = type
    }
    
    func serialize() -> NSDictionary {
        let dictionary: NSMutableDictionary = [
            "_id": id,
            "type": type
        ]
        return dictionary
    }
    
    
    //MARK: - Equatable
    static func == (lhs: ReportTypeModel, rhs: ReportTypeModel) -> Bool {
        lhs.id == rhs.id
    }
    
    
}
