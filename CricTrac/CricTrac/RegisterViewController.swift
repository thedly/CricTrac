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

class RegisterViewController: UIViewController,IndicatorInfoProvider,ThemeChangeable ,GIDSignInDelegate, GIDSignInUIDelegate,UITextFieldDelegate{
   
    @IBOutlet weak var registerBottomViewLabel: UILabel!
    @IBOutlet weak var fbGoogleButtonsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var username:UITextField!
    @IBOutlet weak var password:UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var facebookBtn: UIButton!
    let loginManager = FBSDKLoginManager()
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var facebookBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var googleBtnHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topBarView: UIView!
    
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        topBarView.backgroundColor = currentTheme.topColor
         setPlainShadow(topBarView, color: currentTheme.bottomColor.CGColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.delegate = self
        facebookBtn.hidden = true
       // googleBtn.hidden = true
        
        //fbGoogleButtonsHeightConstraint.constant = 0
        facebookBtnHeightConstraint.constant = 0
       // googleBtnHeightConstraint.constant = 0
        //username.text = ""
        // password.text = ""
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        setBackgroundColor()

    }
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Register")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInBtnTapped(sender: UIButton) {
        
        let loginVC = viewControllerFrom("Main", vcid: "LoginViewController")
        self.presentViewController(loginVC, animated: true, completion: nil)
    }
    
    
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
    
            //var facebookToken:[String:String]!
    
//            if let loginToken = userDefaults.valueForKey("loginToken") as? [String:AnyObject]{
//                if let fbtoken = loginToken["Facebooktoken"]{
//                    facebookToken = fbtoken as! [String : String]
//                }
//            }
    
            var token = [String:AnyObject]()
//            if facebookToken != nil{
//                token["Facebooktoken"] = facebookToken
//            }
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
         self.googleBtn.enabled = true
        //self.facebookBtn.enabled = true
        window?.rootViewController = sliderMenu
        
        self.presentViewController(sliderMenu, animated: true) {}
        KRProgressHUD.dismiss()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField ==  password {
          if  password.text?.characters.count <= 6 {
                let alert = UIAlertController(title: "", message: "Password must be more than 6 characters", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        
        if textField == password {
           return newLength <= 20
        }
        return true
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
        
        if username.text?.trimWhiteSpace != "" || password.text?.trimWhiteSpace != "" || confirmPassword.text?.trimWhiteSpace != "" {
            if password.text?.trimWhiteSpace == confirmPassword.text?.trimWhiteSpace {
                
                KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
                registerWithEmailAndPassword((username.text?.trimWhiteSpace)!, password: (password.text?.trimWhiteSpace)!) { (user, error) in
                    KRProgressHUD.dismiss()
                     if error == nil {
                
                        user?.sendEmailVerificationWithCompletion() { error in
                            KRProgressHUD.dismiss()
                            if let error = error {
                               // SCLAlertView().showError("Error123", subTitle:error.localizedDescription)
                                let alert = UIAlertController(title: "", message: "Inavlid details", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                          
                                // An error happened.
                            }
                                // Email sent.
                            else {
                               
                                  //  SCLAlertView().showInfo("Verify email", subTitle: "An email has been sent for verification")
                                    let alert = UIAlertController(title: "", message: "Please check your email (\(self.username.text!)) and verify the account.", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                }))
                                    self.presentViewController(alert, animated: true, completion: nil)
                            }
                        }
                    }
                    else {
                        if FIRAuth.auth()?.currentUser != "" && FIRAuth.auth()?.currentUser?.emailVerified == false && FIRAuth.auth()?.currentUser?.email == self.username.text {
                            
                            let alert = UIAlertController(title: "Verify Email", message: "Email verification is pending for this account. Do you want to resend the verification email?", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                            
                            alert.addAction(UIAlertAction(title: "Resend", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                                FIRAuth.auth()?.currentUser?.sendEmailVerificationWithCompletion({ (error) in
                                    self.verifyAlertForRegisteration()
                                })
                                
                            }))
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                        else {
                        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
                        dispatch_after(delay, dispatch_get_main_queue()) {
                          //  SCLAlertView().showError("Registration Error", subTitle: error!.localizedDescription)
                            let alert = UIAlertController(title: "", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }))
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                      }
                    }
                }
            }
            else {
                let alert = UIAlertController(title: "", message: "Passwords are not matching", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        else{
            let alert = UIAlertController(title: "", message: "Email/Password is empty", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    
    }
    
    func verifyAlertForRegisteration(){
        
        //  SCLAlertView().showInfo("Verify email", subTitle: "An email has been sent for verification")
        let alert = UIAlertController(title: "", message: "Please check your email (\(self.username.text!)) and verify the account.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func loginWithFB(sender: UIButton) {
        self.facebookBtn.enabled = false
        loginWithFacebook()
    }
    
    @IBAction func termsAndConditionsBtnTapped(sender: UIButton) {
        let menuDataArray = settingsMenuData
         let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vcName = menuDataArray[6]["vc"]
        
        if vcName == "StaticPageViewController" {
            let viewCtrl = storyboard.instantiateViewControllerWithIdentifier(vcName! as! String) as! StaticPageViewController
            viewCtrl.pageToLoad = menuDataArray[6]["contentToDisplay"] as! String + "?color=\(topColor)"
            viewCtrl.pageHeaderText = (menuDataArray[6]["title"] as! String).uppercaseString
            presentViewController(viewCtrl, animated: true, completion: nil)
        }
        
    }
    
}
