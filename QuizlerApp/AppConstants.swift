//
//  AppConstants.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/22/21.
//

import Foundation

enum AppConstants {
    
    
    // Authorization and RESTManger
    static func authAccessTokenKey() -> String {
        return "__auth_access_token_key__"
    }
    
    static func authRefreshTokenKey() -> String {
        return "__auth_refresh_token_key__"
    }
}
