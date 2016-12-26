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

var sliderMenu = KYDrawerController()
var currentUser:FIRUser?

var groundNames = [String]()
var teamNames = [String]()
var opponentTeams = [String]()
var dismissals = [String]()
var tournaments = [String]()
var results = [String]()
var profileData = Profile(usrObj: [String:String]())
var UserProfilesData = [Profile]()
var UserProfilesImages = [String: UIImage]()
var BattingStyles = [String]()
var BowlingStyles = [String]()
var PlayingRoles = [String]()
var AgeGroupData = [String]()
var PlayingLevels = [String]()
var genders = [String]()

var matchDataSource = [[String:String]]()
var profileDataChanged: Bool = false
var ThemeChanged: Bool = false
var timelineData:JSON?

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
        if view.accessibilityIdentifier == "greyMatter" || view.accessibilityIdentifier == "whiteMatter" {
                        if let lbl: UILabel = view as? UILabel {
                            lbl.textColor = UIColor(hex: "#000000")
                            lbl.alpha = 0.5
                            lbl.backgroundColor = UIColor.clearColor()
                        }
                        else if let btn: UIButton = view as? UIButton {
                            btn.setTitleColor(UIColor(hex: "#000000"), forState: .Normal)
                            btn.alpha = 0.3
                        }
                        else
                        {
                            view.backgroundColor = UIColor(hex: "#000000")
                            view.alpha = 0.3
                        }
            
        }
        
        // MARK: Backup in case we go back theme colors
        
//        if view.accessibilityIdentifier == "greyMatter" {
//            if let lbl: UILabel = view as? UILabel {
//                lbl.textColor = UIColor().darkerColorForColor(UIColor(hex: bottomColor))
//                lbl.backgroundColor = UIColor.clearColor()
//            }
//            else if let btn: UIButton = view as? UIButton {
//                btn.setTitleColor(UIColor().darkerColorForColor(UIColor(hex: bottomColor)), forState: .Normal)
//            }
//            else
//            {
//                view.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: bottomColor))
//            }
//        }
//        else if view.accessibilityIdentifier == "whiteMatter" {
//            if let lbl: UILabel = view as? UILabel {
//                lbl.textColor = UIColor().lighterColorForColor(UIColor(hex: topColor))
//                lbl.backgroundColor = UIColor.clearColor()
//            }
//            else if let btn: UIButton = view as? UIButton {
//                btn.setTitleColor(UIColor().lighterColorForColor(UIColor(hex: topColor)), forState: .Normal)
//            }
//            else
//            {
//                view.backgroundColor = UIColor().lighterColorForColor(UIColor(hex: topColor))
//            }
//        }
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




