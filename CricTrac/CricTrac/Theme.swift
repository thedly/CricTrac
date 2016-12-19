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
    
    let meanGreen = CTTheme(topColor: UIColor(hex: "#84CC00"), bottomColor: UIColor(hex: "#4D9D00"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
     let sunSet = CTTheme(topColor: UIColor(hex: "#FF9500"), bottomColor: UIColor(hex: "#FF5E3A"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let dawn = CTTheme(topColor: UIColor(hex: "#4DA0B0"), bottomColor: UIColor(hex: "#D39D38"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let dusk = CTTheme(topColor: UIColor(hex: "#434343"), bottomColor: UIColor(hex: "#000000"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let turquoise = CTTheme(topColor: UIColor(hex: "#136a8a"), bottomColor: UIColor(hex: "#267871"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
     let instagram = CTTheme(topColor: UIColor(hex: "#517fa4"), bottomColor: UIColor(hex: "#243949"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let mango = CTTheme(topColor: UIColor(hex: "#ffcc33"), bottomColor: UIColor(hex: "#ffb347"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let hersheys = CTTheme(topColor: UIColor(hex: "#9a8478"), bottomColor: UIColor(hex: "#1e130c"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let cocktail = CTTheme(topColor: UIColor(hex: "#D38312"), bottomColor: UIColor(hex: "#A83279"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    let earthly = CTTheme(topColor: UIColor(hex: "#DBD5A4"), bottomColor: UIColor(hex: "#649173"), largeFontColor: UIColor(hex: "#ffffff"), mediumFontColor: UIColor(hex: "#ffffff"), smallFontColor: UIColor(hex: "#ffffff"))
    
    var currentTheme:CTTheme!
    
    init(){

        currentTheme = meanGreen
       
    }
    
}

enum Themes:String{
    
    case meanGreen
    case sunSet
    case dawn
    case dusk
    case turquoise
    case instagram
    case mango
    case hersheys
    case cocktail
    case earthly
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
        return cricTracTheme.meanGreen
    }
    
}

func themeFor(key:Themes)->CTTheme{
    
    switch key {
    case .meanGreen : return cricTracTheme.meanGreen
    case .sunSet : return cricTracTheme.sunSet
    case .cocktail: return cricTracTheme.cocktail
    case .dawn:return cricTracTheme.dawn
    case .dusk:return cricTracTheme.dusk
    case .earthly:return cricTracTheme.earthly
    case .hersheys:return cricTracTheme.hersheys
    case .instagram:return cricTracTheme.instagram
    case .mango:return cricTracTheme.mango
    case .turquoise:return cricTracTheme.turquoise
    }
}

func setDefaultAppThems(){
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


