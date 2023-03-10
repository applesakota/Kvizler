//
//  LocalStorage.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/22/21.
//

import Foundation

enum Storage {
    
    //MARK: - Storage Types
    
    /// UserDefauls, best for smaller data chunks.
    case userDefaults(UserDefaults)
    
    /// KeychainWrapper for storing sensitive data
    case keychain(KeychainWrapper)
    
    // MARK: - Public API
    
    /// - Parameters:
    ///   - value: Specific value of generic AnyHashtable type
    ///   - key:String identifier
    /// - Returns: Returns true if data was saved proprly
    func set(_ value: AnyHashable, key: String) -> Bool {
        switch self {
        case .userDefaults(let userDefaults):
            if value is NSNull {
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.setValue(value, forKey: key)
            }
            return true
            
        case .keychain(let keychain):
            if value is NSNull {
                return keychain.removeObject(forKey: key)
            } else {
                if let array = value as? NSArray {
                    let dictionary: NSMutableDictionary = [:]
                    for (index, element) in array.enumerated() {
                        dictionary[ "\(index)" ] = element
                    }
                    return keychain.save(value: ["nsarray": dictionary ], key: key)
                }
                return keychain.save(value: ["data": value], key: key)
            }
        }
    }
    
    /// - Parameter key: String identifier.
    /// - Returns: Returns stored value as AnyHashable, that need to be casted to specific type.
    func get(_ key: String) -> AnyHashable? {
        switch self {
        case .userDefaults(let userDefaults):
            return userDefaults.value(forKey: key) as? AnyHashable
            
        case .keychain(let keychain):
            let storedObject = keychain.load(key: key)
            if let value = storedObject?.value(forKey: "data") as? AnyHashable {
                return value
            }
            if let nsarrayDictionary = storedObject?.value(forKey: "nsarray") as? NSDictionary {
                let array: NSMutableArray = []
                for (_, value) in nsarrayDictionary {
                    array.add(value)
                }
                return array
            }
            return nil
        }
    }
    
    /// Abstract delete function that will try to remove item for given keyword,
    /// If there are more than one matches, all items will be removed
    /// - Parameter keyword: Value that can be specific key or just part of different keys that need to be removed.
    /// - Returns: Returns `true` if some data was deleted.
    func delete(matching keyword: String) -> Bool {
        switch self {
        case .userDefaults(let userDefaults):
            return userDefaults.delete(matching: keyword)
        case .keychain(let keychaing):
            return keychaing.delete(matching: keyword)
        }
    }
}





