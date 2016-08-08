//
//  AppDelegate.swift
//  CricTrac
//
//  Created by Renjith on 7/15/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import Firebase
import KYDrawerController

import FBSDKCoreKit
import FirebaseDatabase
import FirebaseAuth
import GoogleSignIn
import KRProgressHUD

import SCLAlertView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame:UIScreen.mainScreen().bounds)


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FIRApp.configure()
        setSliderMenu()
        return true
    }
    
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
         KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        
        if GIDSignIn.sharedInstance().handleURL(url, sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String, annotation: options [UIApplicationOpenURLOptionsAnnotationKey]) {
            return true
        }
        
        let fb =  FBSDKApplicationDelegate.sharedInstance().application( app,  openURL: url, sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String, annotation: options [UIApplicationOpenURLOptionsAnnotationKey])
        
        return fb
        
    }

    

    
    
    func application(application: UIApplication, openURL url: NSURL,  sourceApplication: String?,  annotation: AnyObject) -> Bool {
        
        KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        
        if GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation) {
            return true
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application( application,  openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setSliderMenu(){
        let dashboardVC = viewControllerFrom("Main", vcid: "parallaxVC") as! parallaxVC

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let fbCredential = userDefaults.valueForKey("loginToken") {

            
            let drawerViewController = viewControllerFrom("Main", vcid: "SliderMenuViewController")
            
            let navigationControl = UINavigationController(rootViewController: dashboardVC )
            sliderMenu.mainViewController = navigationControl
            sliderMenu.drawerViewController = drawerViewController
            
            window?.rootViewController = sliderMenu
        
        
        }
        else {
            let loginVC = viewControllerFrom("Main", vcid: "LoginViewController")
            window?.rootViewController = loginVC
        }
        
    }

    
    func summaryClicked(sender: UIButton){
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : SummaryViewController = storyboard.instantiateViewControllerWithIdentifier("SummaryViewController") as! SummaryViewController
        
        sliderMenu.mainViewController.presentViewController(vc, animated: true, completion: nil)
        sliderMenu.setDrawerState(KYDrawerController.DrawerState.Closed, animated: true)
    }
    func profileBtnClicked(sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : ProfileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        
        sliderMenu.mainViewController.presentViewController(vc, animated: true, completion: nil)
        sliderMenu.setDrawerState(KYDrawerController.DrawerState.Closed, animated: true)

    }

}

