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

import Fabric
import Crashlytics

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
        registerForPushNotifications(application)
        FIRDatabase.database().persistenceEnabled = true
        Fabric.with([Crashlytics.self])
        setSliderMenu()
        
        let refreshedToken = FIRInstanceID.instanceID().token()
        
        return true
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
       //connectToFcm()
        
        
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
    }

    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
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

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        let splashScreenVC = viewControllerFrom("Main", vcid: "SplashScreenViewController")
        window?.rootViewController = splashScreenVC
    }
}

