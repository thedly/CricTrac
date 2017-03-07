//
//  RegisterViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 19/09/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
import FirebaseDatabase
import FirebaseAuth

import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import KRProgressHUD
import SCLAlertView

class RegisterViewController: UIViewController,IndicatorInfoProvider,ThemeChangeable ,GIDSignInDelegate, GIDSignInUIDelegate {
   
    @IBOutlet weak var username:UITextField!
    @IBOutlet weak var password:UITextField!

    @IBOutlet weak var facebookBtn: UIButton!
    let loginManager = FBSDKLoginManager()
    @IBOutlet weak var googleBtn: UIButton!
    
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        //username.text = "bharathi92m@gmail.com"
       // password.text = "qwerty"
        //setUIBackgroundTheme(self.view)
        // Do any additional setup after loading the view.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Register")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK:- GoogleSignIn
    
   
    
    
    
    func loginWithGoogle(){
        
                GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
                GIDSignIn.sharedInstance().uiDelegate = self
                GIDSignIn.sharedInstance().delegate = self
                GIDSignIn.sharedInstance().signIn()
        
    }
    
    
        func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError?) {
    
            if error != nil{
                self.googleBtn.enabled = true
                SCLAlertView().showError("Login Error", subTitle: "Error Occoured")
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
                        self.googleBtn.enabled = true
                        SCLAlertView().showError("Login Error", subTitle: error.localizedDescription)
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
    
            userDefaults.setValue(token, forKey: "loginToken")
    
            userDefaults.synchronize()
    
    
    
        }
    
    
    // MARK:- FBSignIn
    
    
    
  
    
    
    func loginWithFacebook(){
        
        
        loginManager.logInWithReadPermissions(["email"], fromViewController: self, handler: { (result, error) in
            if let error = error {
                self.facebookBtn.enabled = true
                SCLAlertView().showError("Login Error", subTitle:error.description)
            }
            else if(result.isCancelled) {
                self.facebookBtn.enabled = true
                SCLAlertView().showError("Login Error", subTitle: "Login Cancelled")
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
                            self.facebookBtn.enabled = true
                            SCLAlertView().showError("Login Error", subTitle: error.localizedDescription)
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
        
        userDefaults.setValue(token, forKey: "loginToken")
        
        userDefaults.synchronize()
    }
    
    func navigateToNextScreen(){
        
        if let gBtn = self.googleBtn {
            gBtn.enabled = true
        }
        
        if let fBtn = self.facebookBtn {
            fBtn.enabled = true
        }
        
        var window: UIWindow? = UIWindow(frame:UIScreen.mainScreen().bounds)
        
        if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let currentwindow = app.window {
            
            window = currentwindow
        }
        
        let dashboardVC = viewControllerFrom("Main", vcid: "UserDashboardViewController") as! UserDashboardViewController
        
        let drawerViewController = viewControllerFrom("Main", vcid: "SliderMenuViewController")
        
        let navigationControl = UINavigationController(rootViewController: dashboardVC )
        sliderMenu.mainViewController = navigationControl
        sliderMenu.drawerViewController = drawerViewController
        // self.googleBtn.enabled = true
        //self.facebookBtn.enabled = true
        window?.rootViewController = sliderMenu
        
        self.presentViewController(sliderMenu, animated: true) {}
        KRProgressHUD.dismiss()
    }
    
    
    
}

extension RegisterViewController {
    
    @IBAction func closeRegisterViewTapped(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func loginWithGoogle(sender: UIButton) {
        googleBtn.enabled = false
        loginWithGoogle()
        
    }
    
    @IBAction func loginWithUserNamePassword(){
        
        KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        
        
        registerWithEmailAndPassword((username.text?.trimWhiteSpace)!, password: (password.text?.trimWhiteSpace)!) { (user, error) in
            KRProgressHUD.dismiss()
            if error == nil {
                
                user?.sendEmailVerificationWithCompletion() { error in
                    KRProgressHUD.dismiss()
                    if let error = error {
                        SCLAlertView().showError("Error", subTitle:error.localizedDescription)
                        // An error happened.
                    }
                        
                        // Email sent.
                    else {
                        
                        self.dismissViewControllerAnimated(true, completion: {
                            SCLAlertView().showInfo("Verify email", subTitle: "An email has been sent for verification")
                        }) }  } }
            else {
                
                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
                dispatch_after(delay, dispatch_get_main_queue()) {
                    SCLAlertView().showError("Registration Error", subTitle: error!.localizedDescription)
                }
                
                
                
            }
            
        }
        
    }
    @IBAction func loginWithFB(sender: UIButton) {
        self.facebookBtn.enabled = false
        loginWithFacebook()
    }
}
