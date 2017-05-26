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
import FirebaseStorage

public var date = 0

//dev website url
var websiteUrl = "https://arjun-innovations.firebaseapp.com"
//prod website url
//var websiteUrl = "https://crictrac.com"

public var loggedInUserInfo = [String:AnyObject]()
var friendsCity = [String:String]()

public var loggedInUserName:String?{

    guard let firstName = loggedInUserInfo["FirstName"] as? String else {return nil}
    guard let lastName =  loggedInUserInfo["LastName"] as? String else { return nil}
    return firstName + " " + lastName
}

var menuData = [

    ["title":"PAVILION","vc":"timeline", "img": "Menu_TimeLine"],
    ["title":"SIGHTSCREEN","vc":"UserDashboardViewController", "img": "Menu_Dashboard"],
    ["title":"ADD MATCH","vc":"AddMatchDetailsViewController", "img": "Menu_AddMatch"],
    ["title":"SCOREBOARD","vc":"MatchSummaryViewController", "img": "Menu_Summary"],
    ["title":"DUGOUT","vc":"FriendBaseViewController", "img": "Menu_Friends"],
    ["title":"PROFILE","vc":  "ProfileBaseViewController", "img": "Menu_Profile"],
    ["title":"THIRD UMPIRE","vc":"SettingsViewController", "img": "Menu_Settings"],
//    ["title":"TIMELINE","vc":"timeline", "img": "Menu_TimeLine"],
//    ["title":"DASHBOARD","vc":"UserDashboardViewController", "img": "Menu_Dashboard"],
//    ["title":"NEW MATCH","vc":"AddMatchDetailsViewController", "img": "Menu_AddMatch"],
//    ["title":"MATCH SUMMARY","vc":"MatchSummaryViewController", "img": "Menu_Summary"],
//    ["title":"FRIENDS","vc":"FriendBaseViewController", "img": "Menu_Friends"],
//    ["title":"PROFILE","vc":  "ProfileBaseViewController", "img": "Menu_Profile"],
//    ["title":"STATISTICS","vc":"AddMatchDetailsViewController", "img": "Menu_Statistics"],
//    ["title":"NOTIFICATION","vc":"MatchSummaryViewController", "img": "Menu_Summary"],

//    ["title":"SETTINGS","vc":"SettingsViewController", "img": "Menu_Settings"],
//    ["title":"FEEDBACK","vc":"MatchSummaryViewController", "img": "Menu_Summary"],
//    ["title":"HELP & SUPPORT","vc":"MatchSummaryViewController", "img": "Menu_Summary"],
//    ["title":"VERSION: \(versionAndBuildNumber)","vc":"MatchSummaryViewController", "img": "Menu_Summary"],
    
]

var friendInviteData = [
    
    ["title":"MAIL","vc":"email", "img": "Mail"],
    ["title":"MESSAGE","vc":"message", "img": "SMS"],
    ["title":"WHATSAPP","vc":"whatsapp", "img": "WhatsApp-96"]
]
//    ["title":"FACEBOOK","vc":"facebook", "img": "Facebook"],

let settingsMenuData = [
    
    //["title":"Show profile picture","vc":"ProfileBaseViewController", "img": "Menu_TimeLine", "desc": "Show profile picture to other users", "IsSwitchVisible": true],
    //["title":"Media Auto-Download","vc":"UserDashboardViewController", "img": "Menu_Dashboard", "desc": "Selecting no will auto-download media only while you are using wi-fi", "IsSwitchVisible": false],
    //["title":"Offline Matches","vc":"AddMatchDetailsViewController", "img": "Menu_AddMatch", "desc": "Matches to be downloaded for offline view", "IsSwitchVisible": false],
    ["title":"App Theme","vc":"ThemeSettingsViewController", "img": "Menu_Settings", "desc": "Choose desired theme color for your app", "IsSwitchVisible": false],
    ["title":"Change Password","vc":  "ChangePassword", "img": "Menu_Settings", "desc": "", "IsSwitchVisible": false, "contentToDisplay" : "" ],
//    ["title":"Rate this app","vc":  "StaticPageViewController", "img": "Menu_Settings", "desc": "", "IsSwitchVisible": false, "contentToDisplay": "itms://itunes.apple.com/de/app/x-gift/id839686104?mt=8&uo=4"],
    ["title":"Feedback","vc":  "Feedback", "img": "Menu_Settings", "desc": "", "IsSwitchVisible": false, "contentToDisplay" : "" ],
    ["title":"FAQ","vc":  "StaticPageViewController", "img": "Menu_Settings", "desc": "", "IsSwitchVisible": false, "contentToDisplay" : "https://crictrac.com/AppFiles/FAQ.htm"],
    ["title":"Terms & Conditions","vc":"StaticPageViewController", "img": "Menu_Settings", "desc": "", "IsSwitchVisible": false, "contentToDisplay" : "https://crictrac.com/AppFiles/TermsofUse.htm" ],
    ["title":"Privacy Policy","vc":  "StaticPageViewController", "img": "Menu_Settings", "desc": "", "IsSwitchVisible": false, "contentToDisplay" : "https://crictrac.com/AppFiles/PrivacyPolicy.htm" ],
    ["title":"About","vc":  "StaticPageViewController", "img": "Menu_Settings", "desc": "", "IsSwitchVisible": false, "contentToDisplay" : "https://crictrac.com/AppFiles/AboutUs.htm" ],
     ["title":"Logout","vc":  "", "img": "Menu_Settings", "desc": "", "IsSwitchVisible": false]
]

var versionAndBuildNumber:String{

    let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
    
    let build = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
    
    return  (nsObject as! String)+" || Build: "+build

}

//variable to decide whether to show the AD or not
let showAds = 1
let adUnitId = "ca-app-pub-3940256099942544/2934735716"


//MARK:-URLS

//let fireBaseRef =  FIRDatabase.database().referenceFromURL("https://arjun-innovations.firebaseio.com")

let fireBaseRef =  FIRDatabase.database().reference()

let storageRef = FIRStorage.storage().referenceForURL("gs://arjun-innovations.appspot.com")

//Azure Dev environment url
let serverBaseURL = "https://crictracdevserver.azurewebsites.net"

//Azure QA environment url
//let serverBaseURL = "https://crictracqaserver.azurewebsites.net"

//Azure Prod environment url
//let serverBaseURL = "https://crictracserver.azurewebsites.net"

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
    "Grass" : [
        "topColor" : "#b4ed50",
        "bottomColor" : "#429321",
        "theme":"Grass"
    ],
    "Flash" : [
        "topColor" : "#fffaba",
        "bottomColor" : "#FFE205",
        "theme":"Flash"
    ],
    "Feather" : [
        "topColor" : "#ea9eff",
        "bottomColor": "#692580",
        "theme":"Feather"
    ],
    "Peach": [
        "topColor": "#fbda61",
        "bottomColor": "#f76b1c",
        "theme":"Peach"
    ],
    "Cherry": [
        "topColor": "#f5515f",
        "bottomColor": "9f031b",
        "theme":"Cherry"
    ],
    "Daisy": [
        "topColor": "#EDC7D9",
        "bottomColor": "#EF629F",
        "theme":"Daisy"
    ],
    "Ashes": [
        "topColor": "#C8CBC3",
        "bottomColor": "#5C635A",
        "theme":"Ashes"
    ],
    "Beehive": [
        "topColor": "#ba9779",
        "bottomColor": "#910000",
        "theme":"Beehive"
    ],
    "Ferret": [
        "topColor": "#8B8484",
        "bottomColor": "#2D2C2A",
        "theme":"Ferret"
    ]
]

let defaultTheme = "Grass"
let defaultProfileImage = "propic"
let defaultCoverImage = "cover"
let DashboardDataUpdateUrl = serverBaseURL + "/Users/"
let FriendSuggstionUrl = serverBaseURL + "/suggestions/"
let topColorDefault = themeColors[CurrentTheme]!["topColor"]!
let bottomColorDefault = themeColors[CurrentTheme]!["bottomColor"]!
let appFont_black = "SourceSansPro-Black"
let appFont_bold = "SourceSansPro-Bold"
let appFont_regular = "SourceSansPro-Regular"
let appFont_light = "SourceSansPro-Light"

//Marks -- profileSettings
let nameCharacterLimit = 30
let networkErrorMessage = "Please check your internet connection"
let feedbackEmail = "crictrac@outlook.com"


