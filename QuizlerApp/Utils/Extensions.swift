//
//  Extensions.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/10/21.
//

import UIKit

//MARK: - UIStoryboard
extension UIStoryboard {
    
    /// Returns instance of login storyboard
    static let login = UIStoryboard(name: "Login", bundle: nil)
    
    /// Returns instance of main storyboard
    static let main = UIStoryboard(name: "Main", bundle: nil)
    
    /// Returns instance of utils storyboard
    static let utils = UIStoryboard(name: "Utils", bundle: nil)
    
    /// Instantiate view contoller from storyboard
    /// - Parameter identifier: Unique view controller identifer from storyboard
    func instantiate<T: UIViewController>(_ identifier: String) -> T {
        return self.instantiateViewController(withIdentifier: identifier) as! T
    }
}

//MARK: - String
extension String {
    
    ///Returns true if string has valid email structure
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    /// Returns true if string has valid password
    var isValidPassword: Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{8,}$"
        let password = NSPredicate(format: "SELF MATCHES %@ ", passwordRegEx)
        return password.evaluate(with: self)
    }
    
    /// Function will trim all spaces
    func trimmingAllSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        return components(separatedBy: characterSet).joined()
    }
    
    /// Function for NSLocalizedString
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localization", bundle: .main, value: self, comment: self)
    }

}

// MARK: - Array where Element: JSONSerializable

extension Array where Element: JSONSerializable {
    
    /// Simple wrapper function that will serilize whole array into list of NSDictionaries.
    /// - Returns: NSDictionary array instance.
    func serialize() -> [NSDictionary] {
        return self.map({ $0.serialize() })
    }
    
}

// MARK: Decodable

extension Decodable {
    
    static func decodeData<T: Decodable>(_ data: Data?) -> T? {
        var object: T? = nil
        
        if let data = data {
            do {
                object = try JSONDecoder().decode(T.self, from: data)
            } catch {
                
            }
        }
        return object
    }
    
    
}

// MARK: - Data
extension Data {
    
    /// Convert data to NSDictionary object.
    /// - Returns: NSDictionary instance.
    func toDictionary() -> NSDictionary? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? NSDictionary
        } catch let error as NSError {
            print("Failed to serilize: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Convert data to NSDictionary array object.
    /// - Returns: NSDictionary array instance.
    func toDictionaries() -> [NSDictionary]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? [NSDictionary]
        } catch let error as NSError {
            print("Failed to serilize: \(error.localizedDescription)")
            return nil
        }
    }
    
}

//MARK: - UIVIew

extension UIView {
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    func showShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    
    func makeCircleLayer(onView: UIView, withShapeLayer: CAShapeLayer = CAShapeLayer(), label: UILabel, defaultTimeRemaining: Int, timeRemaining: Int) {
        //track
        onView.layer.speed = 1.0
        onView.layer.timeOffset = 0
        let center = CGPoint(x: onView.bounds.width / 2, y: onView.bounds.height / 2)
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 35, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = AppTheme.current.mainColor.cgColor
        trackLayer.lineWidth = 5
        trackLayer.fillColor = AppTheme.current.containerColor.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap(rawValue: "round")
        trackLayer.position = center
        onView.layer.addSublayer(trackLayer)
        //shape
        withShapeLayer.path = circularPath.cgPath
        withShapeLayer.backgroundColor = UIColor.white.cgColor
        withShapeLayer.strokeColor = AppTheme.current.containerColor.cgColor
        withShapeLayer.lineWidth = 5
        withShapeLayer.fillColor = AppTheme.current.containerColor.cgColor
        withShapeLayer.lineCap = CAShapeLayerLineCap(rawValue: "round")
        withShapeLayer.position = center
        withShapeLayer.strokeEnd = 0
        withShapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        onView.layer.addSublayer(withShapeLayer)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: onView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: onView.centerYAnchor).isActive = true
        label.textAlignment = .center
        onView.addSubview(label)
        animateStroke(onShapeLayer: withShapeLayer, defaultTimeRemaining: defaultTimeRemaining, timeRemaining: timeRemaining)
    }
    
    func animateStroke(onShapeLayer: CAShapeLayer, defaultTimeRemaining: Int, timeRemaining: Int) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = Double(defaultTimeRemaining)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        onShapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
    
    func stopAnimation(layer: CAShapeLayer) {
        layer.removeAllAnimations()
        self.layoutIfNeeded()
    }
    
    func pauseAnimation() {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        self.layoutIfNeeded()
    }
    
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

}

//MARK: - Encodable

extension Encodable {
    
    ///Function will encode specific object into JSON data format if possible
    /// - Parameter object: Encodable object that will be encoded into JSON data.
    /// - Returns: JSON data representation of encodable object.
    static func encodeObject<T: Encodable>(_ object: T?) -> Data? {
        var data: Data? = nil
        if let object = object {
            do {
                data = try JSONEncoder().encode(object)
                print("Encoding \(type(of: T.self)), completed seccessfully!")
            } catch EncodingError.invalidValue(let key, let context) {
                print("Encoding error.invalidValue [\(key): \(context.debugDescription)")
            } catch {
                print("DecodingError.unknown")
            }
        }
        return data
    }
}

//MARK: - UIButton

extension UIButton {
    
 func addTopBorder(borderColor: UIColor, borderWidth: CGFloat) {
    let border = CALayer()
    border.backgroundColor = borderColor.cgColor
    border.frame = CGRect(x:0,y: 0, width:self.frame.size.width, height: borderWidth)
    self.layer.addSublayer(border)
 }

 func addLeftBorder(color: UIColor, width: CGFloat) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
    self.layer.addSublayer(border)
 }
    
}

//MARK: - UIStackView

extension UIStackView {
    
    func addTopBorder(borderColor: UIColor, borderWidth: CGFloat) {
       let border = CALayer()
       border.backgroundColor = borderColor.cgColor
       border.frame = CGRect(x:0,y: 0, width:self.frame.size.width, height: borderWidth)
       self.layer.addSublayer(border)
    }

    func addLeftBorder(color: UIColor, width: CGFloat) {
       let border = CALayer()
       border.backgroundColor = color.cgColor
       border.frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
       self.layer.addSublayer(border)
    }
}
