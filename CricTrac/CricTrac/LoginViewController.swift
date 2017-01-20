//
//  LoginViewController.swift
//  CricTrac
//
//  Created by Renjith on 8/2/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import KRProgressHUD
import SCLAlertView
import XLPagerTabStrip

class LoginViewController: UIViewController,IndicatorInfoProvider,GIDSignInDelegate, GIDSignInUIDelegate,ThemeChangeable {
    
    
    @IBOutlet weak var facebookBtn: UIButton!
    
    @IBOutlet weak var googleBtn: UIButton!
    
    @IBOutlet weak var username:UITextField!
    @IBOutlet weak var password:UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    let loginManager = FBSDKLoginManager()

    var myGroup = dispatch_group_create()
    var profileImage: UIImage?
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.boxColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        //setUIBackgroundTheme(self.view)
        
        
        
            }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Sign In")
    }
    
    @IBAction func forgotPwdBtnPressed(sender: AnyObject) {
        
        let forgotPwdVC = viewControllerFrom("Main", vcid: "ForgotPasswordViewController")
        
        self.presentViewController(forgotPwdVC, animated: true, completion: nil)
        
    }
    
    @IBAction func registerBtnTapped(sender: UIButton) {
        
        let registerVC = viewControllerFrom("Main", vcid: "RegisterViewController")
        
        self.presentViewController(registerVC, animated: true, completion: nil)
        
    }
     // MARK:- GoogleSignIn
    
    @IBAction func loginWithGoogle(sender: UIButton) {
        googleBtn.enabled = false
        loginWithGoogle()
        
    }

    @IBAction func loginWithUserNamePassword(){
        KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        
        
        
    loginWithMailAndPassword((username.text?.trimWhiteSpace)!, password: (password.text?.trimWhiteSpace)!) { (user, error) in
        
        if error != nil{
            
            KRProgressHUD.dismiss()
            SCLAlertView().showError("Login Error", subTitle: error!.localizedDescription)
            
           
        }
        else {
            KRProgressHUD.dismiss()
            if user!.emailVerified{
                currentUser = user
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                
//                currentUser?..getTokenForcingRefresh(true) {idToken, error in
//                    if error == nil {
//                        self.saveEmailToken(idToken!)
//                    }
//                }
                
                enableSync()
                self.navigateToNextScreen()
            }
            else
            {
                SCLAlertView().showError("Login Error", subTitle: "This email is has not been verified yet")
            }
        }
        
        }
        
    }
   
    
    func saveEmailToken(idToken:String){
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        var googleTokens: [String:String]!
        
        var facebookToken:[String:String]!
        
        var emailToken = ["tokenString":idToken]
        
        if let loginToken = userDefaults.valueForKey("loginToken") as? [String:AnyObject]{
            
            if let fbtoken = loginToken["Facebooktoken"]{
                
                facebookToken = fbtoken as! [String : String]
            }
            if let googletoken = loginToken["googletoken"]{
                
                googleTokens = googletoken as! [String : String]
            }
            
        }
        
        var token = [String:AnyObject]()
        
        token["Facebooktoken"] = facebookToken
        token["googletoken"] = googleTokens
        token["emailToken"] = emailToken
        
        userDefaults.setValue(token, forKey: "loginToken")
        
        userDefaults.synchronize()
        
        
        
    }

    
    
    
    func loginWithGoogle(){
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError?) {
        
        if error != nil{
            
            SCLAlertView().showError("Login Error", subTitle: "Error Occoured")
            self.googleBtn.enabled = true
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken,
                                                                     accessToken: authentication.accessToken)
        firebaseLogin(credential, sucess: { (user) in
            self.saveGoogleTocken(authentication.idToken, accessToken: authentication.accessToken)
            currentUser = user
            enableSync()
            self.navigateToNextScreen()
            }, failure: { (error) in
                
                KRProgressHUD.dismiss()
                
                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
                dispatch_after(delay, dispatch_get_main_queue()) {
                    
                    SCLAlertView().showError("Login Error", subTitle: error.localizedDescription)
                    self.googleBtn.enabled = true
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
    
    
    // MARK:- FBSignIn
    
    
    
    @IBAction func loginWithFB(sender: UIButton) {
        facebookBtn.enabled = false
        loginWithFacebook()
    }
    
    
    func loginWithFacebook(){
        
        
        loginManager.logInWithReadPermissions(["email"], fromViewController: self, handler: { (result, error) in
            if let error = error {
                
                SCLAlertView().showError("Login Error", subTitle:error.description)
                self.facebookBtn.enabled = true
            }
            else if(result.isCancelled) {
                
                SCLAlertView().showError("Login Error", subTitle: "Login Cancelled")
                self.facebookBtn.enabled = true
            }
            else {
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                
                
                firebaseLogin(credential, sucess: { (user) in
                    
                    self.saveFBToken(FBSDKAccessToken.currentAccessToken().tokenString)
                    currentUser = user
                    enableSync()
                    self.navigateToNextScreen()
                    }, failure: { (error) in
                        
                         KRProgressHUD.dismiss()
                        
                        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
                        dispatch_after(delay, dispatch_get_main_queue()) {
                           
                            SCLAlertView().showError("Login Error", subTitle: error.localizedDescription)
                            self.facebookBtn.enabled = true
                        }
                        
                       
                })
                
            }
        })
    }
    
    func saveFBToken(tokenString:String){
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let fbTokens = ["tokenString":tokenString]
        
        var googleToken:[String:AnyObject]!
        
        
        if let loginToken = userDefaults.valueForKey("loginToken") as? [String:AnyObject]{
            
            if let fbtoken = loginToken["googletoken"]{
                
                googleToken = fbtoken as! [String : String]
            }
            
        }
        
        var token = [String:AnyObject]()
        if googleToken != nil{
            token["googletoken"] = googleToken
        }
        token["Facebooktoken"] = fbTokens
        token["emailToken"] = nil
        userDefaults.setValue(token, forKey: "loginToken")
        
        userDefaults.synchronize()
    }
    
    func navigateToNextScreen(){
        
        
        
        
        if currentUser != nil && profileData.userExists {
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
            else
            {
                getImageFromFirebase(profileData.ProfileImageURL) { (imgData) in
                    LoggedInUserImage = imgData
                }
            }
            
            
            
            
        })
        
        
        dispatch_group_notify(myGroup, dispatch_get_main_queue(), {
            
            var window: UIWindow? = UIWindow(frame:UIScreen.mainScreen().bounds)
            
            if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let currentwindow = app.window {
                
                window = currentwindow
            }
            
            
            let rootViewController: UIViewController = getRootViewController()
            
            
            let profileVC = viewControllerFrom("Main", vcid: "ProfileBaseViewController") as! ProfileBaseViewController
            
            
            self.facebookBtn.enabled = true
            self.googleBtn.enabled = true
            
            
            
            if !profileData.userExists {
                
                KRProgressHUD.dismiss()
                window?.rootViewController = profileVC
                self.presentViewController(profileVC, animated: true) { KRProgressHUD.dismiss() }
            }
            else
            {
                KRProgressHUD.dismiss()
                window?.rootViewController = rootViewController
                self.presentViewController(rootViewController, animated: true) { KRProgressHUD.dismiss() }
            }
            
            
            
            
        })
        
        
        
        
    }

}
