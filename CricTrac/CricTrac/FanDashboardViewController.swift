//
//  FanUDashboardViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 21/01/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class FanDashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ThemeChangeable {
    
    @IBOutlet weak var SupportingTeams: UICollectionView!
    
    @IBOutlet weak var InterestedSports: UICollectionView!
    
    @IBOutlet weak var Hobbies: UICollectionView!
    
    
    @IBOutlet weak var FavoritePlayers: UICollectionView!
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var imgCoverPhoto: UIImageView!

    @IBOutlet weak var PlayerName: UILabel!
    @IBOutlet weak var PlayerLocation: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var favouritePlayerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var interstedSportsheightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var supportingTeamHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var hobbiesHeightConstraint: NSLayoutConstraint!
    
    
    var friendProfile:[String:AnyObject]?
    
    var userProfileData:Profile!
    
    var currentUserProfileImage = UIImage()
    var currentUserCoverImage = UIImage()
    
    @IBAction func CloseDashboardPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        if let value = friendProfile{
            userProfileData = Profile(usrObj: value)
            closeButton.hidden = false
        }else{
            userProfileData = profileData
            closeButton.hidden = true
        }
        
        self.updateFanDashBoard()
        
        setBackgroundColor()
        
        userProfileImage.layer.cornerRadius = userProfileImage.bounds.size.width/2
        userProfileImage.clipsToBounds = true
        
        SupportingTeams.delegate = self
        SupportingTeams.dataSource = self
        
        InterestedSports.delegate = self
        InterestedSports.dataSource = self
        
        Hobbies.delegate = self
        Hobbies.dataSource = self
        
        FavoritePlayers.delegate = self
        FavoritePlayers.dataSource = self
        
        
        
        
        let df = NSDateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        self.PlayerName.text = userProfileData.fullName.uppercaseString
        let formattedString = NSMutableAttributedString()
        let locationText = formattedString.bold("\(userProfileData.City.uppercaseString)\n", fontName: appFont_black, fontSize: 15).bold("\(userProfileData.State.uppercaseString)\n", fontName: appFont_black, fontSize: 15).bold("\(userProfileData.Country.uppercaseString) ", fontName: appFont_black, fontSize: 15)
        self.PlayerLocation.attributedText = locationText
        //self.userProfileImage.image = LoggedInUserImage
        
        getImageFromFirebase(userProfileData.ProfileImageURL) { (imgData) in
            self.currentUserProfileImage = imgData
        }
        
        getImageFromFirebase(userProfileData.CoverPhotoURL) { (imgData) in
            self.currentUserCoverImage = imgData
        }
        self.userProfileImage.image = currentUserProfileImage
        self.imgCoverPhoto.image = currentUserCoverImage
        
        setNavigationBarProperties()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        title = "SIGHTSCREEN"
        //let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        navigationController?.navigationBar.barTintColor = currentTheme.topColor
        //currentTheme.boxColor
        //baseView.backgroundColor = UIColor.clearColor()
    }
    
    @IBAction func didMenuButtonTapp(sender: UIButton){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    // MARK: - Collection view delegates
    
    func updateFanDashBoard() {
        
        if userProfileData.SupportingTeams.count == 0 {
            self.supportingTeamHeightConstraint.constant = 0
            
        }else {
            self.supportingTeamHeightConstraint.constant = 160
        }
        
        if userProfileData.FavoritePlayers.count == 0 {
            self.favouritePlayerHeightConstraint.constant = 0
        }
        else{
            self.favouritePlayerHeightConstraint.constant = 160
        }
        
        if userProfileData.Hobbies.count == 0 {
            self.hobbiesHeightConstraint.constant = 0
        }
        else {
            self.hobbiesHeightConstraint.constant = 160
        }
        
        if userProfileData.InterestedSports.count == 0 {
            self.interstedSportsheightConstraint.constant = 0
        }
        else {
            self.interstedSportsheightConstraint.constant = 160
        }
        
        self.view.layoutIfNeeded()
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var valueToReturn = 0
        
        switch collectionView {
            
        case SupportingTeams:
            valueToReturn = userProfileData.SupportingTeams.count
            break
        case FavoritePlayers:
            valueToReturn = userProfileData.FavoritePlayers.count
            break;
        case Hobbies:
            valueToReturn = userProfileData.Hobbies.count
            break
        case InterestedSports:
            valueToReturn = userProfileData.InterestedSports.count
            break
        default:
            valueToReturn = userProfileData.SupportingTeams.count
            break
            
        }
        return valueToReturn
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        var teamNameToReturn = ""
        
        
        
        switch collectionView {
            
        case FavoritePlayers:
            teamNameToReturn = userProfileData.FavoritePlayers[indexPath.row]
            
            
            if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("FanFavouriteViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
                
                
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
            
            
            
        //break
        case SupportingTeams:
            teamNameToReturn = userProfileData.SupportingTeams[indexPath.row]
            
            
            if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("CoachPastTeamsViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
                
                
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
            
            
        //  break;
        case InterestedSports:
            teamNameToReturn = userProfileData.InterestedSports[indexPath.row]
            
            if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("FanInterestedSportsViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
                
                
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
        case Hobbies:
            teamNameToReturn = userProfileData.Hobbies[indexPath.row]
            
            if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("FanHobbiesViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
                
                
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
        default:
            teamNameToReturn = userProfileData.SupportingTeams[indexPath.row]
            
            
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
