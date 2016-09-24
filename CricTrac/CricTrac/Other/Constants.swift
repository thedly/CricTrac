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

    ["title":"Timeline","vc":"timeline"],
    ["title":"Dashboard","vc":"AddMatchDetailsViewController"],
    ["title":"New Match","vc":"AddMatchDetailsViewController"],
    ["title":"Match Summary","vc":"MatchSummaryViewController"],
    ["title":"Friends","vc":"FriendBaseViewController"],
    ["title":"Profile","vc":"UserInfoViewController"],
    ["title":"Statistics","vc":"NewMatchViewController"],
    ["title":"Notification","vc":"SummaryViewController"],
    ["title":"Settings","vc":"NewMatchViewController"],
    ["title":"Feedback","vc":"SummaryViewController"],
    ["title":"Help & Support","vc":"SummaryViewController"],
    ["title":"Version: \(versionAndBuildNumber)","vc":"SummaryViewController"],
    
]


var versionAndBuildNumber:String{

    let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
    
    let build = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
    
    return  (nsObject as! String)+" || Build: "+build

}


let fireBaseRef =  FIRDatabase.database().referenceFromURL("https://arjun-innovations.firebaseio.com")

let storageRef = FIRStorage.storage().referenceForURL("gs://arjun-innovations.appspot.com")

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

let topColorDefault = "#84CC00"
let bottomColorDefault = "#4D9D00"
let appFont_black = "SourceSansPro-Black"
let appFont_bold = "SourceSansPro-Bold"
let appFont_regular = "SourceSansPro-Regular"
let appFont_light = "SourceSansPro-Light"

let states = ["Alabama",
              "Alaska",
              "Arizona",
              "Arkansas",
              "California",
              "Colorado",
              "Connecticut",
              "Delaware",
              "Florida",
              "Georgia",
              "Hawaii",
              "Idaho",
              "Illinois",
              "Indiana",
              "Iowa",
              "Kansas",
              "Kentucky",
              "Louisiana",
              "Maine",
              "Maryland",
              "Massachusetts",
              "Michigan",
              "Minnesota",
              "Mississippi",
              "Missouri",
              "Montana",
              "Nebraska",
              "Nevada",
              "New Hampshire",
              "New Jersey",
              "New Mexico",
              "New York",
              "North Carolina",
              "North Dakota",
              "Ohio",
              "Oklahoma",
              "Oregon",
              "Pennsylvania",
              "Rhode Island",
              "South Carolina",
              "South Dakota",
              "Tennessee",
              "Texas",
              "Utah",
              "Vermont",
              "Virginia",
              "Washington",
              "West Virginia",
              "Wisconsin",
              "Wyoming"]

