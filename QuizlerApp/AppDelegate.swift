//
//  AppDelegate.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/5/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        prepareApplicationGlobalAppereance()
        return true
    }
    
    private func prepareApplicationGlobalAppereance() {
        UIBarButtonItem.appearance().setTitleTextAttributes([
            .font: AppTheme.semiboldFont(ofSize: 17)
        ], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([
            .font: AppTheme.semiboldFont(ofSize: 17)
        ], for: .highlighted)
        UIBarButtonItem.appearance().setTitleTextAttributes([
            .font: AppTheme.semiboldFont(ofSize: 17)
        ], for: .focused)
        
        UITabBarItem.appearance().setTitleTextAttributes([
            .font: AppTheme.semiboldFont(ofSize: 10)
        ], for: .normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([
           .font: AppTheme.semiboldFont(ofSize: 10)
        ], for: .selected)
    }
}

