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

let ProfilePictureUpdated = "ProfilePictureUpdated"
let CoverPictureUpdated = "CoverPictureUpdated"
public var date = 0

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
    
    ["title":"MAIL","vc":"UserDashboardViewController", "img": "mail_icon"],
    ["title":"MESSAGE","vc":"AddMatchDetailsViewController", "img": "message_icon"],
    ["title":"FACEBOOK","vc":"MatchSummaryViewController", "img": "facebook_icon"],
    ["title":"TWITTER","vc":"FriendBaseViewController", "img": "twitter_icon"]
]

let settingsMenuData = [
    
    //["title":"Show profile picture","vc":"ProfileBaseViewController", "img": "Menu_TimeLine", "desc": "Show profile picture to other users", "IsSwitchVisible": true],
    //["title":"Media Auto-Download","vc":"UserDashboardViewController", "img": "Menu_Dashboard", "desc": "Selecting no will auto-download media only while you are using wi-fi", "IsSwitchVisible": false],
    //["title":"Offline Matches","vc":"AddMatchDetailsViewController", "img": "Menu_AddMatch", "desc": "Matches to be downloaded for offline view", "IsSwitchVisible": false],
    ["title":"App Theme","vc":"ThemeSettingsViewController", "img": "Menu_Summary", "desc": "Choose desired theme color for your app", "IsSwitchVisible": false],
    ["title":"Change Password","vc":  "StaticPageViewController", "img": "Menu_Profile", "desc": "", "IsSwitchVisible": false, "contentToDisplay" : "https://arjun-innovations.firebaseapp.com/info/PrivacyPolicy.htm" ],
    ["title":"FAQ","vc":  "StaticPageViewController", "img": "Menu_Profile", "desc": "", "IsSwitchVisible": false, "contentToDisplay" : "https://arjun-innovations.firebaseapp.com/info/PrivacyPolicy.htm"],
    ["title":"Feedback","vc":  "StaticPageViewController", "img": "Menu_Profile", "desc": "", "IsSwitchVisible": false, "contentToDisplay" : "https://arjun-innovations.firebaseapp.com/info/PrivacyPolicy.htm" ],
    ["title":"Rate this app","vc":  "StaticPageViewController", "img": "Menu_Profile", "desc": "", "IsSwitchVisible": false, "contentToDisplay": "itms://itunes.apple.com/de/app/x-gift/id839686104?mt=8&uo=4"],
    ["title":"Terms & Conditions","vc":"StaticPageViewController", "img": "Menu_Statistics", "desc": "", "IsSwitchVisible": false, "contentToDisplay" : "https://arjun-innovations.firebaseapp.com/info/TermsofUse.htm" ],
    ["title":"Privacy Policy","vc":  "StaticPageViewController", "img": "Menu_Profile", "desc": "", "IsSwitchVisible": false, "contentToDisplay" : "https://arjun-innovations.firebaseapp.com/info/PrivacyPolicy.htm" ],
    ["title":"About","vc":  "StaticPageViewController", "img": "Menu_Profile", "desc": "", "IsSwitchVisible": false, "contentToDisplay" : "https://arjun-innovations.firebaseapp.com/info/PrivacyPolicy.htm" ],
     ["title":"Logout","vc":  "", "img": "Menu_Profile", "desc": "", "IsSwitchVisible": false]
]


var versionAndBuildNumber:String{

    let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
    
    let build = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
    
    return  (nsObject as! String)+" || Build: "+build

}


let adUnitId = "ca-app-pub-3940256099942544/2934735716"


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
//Grass - green theme (b4ed50 - 429321)
//Flash - yellow theme (fdef0f - b49b09)
//Feather - blue theme (c96dd8 - 3023ae)
//Peach - orange theme (fbda61 - f76b1c)
//Cherry - maroon theme (f5515f - 9f031b)
//Daisy - purple theme (eb56c1 - 961b74 )
//Ashes - grey theme (C8CBC3 - 5C635A)
//Beehive - brown theme (B8896B - 6F401B)
//Ferret - black theme (8B8484 - 2D2C2A)


let themeColors = [
    "Grass" : [
        "topColor" : "#b4ed50",
        "bottomColor" : "#429321",
        "theme":"grass"
    ],
    "Flash" : [
        "topColor" : "#fdef0f",
        "bottomColor" : "#b49b09",
        "theme":"flash"
    ],
    "Feather" : [
        "topColor" : "#c96dd8",
        "bottomColor": "#3023ae",
        "theme":"feather"
    ],
    "Peach": [
        "topColor": "#fbda61",
        "bottomColor": "#f76b1c",
        "theme":"peach"
    ],
    "Cherry": [
        "topColor": "#f5515f",
        "bottomColor": "#9f031b",
        "theme":"cherry"
    ],
    "Daisy": [
        "topColor": "#eb56c1",
        "bottomColor": "#961b74",
        "theme":"daisy"
    ],
    "Ashes": [
        "topColor": "#C8CBC3",
        "bottomColor": "#5C635A",
        "theme":"ashes"
    ],
    "Beehive": [
        "topColor": "#B8896B",
        "bottomColor": "#6F401B",
        "theme":"beehive"
    ],
    "Ferret": [
        "topColor": "#8B8484",
        "bottomColor": "#2D2C2A",
        "theme":"ferret"
    ]
]



//let themeColors = [
//    "Dawn" : [
//        "topColor" : "#4DA0B0",
//        "bottomColor" : "#D39D38",
//        "theme":"dawn"
//    ],
//    "MeanGreen" : [                                      
//        "topColor" : "#84CC00",
//        "bottomColor" : "#4D9D00",
//        "theme":"meanGreen"
//    ],
//    "Dusk" : [
//        "topColor" : "#434343",
//        "bottomColor": "#000000",
//        "theme":"dusk"
//    ],
//    "Sunset456": [
//        "topColor": "#FF9500",
//        "bottomColor": "#FF5E3A",
//        "theme":"sunSet678"
//    ],
//    "Turquoise": [
//        "topColor": "#136a8a",
//        "bottomColor": "#267871",
//        "theme":"turquoise"
//    ],
//    "Instagram": [
//        "topColor": "#517fa4",
//        "bottomColor": "#243949",
//        "theme":"instagram"
//    ],
//    "Mango": [
//        "topColor": "#ffcc33",
//        "bottomColor": "#ffb347",
//        "theme":"mango"
//    ],
//    "Hersheys": [
//        "topColor": "#9a8478",
//        "bottomColor": "#1e130c",
//        "theme":"hersheys"
//    ],
//    "Cocktail": [
//        "topColor": "#D38312",
//        "bottomColor": "#A83279",
//        "theme":"cocktail"
//    ],
//    "Earthly": [
//        "topColor": "#DBD5A4",
//        "bottomColor": "#649173",
//        "theme":"earthly"
//    ]
//]
//


let defaultTheme = "Grass"
let defaultProfileImage = "propic"
let DashboardDataUpdateUrl = "http://crictracserver.azurewebsites.net/Users/"
let FriendSuggstionUrl = "http://crictracserver.azurewebsites.net/suggestions/"
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


//Marks -- profileSettings
let nameCharacterLimit = 30
let networkErrorMessage = "Please check your internet connection"

