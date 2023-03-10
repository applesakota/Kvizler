//
//  LocalStorage+UserDefaults.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 10/21/21.
//

import Foundation

/// We don't need to create UserDefaults wrapper, we can just use extension.
extension UserDefaults {
    
    /// - Parameter keyword: If given key contains part of the keyword text it will be removed, if provided keyword is `empty` all items will be removed.
    func delete(matching keyword: String) -> Bool {
        var flag = false
        if let keys = (self.dictionaryRepresentation() as NSDictionary).allKeys as? [String] {
            for key in keys {
                if keyword.isEmpty || key.contains(keyword) {
                    self.removeObject(forKey: key)
                    flag = true
                }
            }
        }
        return flag
    }
}
