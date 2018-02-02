//
//  SplashScreenViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 07/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseAuth
import KeychainSwift
import GoogleSignIn
import Firebase
import SCLAlertView

class SplashScreenViewController: UIViewController,ThemeChangeable, GIDSignInDelegate, GIDSignInUIDelegate {

    var window: UIWindow? = UIWindow(frame:UIScreen.mainScreen().bounds)
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.boxColor
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    var myGroup = dispatch_group_create()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let currentwindow = app.window {
            window = currentwindow
            window?.makeKeyAndVisible()
        }
        
        if let usrTheme = NSUserDefaults.standardUserDefaults().valueForKey("userTheme") {
            CurrentTheme = usrTheme as! String
        }
        
        setBackgroundColor()
        
        //setUIBackgroundTheme(self.view)
        // Do any additional setup after loading the view.
        
        
        //screensize: 1-iPhone4, 2-iPhone5, 3-iPhone6, 4-iPhone6 plus
        if modelName == "iPhone 4"  || modelName == "iPhone 4s" {
            screensize = "1"
        }
        else if modelName == "iPhone 5"  || modelName == "iPhone 5s" || modelName == "iPhone 5c" {
            screensize = "2"
        }
        else if modelName == "iPhone 6 Plus"  || modelName == "iPhone 6s Plus" || modelName == "iPhone 7 Plus" || modelName == "iPhone 7s Plus" || modelName == "iPhone 8 Plus" || modelName == "iPhone X" {
            screensize = "4"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        loginWithSavedCredentials()
        //authorizeUser()
                
        fetchAdDetails({ (result) in
            adUnitId = result["adUnitId"]!
            showAds = result["showAds"]!
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func authorizeUser(){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let credential = userDefaults.valueForKey("loginToken") {
            if let googleCredentials = credential.valueForKey("googletoken") as? [String:String]{
                KRProgressHUD.show(message: "Loading...")
                firebaseLoginWithGoogle(googleCredentials["idToken"]!, accessToken:googleCredentials["accessToken"]! , sucess: { (user) in
                   currentUser = user
                    self.moveToNextScreen(true)
                    
                   }, failure: { (error) in
                       KRProgressHUD.dismiss()
                        self.moveToNextScreen(false)
                        print(error.localizedDescription)
               })
            }
//            else if let fbCredentials = credential.valueForKey("Facebooktoken") as? [String:String]{
//                KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
//                firebaseLoginWithFacebook(fbCredentials["tokenString"]! , sucess: { (user) in
//                    currentUser = user
//                    self.moveToNextScreen(true)
//                    }, failure: { (error) in
//                        self.moveToNextScreen(false)
//                })
//            }
//            else if let emailCredentials = credential.valueForKey("emailToken") as? [String:String]{
          
            //
//            if let emailCredentials = credential.valueForKey("emailToken") as? [String:String]{
//                KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
//                FIRAuth.auth()?.signInWithCustomToken(emailCredentials["tokenString"]!, completion: { (user, error) in
//                    if error == nil {
//                        currentUser = user
//                        self.moveToNextScreen(true)
//                    }
//                    else
//                    {
//                        self.moveToNextScreen(false)
//                    }
//                })
//            }
//            else
//            {
//                self.moveToNextScreen(false)
//            }
        }
        else
        {
            self.moveToNextScreen(false)
        }
    }
    
    func moveToNextScreen(IsAuthorized: Bool){
        if IsAuthorized {
            if currentUser != nil {
                updateLastLogin()
            }
            
            dispatch_group_enter(myGroup)
            getAllProfileData({ data in
                profileData = Profile(usrObj: data)
                dispatch_group_leave(self.myGroup)
                
                if profileData.ProfileImageURL == "" {
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    if let token = userDefaults.valueForKey("loginToken") {
                        if token["Facebooktoken"] != nil || token["googletoken"] != nil{
                            let profileimage = getImageFromFacebook()
                            addProfileImageData(profileimage)
                        }
                    }
                }
//                else
//                {
//                    let profilePic = profileData.ProfileImageURL
//                    getImageFromFirebase(profileData.ProfileImageURL) { (imgData) in
//                        LoggedInUserImage = imgData
//                    }
//                    getImageFromFirebase(profileData.CoverPhotoURL) { (imgData) in
//                        LoggedInUserCoverImage = imgData
//                    }
                //}
            })
            
            dispatch_group_notify(myGroup, dispatch_get_main_queue(), {
                let rootViewController: UIViewController = getRootViewController()
                let profileVC = viewControllerFrom("Main", vcid: "ProfileBaseViewController") as! ProfileBaseViewController
                
                if !profileData.userExists {
                    KRProgressHUD.dismiss()
                    self.window?.rootViewController = profileVC
                    self.presentViewController(profileVC, animated: true) { KRProgressHUD.dismiss() }
                }
                else
                {
                    KRProgressHUD.dismiss()
                    self.window?.rootViewController = rootViewController
                    self.presentViewController((self.window?.rootViewController)!, animated: true, completion: nil)
                }
            })
        }
        else
        {
            let loginVC = viewControllerFrom("Main", vcid: "LoginViewController")
            window?.rootViewController = loginVC
            KRProgressHUD.dismiss()
            self.presentViewController((self.window?.rootViewController)!, animated: true, completion: nil)
            
//            let registerVC = viewControllerFrom("Main", vcid: "RegisterViewController")
//            window?.rootViewController = registerVC
//            KRProgressHUD.dismiss()
//            self.presentViewController((self.window?.rootViewController)!, animated: true, completion: nil)
            
        }
    }
    
    func loginWithGoogle(){
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError?) {
//        if error != nil{
//            //SCLAlertView().showError("Login Error", subTitle: "Error Occoured")
//            self.googleBtn.enabled = true
//            return
//        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken,
                                                                     accessToken: authentication.accessToken)
        firebaseLogin(credential, sucess: { (user) in
            self.saveGoogleTocken(authentication.idToken, accessToken: authentication.accessToken)
            currentUser = user
            currentUser?.getTokenForcingRefresh(true) { accessToken, error in
                if error == nil {
                    self.saveGoogleTocken(authentication.idToken, accessToken: accessToken!)
                }
            }
            
            enableSync()
            self.navigateToNextScreen()
            }, failure: { (error) in
                KRProgressHUD.dismiss()
                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
                dispatch_after(delay, dispatch_get_main_queue()) {
                    SCLAlertView().showError("Login Error", subTitle: error.localizedDescription)
                    //self.googleBtn.enabled = true
                }
        })
    }
    
    func saveGoogleTocken(idToken:String,accessToken:String ){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let googleTokens = ["idToken":idToken,"accessToken":accessToken]
        var facebookToken:[String:String]!
        
        if let loginToken = userDefaults.valueForKey("loginToken") as? [String:AnyObject]{
            if let fbtoken = loginToken["Facebooktoken"]{
                facebookToken = fbtoken as! [String : String]
            }
        }
        
        var token = [String:AnyObject]()
        if facebookToken != nil{
            token["Facebooktoken"] = facebookToken
        }
        token["googletoken"] = googleTokens
        token["emailToken"] = nil
        userDefaults.setValue(token, forKey: "loginToken")
        userDefaults.synchronize()
    }
    
    func loginWithSavedCredentials(){
        // KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let credential = userDefaults.valueForKey("loginToken") {
            if let googleCredentials = credential.valueForKey("googletoken") as? [String:String]{
                KRProgressHUD.show(message: "Loading...")
                firebaseLoginWithGoogle(googleCredentials["idToken"]!, accessToken:googleCredentials["accessToken"]! , sucess: { (user) in
                    currentUser = user
                    self.moveToNextScreen(true)
                    
                    }, failure: { (error) in
                        KRProgressHUD.dismiss()
                        self.loginWithGoogle()
//                        self.moveToNextScreen(false)
//                        print(error.localizedDescription)
                })
            }
            else  if ((credential.valueForKey("emailToken") as? [String:String]) != nil){
            
        
                let keychain = KeychainSwift()
                if keychain.get("ct_userName") == nil {
                    self.authorizeUser()
                    self.moveToNextScreen(false)
                    return
                }
                if keychain.get("ct_password") == nil {
                    self.moveToNextScreen(false)
                    return
                }
                
                guard let userName = keychain.get("ct_userName") else {return}
                guard let password = keychain.get("ct_password") else {return}
                loginWithMailAndPassword(userName, password:password) { (user, error) in
                    KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
                    if error != nil{
                        KRProgressHUD.dismiss()
                        self.authorizeUser()
                    }
                    else {
                        KRProgressHUD.dismiss()
                        if user!.emailVerified{
                            
                            currentUser = user
                            enableSync()
                            self.navigateToNextScreen()
                        }
                    }
                }
            }
            else
            {
                self.moveToNextScreen(false)
            }
            
        }
        else
        {
            self.moveToNextScreen(false)
        }
    }

    func navigateToNextScreen(){
        var myGroup = dispatch_group_create()
//        if let userName = username.text?.trimWhiteSpace where userName != ""{
//            if let password = password.text?.trimWhiteSpace where password != "" {
//                let keychain = KeychainSwift()
//                keychain.set(userName, forKey: "ct_userName")
//                keychain.set(password, forKey: "ct_password")
//            }
//        }
        
        //get the saved app theme from database
        var newTheme:String?
        getAppTheme((currentUser?.uid)!, sucess: { (result) in
            newTheme = result
            
            if let usrTheme = NSUserDefaults.standardUserDefaults().valueForKey("userTheme") {
                CurrentTheme = usrTheme as! String
            }
            
            if CurrentTheme != newTheme! {
                CurrentTheme = newTheme!
                NSUserDefaults.standardUserDefaults().setValue(newTheme, forKeyPath: "userTheme")
                NSNotificationCenter.defaultCenter().postNotificationName("ThemeChanged", object: nil)
            }
            cricTracTheme.currentTheme = getPersistedTheme()
            //self.setBackgroundColor()
        })
        
        
        if currentUser != nil && profileData.userExists {
            updateLastLogin()
        }
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            getAllProfileData({ data in
                profileData = Profile(usrObj: data)
//                if profileData.ProfileImageURL == "" {
//                    let userDefaults = NSUserDefaults.standardUserDefaults()
//                    if let token = userDefaults.valueForKey("loginToken") {
//                        if token["Facebooktoken"] != nil || token["googletoken"] != nil{
//                            let profileimage = getImageFromFacebook()
//                            addProfileImageData(profileimage)
//                        }
//                    }
//                }
                //                else
                //                {
                //let profilePic = profileData.ProfileImageURL
                //                    getImageFromFirebase(profileData.ProfileImageURL) { (imgData) in
                //                        LoggedInUserImage = imgData
                //                    }
                //                    getImageFromFirebase(profileData.CoverPhotoURL) { (imgData) in
                //                        LoggedInUserCoverImage = imgData
                //                    }
                //}
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let window = getCurrentWindow()
                    let rootViewController: UIViewController = getRootViewController()
                    let profileVC = viewControllerFrom("Main", vcid: "ProfileBaseViewController") as! ProfileBaseViewController
//                    self.facebookBtn.enabled = true
//                    self.googleBtn.enabled = true
                    
                    //if profileData.DeviceInfo == "" {
                    if !profileData.userExists || profileData.Email.length == 0 {
                        KRProgressHUD.dismiss()
                        // window.rootViewController = profileVC
                        let nav = UINavigationController(rootViewController: profileVC)
                        self.presentViewController(nav, animated: true) { KRProgressHUD.dismiss() }
                    }
                    else
                    {
                        //let rootViewController: UIViewController = getRootViewController()
                        KRProgressHUD.dismiss()
                        /*
                         [UIView transitionWithView:self.window
                         duration:0.5
                         options:UIViewAnimationOptionTransitionFlipFromLeft
                         animations:^{ self.window.rootViewController = newViewController; }
                         completion:nil];
                         */
                        UIView.transitionWithView(window, duration: 1, options: .TransitionCurlDown, animations: {
                            window.rootViewController = rootViewController
                            self.presentViewController(rootViewController, animated: true) { KRProgressHUD.dismiss() }
                            }, completion: nil)
                    }
                    KRProgressHUD.dismiss()
                })
            })
        })
    }


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
