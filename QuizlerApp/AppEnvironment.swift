//
//  AppEnvironment.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/5/21.
//

import Foundation

/// Aplication Environment. Contain 2 environments, local and dev
enum AppEnvironment {
    
    /// Local environment represents dummy content and mocked data. There is no server side here.
    case local
    
    /// Development environment.
    /// - note: Should be used on feature/bugfix branches.
    case development
    
    /// Returns current executing application environment
    static var current: AppEnvironment {
        switch identifier {
        case "development": return .development
        default:            return .local
        }
        
    }
    
    /// Environment identifier
    static var identifier: String {
        return Bundle.main.infoDictionary!["Environment Identifier"] as! String
    }
    
    /// Server side api url's host component.
    var host: String {
        switch self {
        case .development: return ""
        default:           return "local"
        }
    }
}
