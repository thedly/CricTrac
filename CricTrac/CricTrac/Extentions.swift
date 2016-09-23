//
//  Extentions.swift
//  CricTrac
//
//  Created by Renjith on 7/21/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha:1)
    }
    
    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol = hex.substring(1)
        }
        
        let scanner = NSScanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt(&hexInt)
        
        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.length) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            // TODO:ERROR
            break;
        }
        
        self.init(
            red: (CGFloat(r)/255),
            green: (CGFloat(g)/255),
            blue: (CGFloat(b)/255),
            alpha:alpha)
    }
    
    func darkerColorForColor(color:UIColor) -> UIColor {
        var r: CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        if color.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
        }
        return UIColor()
    }
}

extension CAGradientLayer {
    func setGradientBackground(topColor:CGColor, bottomColor:CGColor) -> CAGradientLayer{
        let colorTop = topColor
        let colorBottom = bottomColor
        
        let gradientColor = CAGradientLayer()
        gradientColor.colors = [colorTop, colorBottom]
        gradientColor.locations = [0.0, 1.0]
        return gradientColor
    }

}

extension String {
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).componentsSeparatedByString(".").last!
    }
    
    func substring(from: Int) -> String {
        return self.substringFromIndex(self.startIndex.advancedBy(from))
    }
    
    var length: Int {
        return self.characters.count
    }
    
    var trimWhiteSpace:String{
       return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    var hasDataPresent:Bool{
        
        let value = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if value.length > 0 {
            return true
        }
        else{
            return false
        }

    }
    
    var monthName:String{
        
        switch self {
        case "01": return "JAN"
        case "02": return "FEB"
        case "03": return "MAR"
        case "04": return "APR"
        case "05": return "MAY"
        case "06": return "JUN"
        case "07": return "JUL"
        case "08": return "AUG"
        case "09": return "SEPT"
        case "10": return "OCT"
        case "11": return "NOV"
        case "12": return "DEC"
        default: return "NA"
        }
        
    }
}

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}

extension CALayer {
    var borderColorFromUIColor: UIColor {
        get {
            return UIColor(CGColor: self.borderColor!)
        } set {
            self.borderColor = newValue.CGColor
        }
    }
}

extension UIScrollView {
    /// Sets content offset to the top.
    func resetScrollPositionToTop() {
        self.contentOffset = CGPoint(x: -contentInset.left, y: -contentInset.top)
    }
}

extension String
{
    mutating func replace(originalString:String, withString newString:String)
    {
        let replacedString = self.stringByReplacingOccurrencesOfString(originalString, withString: newString)
        self = replacedString
    }
}
extension String
{
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}


extension UITextField{
    
    var textVal:String{
        
        get{
            if  (self.text?.length < 1) || self.text == nil{
                
                return "-"
            }
            else{
                
                return self.text!
            }
        }
        set (newVal){
            
            
            if newVal == "-"{
                text = ""
            }else{
                text = newVal
            }
        }
    }
    
}

extension NSMutableAttributedString {
    func bold(text:String) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "SFUIText-Bold", size: 17)!]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.appendAttributedString(boldString)
        return self
    }
    
    func normal(text:String)->NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "SFUIText-Regular", size: 15)!]
        let normal =  NSAttributedString(string: text, attributes:attrs)
        self.appendAttributedString(normal)
        return self
    }
}

extension SequenceType where Generator.Element: NSAttributedString {
    func joinWithSeparator(separator: NSAttributedString) -> NSAttributedString {
        var isFirst = true
        return self.reduce(NSMutableAttributedString()) {
            (r, e) in
            if isFirst {
                isFirst = false
            } else {
                r.appendAttributedString(separator)
            }
            r.appendAttributedString(e)
            return r
        }
    }
    
    func joinWithSeparator(separator: String) -> NSAttributedString {
        return joinWithSeparator(NSAttributedString(string: separator))
    }
}
