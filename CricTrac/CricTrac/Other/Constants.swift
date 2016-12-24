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
    ["title":"Profile","vc":  "ProfileBaseViewController"],
    ["title":"Statistics","vc":"AddMatchDetailsViewController"],
    ["title":"Notification","vc":"MatchSummaryViewController"],
    ["title":"Settings","vc":"SettingsViewController"],
    ["title":"Feedback","vc":"MatchSummaryViewController"],
    ["title":"Help & Support","vc":"MatchSummaryViewController"],
    ["title":"Version: \(versionAndBuildNumber)","vc":"MatchSummaryViewController"],
    
]


var versionAndBuildNumber:String{

    let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
    
    let build = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
    
    return  (nsObject as! String)+" || Build: "+build

}

//MARK:-URLS

//let fireBaseRef =  FIRDatabase.database().referenceFromURL("https://arjun-innovations.firebaseio.com")

let fireBaseRef =  FIRDatabase.database().reference()


let storageRef = FIRStorage.storage().referenceForURL("gs://arjun-innovations.appspot.com")

let serverBaseURL = "http://crictracserver.azurewebsites.net"

/*
 
 struct CustomTextInputStyle: AnimatedTextInputStyle {
 
 var activeColor =   UIColor(hex: "#B12420")
 var inactiveColor = UIColor(hex: "#667815")
 var errorColor = UIColor.redColor()
 var lineInactiveColor = UIColor.redColor()
 var textInputFont = UIFont.systemFontOfSize(14)
 var textInputFontColor = UIColor.blackColor()
 var placeholderMinFontSize: CGFloat = 15
 var counterLabelFont: UIFont? = UIFont.systemFontOfSize(9)
 var leftMargin: CGFloat = 0
 var topMargin: CGFloat = 40
 var rightMargin: CGFloat = 0
 var  bottomMargin: CGFloat = 00
 var yHintPositionOffset: CGFloat = 7
 var yPlaceholderPositionOffset = 0
 }
 
 */


 struct CustomTextInputStyle: AnimatedTextInputStyle  {
    var activeColor =   UIColor(hex: "#B12420")
    var inactiveColor = UIColor(hex: "#667815")
    var lineInactiveColor = UIColor.redColor()
    var errorColor = UIColor.redColor()
    var textInputFont = UIFont.systemFontOfSize(14)
    var textInputFontColor = UIColor.blackColor()
    var placeholderMinFontSize: CGFloat = 15
    var counterLabelFont: UIFont? = UIFont.systemFontOfSize(9)
    var leftMargin: CGFloat = 0
    var topMargin: CGFloat = 40
    var rightMargin: CGFloat = 0
    var bottomMargin: CGFloat = 00
    var yHintPositionOffset: CGFloat = 7
    var yPlaceholderPositionOffset: CGFloat = 0
}




let themeColors = [
    "Dawn" : [
        "topColor" : "#4DA0B0",
        "bottomColor" : "#D39D38",
        "theme":"dawn"
    ],
    "MeanGreen" : [
        "topColor" : "#84CC00",
        "bottomColor" : "#4D9D00",
        "theme":"meanGreen"
    ],
    "Dusk" : [
        "topColor" : "#434343",
        "bottomColor": "#000000",
        "theme":"dusk"
    ],
    "Sunset": [
        "topColor": "#FF9500",
        "bottomColor": "#FF5E3A",
        "theme":"sunSet"
    ],
    "Turquoise": [
        "topColor": "#136a8a",
        "bottomColor": "#267871",
        "theme":"turquoise"
    ],
    "Instagram": [
        "topColor": "#517fa4",
        "bottomColor": "#243949",
        "theme":"instagram"
    ],
    "Mango": [
        "topColor": "#ffcc33",
        "bottomColor": "#ffb347",
        "theme":"mango"
    ],
    "Hersheys": [
        "topColor": "#9a8478",
        "bottomColor": "#1e130c",
        "theme":"hersheys"
    ],
    "Cocktail": [
        "topColor": "#D38312",
        "bottomColor": "#A83279",
        "theme":"cocktail"
    ],
    "Earthly": [
        "topColor": "#DBD5A4",
        "bottomColor": "#649173",
        "theme":"earthly"
    ]
]



let defaultTheme = "MeanGreen"
let topColorDefault = themeColors[CurrentTheme]!["topColor"]!
let bottomColorDefault = themeColors[CurrentTheme]!["bottomColor"]!
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

