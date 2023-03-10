//
//  LoaderView.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/17/21.
//

import Foundation
import UIKit

class LoaderView: UIView {
    
    private weak var owner: UIView?
    
    struct Config {
        var autopresent: Bool = true
        var backgroundColor: UIColor = UIColor.clear
        var foregroundColor: UIColor = UIColor.black
        var userLargeSpinner: Bool = true
    }
    
    class func create(for view: UIView, config: Config = Config()) -> LoaderView {
        let loader = LoaderView(frame: view.bounds)
        
        let activityIndicator: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: config.userLargeSpinner ? .large : .medium)
        } else {
            activityIndicator = UIActivityIndicatorView(style: .white)
        }
        
        activityIndicator.frame = loader.bounds
        activityIndicator.color = config.foregroundColor
        activityIndicator.startAnimating()
        loader.addSubview(activityIndicator)
        activityIndicator.backgroundColor = config.backgroundColor
        loader.isUserInteractionEnabled = true
        loader.owner = view
        if config.autopresent { loader.present() }
        return loader
        
    }
    
    func present() {
        DispatchQueue.main.async {
            if self.superview != nil {
                self.removeFromSuperview()
            }
            self.owner?.addSubview(self)
        }
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            if self.superview != nil {
                self.removeFromSuperview()
            }
        }
    }
}
