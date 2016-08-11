//
//  Constants.swift
//  CricTrac
//
//  Created by Renjith on 7/28/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation
import AnimatedTextInput
import Firebase

public var date = 0

let menuData = [

    ["title":"New Match","vc":"AddMatchDetailsViewController"],
    ["title":"Profile","vc":"ProfileBaseViewController"],
    ["title":"Summary","vc":"SummaryViewController"],
    ["title":"Statistics","vc":"NewMatchViewController"],
    ["title":"Invite Friends","vc":"NewMatchViewController"],
    ["title":"Friends Requests","vc":"NewMatchViewController"],
    ["title":"Notification","vc":"NewMatchViewController"],
]


let userDataRef =  FIRDatabase.database().referenceFromURL("https://arjun-innovations.firebaseio.com")


struct CustomTextInputStyle: AnimatedTextInputStyle {
    
    let activeColor =   UIColor(hex: "#B12420")
    let inactiveColor = UIColor(hex: "#667815")
    let errorColor = UIColor.redColor()
    let textInputFont = UIFont.systemFontOfSize(14)
    let textInputFontColor = UIColor.blackColor()
    let placeholderMinFontSize: CGFloat = 15
    let counterLabelFont: UIFont? = UIFont.systemFontOfSize(9)
    let leftMargin: CGFloat = 0
    let topMargin: CGFloat = 40
    let rightMargin: CGFloat = 0
    let bottomMargin: CGFloat = 00
    let yHintPositionOffset: CGFloat = 7
}