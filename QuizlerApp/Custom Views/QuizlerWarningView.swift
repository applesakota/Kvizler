//
//  QuizlerWarningView.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 2/6/23.
//

import UIKit



class QuizlerWarningView: UIView {
    
    //MARK: - Globals
    
    class var identifier: String { return "QuizlerWarningView" }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var warningDescription: UILabel!

    @IBOutlet weak var view: UIView!
    
    struct Config {
        let title: String
        let wariningColor: UIColor
        let warinngDescription: String
        
        static var empty: Config {
            return Config(
                title: "",
                wariningColor: UIColor.clear,
                warinngDescription: ""
            )
        }
    }
    
    
    private (set) var config: Config = Config.empty
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
    }
    
    convenience init(frame: CGRect, config: Config) {
        self.init(frame: frame)
        self.configure(with: config)
    }
    
    func nibSetup() {
        backgroundColor = .clear
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        insertSubview(view, at: 0)
        
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: QuizlerWarningView.identifier, bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    
    func configure(with config: Config) {
        self.config = config
        
        titleLabel.text = config.title
        warningView.backgroundColor = config.wariningColor
        warningDescription.text = config.warinngDescription
        
    }
    
}
