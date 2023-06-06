//
//  LocalStorage.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 10/21/21.
//

import Foundation


/// Local Storage is class that should be used to store all kind of persistent data
class LocalStorage {
    
    //MARK: - Global shared instances
    
    /// Standard local data storage instance that is using standard UserDefaults as local storage.
    static let standard = LocalStorage(storage: .userDefaults(UserDefaults.standard))
    
    /// Secured local storage instance that is using Keychain to store data.
    static let secured = LocalStorage(storage: .keychain(KeychainWrapper(identifier: AppTarget.name)))
    
    // MARK: - Globals
    
    /// Local storage reference
    let storage: Storage
    
    //MARK: - Constructor
    
    /// Default init
    /// - Parameter: Storage instance
    init(storage: Storage) {
        self.storage = storage
    }
    
    
    //MARK: - Public API
    
    // Save functions
    
    @discardableResult
    func save(string value: String, key: String, forced: Bool = true) -> Bool {
        self.save(string: value, key: key, forced: forced)
    }
        
    @discardableResult
    func save(bool value: Bool, key: String, forced: Bool = true) -> Bool {
        self.save(bool: value, key: key, forced: forced)
    }
    
    @discardableResult
    func save(int value: Int, key: String, forced: Bool = true) -> Bool {
        self.save(int: value, key: key, forced: forced)
    }
    
    @discardableResult
    func save(double value: Double, key: String, forced: Bool = true) -> Bool {
        self.save(double: value, key: key, forced: forced)
    }
    
    @discardableResult
    func save(array value: NSArray, key: String, forced: Bool = true) -> Bool {
        self.save(array: value, key: key, forced: forced)
    }
    
    @discardableResult
    func save(dictionary value: NSDictionary, key: String, forced: Bool = true) -> Bool {
        self.save(dictionary: value, key: key, forced: forced)
    }
    
    @discardableResult
    func save(dictionaries value: [NSDictionary], key: String, forced:Bool = true) -> Bool {
        self.save(dictionaries: value, key: key, forced: forced)
    }
    
    @discardableResult
    func save<T: Codable>(codable value: T, key: String, forced: Bool = true) -> Bool {
        if let encoded = T.encodeObject(value) {
            return save(value: encoded, key: key, forced: forced)
        }
        return false
    }
    
    private func save(value: AnyHashable, key: String, forced: Bool) -> Bool {
        //Storage already taken
        if let oldValue = storage.get(key) {
            if forced && storage.set(value, key: key) {
                if let oldDictionary = oldValue as? NSDictionary, let newDictionary = value as? NSDictionary {
                    print("Seccessfully replaced \(oldDictionary) with new \(newDictionary)")
                } else if let oldDictionaries = oldValue as? [NSDictionary], let newDictionaries = value as? [NSDictionary] {
                    print("Seccessfully replaced \(oldDictionaries) with new \(newDictionaries)")
                } else if let oldArray = oldValue as? NSArray, let newArray = value as? NSArray {
                    print("Seccessfully replaced \(oldArray) with new \(newArray)")
                } else {
                    print("Seccessfully replaced \(oldValue) with new \(value)")
                }
                return true
            } else {
                if forced && storage.set(value, key: key) {
                    if let oldDictionary = oldValue as? NSDictionary, let newDictionary = value as? NSDictionary {
                        print("Failed to replace \(oldDictionary) with new \(newDictionary)")
                    } else if let oldDictionaries = oldValue as? [NSDictionary], let newDictionaries = value as? [NSDictionary] {
                        print("Failed to replace \(oldDictionaries) with new \(newDictionaries)")
                    } else if let oldArray = oldValue as? NSArray, let newArray = value as? NSArray {
                        print("Failed to replace \(oldArray) with new \(newArray)")
                    } else {
                        print("Failed to replace \(oldValue) with new \(value)")
                    }
                }
                return false
            }
        }
        if storage.set(value, key: key) {
            if let newDictionary = value as? NSDictionary {
                print("Seccessfully stored \(newDictionary)")
            } else if let newDictionaries = value as? [NSDictionary] {
                print("Seccessfully stored dictionaries \(newDictionaries)")
            } else if let newArray = value as? NSArray {
                print("Seccessfully stored array \(newArray)")
            } else {
                print("Seccesfully stored new value \(value)")
            }
            return true
        } else {
            if let newDictionary = value as? NSDictionary {
                print("Failed to store \(newDictionary)")
            } else if let newDictionaries = value as? [NSDictionary] {
                print("Failed to store dictionaries \(newDictionaries)")
            } else if let newArray = value as? NSArray {
                print("Failed to store array \(newArray)")
            } else {
                print("Failed to store new value \(value)")
            }
            return false
        }
    }
    
    // Load functions
    
    func loadString(_ key: String) -> String? {
        return self.load(key: key) as? String
    }
    
    func loadBool(_ key: String) -> Bool? {
        return self.load(key: key) as? Bool
    }
    
    func loadInt(_ key: String) -> Int? {
        return self.load(key: key) as? Int
    }
    
    func loadDouble(_ key: String) -> Double? {
        return self.load(key: key) as? Double
    }
    
    func loadArray(_ key: String) -> NSArray? {
        return self.load(key: key) as? NSArray
    }
    
    func loadDictionary(_ key: String) -> NSDictionary? {
        return self.load(key: key) as? NSDictionary
    }
    
    func loadDictionaries(_ key: String) -> [NSDictionary]? {
        return self.load(key: key) as? [NSDictionary]
    }
    
    func loadData(_ key: String) -> Data? {
        return self.load(key: key) as? Data
    }
    
    func loadCodable<T: Codable>(_ key: String) -> T? {
        if let data = self.load(key: key) as? Data {
            let t: T? = T.decodeData(data)
            return t
        }
        return nil
    }
    
    private func load(key: String) -> AnyHashable? {
        if let value = storage.get(key) {
            
            if let dictionary = value as? NSDictionary {
                print("📦 [LocalStorage]: Successfuly retrived \n\(dictionary) for key: \(key).")
                
            } else if let dictionaries = value as? [NSDictionary] {
                print("📦 [LocalStorage]: Successfuly retrived \n\(dictionaries) for key: \(key).")
                
            } else if let array = value as? NSArray {
                print("📦 [LocalStorage]: Successfuly retrived \n\(array) for key: \(key).")
                
            } else {
                print("📦 [LocalStorage]: Successfuly retrived \"\(value)\" for key: \(key).")
            }
            
            return value
        }
        return nil
    }
    
    // Delete functions
    
    @discardableResult
    func delete(_ key: String) -> Bool {
        // There is data to be deleted.
        if let oldValue = storage.get(key), storage.set(NSNull(), key: key) {
            
            if let dictionary = oldValue as? NSDictionary {
                print("📦 [LocalStorage]: Successfuly removed \n\(dictionary) for key: \(key).")
                
            } else if let dictionaries = oldValue as? [NSDictionary] {
                print("📦 [LocalStorage]: Successfuly removed \n\(dictionaries) for key: \(key).")
                
            } else if let array = oldValue as? NSArray {
                print("📦 [LocalStorage]: Successfuly removed \n\(array) for key: \(key).")
                
            } else {
                print("📦 [LocalStorage]: Successfuly removed \"\(oldValue)\" for key: \(key).")
            }
        }
        return false
    }
    
    @discardableResult
    func delete(matching keyword: String) -> Bool {
        if self.storage.delete(matching: keyword) {
            return true
        } else {
            return false
        }
    }
    
    
}
