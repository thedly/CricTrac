//
//  utility.swift
//  CricTrac
//
//  Created by Renjith on 7/21/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation
import KYDrawerController
import FirebaseAuth
import SwiftyJSON
import SCLAlertView
import KRProgressHUD
import SwiftCountryPicker
import KeychainSwift

var sliderMenu = KYDrawerController()
var currentUser:FIRUser?

var groundNames = [String]()
var venueNames = [String]()
var teamNames = [String]()
var opponentTeams = [String]()
var dismissals = [String]()
var tournaments = [String]()
var results = [String]()

var CountriesList = [CustomCountry]()

var profileData = Profile(usrObj: [String:String]())
var LoggedInUserImage = UIImage(named: defaultProfileImage)
var UserProfilesData = [Profile]()
var UserProfilesImages = [String: UIImage]()
var userImageMetaData = NSURL()
var userCoverPhotoMetaData = NSURL()
var BattingStyles = [String]()
var BowlingStyles = [String]()
var PlayingRoles = [String]()
var AgeGroupData = [String]()

var friendsDataArray = [Friends]()
var friendsRequestsData = [ReceivedFriendRequest]()

var Achievements = [String]()

var DashboardDetails : DashboardData!

var PlayingLevels = [String]()
var genders = [String]()
var MatchStage = [String]()
var matchDataSource = [[String:AnyObject]]()
var profileDataChanged: Bool = false
var ThemeChanged: Bool = false
var timelineData:JSON?
var likeCountDic = [String:Int]()

private var _currentTheme: String = defaultTheme
var topColor = topColorDefault
var bottomColor = bottomColorDefault

var background: CAGradientLayer!

var CurrentTheme: String {
    set
    {
        _currentTheme = newValue
        topColor = themeColors[_currentTheme]!["topColor"]!
        bottomColor = themeColors[_currentTheme]!["bottomColor"]!
    }
    get { return _currentTheme }
}

public func viewControllerFrom(storyBoard:String,vcid:String)->UIViewController{
    
    let storyboard = UIStoryboard(name:storyBoard, bundle: nil)
    
    return storyboard.instantiateViewControllerWithIdentifier(vcid)
}

public func extractImages(userId:String) -> UIImage {
    if userId != "" {
        return UserProfilesImages[userId] ?? UIImage(named: "User")!
    }
    return UIImage(named: "User")!
}


public func getRootViewController() -> UIViewController {
    
    let drawerViewController: UIViewController = viewControllerFrom("Main", vcid: "SliderMenuViewController") as!SliderMenuViewController
    
    
    let dashboardVC = viewControllerFrom("Main", vcid: "timeline") as! TimeLineViewController
    let navigationControl = UINavigationController(rootViewController: dashboardVC )
    sliderMenu.mainViewController = navigationControl
    sliderMenu.drawerViewController = drawerViewController
    return sliderMenu
}

public func setUIBackgroundTheme(baseView: UIView) {
    
    
    let background = CAGradientLayer().setGradientBackground(UIColor(hex: "\(topColor)").CGColor, bottomColor: UIColor(hex: "\(bottomColor)").CGColor)
    background.frame = baseView.bounds
    baseView.layer.insertSublayer(background, atIndex: 0)
    
}

public func setCustomUIBackgroundTheme(baseView: UIView, _topColor:String, _bottomColor: String  ) {
    
    
    
    
    
    background = CAGradientLayer().setGradientBackground(UIColor(hex: "\(_topColor)").CGColor, bottomColor: UIColor(hex: "\(_bottomColor)").CGColor)
    background.frame = baseView.bounds
    
    
    baseView.layer.insertSublayer(background, atIndex: 0)
    
}

func setColorForViewsWithSameTag(baseView: UIView) {
    for view in baseView.subviews {
        
        
        // MARK: Setting all colors to black #000000
//        if view.accessibilityIdentifier == "greyMatter" || view.accessibilityIdentifier == "whiteMatter" {
//                        if let lbl: UILabel = view as? UILabel {
//                            lbl.textColor = UIColor(hex: "#000000")
//                            lbl.alpha = 0.5
//                            lbl.backgroundColor = UIColor.clearColor()
//                        }
//                        else if let btn: UIButton = view as? UIButton {
//                            btn.setTitleColor(UIColor(hex: "#000000"), forState: .Normal)
//                            btn.alpha = 0.3
//                        }
//                        else
//                        {
//                            view.backgroundColor = UIColor(hex: "#000000")
//                            view.alpha = 0.3
//                        }
//            
//        }
        
        // MARK: Backup in case we go back theme colors
        
        if view.accessibilityIdentifier == "greyMatter" {
            
            let botColor = UIColor().hexFromUIColor(cricTracTheme.currentTheme.bottomColor)
            
            
            if let lbl: UILabel = view as? UILabel {
                lbl.textColor = UIColor().darkerColorForColor(UIColor(hex: botColor))
                lbl.backgroundColor = UIColor.clearColor()
            }
            else if let btn: UIButton = view as? UIButton {
                btn.setTitleColor(UIColor().darkerColorForColor(UIColor(hex: botColor)), forState: .Normal)
            }
            else
            {
                view.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: botColor))
            }
        }
        else if view.accessibilityIdentifier == "whiteMatter" {
            
            
            let TopColor = UIColor().hexFromUIColor(cricTracTheme.currentTheme.topColor)
            
            if let lbl: UILabel = view as? UILabel {
                lbl.textColor = UIColor().lighterColorForColor(UIColor(hex: TopColor))
                lbl.backgroundColor = UIColor.clearColor()
            }
            else if let btn: UIButton = view as? UIButton {
                btn.setTitleColor(UIColor().lighterColorForColor(UIColor(hex: TopColor)), forState: .Normal)
            }
            else
            {
                view.backgroundColor = UIColor().lighterColorForColor(UIColor(hex: TopColor))
            }
        }
    }
}

func updateBackgroundTheme(baseView: UIView) {
    
    let newbackground = CAGradientLayer().setGradientBackground(UIColor(hex: "\(topColor)").CGColor, bottomColor: UIColor(hex: "\(bottomColor)").CGColor)
    newbackground.frame = baseView.bounds
    
    baseView.layer.replaceSublayer(baseView.layer.sublayers![0], with: newbackground)
}

public func viewController(vcid:String)->UIViewController{
    
    let storyboard = UIStoryboard(name:"Main", bundle: nil)
    
    return storyboard.instantiateViewControllerWithIdentifier(vcid)
}


func += <K, V> (inout left: [K:V], right: [K:V]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}


//MARK :- Firebase Auth

public func firebaseLogin(credential: FIRAuthCredential, sucess:(FIRUser)->Void,failure:(NSError)->Void){
    
    FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
        
        if user != nil{
            sucess(user!)
        }
        else{
            failure(error!)
        }
        
    }
}


public func firebaseLoginWithFacebook(fbToken:String,sucess:(FIRUser)->Void,failure:(NSError)->Void){
    
    let credential = FIRFacebookAuthProvider.credentialWithAccessToken(fbToken)
    firebaseLogin(credential, sucess: { (user) in
        
        sucess(user)
        
        }) { (error) in
            
        failure(error)
    }
}



public func firebaseLoginWithGoogle(idToken:String,accessToken:String,sucess:(FIRUser)->Void,failure:(NSError)->Void){
    
    let credential = FIRGoogleAuthProvider.credentialWithIDToken(idToken,
                                                                 accessToken:accessToken)
    firebaseLogin(credential, sucess: { (user) in
        
        sucess(user)
        
    }) { (error) in
        
        failure(error)
    }
}

public func currentTimeMillis() -> Int64{
    let nowDouble = NSDate().timeIntervalSince1970
    return Int64(nowDouble*1000)
}


public func directoryExistsInsideDocuments(name:String)->Bool{
    
    let fileManager = NSFileManager()
    var isDir : ObjCBool = false
    let docPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    if fileManager.fileExistsAtPath(docPath+"/\(name)", isDirectory:&isDir) {
        if isDir {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
    
}


public func fileExists(url:String)->Bool{
    
    let fileManager = NSFileManager()
    var isDir : ObjCBool = false
 
    if fileManager.fileExistsAtPath(url, isDirectory:&isDir) {
        if isDir {
            return false
        } else {
            return true
        }
    } else {
        return false
    }
    
}


public func createDirectoryInsideDocuments(name:String)->Bool{
    
    let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    let documentsDirectory: AnyObject = paths[0]
    let dataPath = documentsDirectory.stringByAppendingPathComponent(name)
    
    do {
        try NSFileManager.defaultManager().createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil)
        return true
    } catch _ as NSError {
        return false
    }
}

var documentsDirectory:AnyObject {
    return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
}

func saveToCachedImages(image:UIImage,imageName:String){

        if let data = UIImagePNGRepresentation(image) {
            let filename = documentsDirectory.stringByAppendingPathComponent("cachedImages/\(imageName).png")
             data.writeToFile(filename, atomically: false)
        }
}


public func logout(currentController: UIViewController) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    
    try! FIRAuth.auth()!.signOut() 
    
    let keychain = KeychainSwift()
    keychain.delete("ct_userName")
    keychain.delete("ct_password")
    
    if let _ = userDefaults.valueForKey("loginToken"){
        
        userDefaults.removeObjectForKey("loginToken")
        
    }
    
    var currentwindow = UIWindow()
    
    if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window {
        
        currentwindow = window
    }
    
    
    
    currentwindow.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    
    let loginBaseViewController = viewControllerFrom("Main", vcid: "LoginViewController")
    
    currentwindow.rootViewController = loginBaseViewController
    
    currentwindow.makeKeyAndVisible()
    
    
    
    //currentController.presentViewController(loginBaseViewController, animated: true) {
        //SCLAlertView().showInfo("Logout",subTitle: "Data saved is cleared, Kill the app and relaunch for now") 
    //}
    
}

public func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        if(background != nil){ background!(); }
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue()) {
            if(completion != nil){ completion!(); }
        }
    }
}

public func getCurrentWindow() -> UIWindow {
    var window = UIWindow(frame:UIScreen.mainScreen().bounds)
    
    if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let currentwindow = app.window {
        
        window = currentwindow
    }
    return window
}

func getPreviousViewController(currentController: UIViewController) -> UIViewController {
    if let presentingVC = currentController.presentingViewController {
        return presentingVC
    }
    return currentController
}

public struct CustomCountry {
    
    /// Name of the country
    public let name : String!
    
    /// ISO country code of the country
    public let iso : String!
    
    /// Emoji flag of the country
    public let emoji: String!
    
}


public func loadCountriesData() {
    let bundlePath = NSBundle(forClass: CountryPicker.self).pathForResource("SwiftCountryPicker", ofType: "bundle")
    
    if let path = NSBundle(path: bundlePath!)!.pathForResource("EmojiCountryCodes", ofType: "json")
    {
        
        do {
            let jsonData = try NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments)
            
            var countryCode: String?
            
            if let local = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as? String {
                countryCode = local
            }
            
            
            guard let countries = json as? NSArray else {
                print("countries is not an array")
                return
            }
            
            for subJson in countries{
                
                guard let name = subJson["name"] as? String, iso = subJson["code"] as? String, emoji = subJson["emoji"] as? String else {
                    
                    print("couldn't parse json")
                    
                    break
                }
                
                let country = CustomCountry(name: name, iso: iso, emoji: emoji)
                                
                // append country
                CountriesList.append(country)
            }
            
            CountriesList.sortInPlace { $1.name > $0.name }
            
        } catch {
            print("error reading file")
            
        }
    }
    
}
