//
//  QuizlerProgressBarView.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 4/18/23.
//

import UIKit

class QuizlerProgressBarView: UIView {
    
    //MARK: - Globals
    @IBInspectable var color: UIColor = AppTheme.current.containerColor
    let backgroundMask = CAShapeLayer()
    var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    private let progressLayer = CALayer()
    let gradientLayer = CAGradientLayer()
        
    //MARK: - Init
    
    override func draw(_ rect: CGRect) {
        backgroundColor?.setFill()
        backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.25).cgPath
        layer.mask = backgroundMask
        /// Create progress rect
        let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * progress, height: rect.height))
        progressLayer.frame = progressRect
        
        layer.addSublayer(progressLayer)
        progressLayer.backgroundColor = color.cgColor
    }
    
    func setProgress(to percent : CGFloat) {
        progress = percent
        let duration = 0.5
        
        let rect = self.bounds
        let oldBounds = progressLayer.bounds
        let newBounds = CGRect(origin: .zero, size: CGSize(width: rect.width * progress, height: rect.height))
        
        
        let redrawAnimation = CABasicAnimation(keyPath: "bounds")
        redrawAnimation.fromValue = oldBounds
        redrawAnimation.toValue = newBounds

        redrawAnimation.fillMode = .both
        redrawAnimation.isRemovedOnCompletion = false
        redrawAnimation.duration = duration
        
        progressLayer.bounds = newBounds
        progressLayer.position = CGPoint(x: 0, y: 0)
        progressLayer.anchorPoint = CGPoint(x: 0, y: 0)
        progressLayer.add(redrawAnimation, forKey: "redrawAnim")
        
        let oldGradEnd = gradientLayer.endPoint
        let newGradEnd = CGPoint(x: progress, y: 0.5)
        let gradientEndAnimation = CABasicAnimation(keyPath: "endPoint")
        gradientEndAnimation.fromValue = oldGradEnd
        gradientEndAnimation.toValue = newGradEnd
        gradientEndAnimation.fillMode = .both
        gradientEndAnimation.isRemovedOnCompletion = false
        gradientEndAnimation.duration = duration
        
        gradientLayer.endPoint = newGradEnd
        gradientLayer.add(gradientEndAnimation, forKey: "gradEndAnim")
    }
    

}
