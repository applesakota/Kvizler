//
//  QuizPauseViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 7/8/21.
//

import UIKit

class QuizPauseViewController: UIViewController {
    
    class var identifier: String { return "QuizPauseViewController"}
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    var timer = Timer()
    var timerCount = 3
    
    
    class func instantiate() -> QuizPauseViewController {
        let viewController = UIStoryboard.utils.instantiate(identifier) as! QuizPauseViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareThemeAndLocalization()
        
        timer.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(QuizViewController.timerClass),
            userInfo: nil,
            repeats: true)
    }
    
    
    func prepareThemeAndLocalization() {
        self.valueLabel.textColor = AppTheme.current.primary
    }
    
    @objc func timerClass() {
        
        valueLabel.alpha = 0.0
        timerCount -= 1
        valueLabel.text = String(timerCount)
        
        UIView.animate(withDuration: 0.5) {
            self.valueLabel.alpha = 1.0
        }
        
        if timerCount == 0 {
            timer.invalidate()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
