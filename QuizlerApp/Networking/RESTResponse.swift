//
//  RESTResponse.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/23/21.
//

import Foundation


extension RESTManager {
    
    struct ResponseResult<T: Decodable> {
        let result: Result<T?, Error>
        let rawData: Data?
        let statusCode: Int?
    }
    
    struct DiscardableServerModel: Decodable {
        // We don't care about data
    }
    
}
