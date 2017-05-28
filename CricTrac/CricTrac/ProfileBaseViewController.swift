//
//  ProfileBaseViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 10/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class ProfileBaseViewController: UIViewController , UIGestureRecognizerDelegate,ThemeChangeable {
    
    var ProfileBaseDetails: [String:AnyObject]!
    var NextVC: UIViewController!
   
    @IBOutlet weak var imgPlayer: UIImageView!
    @IBOutlet weak var imgCoach: UIImageView!
    @IBOutlet weak var imgFan: UIImageView!

    @IBAction func nextBtnPressed(sender: AnyObject) {
        
       // let nav1 = UINavigationController()
        let usrViewController = viewControllerFrom("Main", vcid: "UserInfoViewController") as! UserInfoViewController
        usrViewController.userProfile = profileData.UserProfile
        
        //  let nextViewController = viewControllerFrom("Main", vcid: "UserInfoViewController") as! UserInfoViewController
        var toViewController: UIViewController
        
        switch profileData.UserProfile {
        case userProfileType.Player.rawValue :
            toViewController = viewControllerFrom("Main", vcid: "PlayerExperienceViewController")
            //(toViewController as! PlayerExperienceViewController).userProfile = ""
        case userProfileType.Coach.rawValue :
            toViewController = viewControllerFrom("Main", vcid: "CoachingExperienceViewController")
        case userProfileType.Fan.rawValue :
            toViewController = viewControllerFrom("Main", vcid: "CricketFanViewController")
        default:
            toViewController = viewControllerFrom("Main", vcid: "PlayerExperienceViewController")
        }
        
        let window = UIApplication.sharedApplication().delegate?.window
        let vc = window!!.rootViewController
       // vc?.presentViewController(nav1, animated: true, completion: nil)
        self.navigationController?.pushViewController(usrViewController, animated: true)
    }
    
    @IBOutlet weak var playerTextView: radioSelectView!
    @IBOutlet weak var coachTextView: radioSelectView!
    @IBOutlet weak var cricketFanTextView: radioSelectView!
    
    let transitionManager = TransitionManager.sharedInstance
    
    func handleProfileTap(sender: UITapGestureRecognizer? = nil) {
        deselectAll(self.view)
        playerTextView.isSelected = true
        profileData.UserProfile = userProfileType.Player.rawValue
        
        self.imgPlayer.image = UIImage(named: "OkFilled")
        self.imgCoach.image = UIImage(named: "OkUnfilled")
        self.imgFan.image = UIImage(named: "OkUnfilled")
    }
    
    func handleCoachTap(sender: UITapGestureRecognizer? = nil) {
        deselectAll(self.view)
        coachTextView.isSelected = true
        profileData.UserProfile = userProfileType.Coach.rawValue
        
        self.imgPlayer.image = UIImage(named: "OkUnfilled")
        self.imgCoach.image = UIImage(named: "OkFilled")
        self.imgFan.image = UIImage(named: "OkUnfilled")
    }
    
    func handleFanTap(sender: UITapGestureRecognizer? = nil) {
        deselectAll(self.view)
        cricketFanTextView.isSelected = true
        profileData.UserProfile = userProfileType.Fan.rawValue
        
        self.imgPlayer.image = UIImage(named: "OkUnfilled")
        self.imgCoach.image = UIImage(named: "OkUnfilled")
        self.imgFan.image = UIImage(named: "OkFilled")
    }
    
    
    func setNavigationBarProperties(){
        var currentTheme:CTTheme!
        currentTheme = cricTracTheme.currentTheme
        let menuButton: UIButton = UIButton(type:.Custom)
        menuButton.setTitle("Logout", forState:.Normal)
        menuButton.titleLabel?.font = UIFont(name: appFont_black, size: 16)
        menuButton.addTarget(self, action: #selector(popAndLogout), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 80, 40)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        let addNewMatchButton: UIButton = UIButton(type:.Custom)
        addNewMatchButton.frame = CGRectMake(0, 0, 40, 40)
        addNewMatchButton.setTitle("NEXT", forState:.Normal)
        addNewMatchButton.titleLabel?.font = UIFont(name: appFont_black, size: 16)
        addNewMatchButton.addTarget(self, action: #selector(nextBtnPressed), forControlEvents: UIControlEvents.TouchUpInside)
        let righttbarButton = UIBarButtonItem(customView: addNewMatchButton)
        
        //assign button to navigationbar
        
        navigationItem.leftBarButtonItem = leftbarButton
        navigationItem.rightBarButtonItem = righttbarButton
        navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
        title = "CREATE PROFILE"
       // let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
       // navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    
    func popAndLogout() {
        logout(self)
    }
    
    
    @IBAction func disPressCancel(sender: AnyObject) {
          logout(self)
       // dismissViewControllerAnimated(true, completion: nil)
       // self.dismissViewControllerAnimated(true, completion: nil)
       // self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupControls() {
        if profileData.UserProfile.length > 0 {
            switch profileData.UserProfile {
                case userProfileType.Coach.rawValue:
                    self.coachTextView.isSelected = true
                    self.playerTextView.isSelected = false
                    self.cricketFanTextView.isSelected = false
                    self.imgPlayer.image = UIImage(named: "OkUnfilled")
                    self.imgCoach.image = UIImage(named: "OkFilled")
                    self.imgFan.image = UIImage(named: "OkUnfilled")

                //OkFilled
                case userProfileType.Player.rawValue:
                    self.playerTextView.isSelected = true
                    self.coachTextView.isSelected = false
                    self.cricketFanTextView.isSelected = false
                    self.imgPlayer.image = UIImage(named: "OkFilled")
                    self.imgCoach.image = UIImage(named: "OkUnfilled")
                    self.imgFan.image = UIImage(named: "OkUnfilled")
                case userProfileType.Fan.rawValue:
                    self.cricketFanTextView.isSelected = true
                    self.playerTextView.isSelected = false
                    self.coachTextView.isSelected = false
                    self.imgPlayer.image = UIImage(named: "OkUnfilled")
                    self.imgCoach.image = UIImage(named: "OkUnfilled")
                    self.imgFan.image = UIImage(named: "OkFilled")
                default:
                    self.playerTextView.isSelected = true
                    self.coachTextView.isSelected = false
                    self.cricketFanTextView.isSelected = false
                    self.imgPlayer.image = UIImage(named: "OkFilled")
                    self.imgCoach.image = UIImage(named: "OkUnfilled")
                    self.imgFan.image = UIImage(named: "OkUnfilled")
                }
                
            }
      
        
        
        let playertap = UITapGestureRecognizer(target: self, action: #selector(ProfileBaseViewController.handleProfileTap(_:)))
        playertap.delegate = self
        
        let coachtap = UITapGestureRecognizer(target: self, action: #selector(ProfileBaseViewController.handleCoachTap(_:)))
        coachtap.delegate = self
        
        let fantap = UITapGestureRecognizer(target: self, action: #selector(ProfileBaseViewController.handleFanTap(_:)))
        fantap.delegate = self
        
        playerTextView.userInteractionEnabled = true
        playerTextView.addGestureRecognizer(playertap)
        
        coachTextView.userInteractionEnabled = true
        coachTextView.addGestureRecognizer(coachtap)
        
        cricketFanTextView.userInteractionEnabled = true
        cricketFanTextView.addGestureRecognizer(fantap)
        profileData.UserProfile = userProfileType.Player.rawValue
        self.imgPlayer.image = UIImage(named: "OkFilled")
        self.imgCoach.image = UIImage(named: "OkUnfilled")
        self.imgFan.image = UIImage(named: "OkUnfilled")
        
    }
    
   
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
      //  navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setUIBackgroundTheme(self.view)
        setupControls();
        
        setNavigationBarProperties()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackgroundColor()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func deselectAll(baseView: UIView) {
        for view in baseView.subviews {
            if view.accessibilityIdentifier == "radioSelect" {
                if let lbl: radioSelectView = view as? radioSelectView {
                    lbl.isSelected = false;
                }
            }
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

