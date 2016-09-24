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

var topColor = topColorDefault
var bottomColor = bottomColorDefault
var appThemeChanged: Bool = false

public func viewControllerFrom(storyBoard:String,vcid:String)->UIViewController{
    
    let storyboard = UIStoryboard(name:storyBoard, bundle: nil)
    
    return storyboard.instantiateViewControllerWithIdentifier(vcid)
}


public func setUIBackgroundTheme(baseView: UIView) {
    
    
    let background = CAGradientLayer().setGradientBackground(UIColor(hex: "\(topColor)").CGColor, bottomColor: UIColor(hex: "\(bottomColor)").CGColor)
    background.frame = baseView.bounds
    baseView.layer.insertSublayer(background, atIndex: 0)
    
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

