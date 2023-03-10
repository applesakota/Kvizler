//
//  AppGlobals.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/8/21.
//

import Foundation
import UIKit

enum AppGlobals {
    
    // MARK: - Flags
    
    /// if set to true, application will use mocked data and whole flow will be in offlane mode with dummy content
    /// if set to false, application will use real time server data and flow will be in online/offline mode with valid content
    static var isLocalEnvironment: Bool {
        return AppEnvironment.current == .local
    }
    
    /// Secured local storage reference used in application.
    /// - note: Local Storage is class that should be used to store all kind of persistent data.
    /// - important: This reference provide single place of truth where service can be overwritten by external source
    static var securedLocalStorage = LocalStorage.secured
    
    static var standardLocalStorage = LocalStorage.standard
    
    //MARK: - Services/Managers
    /// Auth manager reference used in application
    /// - note: Auth Manager class. Contains all user authentication functionalities linked wrapped around RealmSwift service provider
    /// - important: This reference provide single place of truth where service can be overwritten by external source, for example unit tests.
    static var herokuRESTManager = HerokuRestManager.shared
    
    //MARK: - Common
    /// Current user that has it's access token saved
    static var currentUser: UserModel?
    
    //MARK: - CommonLoadView
    static var defaultLoadConfig: LoaderView.Config {
        return LoaderView.Config(
            autopresent: true,
            backgroundColor: UIColor.clear,
            foregroundColor: AppTheme.current.blackColor.withAlphaComponent(0.2),
            userLargeSpinner: true)
    }
}
