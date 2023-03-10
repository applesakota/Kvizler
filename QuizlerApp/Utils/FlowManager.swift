//
//  FlowManager.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/10/21.
//

import UIKit


struct FlowManager {
    
    static var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    static var keyWindow: UIWindow? {
        return appDelegate?.window
    }
    
    static var rootViewController: UIViewController? {
        return keyWindow?.rootViewController
    }
    
    static func presentRegistrationScreen() {
        DispatchQueue.main.async {
            let viewController = RegisterViewController.instantiateWithNavigation()
            keyWindow?.rootViewController = viewController
        }
    }
    
    static func presentMainScreen() {
        DispatchQueue.main.async {
            let viewController = MainTabBarController.instantiate()
            keyWindow?.rootViewController = viewController
            
        }
    }
    
    private init() {}
}
