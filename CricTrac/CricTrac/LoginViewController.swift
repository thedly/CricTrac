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

class LoginViewController: UIViewController,GIDSignInDelegate, GIDSignInUIDelegate {
    
    
    @IBOutlet weak var username:UITextField!
    @IBOutlet weak var password:UITextField!
    
    let loginManager = FBSDKLoginManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
     // MARK:- GoogleSignIn
    
    @IBAction func loginWithGoogle(sender: UIButton) {
        
        loginWithGoogle()
        
    }

    @IBAction func loginWithUserNamePassword(){
        
        
        
    loginWithMailAndPassword((username.text?.trimWhiteSpace)!, password: (password.text?.trimWhiteSpace)!) { (user, error) in
        
        if error != nil{
            
            SCLAlertView().showError("Login Error", subTitle: error!.localizedDescription)
            
           
        }
        else {
            currentUser = user
            enableSync()
            self.navigateToNextScreen()
            
        }
        
        }
        
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
    
    
    
    @IBAction func loginWithFB(sender: UIButton) {
        
        loginWithFacebook()
    }
    
    
    func loginWithFacebook(){
        
        
        loginManager.logInWithReadPermissions(["email"], fromViewController: self, handler: { (result, error) in
            if let error = error {
                
                SCLAlertView().showError("Login Error", subTitle:error.description)
            }
            else if(result.isCancelled) {
                
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
        
        let window: UIWindow? = UIWindow(frame:UIScreen.mainScreen().bounds)
        let dashboardVC = viewControllerFrom("Main", vcid: "CollapsibleTableViewController") as! CollapsibleTableViewController
        
        let drawerViewController = viewControllerFrom("Main", vcid: "SliderMenuViewController")
        
        let navigationControl = UINavigationController(rootViewController: dashboardVC )
        sliderMenu.mainViewController = navigationControl
        sliderMenu.drawerViewController = drawerViewController
        
        window?.rootViewController = sliderMenu
        
        self.presentViewController(sliderMenu, animated: true) {}
    }

}
