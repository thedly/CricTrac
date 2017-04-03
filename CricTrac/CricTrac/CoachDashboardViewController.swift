//
//  CoachDashboardViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 21/01/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class CoachDashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ThemeChangeable {

    @IBOutlet weak var MatchesView: UIView!
    
    
    @IBOutlet weak var CurrentTeams: UICollectionView!
   
   // @IBOutlet weak var PastTeams: UICollectionView!
    
    @IBOutlet weak var PlayedFor: UICollectionView!
    
    
    @IBOutlet weak var Certifications: UICollectionView!
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var PlayerName: UILabel!
    @IBOutlet weak var PlayerLocation: UILabel!
    
    @IBOutlet weak var CoachExperience: UILabel!
    
    
    @IBOutlet weak var CoachLevel: UILabel!
    @IBOutlet weak var closeButton: UIButton!

    @IBOutlet weak var coachCurrentTeamsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var coachPastTeamsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var coachPlayedHeightConstraint: NSLayoutConstraint!
    
   
    
    @IBAction func CloseDashboardPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    var friendProfile:[String:AnyObject]?
    
    var userProfileData:Profile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let value = friendProfile{
            userProfileData = Profile(usrObj: value)
            closeButton.hidden = false
        }else{
            userProfileData = profileData
            closeButton.hidden = true
        }
        
        
        setBackgroundColor()
        
        userProfileImage.layer.cornerRadius = userProfileImage.bounds.size.width/2
        MatchesView.layer.cornerRadius = 10
        userProfileImage.clipsToBounds = true
        
        MatchesView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: UIColor().hexFromUIColor(cricTracTheme.currentTheme.bottomColor)))
        
        MatchesView.alpha = 0.8
        
        CurrentTeams.delegate = self
        CurrentTeams.dataSource = self
//        
//        PastTeams.delegate = self
//        PastTeams.dataSource = self
        
        PlayedFor.delegate = self
        PlayedFor.dataSource = self
        
        Certifications.delegate = self
        Certifications.dataSource = self
        
        
       
        CoachExperience.text = userProfileData.Experience
        CoachLevel.text = userProfileData.CoachingLevel
        
        
        let df = NSDateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        self.PlayerName.text = userProfileData.fullName.uppercaseString
        let formattedString = NSMutableAttributedString()
        let locationText = formattedString.bold("\(userProfileData.City.uppercaseString)\n", fontName: appFont_black, fontSize: 15).bold("\(userProfileData.State.uppercaseString)\n", fontName: appFont_black, fontSize: 15).bold("\(userProfileData.Country.uppercaseString) ", fontName: appFont_black, fontSize: 15)
        self.PlayerLocation.attributedText = locationText
        self.userProfileImage.image = LoggedInUserImage
        
        setNavigationBarProperties()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        MatchesView.backgroundColor = UIColor.blackColor()
        MatchesView.alpha = 0.3
        navigationController?.navigationBar.barTintColor = currentTheme.topColor
        //currentTheme.boxColor
        //baseView.backgroundColor = UIColor.clearColor()
    }

    @IBAction func didMenuButtonTapp(sender: UIButton){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    func setNavigationBarProperties(){
        var currentTheme:CTTheme!
        currentTheme = cricTracTheme.currentTheme
        let menuButton: UIButton = UIButton(type:.Custom)
        menuButton.setImage(UIImage(named: "menu-icon"), forState: UIControlState.Normal)
        menuButton.titleLabel?.font = UIFont(name: appFont_black, size: 16)
        menuButton.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        navigationItem.leftBarButtonItem = leftbarButton
        navigationController?.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
        title = "DASHBOARD"
        //let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
       //// navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    
    // MARK: - Collection view delegates
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var valueToReturn = 0
        
        switch collectionView {
            
        case CurrentTeams:
            valueToReturn = (userProfileData.CoachCurrentTeams.count) + userProfileData.CoachPastTeams.count
            break
       // case PastTeams:
          //  valueToReturn = userProfileData.CoachPastTeams.count
          //  break;
        case PlayedFor:
            valueToReturn = userProfileData.CoachPlayedFor.count
            break
        case Certifications:
            valueToReturn = userProfileData.Certifications.count
            break
        default:
            valueToReturn = userProfileData.CoachCurrentTeams.count
            break
            
        }
        return valueToReturn
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        var teamNameToReturn = ""
       
        switch collectionView {
            
        case CurrentTeams:
           // teamNameToReturn = userProfileData.CoachCurrentTeams[indexPath.row]
            
            if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("CoachCurrentTeamsViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
                
                
                aCell.TeamImage.image = UIImage()
                
                if indexPath.row < (userProfileData.CoachCurrentTeams.count) {
                    
                    teamNameToReturn = userProfileData.CoachCurrentTeams[indexPath.row]
                    
                    aCell.baseView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: UIColor().hexFromUIColor(cricTracTheme.currentTheme.boxColor)))
                    
                    aCell.TeamAbbr.textColor = UIColor.whiteColor()

                }
                else if (indexPath.row - (userProfileData.CoachCurrentTeams.count)) < (userProfileData.CoachPastTeams.count) {
                    
                    teamNameToReturn = userProfileData.CoachPastTeams[(indexPath.row - userProfileData.CoachCurrentTeams.count)]
                    
                    aCell.baseView.backgroundColor = UIColor.grayColor()
                    aCell.TeamAbbr.textColor = UIColor.blackColor()
                }
                
                
                if teamNameToReturn != "" {
                    aCell.TeamName.text = teamNameToReturn
                    
                    let teamName = teamNameToReturn.componentsSeparatedByString(" ")
                    
                    if teamName.count == 1 {
                        aCell.TeamAbbr.text = "\(teamName[0].characters.first!)"
                    }
                    else if teamName.count == 2 {
                        aCell.TeamAbbr.text = "\(teamName[0].characters.first!)\(teamName[1].characters.first!)"
                    }
                    else {
                        aCell.TeamAbbr.text = "\(teamName[0].characters.first!)\(teamName[1].characters.first!)\(teamName[2].characters.first!)"
                }
                
                }
                return aCell
            }
            return ThemeColorsCollectionViewCell()
            
            
            
         //   break
//        case PastTeams:
//            teamNameToReturn = userProfileData.CoachPastTeams[indexPath.row]
//            
//            
//            if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("CoachPastTeamsViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
//                
//                
//                aCell.TeamImage.image = UIImage()
//                
//                
//                if teamNameToReturn != "" {
//                    aCell.TeamName.text = teamNameToReturn
//                    aCell.TeamAbbr.text = "\(teamNameToReturn[0])\(teamNameToReturn[1])"
//                }
//                
//                
//                return aCell
//            }
//            return ThemeColorsCollectionViewCell()
//            
            
           // break;
        case PlayedFor:
            teamNameToReturn = userProfileData.CoachPlayedFor[indexPath.row]
            
            if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("CoachPlayedForViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
                
                
                aCell.TeamImage.image = UIImage()
                
                
                if teamNameToReturn != "" {
                    aCell.TeamName.text = teamNameToReturn
                    
                    let teamName = teamNameToReturn.componentsSeparatedByString(" ")
                    
                    if teamName.count == 1 {
                        aCell.TeamAbbr.text = "\(teamName[0].characters.first!)"
                    }
                    else if teamName.count == 2 {
                        aCell.TeamAbbr.text = "\(teamName[0].characters.first!)\(teamName[1].characters.first!)"
                    }
                    else {
                        aCell.TeamAbbr.text = "\(teamName[0].characters.first!)\(teamName[1].characters.first!)\(teamName[2].characters.first!)"
                    }
                    
                }
                
                return aCell
            }
            return ThemeColorsCollectionViewCell()
            
            
           // break
        case Certifications:
            teamNameToReturn = userProfileData.Certifications[indexPath.row]
            
            if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("CertificationsViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
                
                
                aCell.TeamImage.image = UIImage()
                
                
                if teamNameToReturn != "" {
                    aCell.TeamName.text = teamNameToReturn
                    
                    let teamName = teamNameToReturn.componentsSeparatedByString(" ")
                    
                    if teamName.count == 1 {
                        aCell.TeamAbbr.text = "\(teamName[0].characters.first!)"
                    }
                    else if teamName.count == 2 {
                        aCell.TeamAbbr.text = "\(teamName[0].characters.first!)\(teamName[1].characters.first!)"
                    }
                    else {
                        aCell.TeamAbbr.text = "\(teamName[0].characters.first!)\(teamName[1].characters.first!)\(teamName[2].characters.first!)"
                    }
                    
                }
                
                
                return aCell
            }
            return ThemeColorsCollectionViewCell()
            
            
          //  break
        default:
            teamNameToReturn = userProfileData.CoachCurrentTeams[indexPath.row]
            
            
            if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("TeamCollectionViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
                
                
                aCell.TeamImage.image = UIImage()
                
                
                if teamNameToReturn != "" {
                    aCell.TeamName.text = teamNameToReturn
                    
                    let teamName = teamNameToReturn.componentsSeparatedByString(" ")
                    
                    if teamName.count == 1 {
                        aCell.TeamAbbr.text = "\(teamName[0].characters.first!)"
                    }
                    else if teamName.count == 2 {
                        aCell.TeamAbbr.text = "\(teamName[0].characters.first!)\(teamName[1].characters.first!)"
                    }
                    else {
                        aCell.TeamAbbr.text = "\(teamName[0].characters.first!)\(teamName[1].characters.first!)\(teamName[2].characters.first!)"
                    }
                    
                }
                
                
                return aCell
            }
            return ThemeColorsCollectionViewCell()
            
          //  break
            
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
