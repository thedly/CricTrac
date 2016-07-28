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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame:UIScreen.mainScreen().bounds)


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FIRApp.configure()
        setSliderMenu()
        return true
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
        let dashboardVC = viewControllerFrom("Main", vcid: "DashboardViewController") as! DashboardViewController
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC : MenuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController

        
//        let drawerViewController = UIViewController()
//        drawerViewController.view.backgroundColor = UIColor.whiteColor()
        
        
        // styling required for these buttons
//        let summaryBtn = UIButton(frame: CGRectMake(0, 20, 130, 100))
        
//        summaryBtn.setTitle("Summary", forState: .Normal)
//        summaryBtn.tintColor = UIColor(hex: "D8D8D8")
//        summaryBtn.setTitleColor(UIColor(hex: "000000"), forState: .Normal)
//        summaryBtn.setTitleColor(UIColor.redColor(), forState: .Highlighted)
//        summaryBtn.addTarget(self, action: "summaryClicked:", forControlEvents: .TouchUpInside)
//        drawerViewController.view.addSubview(summaryBtn)
        
        // styling required for these buttons
//        let profileBtn = UIButton(frame: CGRectMake(0, 80, 130, 100))
//        profileBtn.setTitle("Profile", forState: .Normal)
//        profileBtn.tintColor = UIColor(hex: "D8D8D8")
//        profileBtn.setTitleColor(UIColor(hex: "000000"), forState: .Normal)
//        profileBtn.setTitleColor(UIColor.redColor(), forState: .Highlighted)
//        profileBtn.addTarget(self, action: "profileBtnClicked:", forControlEvents: .TouchUpInside)
//        drawerViewController.view.addSubview(profileBtn)
        
        
        
        
        let navigationControl = UINavigationController(rootViewController: dashboardVC )
        sliderMenu.mainViewController = navigationControl
        sliderMenu.drawerViewController = menuVC
        
        
               
        
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = sliderMenu
        window?.makeKeyAndVisible()
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

