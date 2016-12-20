//
//  ProfileReadOnlyViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 19/12/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class ProfileReadOnlyViewController: UIViewController {

    @IBOutlet weak var PersonalInfoView: UIView!
    @IBOutlet weak var PlayerExperienceView: UIView!
    @IBOutlet weak var CoachingExperienceView: UIView!
    @IBOutlet weak var CricketFanView: UIView!
    
    
    
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
    
    @IBOutlet weak var CoachCurrentTeams: UILabel!
    @IBOutlet weak var CoachPastTeams: UILabel!
    @IBOutlet weak var CoachCoachingLevel: UILabel!
    @IBOutlet weak var CoachCertifications: UILabel!
    @IBOutlet weak var CoachExperience: UILabel!
    
    @IBOutlet weak var FanSupportingTeams: UILabel!
    @IBOutlet weak var FanInterestedSports: UILabel!
    @IBOutlet weak var FanFavouritePlayer: UILabel!
    @IBOutlet weak var FanHobbies: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
        
        if profileData.fullName != " " {
            
            self.NameText.text = profileData.fullName
            self.DOBText.text = profileData.DateOfBirth
            self.EmailText.text = profileData.Email
            self.MobileText.text = profileData.Mobile
            self.GenderText.text = profileData.Gender
            self.CountryText.text = profileData.Country
            self.StateText.text = profileData.State
            self.CityText.text = profileData.City
            
            self.PlayerCurrentTeams.text = profileData.PlayerCurrentTeams.joinWithSeparator(",")
            self.PlayerPastTeams.text = profileData.PlayerPastTeams.joinWithSeparator(",")
            self.PlayerBattingStyle.text = profileData.BattingStyle
            self.PlayerBowlingStyle.text = profileData.BowlingStyle
            
            self.CoachCurrentTeams.text = profileData.CoachCurrentTeams.joinWithSeparator(",")
            self.CoachPastTeams.text = profileData.CoachPastTeams.joinWithSeparator(",")
            self.CoachCoachingLevel.text = profileData.CoachingLevel
            self.CoachCertifications.text = profileData.Certifications
            self.CoachExperience.text = profileData.Experience
            
            self.FanSupportingTeams.text = profileData.SupportingTeams.joinWithSeparator(",")
            self.FanInterestedSports.text = profileData.InterestedSports.joinWithSeparator(",")
            self.FanFavouritePlayer.text = profileData.FavouritePlayers
            self.FanHobbies.text = profileData.Hobbies.joinWithSeparator(",")
            
            
            self.CoachingExperienceView.hidden = profileData.UserProfile != userProfileType.Coach.rawValue
            self.CricketFanView.hidden = profileData.UserProfile != userProfileType.Fan.rawValue
            self.PlayerExperienceView.hidden = profileData.UserProfile != userProfileType.Player.rawValue
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIBackgroundTheme(self.view)
        
        setColorForViewsWithSameTag(PersonalInfoView)
        setColorForViewsWithSameTag(PlayerExperienceView)
        setColorForViewsWithSameTag(CoachingExperienceView)
        setColorForViewsWithSameTag(CricketFanView)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
