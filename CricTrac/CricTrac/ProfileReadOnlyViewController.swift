//
//  ProfileReadOnlyViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 19/12/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class ProfileReadOnlyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,ThemeChangeable {

    @IBOutlet weak var PersonalInfoView: UIView!
    @IBOutlet weak var PlayerExperienceView: UIView!
    @IBOutlet weak var CoachingExperienceView: UIView!
    @IBOutlet weak var CricketFanView: UIView!
    @IBOutlet weak var matchViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerExprHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cricketFanHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var coachingExprHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    @IBOutlet weak var PlayingRole: UILabel!
    @IBOutlet weak var NameText: UILabel!
    @IBOutlet weak var DOBText: UILabel!
    @IBOutlet weak var EmailText: UILabel!
    @IBOutlet weak var MobileText: UILabel!
    @IBOutlet weak var GenderText: UILabel!
    @IBOutlet weak var CountryText: UILabel!
    @IBOutlet weak var StateText: UILabel!
    @IBOutlet weak var CityText: UILabel!
    @IBOutlet weak var PlayerCurrentTeams: UILabel!
    @IBOutlet weak var PlayerPastTeams: UILabel!
    @IBOutlet weak var PlayerBattingStyle: UILabel!
    @IBOutlet weak var PlayerBowlingStyle: UILabel!
    @IBOutlet weak var lblCoachPastPlayedFor: UILabel!
    @IBOutlet weak var CoachCurrentTeams: UILabel!
    @IBOutlet weak var CoachPastTeams: UILabel!
    @IBOutlet weak var CoachCoachingLevel: UILabel!
    @IBOutlet weak var CoachCertifications: UILabel!
    @IBOutlet weak var CoachExperience: UILabel!
    @IBOutlet weak var FanSupportingTeams: UILabel!
    @IBOutlet weak var FanInterestedSports: UILabel!
    @IBOutlet weak var FanFavouritePlayer: UILabel!
    @IBOutlet weak var FanHobbies: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    let transitionManager = TransitionManager.sharedInstance
    
    @IBAction func didMenuButtonTapp(sender: UIButton){
        sliderMenu.setDrawerState(.Opened, animated: true)
        
        
    }
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
      //  navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
    }
    
    @IBAction func EditProfilePressed(sender: AnyObject) {
        
        let vc = viewControllerFrom("Main", vcid: "UserInfoEditViewController") as! UserInfoViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
      //  vc.transitioningDelegate = self.transitionManager
        
       // presentViewController(vc, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
//        self.profileImage.image = LoggedInUserImage
        
        if profileData.userExists {
            
            self.NameText.text = profileData.fullName
            self.DOBText.text = profileData.DateOfBirth
            self.EmailText.text = profileData.Email
            self.MobileText.text = profileData.Mobile
            self.GenderText.text = profileData.Gender
            self.CountryText.text = profileData.Country
            self.StateText.text = profileData.State
            self.CityText.text = profileData.City
            
            if profileData.UserProfile == "Player" {
                
                self.matchViewHeightConstraint.constant = 700
                
                if profileData.PlayerCurrentTeams.count > 0 {
                    self.PlayerCurrentTeams.text = profileData.PlayerCurrentTeams.joinWithSeparator("\n")
                    self.matchViewHeightConstraint.constant += CGFloat(profileData.PlayerCurrentTeams.count * 16)
                }
                else {
                    self.PlayerCurrentTeams.text = "No Teams"
                }
                if profileData.PlayerPastTeams.count > 0 {
                    self.PlayerPastTeams.text = profileData.PlayerPastTeams.joinWithSeparator("\n")
                    self.matchViewHeightConstraint.constant += CGFloat(profileData.PlayerPastTeams.count * 16)
                }
                else {
                     self.PlayerPastTeams.text = "No Teams"
                }
               
                self.PlayerBattingStyle.text = profileData.BattingStyle
                self.PlayerBowlingStyle.text = profileData.BowlingStyle
                self.PlayingRole.text = profileData.PlayingRole
            }
            else if profileData.UserProfile == "Coach" {
                self.matchViewHeightConstraint.constant = 800
                
                if profileData.CoachCurrentTeams.count > 0 {
                    self.CoachCurrentTeams.text = profileData.CoachCurrentTeams.joinWithSeparator("\n")
                    self.matchViewHeightConstraint.constant += CGFloat(profileData.CoachCurrentTeams.count * 16)
                }
                else {
                    self.CoachCurrentTeams.text = "No Teams"
                }
                if profileData.CoachPastTeams.count > 0 {
                    self.CoachPastTeams.text = profileData.CoachPastTeams.joinWithSeparator("\n")
                    self.matchViewHeightConstraint.constant += CGFloat(profileData.CoachPastTeams.count * 16)
                }
                  else {
                    self.CoachPastTeams.text = "No Teams"
                }
                if profileData.CoachPlayedFor.count > 0 {
                    self.lblCoachPastPlayedFor.text = profileData.CoachPlayedFor.joinWithSeparator("\n")
                    self.matchViewHeightConstraint.constant += CGFloat(profileData.CoachPlayedFor.count * 16)
                }
                else {
                    self.lblCoachPastPlayedFor.text = "No Teams"
                }
                self.CoachCoachingLevel.text = profileData.CoachingLevel
                
                if profileData.Certifications.count > 0 {
                    self.CoachCertifications.text = profileData.Certifications.joinWithSeparator("\n")
                    self.matchViewHeightConstraint.constant += CGFloat(profileData.Certifications.count * 16)
                }
                else {
                     self.CoachCertifications.text = "No Certifications"
                }
                
                self.CoachExperience.text = profileData.Experience.uppercaseString
                
            }
            else {
                self.matchViewHeightConstraint.constant = 680
                
                if profileData.SupportingTeams.count > 0 {
                    self.FanSupportingTeams.text = profileData.SupportingTeams.joinWithSeparator("\n")
                    self.matchViewHeightConstraint.constant += CGFloat(profileData.SupportingTeams.count * 16)
                }
                else {
                     self.FanSupportingTeams.text = "No Teams"
                }
                if profileData.InterestedSports.count > 0 {
                    self.FanInterestedSports.text = profileData.InterestedSports.joinWithSeparator("\n")
                    self.matchViewHeightConstraint.constant += CGFloat(profileData.InterestedSports.count * 16)
                }
                else {
                    self.FanInterestedSports.text = "No Sports"
                }
                if profileData.FavoritePlayers.count > 0 {
                    self.FanFavouritePlayer.text = profileData.FavoritePlayers.joinWithSeparator("\n")
                    self.matchViewHeightConstraint.constant += CGFloat(profileData.FavoritePlayers.count * 16)
                }
                else {
                    self.FanFavouritePlayer.text = "No Players"
                }
                if profileData.Hobbies.count > 0 {
                    self.FanHobbies.text = profileData.Hobbies.joinWithSeparator("\n")
                    self.matchViewHeightConstraint.constant += CGFloat(profileData.Hobbies.count * 16)
                }
                else {
                    self.FanHobbies.text = "No Hobbies"
                }
            }
            
            self.CoachingExperienceView.hidden = profileData.UserProfile != userProfileType.Coach.rawValue
            self.CricketFanView.hidden = profileData.UserProfile != userProfileType.Fan.rawValue
            self.PlayerExperienceView.hidden = profileData.UserProfile != userProfileType.Player.rawValue
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setUIBackgroundTheme(self.view)
        setNavigationBarProperties()
//        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
//        profileImage.clipsToBounds = true
//        
//        activityInd.layer.cornerRadius = profileImage.frame.size.width/2
//        activityInd.clipsToBounds = true
//        
//        editBtn.layer.cornerRadius = editBtn.frame.size.width/2
//        editBtn.clipsToBounds = true
        
        
        
        
        //setColorForViewsWithSameTag(PersonalInfoView)
        //setColorForViewsWithSameTag(PlayerExperienceView)
        //setColorForViewsWithSameTag(CoachingExperienceView)
        //setColorForViewsWithSameTag(CricketFanView)
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackgroundColor()
        setNavigationBarProperties()

    }
    func setNavigationBarProperties(){
        var currentTheme:CTTheme!
        currentTheme = cricTracTheme.currentTheme
        let menuButton: UIButton = UIButton(type:.Custom)
        menuButton.setImage(UIImage(named: "menu-icon"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        let editButton: UIButton = UIButton(type:.Custom)
        editButton.frame = CGRectMake(0, 0, 40, 40)
        editButton.setImage(UIImage(named: "Edit-100"), forState: UIControlState.Normal)
        editButton.addTarget(self, action: #selector(EditProfilePressed), forControlEvents: UIControlEvents.TouchUpInside)
        let righttbarButton = UIBarButtonItem(customView: editButton)
        
        //assign button to navigationbar
        
        navigationItem.leftBarButtonItem = leftbarButton
        navigationItem.rightBarButtonItem = righttbarButton
        navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
        title = "PROFILE"
       // let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
       // navigationController!.navigationBar.titleTextAttributes = titleDict
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
