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

var sliderMenu = KYDrawerController()
var currentUser:FIRUser?

var groundNames = [String]()
var teamNames = [String]()
var opponentTeams = [String]()
var dismissals = [String]()
var tournaments = [String]()
var results = [String]()
var profileData = [String:String]()
var BattingStyles = [String]()
var BowlingStyles = [String]()
var PlayingRoles = [String]()
var PlayingLevels = [String]()
var genders = [String]()
var matchDataSource = [[String:String]]()
var profileDataChanged: Bool = false

private var _currentTheme: String = defaultTheme
var topColor = topColorDefault
var bottomColor = bottomColorDefault

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

func setColorForViewsWithSameTag(baseView: UIView) {
    for view in baseView.subviews {
        if view.accessibilityIdentifier == "greyMatter" {
            if let lbl: UILabel = view as? UILabel {
                lbl.textColor = UIColor().darkerColorForColor(UIColor(hex: bottomColor))
                lbl.backgroundColor = UIColor.clearColor()
            }
            else if let btn: UIButton = view as? UIButton {
                btn.setTitleColor(UIColor().darkerColorForColor(UIColor(hex: bottomColor)), forState: .Normal)
            }
            else
            {
                view.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: bottomColor))
            }
        }
        else if view.accessibilityIdentifier == "whiteMatter" {
            if let lbl: UILabel = view as? UILabel {
                lbl.textColor = UIColor().lighterColorForColor(UIColor(hex: topColor))
                lbl.backgroundColor = UIColor.clearColor()
            }
            else if let btn: UIButton = view as? UIButton {
                btn.setTitleColor(UIColor().lighterColorForColor(UIColor(hex: topColor)), forState: .Normal)
            }
            else
            {
                view.backgroundColor = UIColor().lighterColorForColor(UIColor(hex: topColor))
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

