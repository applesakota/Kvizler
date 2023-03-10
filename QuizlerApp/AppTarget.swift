//
//  AppTarget.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 10/21/21.
//

import Foundation

enum AppTarget {
    
    
    /// Target name.
    static var name: String {
        return Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    }
    
}

