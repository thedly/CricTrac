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
//var websiteUrl = "https://arjun-innovations.firebaseapp.com"
//prod website url
//var websiteUrl = "https://crictrac.com"

public var loggedInUserInfo = [String:AnyObject]()
var friendsCity = [String:String]()

public var loggedInUserName:String?{

    guard let firstName = loggedInUserInfo["FirstName"] as? String else {return nil}
    guard let lastName =  loggedInUserInfo["LastName"] as? String else { return nil}
    return firstName + " " + lastName
}

public extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}

let modelName = UIDevice.currentDevice().modelName
var systemVersion = UIDevice.currentDevice().systemVersion

var versionAndBuildNumber:String{
    let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
    let build = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
    return  (nsObject as! String) + "(" + build + ")"
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
    ["title":"Rate this app","vc":  "StaticPageViewController", "img": "Menu_Settings", "desc": "", "IsSwitchVisible": false, "contentToDisplay": "itms-apps://itunes.apple.com/app/1137502744"],
    ["title":"Feedback","vc":  "Feedback", "img": "Menu_Settings", "desc": "", "IsSwitchVisible": false, "contentToDisplay" : "" ],
    ["title":"FAQ","vc":  "StaticPageViewController", "img": "Menu_Settings", "desc": "", "IsSwitchVisible": false, "contentToDisplay" : "https://crictrac.com/AppFiles/FAQ.htm"],
    ["title":"Terms & Conditions","vc":"StaticPageViewController", "img": "Menu_Settings", "desc": "", "IsSwitchVisible": false, "contentToDisplay" : "https://crictrac.com/AppFiles/TermsofUse.htm" ],
    ["title":"Privacy Policy","vc":  "StaticPageViewController", "img": "Menu_Settings", "desc": "", "IsSwitchVisible": false, "contentToDisplay" : "https://crictrac.com/AppFiles/PrivacyPolicy.htm" ],
    ["title":"About","vc":  "StaticPageViewController", "img": "Menu_Settings", "desc": "", "IsSwitchVisible": false, "contentToDisplay" : "https://crictrac.com/AppFiles/AboutUs.htm" ],
//    ["title":"About","vc":  "About", "img": "Menu_Settings", "desc": "", "IsSwitchVisible": false, "contentToDisplay" : "" ],
     ["title":"Logout","vc":  "", "img": "Menu_Settings", "desc": "", "IsSwitchVisible": false],
     ["title":"Version","vc":  "Version", "img": "", "desc": "", "IsSwitchVisible": false]
]



//variable to decide whether to show the AD or not
var showAds = "1"
//let adUnitId = "ca-app-pub-3940256099942544/2934735716"
var adUnitId = ""


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
    "Beamer" : [
        "topColor" : "#F0FE00",
        "bottomColor" : "#FF8F05",
        "theme":"Beamer"
    ],
    "Feather" : [
        "topColor" : "#ea9eff",
        "bottomColor": "#692580",
        "theme":"Feather"
    ],
    "Slice": [
        "topColor": "#fbda61",
        "bottomColor": "#f76b1c",
        "theme":"Slice"
    ],
    "Cherry": [
        "topColor": "#D40D12",
        "bottomColor": "5C0002",
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
    ],
    "Glove": [
        "topColor": "#3BACB2",
        "bottomColor": "#295154",
        "theme":"Glove"
    ],
    "Flash": [
        "topColor": "#09BD66",
        "bottomColor": "#044C29",
        "theme":"Flash"
    ],
    "Swing": [
        "topColor": "#40627C",
        "bottomColor": "#26393D",
        "theme":"Swing"
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


