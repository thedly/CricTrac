//
//  Theme.swift
//  CricTrac
//
//  Created by Renjith on 20/11/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation
import UIKit

var cricTracTheme = AppTheme()

class CTCAGradientLayer: CAGradientLayer {
    let tag = 0
}

struct CTTheme {
    var topColor:UIColor
    var bottomColor:UIColor
    var backGroundGradientLayer:CTCAGradientLayer
    var boxColor:UIColor
    var largeFontColor:UIColor
    var mediumFontColor:UIColor
    var smallFontColor:UIColor
    
    init(topColor:UIColor,bottomColor:UIColor,largeFontColor:UIColor,mediumFontColor:UIColor,smallFontColor:UIColor){
        self.topColor = topColor
        self.boxColor = bottomColor
        self.bottomColor = bottomColor
        self.largeFontColor = largeFontColor
        self.smallFontColor = smallFontColor
        self.mediumFontColor = mediumFontColor
        self.backGroundGradientLayer = CTCAGradientLayer()
        self.backGroundGradientLayer.colors = [topColor.CGColor, bottomColor.CGColor]
        self.backGroundGradientLayer.locations = [0.0, 1.0]
    }
}

struct AppTheme{
    
    let Grass = CTTheme(topColor: UIColor(hex: "#b4ed50"), bottomColor: UIColor(hex: "#429321"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let Flash = CTTheme(topColor: UIColor(hex: "#FFE205"), bottomColor: UIColor(hex: "#FF8F05"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let Feather = CTTheme(topColor: UIColor(hex: "#ea9eff"), bottomColor: UIColor(hex: "#692580"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let Peach = CTTheme(topColor: UIColor(hex: "#fbda61"), bottomColor: UIColor(hex: "#f76b1c"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let Cherry = CTTheme(topColor: UIColor(hex: "#D40D12"), bottomColor: UIColor(hex: "#5C0002"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let Daisy = CTTheme(topColor: UIColor(hex: "#EDC7D9"), bottomColor: UIColor(hex: "#EF629F"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let Ashes = CTTheme(topColor: UIColor(hex: "#C8CBC3"), bottomColor: UIColor(hex: "#5C635A"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let Beehive = CTTheme(topColor: UIColor(hex: "#ba9779"), bottomColor: UIColor(hex: "#910000"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let Ferret = CTTheme(topColor: UIColor(hex: "#8B8484"), bottomColor: UIColor(hex: "#2D2C2A"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
  
    let Ocean = CTTheme(topColor: UIColor(hex: "#3BACB2"), bottomColor: UIColor(hex: "#295154"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let Pista = CTTheme(topColor: UIColor(hex: "#CDE855"), bottomColor: UIColor(hex: "#85DB18"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let Lemon = CTTheme(topColor: UIColor(hex: "#40627C"), bottomColor: UIColor(hex: "#26393D"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))

    
    var currentTheme:CTTheme!
    var testTheme:CTTheme!
    var currentThemeTxt : String! {
        get {
            //                      return (NSUserDefaults.standardUserDefaults().objectForKey("selectedTheme") ?? "Grass") as? String
              return (NSUserDefaults.standardUserDefaults().valueForKey("userTheme") ?? "Grass") as? String
        }
    }
    
    init(){
        currentTheme = Grass
    }
}

enum Themes:String{
    case Grass
    case Flash
    case Feather
    case Peach
    case Cherry
    case Daisy
    case Ashes
    case Beehive
    case Ferret
    case Ocean
    case Pista
    case Lemon
}

func setCurrentTheme(theme:Themes){
    cricTracTheme.testTheme = themeFor(Themes(rawValue: theme.rawValue)!)
}

func getPersistedTheme()->CTTheme {
    if let savedTheme = NSUserDefaults.standardUserDefaults().valueForKey("userTheme") as? String{
        return themeFor(Themes(rawValue: savedTheme)!)
    }
    else{
        return cricTracTheme.Grass
    }
}

//func testCurrentTheme(theme:Themes){
//    NSUserDefaults.standardUserDefaults().setValue(theme.rawValue, forKey: "testTheme")
//    cricTracTheme.testTheme = getPersistedTheme()
//    NSNotificationCenter.defaultCenter().postNotificationName("TestTheme", object: nil)
//}
//
//func getTestPersistedTheme()->CTTheme{
//    if let savedTheme = NSUserDefaults.standardUserDefaults().objectForKey("testTheme") as? String{
//        return themeFor(Themes(rawValue: savedTheme)!)
//    }
//    else{
//        return cricTracTheme.Grass
//    }
//}

func themeFor(key:Themes)->CTTheme{
    switch key {
    case .Grass : return cricTracTheme.Grass
    case .Flash : return cricTracTheme.Flash
    case .Feather: return cricTracTheme.Feather
    case .Peach:return cricTracTheme.Peach
    case .Cherry:return cricTracTheme.Cherry
    case .Daisy:return cricTracTheme.Daisy
    case .Ashes:return cricTracTheme.Ashes
    case .Beehive:return cricTracTheme.Beehive
    case .Ferret:return cricTracTheme.Ferret
    case .Ocean:return cricTracTheme.Ocean
    case .Pista:return cricTracTheme.Pista
    case .Lemon:return cricTracTheme.Lemon
    }
}

func setDefaultAppTheme(){
    cricTracTheme.currentTheme = getPersistedTheme()
}

protocol ThemeChangeable{
    func changeThemeSettigs()
}

extension ThemeChangeable where Self:UIViewController{
    
    func setTestBackgroundColor(){
        let gradient = cricTracTheme.testTheme.backGroundGradientLayer
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, atIndex: 0)
        self.setTestBackgroundLayer()
        
//        NSNotificationCenter.defaultCenter().addObserverForName("ThemeChanged", object: nil, queue: nil) { (notification) in
//            
//            self.setBackgroundLayer()
//            self.changeThemeSettigs()
//        }
    }
    
    func setTestBackgroundLayer(){
        let gradient = cricTracTheme.testTheme.backGroundGradientLayer
        gradient.frame = view.bounds
        
        for aLayer in view.layer.sublayers!{
            if aLayer is CTCAGradientLayer{
                gradient.frame = view.bounds
                view.layer.insertSublayer(gradient, above: aLayer)
                aLayer.removeFromSuperlayer()
            }
        }
    }

    func setBackgroundColor(){
        let gradient = cricTracTheme.currentTheme.backGroundGradientLayer
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, atIndex: 0)
        self.changeThemeSettigs()
        
        NSNotificationCenter.defaultCenter().addObserverForName("ThemeChanged", object: nil, queue: nil) { (notification) in
            
            self.setBackgroundLayer()
            self.changeThemeSettigs()
        }
    }
    
    func setBackgroundLayer(){
        let gradient = cricTracTheme.currentTheme.backGroundGradientLayer
        gradient.frame = view.bounds
        
        for aLayer in view.layer.sublayers!{
            if aLayer is CTCAGradientLayer{
                gradient.frame = view.bounds
                view.layer.insertSublayer(gradient, above: aLayer)
                aLayer.removeFromSuperlayer()
            }
        }
    }
}


