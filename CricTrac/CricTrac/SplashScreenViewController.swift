//
//  SplashScreenViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 07/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import KRProgressHUD

class SplashScreenViewController: UIViewController {

    var window: UIWindow? = UIWindow(frame:UIScreen.mainScreen().bounds)
    var myGroup = dispatch_group_create()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let usrTheme = NSUserDefaults.standardUserDefaults().valueForKey("userTheme") {
            CurrentTheme = usrTheme as! String
        }
        
        setUIBackgroundTheme(self.view)
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
                
                if profileData.ProfileImageUrl == "" {
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
                    getImageFromFirebase(profileData.ProfileImageUrl) { (imgData) in
                        LoggedInUserImage = imgData
                    }
                }
                
                
                
            })
            
            dispatch_group_notify(myGroup, dispatch_get_main_queue(), {
                
                let drawerViewController = viewControllerFrom("Main", vcid: "SliderMenuViewController")
                
                let dashboardVC = viewControllerFrom("Main", vcid: "UserDashboardViewController") as! UserDashboardViewController
                
                let navigationControl = UINavigationController(rootViewController: dashboardVC )
                sliderMenu.mainViewController = navigationControl
                sliderMenu.drawerViewController = drawerViewController
                
                self.window?.rootViewController = sliderMenu
                
                let profileVC = viewControllerFrom("Main", vcid: "ProfileBaseViewController") as! ProfileBaseViewController
                
                
                if profileData.fullName == " " {
                    self.presentViewController(profileVC, animated: true) { KRProgressHUD.dismiss() }
                }
                else
                {
                    KRProgressHUD.dismiss()
                    self.presentViewController((self.window?.rootViewController)!, animated: true, completion: nil)
                }
                
                
                
                
            })

            
        }
        else
        {
            let loginVC = viewControllerFrom("Main", vcid: "LoginViewController")
            window?.rootViewController = loginVC
            
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
