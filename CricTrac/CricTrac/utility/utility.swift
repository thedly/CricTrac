//
//  utility.swift
//  CricTrac
//
//  Created by Renjith on 7/21/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation
import KYDrawerController

var sliderMenu = KYDrawerController()

public func viewControllerFrom(storyBoard:String,vcid:String)->UIViewController{
    
    let storyboard = UIStoryboard(name:storyBoard, bundle: nil)
    
    return storyboard.instantiateViewControllerWithIdentifier(vcid)
}

public func UIColorFromRGB(rgbValue: Int) -> UIColor {
    return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgbValue & 0x00FF00) >>  8))/255.0, blue: ((CGFloat)((rgbValue & 0x0000FF) >>  0))/255.0, alpha: 1.0)
}

