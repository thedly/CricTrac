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

    
    // NavigationControllers
    
    var navTimeLine : UINavigationController?
    var navUserDashBoard : UINavigationController?
    var navCoachDashBoard : UINavigationController?
    var navFanDashBoard : UINavigationController?
    var navAddMatch : UINavigationController?
    var navMatchSummary : UINavigationController?
    var navFriends : UINavigationController?
    var navProfile : UINavigationController?
    var navSettings : UINavigationController?
    var navVersion: UINavigationController?
    
    @IBOutlet var baseView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
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
        
        
        logout(self)
        
    
        
       
        
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
        

//        if indexPath.row == 0
//        {
//            return
//        }
        
            
        if menuData[indexPath.row]["title"] == "PROFILE" && profileData.userExists {
            vcName = "ProfileReadOnlyViewController"

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
            let navigationControl = getNavigationControllerFor(vcName!)
            sliderMenu.mainViewController = navigationControl
            sliderMenu.setDrawerState(.Closed, animated: true)
    }
    
    
    func moveTo(vc:String){
        let navigationControl = getNavigationControllerFor(vc)
        sliderMenu.mainViewController = navigationControl
        sliderMenu.setDrawerState(.Closed, animated: true)
    }
    
}





/*
 ["title":"TIMELINE","vc":"timeline", "img": "Menu_TimeLine"],
 ["title":"DASHBOARD","vc":"UserDashboardViewController", "img": "Menu_Dashboard"],
 ["title":"NEW MATCH","vc":"AddMatchDetailsViewController", "img": "Menu_AddMatch"],
 ["title":"MATCH SUMMARY","vc":"MatchSummaryViewController", "img": "Menu_Summary"],
 ["title":"FRIENDS","vc":"FriendBaseViewController", "img": "Menu_Friends"],
 ["title":"PROFILE","vc":  "ProfileBaseViewController", "img": "Menu_Profile"],
 //    ["title":"STATISTICS","vc":"AddMatchDetailsViewController", "img": "Menu_Statistics"],
 //    ["title":"NOTIFICATION","vc":"MatchSummaryViewController", "img": "Menu_Summary"],
 ["title":"SETTINGS","vc":"SettingsViewController", "img": "Menu_Settings"],
 //    ["title":"FEEDBACK","vc":"MatchSummaryViewController", "img": "Menu_Summary"],
 //    ["title":"HELP & SUPPORT","vc":"MatchSummaryViewController", "img": "Menu_Summary"],
 ["title":"VERSION: \(versionAndBuildNumber)","vc":"MatchSummaryViewController", "img": "Menu_Summary"],
 */
extension SliderMenuViewController {
    
    func getNavigationControllerFor(vcName:String) -> UINavigationController {
        
        //let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //let vc  = storyboard.instantiateViewControllerWithIdentifier(vcName)
        switch vcName {
        case "timeline":
            if navTimeLine == nil {
                let dashboardVC = viewControllerFrom("Main", vcid: "timeline") as! TimeLineViewController
                navTimeLine = UINavigationController(rootViewController: dashboardVC)
            }
            return navTimeLine!
        case "UserDashboardViewController":
            if navUserDashBoard == nil {
                let dashboardVC = viewControllerFrom("Main", vcid: "UserDashboardViewController") as! UserDashboardViewController

                navUserDashBoard = UINavigationController(rootViewController: dashboardVC)
            }
            return navUserDashBoard!
        case "CoachDashboardViewController":
            if navCoachDashBoard == nil {
                let dashboardVC = viewControllerFrom("Main", vcid: "CoachDashboardViewController") as! CoachDashboardViewController

                navCoachDashBoard = UINavigationController(rootViewController: dashboardVC)
            }
            return navCoachDashBoard!
        case "FanDashboardViewController":
            if navFanDashBoard == nil {
                let dashboardVC = viewControllerFrom("Main", vcid: "FanDashboardViewController") as! FanDashboardViewController

                navFanDashBoard = UINavigationController(rootViewController: dashboardVC)
            }
            return navFanDashBoard!
        case "AddMatchDetailsViewController":
            if navAddMatch == nil {
                let dashboardVC = viewControllerFrom("Main", vcid: "AddMatchDetailsViewController") as! AddMatchDetailsViewController

                navAddMatch = UINavigationController(rootViewController: dashboardVC)
            }
            return navAddMatch!
        case "MatchSummaryViewController":
            if navMatchSummary == nil {
                let dashboardVC = viewControllerFrom("Main", vcid: "MatchSummaryViewController") as! MatchSummaryViewController

                navMatchSummary = UINavigationController(rootViewController: dashboardVC)
            }
            return navMatchSummary!
        case "FriendBaseViewController":
            if navFriends == nil {
                let dashboardVC = viewControllerFrom("Main", vcid: "FriendBaseViewController") as! FriendBaseViewController

                navFriends = UINavigationController(rootViewController: dashboardVC)
            }
            return navFriends!
        case "ProfileBaseViewController":
            if navProfile == nil {
                let dashboardVC = viewControllerFrom("Main", vcid: "ProfileBaseViewController") as! ProfileBaseViewController

                navProfile = UINavigationController(rootViewController: dashboardVC)
            }
            return navProfile!
        case "ProfileReadOnlyViewController":
            if navProfile == nil {
                let dashboardVC = viewControllerFrom("Main", vcid: "ProfileReadOnlyViewController") as! ProfileReadOnlyViewController
                
                navProfile = UINavigationController(rootViewController: dashboardVC)
            }
            return navProfile!
        case "SettingsViewController":
            if navSettings == nil {
                let dashboardVC = viewControllerFrom("Main", vcid: "SettingsViewController") as! SettingsViewController

                navSettings = UINavigationController(rootViewController: dashboardVC)
            }
            return navSettings!
        
            
        default:
            
            if navTimeLine == nil {
                let dashboardVC = viewControllerFrom("Main", vcid: "UserDashboardViewController") as! TimeLineViewController

                navTimeLine = UINavigationController(rootViewController: dashboardVC)
            }
            return navTimeLine!
            
            
        }
    }
}
