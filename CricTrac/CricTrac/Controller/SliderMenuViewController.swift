//
//  SliderMenuViewController.swift
//  CricTrac
//
//  Created by Renjith on 7/28/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import SCLAlertView

class SliderMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ThemeChangeable {

    
    @IBOutlet var baseView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.boxColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        
        userName.text = profileData.fullName
        //baseView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: topColor))
        
        self.profileImage.image = LoggedInUserImage
        
        loadInitialValues();
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogout(sender: UIButton) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let _ = userDefaults.valueForKey("loginToken"){
            
            userDefaults.removeObjectForKey("loginToken")
            
        }
        
        var currentwindow = UIWindow()
        
        if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window {
            
            currentwindow = window
        }
        
        
        let loginBaseViewController = viewControllerFrom("Main", vcid: "LoginViewController")
        
        currentwindow.rootViewController = loginBaseViewController
        self.presentViewController(loginBaseViewController, animated: true) {
             SCLAlertView().showInfo("Logout",subTitle: "Data saved is cleared, Kill the app and relaunch for now")
        }
    
        
       
        
    }

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuData.count
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SliderMenuViewCell", forIndexPath: indexPath) as! SliderMenuViewCell
        let itemTitle = menuData[indexPath.row]["title"]
        
        let menuIcon = UIImage(named: menuData[indexPath.row]["img"]!)
        
        cell.menuName.text = itemTitle
        cell.menuIcon.image = menuIcon
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var vcName = menuData[indexPath.row]["vc"]
        
<<<<<<< HEAD
        if indexPath.row != 0{
            if menuData[indexPath.row]["title"] == "PROFILE" && profileData.fullName != " "{
                vcName = "ProfileReadOnlyViewController"
            }
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc  = storyboard.instantiateViewControllerWithIdentifier(vcName!)
            sliderMenu.mainViewController.presentViewController(vc, animated: true, completion: nil)
            sliderMenu.setDrawerState(.Closed, animated: true)
=======
        if menuData[indexPath.row]["title"] == "PROFILE" && profileData.userExists {
            vcName = "ProfileReadOnlyViewController"
>>>>>>> Backup
        }
        else if menuData[indexPath.row]["title"] == "DASHBOARD" {
            
            switch profileData.UserProfile {
            case userProfileType.Player.rawValue :
                vcName = "UserDashboardViewController"
                break
            case userProfileType.Coach.rawValue :
                vcName = "CoachDashboardViewController"
                break
            case userProfileType.Fan.rawValue :
                vcName = "FanDashboardViewController"
                break
            default:
                vcName = "UserDashboardViewController"
                break
                
            }
        }
        
    }

}
