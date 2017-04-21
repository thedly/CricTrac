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
//Grass - green theme (b4ed50 - 429321)
//Flash - yellow theme (fdef0f - b49b09)
//Feather - blue theme (c96dd8 - 3023ae)
//Peach - orange theme (fbda61 - f76b1c)
//Cherry - maroon theme (f5515f - 9f031b)
//Daisy - purple theme (eb56c1 - 961b74 )
//Ashes - grey theme (C8CBC3 - 5C635A)
//Beehive - brown theme (B8896B - 6F401B)
//Ferret - black theme (8B8484 - 2D2C2A)

struct AppTheme{
    
    let grass = CTTheme(topColor: UIColor(hex: "#b4ed50"), bottomColor: UIColor(hex: "#429321"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let flash = CTTheme(topColor: UIColor(hex: "#fdef0f"), bottomColor: UIColor(hex: "#b49b09"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let feather = CTTheme(topColor: UIColor(hex: "#c96dd8"), bottomColor: UIColor(hex: "#3023ae"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let peach = CTTheme(topColor: UIColor(hex: "#fbda61"), bottomColor: UIColor(hex: "#f76b1c"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let cherry = CTTheme(topColor: UIColor(hex: "#f5515f"), bottomColor: UIColor(hex: "#9f031b"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let daisy = CTTheme(topColor: UIColor(hex: "#eb56c1"), bottomColor: UIColor(hex: "#961b74"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let ashes = CTTheme(topColor: UIColor(hex: "#C8CBC3"), bottomColor: UIColor(hex: "#5C635A"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let beehive = CTTheme(topColor: UIColor(hex: "#B8896B"), bottomColor: UIColor(hex: "#6F401B"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let ferret = CTTheme(topColor: UIColor(hex: "#8B8484"), bottomColor: UIColor(hex: "#2D2C2A"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
  
    
    var currentTheme:CTTheme!
    var testTheme:CTTheme!
    var currentThemeTxt : String! {
        get {
            return (NSUserDefaults.standardUserDefaults().objectForKey("selectedTheme") ?? "grass") as? String
        }
    }
    
    init(){
        
        currentTheme = grass
    }
    
}

//struct AppTheme{
//    
//    let meanGreen = CTTheme(topColor: UIColor(hex: "#84CC00"), bottomColor: UIColor(hex: "#4D9D00"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
//    
//     let sunSet = CTTheme(topColor: UIColor(hex: "#FF9500"), bottomColor: UIColor(hex: "#FF5E3A"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
//    
//    let dawn = CTTheme(topColor: UIColor(hex: "#4DA0B0"), bottomColor: UIColor(hex: "#D39D38"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
//    
//    let dusk = CTTheme(topColor: UIColor(hex: "#434343"), bottomColor: UIColor(hex: "#000000"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
//    
//    let turquoise = CTTheme(topColor: UIColor(hex: "#136a8a"), bottomColor: UIColor(hex: "#267871"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
//    
//     let instagram = CTTheme(topColor: UIColor(hex: "#517fa4"), bottomColor: UIColor(hex: "#243949"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
//    
//    let mango = CTTheme(topColor: UIColor(hex: "#ffcc33"), bottomColor: UIColor(hex: "#ffb347"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
//    
//    let hersheys = CTTheme(topColor: UIColor(hex: "#9a8478"), bottomColor: UIColor(hex: "#1e130c"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
//    
//    let cocktail = CTTheme(topColor: UIColor(hex: "#D38312"), bottomColor: UIColor(hex: "#A83279"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
//    
//    let earthly = CTTheme(topColor: UIColor(hex: "#DBD5A4"), bottomColor: UIColor(hex: "#649173"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
//    
//    var currentTheme:CTTheme!
//    var testTheme:CTTheme!
//    var currentThemeTxt : String! {
//        get {
//            return (NSUserDefaults.standardUserDefaults().objectForKey("selectedTheme") ?? "meanGreen") as? String
//        }
//    }
//    
//    init(){
//
//        currentTheme = meanGreen
//    }
//    
//}




enum Themes:String{
    
    case grass
    case flash
    case feather
    case peach
    case cherry
    case daisy
    case ashes
    case beehive
    case ferret
    
}

func setCurrentTheme(theme:Themes){
    
    NSUserDefaults.standardUserDefaults().setValue(theme.rawValue, forKey: "selectedTheme")
    cricTracTheme.currentTheme = getPersistedTheme()
    NSNotificationCenter.defaultCenter().postNotificationName("ThemeChanged", object: nil)
    
}


func getPersistedTheme()->CTTheme{
    
    if let savedTheme = NSUserDefaults.standardUserDefaults().objectForKey("selectedTheme") as? String{
        
        return themeFor(Themes(rawValue: savedTheme)!)
        
    }
    else{
        return cricTracTheme.grass
    }
    
}
func testCurrentTheme(theme:Themes){
    
    NSUserDefaults.standardUserDefaults().setValue(theme.rawValue, forKey: "testTheme")
    cricTracTheme.testTheme = getPersistedTheme()
    NSNotificationCenter.defaultCenter().postNotificationName("TestTheme", object: nil)
    
}
func getTestPersistedTheme()->CTTheme{
    
    if let savedTheme = NSUserDefaults.standardUserDefaults().objectForKey("testTheme") as? String{
        
        return themeFor(Themes(rawValue: savedTheme)!)
        
    }
    else{
        return cricTracTheme.grass
    }
    
}

func themeFor(key:Themes)->CTTheme{
    
    switch key {
    case .grass : return cricTracTheme.grass
    case .flash : return cricTracTheme.flash
    case .feather: return cricTracTheme.feather
    case .peach:return cricTracTheme.peach
    case .cherry:return cricTracTheme.cherry
    case .daisy:return cricTracTheme.daisy
    case .ashes:return cricTracTheme.ashes
    case .beehive:return cricTracTheme.beehive
    case .ferret:return cricTracTheme.ferret
    
    }
}

func setDefaultAppTheme(){
    cricTracTheme.currentTheme = getPersistedTheme()
}


protocol ThemeChangeable{
    
      func changeThemeSettigs()
    
}

extension ThemeChangeable where Self:UIViewController{
    
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


