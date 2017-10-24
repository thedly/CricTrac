//
//  SliderMenuViewController.swift
//  CricTrac
//
//  Created by Renjith on 7/28/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import SCLAlertView
import KYDrawerController
import Kingfisher
import Firebase


class SliderMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ThemeChangeable,KYDrawerControllerDelegate {
    
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
    @IBOutlet weak var tableView : UITableView!
    
    var menuDataArray = menuData
    var profilePic:String?
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setBackgroundColor()
        userName.text = profileData.fullName
        profilePic = profileData.ProfileImageURL
        
        loginWithSavedCredentials()
               
        if let _ = profileData.UserProfile as? String {
            removeUnwantedMenu()
        }else{
            getAllUserProfileInfo {
            self.removeUnwantedMenu()
            }
        }
        
        loadInitialValues();
        
        if profileData.Email != "" {
            fetchBasicProfile((currentUser?.uid)!, sucess: { (result) in
                let fullname = result["firstname"]! + " " + result["lastname"]!
                self.userName.text = fullname
                
                let proPic = result["proPic"]
                
                if proPic! == "-"{
                    let imageName = defaultProfileImage
                    let image = UIImage(named: imageName)
                    self.profileImage.image = image
                }
                else{
                    if let imageURL = NSURL(string:proPic!){
                        self.profileImage.kf_setImageWithURL(imageURL)
                    }
                }
            })
        }
        else {
            userName.text = profileData.fullName
            profilePic = profileData.ProfileImageURL
        }
        
//        NSNotificationCenter.defaultCenter().addObserverForName(ProfilePictureUpdated, object: nil, queue: nil) { (notification) in
//            if self.profilePic == "-" {
//                let imageName = defaultProfileImage
//                let image = UIImage(named: imageName)
//                self.profileImage.image = image!
//            }else{
//                if let imageURL = NSURL(string:self.profilePic!){
//                    self.profileImage.kf_setImageWithURL(imageURL)
//                }
//            }
//            //self.profileImage.image = LoggedInUserImage
//        }
        // Do any additional setup after loading the view.
        
       // let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if FIRInstanceID.instanceID().token() != nil {
            if profileData.FirstName != "" {
                saveFCMToken(FIRInstanceID.instanceID().token()!)
            }
        }
        
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let deviceToken = appDelegate.tokenString
//        
//        if deviceToken != "" {
//            saveFCMToken(deviceToken)
//        }
        
    }
    
    @IBAction func profileImageButtonTapped(sender: UIButton) {
        
       let profileImageVc = viewControllerFrom("Main", vcid: "ProfileImageExpandingVC") as! ProfileImageExpandingVC
        
        profileImageVc.imageString = profileData.ProfileImageURL
        if profileData.ProfileImageURL != "-" {
            self.presentViewController(profileImageVc, animated: true) {}
        }
    }
    
    func removeUnwantedMenu(){
        //if let userType = loggedInUserInfo["UserProfile"] as? String where userType != "Player"{
        if let userType = profileData.UserProfile as? String where userType != "Player"{
            if let newMatchIndex =  self.menuDataArray.indexOf({ $0["title"] == "ADD MATCH"}){
                self.menuDataArray.removeAtIndex(newMatchIndex)
               //tableView.reloadData()
            }
            
            //if let matchSummaryIndexIndex =  self.menuDataArray.indexOf({ $0["title"] == "MATCH SUMMARY"}){
            if let matchSummaryIndexIndex =  self.menuDataArray.indexOf({ $0["title"] == "SCOREBOARD"}){
                self.menuDataArray.removeAtIndex(matchSummaryIndexIndex)
                //tableView.reloadData()
            }
        }
    }

    func drawerController(drawerController: KYDrawerController, stateChanged state: KYDrawerController.DrawerState) {
        
        if profilePic == "-" {
            let imageName = defaultProfileImage
            let image = UIImage(named: imageName)
            profileImage.image = image!
        }else{
            if let imageURL = NSURL(string:profilePic!){
                profileImage.kf_setImageWithURL(imageURL)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setBackgroundColor()
        userName.text = profileData.fullName
        profilePic = profileData.ProfileImageURL
        
        if profilePic == "-" {
            let imageName = defaultProfileImage
            let image = UIImage(named: imageName)
            profileImage.image = image!
        }else{
            if let imageURL = NSURL(string:profilePic!){
                profileImage.kf_setImageWithURL(imageURL)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
        return menuDataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SliderMenuViewCell", forIndexPath: indexPath) as! SliderMenuViewCell
        let itemTitle = menuDataArray[indexPath.row]["title"]
        let menuIcon = UIImage(named: menuDataArray[indexPath.row]["img"]!)
        cell.menuName.text = itemTitle
        cell.menuIcon.image = menuIcon
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var vcName = menuDataArray[indexPath.row]["vc"]

//        if indexPath.row == 0
//        {
//            return
//        }
        
        if menuDataArray[indexPath.row]["title"] == "PROFILE" && profileData.userExists {
            vcName = "ProfileReadOnlyViewController"
        }
        else if menuDataArray[indexPath.row]["title"] == "SIGHTSCREEN" {
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
    
    func loginWithSavedCredentials(){
        // KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let loggedInImage: UIButton = UIButton(type:.Custom)
        
        if let credential = userDefaults.valueForKey("loginToken") {
            if (credential.valueForKey("emailToken") as? [String:String]) != nil{
                    loggedInImage.setImage(UIImage(named: "mail_icon"), forState: UIControlState.Normal)
                    loggedInImage.frame = CGRectMake(165, 28, 30, 30)
            }
            
            else  {
                loggedInImage.setImage(UIImage(named: "Google Plus-96"), forState: UIControlState.Normal)
                loggedInImage.frame = CGRectMake(170, 30, 25, 25)
            }
            self.baseView.addSubview(loggedInImage)
        }
    }
}


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
            //if navAddMatch == nil {
            let launchedAddMatch = NSUserDefaults.standardUserDefaults().boolForKey("launchedAddMatch")
            
            if !launchedAddMatch  {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launchedAddMatch")
                let rootVC = viewControllerFrom("Main", vcid: "AddMatchIntroScreens" ) as! AddMatchIntroScreens
                 navAddMatch = UINavigationController(rootViewController: rootVC)
               
//                UINavigationBar.appearance().shadowImage = UIImage()
//                UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
//                self.navigationController?.navigationBarHidden
            }
            
            else {
                let dashboardVC = viewControllerFrom("Main", vcid: "AddMatchDetailsViewController") as! AddMatchDetailsViewController
                
                navAddMatch = UINavigationController(rootViewController: dashboardVC)
                
            }
            
            //  }
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
