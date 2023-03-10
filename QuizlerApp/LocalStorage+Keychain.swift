//
//  LocalStorage+Keychain.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 10/19/21.
//

import Foundation

/// KeychainWrapper is imple utility class that wraps Keychain functionalitty and provides of handling sensitive data.
class KeychainWrapper {
    
    private(set) var identifier: String
    
    init(identifier: String) {
        self.identifier = identifier
    }
    
    
    /// Keychain set function will store specific value in Kaychain at provided key
    /// - Parameters:
    /// - value: Specific value of generic AnyHashtable type.
    /// - key: `String` identifier
    /// - Returns: Returns `true` if data is saved properly.
    func save(value: NSDictionary, key: String) -> Bool {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true) else { return false }
        
        //Create query
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : "\(identifier):\(key)",
            kSecValueData as String   : data
        ] as [ String : Any ]
        
        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil) == noErr
        
    }
    
    
    /// Keychain get method that will return speciffic value savet at provided key if any
    /// - Parameter key: `String` identifier
    /// - Returns : Returns stored property value as `AnyHashable`, that need to be casted to specific type.
    func load(key: String) -> NSDictionary? {
        //Create query
        let query: [String : Any] = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : "\(identifier):\(key)",
            kSecReturnData as String  : true,
            kSecMatchLimit as String  : kSecMatchLimit
        ]
        
        var dataTypeRef: AnyObject? = nil
        SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if let data = dataTypeRef as? Data {
            do {
                return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    ///Keychain removeObject method that will try to remove object for given key
    /// - Parameter key: `String` identifier.
    /// - Returns: Returns `true` if data was removed properly
    func removeObject(forKey key: String) -> Bool {
        //Create query
        let query: [String: Any] = [
            kSecClass as String            : kSecClassGenericPassword,
            kSecReturnAttributes as String : true,
            kSecReturnRef as String        : true,
            kSecMatchLimit as String       : kSecMatchLimit
        ]
        
        var result: AnyObject?
        
        let lastResultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        if lastResultCode == noErr {
            if let array = result as? [NSDictionary] {
                for item in array {
                    if let itemKey = item[kSecAttrAccount as String] as? String,
                       itemKey == "\(identifier):\(key)" {
                        SecItemDelete(item)
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    /// Clear whole storage.
    /// - Parameter keyword: If given key contains part of the keyword text it will be removed, If providen keyword is `empty` all items will be removed.
    func delete(matching keyword: String) -> Bool {
        var flag = false
        let dictionary = dictionaryRepresentation()
        let matchingKeys = dictionary.keys.filter({ keyword.isEmpty || $0.contains(keyword) })
        for key in matchingKeys {
            flag = removeObject(forKey: key)
        }
        return flag
    }
    
    
    
    
    ///Utility function that will convert keychain data storage into dictionary like structure. Should be used only for debugging.
    /// - Returns: [String:Any] Instance.
    func dictionaryRepresentation() -> [String: Any] {
        let query: [String: Any] = [
            kSecClass as String            : kSecClassGenericPassword,
            kSecReturnAttributes as String : true,
            kSecReturnRef as String        : true,
            kSecMatchLimit as String       : kSecMatchLimitAll
        ]
        
        var result: AnyObject?
        
        let lastResultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        var values = [String : Any]()
        if lastResultCode == noErr {
            if let array = result as? [NSDictionary] {
                for item in array {
                    if
                        let key = item[kSecAttrAccount as String] as? String,
                        let data = item[kSecValueData as String] as? Data,
                        let dictionary = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? NSDictionary
                    {
                        if key.contains(identifier) {
                            let cleanKey = key.replacingOccurrences(of: "\(identifier):", with: "")
                            values[cleanKey] = dictionary
                        }
                    }
                }
            }
        }
        return values
    }
    
}
