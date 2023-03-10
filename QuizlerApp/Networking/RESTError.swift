//
//  RESTError.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/23/21.
//

import Foundation


extension RESTManager {
    
    struct ErrorWrapperObject: Decodable {
        let error: ErrorObject?
    }
    
    struct ErrorObject: Decodable {
        let message: String?
        let fields: GenericErrorObject?
        
        var errorMessage: String? {
            if let errors = fields {
                return errors.values.first
            }
            return message ?? nil
        }
    }
    
    struct GenericCodingKey: CodingKey {
        var intValue: Int?
        var stringValue: String
        
        init?(stringValue: String) { self.stringValue = stringValue }
        init?(intValue: Int) { self.intValue = intValue; self.stringValue = "\(intValue)" }
        
        static func makeKey(name: String) -> GenericCodingKey {
            return GenericCodingKey(stringValue: name)!
        }
    }
    
    struct GenericErrorObject: Decodable {
        var values: [String]
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: GenericCodingKey.self)
            values = [String]()
            for key in container.allKeys {
                let stringArray = try container.decode([String].self, forKey: key)
                values = values + stringArray
            }
        }
    }
    
    
    
    
    enum Errors {
        class Network: LocalizedError {
            public var errorDescription: String? {
                return NSLocalizedString("Network conectivity issue", comment: "Network")
            }
        }
        
        class Client: LocalizedError {
            private let message: String?
            private let statusCode: Int
            
            init(message: String?, statusCode:Int) {
                self.message = message
                self.statusCode = statusCode
            }
            
            public var errorDescription: String? {
                return NSLocalizedString(message ?? "Generic Error", comment: "Client")
            }
        }
        
        class Unknown: LocalizedError {
            public var errorDescription: String? {
                return NSLocalizedString("Backand Issue", comment: "Unknown")
            }
        }
        class Server: LocalizedError {
            public var errorDescription: String? {
                return NSLocalizedString("Server Issue", comment: "Server")
            }
        }
        
        class InvalidData: LocalizedError {
            public var errorDescription: String? {
                return NSLocalizedString("Invalid Data", comment: "Invalid Data")
            }
        }
        
        
    }
    
}
