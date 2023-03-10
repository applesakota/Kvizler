//
//  LocalStorageStorable.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 10/22/21.
//

import Foundation



//MARK: - LocalStorageStorable decleration

/// Contains all required Local Storage functionality that any object can inherit.
protocol LocalStorageStorable: AnyObject {
    
    /// Associated type (Generics for protocols).
    associatedtype LocalStorageStorableObject: JSONSerializable, LocalStorageStorable
    
    ///Unique instance identifier
    var storage: String { get }
    
    /// Generates and returns unique key identifier that will be used to store/load/delete data in local
    /// - Parameter storageIdentifier: object unique identifier used in key generation (example: User email, or score number).
    static func getKey(with storageIdentifier: String) -> String
    
    /// Store user in Local Storage so we don't lose data even after application terminates.
    /// - Parameter localStorage: Local Storage instance
    /// - Returns: Returns true if object was stored seccessfully
    @discardableResult
    static func save(to localStorage: LocalStorage, forced: Bool) -> Bool
    
    /// Remove object from Local Storage
    /// - Parameter LocalStorage: Local Storage Instance
    static func remove(from localStorage: LocalStorage)
    
    /// Globar function that can be used to store object in Local Storage so we don't lose data even after application terminates.
    /// - Parameters:
    /// - object: SplashScreen instance
    /// - localStorage: Local Storage instance
    /// - Returns: Returns true if object was stored seccessfully.
    @discardableResult
    static func save(object: LocalStorageStorableObject, from localStorage: LocalStorage) -> Bool
    
    ///Global function that can be used to remove object from Local Storage.
    /// - Parameters:
    /// - object: Object instance
    /// - localStorage: Local Storage instance
    static func remove(object: LocalStorageStorableObject, from localStorage: LocalStorage)
    
    ///Global function that can be used to retrive object from Local Storage if any
    /// - Parameters:
    /// - storageIdentifier: object unique identifier used in key generation.
    ///  - localStorage: Local Storage Instance.
    ///  - Returns : Returns object instance with all fields already set to ones we had in local storage
    static func loadObject(with storageIdentifier: String, from localStorage: LocalStorage) -> LocalStorageStorableObject
    
}
