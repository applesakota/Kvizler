//
//  MainTabBarController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/11/21.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    //MARK: - Globals
    class var identifier: String { return "MainTabBarController" }
    
    
    class func instantiate() -> MainTabBarController {
        let tabBarController = UIStoryboard.main.instantiate(identifier) as! MainTabBarController
        return tabBarController
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTabBarTheme()
        // Do any additional setup after loading the view.
        viewControllers = [
            NewHomeViewController.instantiateWithNavigation(),
            ScoreboardViewController.instantiateWithNavigation()
        ]
    }
    
    
    private func prepareTabBarTheme() {
        self.tabBar.tintColor = AppTheme.current.blackColor
        self.tabBar.barTintColor = AppTheme.current.secondPlaceColor
        self.tabBar.unselectedItemTintColor = AppTheme.current.blackColor.withAlphaComponent(0.5)
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = AppTheme.current.secondPlaceColor
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: AppTheme.current.blackColor.withAlphaComponent(0.4)]
            appearance.stackedLayoutAppearance.normal.iconColor = AppTheme.current.blackColor.withAlphaComponent(0.4)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: AppTheme.current.blackColor]
            appearance.stackedLayoutAppearance.selected.iconColor = AppTheme.current.blackColor
            appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: AppTheme.current.blackColor.withAlphaComponent(0.4)]
            appearance.inlineLayoutAppearance.normal.iconColor = AppTheme.current.blackColor.withAlphaComponent(0.4)
            appearance.inlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: AppTheme.current.blackColor]
            appearance.inlineLayoutAppearance.selected.iconColor = AppTheme.current.blackColor
            appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: AppTheme.current.blackColor.withAlphaComponent(0.4)]
            appearance.compactInlineLayoutAppearance.normal.iconColor = AppTheme.current.blackColor.withAlphaComponent(0.4)
            appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: AppTheme.current.blackColor]
            appearance.compactInlineLayoutAppearance.selected.iconColor = AppTheme.current.blackColor
                 
            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    /// List of all tab bar view controllers, instantiated and loaded, so we easy simulate caching here and save time loading and preparing UI over and over again.
    lazy var tabBarViewControllers: [UIViewController] = {
        let viewControllers = [
            NewHomeViewController.instantiateWithNavigation(),
            ScoreboardViewController.instantiateWithNavigation()
        ]
        viewControllers.forEach({ $0.viewControllers.first?.loadViewIfNeeded() })
        return viewControllers
    }()
    
    // HomeViewController
    var homeViewController: NewHomeViewController {
        return (tabBarViewControllers[0] as! UINavigationController).viewControllers[0] as! NewHomeViewController
    }
    
    var scoreBoardViewController: ScoreboardViewController {
        return (tabBarViewControllers[1] as! UINavigationController).viewControllers[0] as! ScoreboardViewController
    }

}
