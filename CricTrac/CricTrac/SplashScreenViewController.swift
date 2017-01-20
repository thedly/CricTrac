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

class SplashScreenViewController: UIViewController,ThemeChangeable {

    var window: UIWindow? = UIWindow(frame:UIScreen.mainScreen().bounds)
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.boxColor
    }
    
    var myGroup = dispatch_group_create()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let currentwindow = app.window {
            
            window = currentwindow
        }
        
        if let usrTheme = NSUserDefaults.standardUserDefaults().valueForKey("userTheme") {
            CurrentTheme = usrTheme as! String
        }
        
        setBackgroundColor()
        
        //setUIBackgroundTheme(self.view)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        authorizeUser()
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
            else if let fbCredentials = credential.valueForKey("Facebooktoken") as? [String:String]{
                
                KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
                
                firebaseLoginWithFacebook(fbCredentials["tokenString"]! , sucess: { (user) in
                    
                    currentUser = user
                    
                    self.moveToNextScreen(true)
                    
                    }, failure: { (error) in
                        
                        self.moveToNextScreen(false)
                })
                
                
            }
//            else if let emailCredentials = credential.valueForKey("emailToken") as? [String:String]{
//                KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
//                
//                
//                FIRAuth.auth()?.signInWithCustomToken(emailCredentials["tokenString"]!, completion: { (user, error) in
//                    
//                    if error == nil {
//                        currentUser = user
//                        self.moveToNextScreen(true)
//                    }
//                    else
//                    {
//                        self.moveToNextScreen(false)
//                    }
//                    
//                })
//            }
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
                else
                {
                    getImageFromFirebase(profileData.ProfileImageURL) { (imgData) in
                        LoggedInUserImage = imgData
                    }
                }
                
                
                
            })
            
            dispatch_group_notify(myGroup, dispatch_get_main_queue(), {
                
                var rootViewController: UIViewController = getRootViewController()
                
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
            
        }
        
        
        
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
