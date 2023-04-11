//
//  AppTheme.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/5/21.
//

import UIKit


enum AppTheme {
    
    case dark
    case light
    
    static var current: AppTheme {
        switch identifier {
        case "light" : return .light
        case "dark"  : return .dark
        default:       return .light
        }
    }
    
    /// Theme identifier
    static var identifier: String {
        return Bundle.main.infoDictionary!["Theme Identifier"] as! String
    }
    
    static func regularFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "RobotoSlab-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func semiboldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "RobotoSlab-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    var buttonCornerRadius: CGFloat {
        return 10
    }
    
    var brandLogoImage: UIImage { return UIImage(named: "logo_image") ?? UIImage() }
    var backgroundImage: UIImage { return UIImage(named: "background") ?? UIImage() }
    
    var blackColor: UIColor {
        return UIColor(named: "Black")!
    }
    
    var geographyColor: UIColor {
        return UIColor(named: "GeographyColor")!
        
    }
    
    var cardOrange: UIColor {
        return UIColor(named: "CardOrange")!
        
    }
    
    
    var filmColor: UIColor {
        return UIColor(named: "filmColor")!
    }
    
    var cardYellow: UIColor {
        UIColor(named: "CardYellow")!
    }
    
    var darkGreyColor: UIColor {
        UIColor(named: "DarkGreyColor")!
    }
    
    var errorRed: UIColor { 
        return UIColor(named: "ErrorRed")!
    }
    
    var grayColor: UIColor {
        return UIColor(named: "GrayColor")!
    }
    
    var primary: UIColor {
        return UIColor(named: "Primary")!
        
    }
    var historyColor: UIColor {
        return UIColor(named: "HistoryColor")!
        
    }
    var primaryLight: UIColor {
        return UIColor(named: "PrimaryLight")!
        
    }
    var secondaryColor: UIColor {
        return UIColor(named: "SecondaryColor")!
    }
    var skyBlue: UIColor {
        return UIColor(named: "SkyBlue")!
        
    }
    var somePurpleColor: UIColor {
        return UIColor(named: "SomePurpleColor")!
        
    }
    var toxicPurple: UIColor {
        return UIColor(named: "ToxicPurple")!
        
    }
    var toxicYellow: UIColor {
        return UIColor(named: "ToxicYellow")!
        
    }
    var white: UIColor {
        return UIColor(named: "White")!
        
    }
    var zenOrange: UIColor {
        return UIColor(named: "ZenOrange")!
        
    }
    var backgroundColor: UIColor {
        return UIColor(named: "Background")!
    }
    
    func getColorFromName(name: String) -> UIColor {
        return UIColor(named: name) ?? UIColor.clear
    }
    
    var cellBackgroundColor: UIColor {
        return UIColor(named: "backgroundColor")!
    }
    
    var collectionViewBackgroundColor: UIColor {
        return UIColor(named: "cellColor")!
    }
    
    var bodyTextColor: UIColor {
        return UIColor(named: "bodyTextColor")!
    }
    
    var cellColor: UIColor {
        return UIColor(named: "cellColor")!
    }
    
    var secondPlaceColor: UIColor {
        UIColor(named: "SecondPlaceColor")!
    }
    
    var thirdPlaceColor: UIColor {
        UIColor(named: "ThirdPlaceColor")!
    }
    
    var firstPlaceColor: UIColor {
        UIColor(named: "FirstPlaceColor")!
    }
    
    var secondScoreBackgroundColor: UIColor {
        UIColor(named: "SecondScoreBackgroundColor")!
    }
    
    var firstScoreBackgroundColor: UIColor {
        UIColor(named: "FirstScoreBackgroundColor")!
    }
    
    var thirdScoreBackgroundColor: UIColor {
        UIColor(named: "ThirdScoreBackgroundColor")!
    }
    
    var scoreBackgroundColor: UIColor {
        UIColor(named: "ScoreBackgroundColor")!
    }
    
    var scoreCellBackgroundColor: UIColor {
        UIColor(named: "ScoreCellBackgroundColor")!
    }
    
    var popUpColor: UIColor {
        UIColor(named: "popUpColor")!
    }
}
