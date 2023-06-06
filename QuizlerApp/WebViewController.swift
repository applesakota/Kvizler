//
//  WebViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 5/29/23.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    //MARK: - Globals
    class var identifier: String { return "WebViewController" }
    
    
    @IBOutlet weak var navigationBackground: UIView!
    @IBOutlet weak var webView: WKWebView!
    

    //MARK: - Init
    
    class func instantiate() -> WebViewController {
        let viewController = UIStoryboard.main.instantiate(identifier) as! WebViewController
        return viewController
    }

    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareThemeAndLocalization()
        self.prepareNavigationBarTheme()
        self.loadWebPage()

    }

    private func prepareThemeAndLocalization() {
        self.view.backgroundColor = AppTheme.current.scoreboardTableViewBackgroundColor
    }
    
    func prepareNavigationBarTheme() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.tintColor = AppTheme.current.textColor
        self.navigationBackground.backgroundColor = AppTheme.current.containerColor
    }

    
    func loadWebPage() {
        webView.load(URLRequest(url: AppGlobals.privacyPolicyUrl))
    }
}
