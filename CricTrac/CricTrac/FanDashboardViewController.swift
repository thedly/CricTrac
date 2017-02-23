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
    @IBOutlet weak var PlayerName: UILabel!
    @IBOutlet weak var PlayerLocation: UILabel!
    
    
    @IBAction func CloseDashboardPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        self.PlayerName.text = profileData.fullName.uppercaseString
        let formattedString = NSMutableAttributedString()
        let locationText = formattedString.bold("\(profileData.City.uppercaseString)\n", fontName: appFont_black, fontSize: 15).bold("\(profileData.State.uppercaseString)\n", fontName: appFont_black, fontSize: 15).bold("\(profileData.Country.uppercaseString) ", fontName: appFont_black, fontSize: 15)
        self.PlayerLocation.attributedText = locationText
        self.userProfileImage.image = LoggedInUserImage
        
        setNavigationBarProperties()
        // Do any additional setup after loading the view.
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
        navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
        title = "DASHBOARD"
        let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        
        //currentTheme.boxColor
        //baseView.backgroundColor = UIColor.clearColor()
    }
    
    @IBAction func didMenuButtonTapp(sender: UIButton){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    // MARK: - Collection view delegates
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var valueToReturn = 0
        
        switch collectionView {
            
        case SupportingTeams:
            valueToReturn = profileData.SupportingTeams.count
            break
        case FavoritePlayers:
            valueToReturn = profileData.FavoritePlayers.count
            break;
        case Hobbies:
            valueToReturn = profileData.Hobbies.count
            break
        case InterestedSports:
            valueToReturn = profileData.InterestedSports.count
            break
        default:
            valueToReturn = profileData.SupportingTeams.count
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
            teamNameToReturn = profileData.FavoritePlayers[indexPath.row]
            
            
            if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("CoachCurrentTeamsViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
                
                
                //aCell.TeamImage.image = UIImage()
                
                
                if teamNameToReturn != "" {
                    aCell.TeamName.text = teamNameToReturn
                    if aCell.TeamAbbr != nil {
                        aCell.TeamAbbr.text = "\(teamNameToReturn[0])\(teamNameToReturn[1])"
                    }
                }
                
                
                return aCell
            }
            return ThemeColorsCollectionViewCell()
            
            
            
            break
        case SupportingTeams:
            teamNameToReturn = profileData.SupportingTeams[indexPath.row]
            
            
            if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("CoachPastTeamsViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
                
                
                aCell.TeamImage.image = UIImage()
                
                
                if teamNameToReturn != "" {
                    aCell.TeamName.text = teamNameToReturn
                    if aCell.TeamAbbr != nil {
                        aCell.TeamAbbr.text = "\(teamNameToReturn[0])\(teamNameToReturn[1])"
                    }
                }
                
                
                return aCell
            }
            return ThemeColorsCollectionViewCell()
            
            
            break;
        case InterestedSports:
            teamNameToReturn = profileData.InterestedSports[indexPath.row]
            
            if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("CoachPlayedForViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
                
                
                //aCell.TeamImage.image = UIImage()
                
                
                if teamNameToReturn != "" {
                    aCell.TeamName.text = teamNameToReturn
                    if aCell.TeamAbbr != nil {
                        aCell.TeamAbbr.text = "\(teamNameToReturn[0])\(teamNameToReturn[1])"
                    }
                    
                }
                
                
                return aCell
            }
            return ThemeColorsCollectionViewCell()
            
            
            break
        case Hobbies:
            teamNameToReturn = profileData.Hobbies[indexPath.row]
            
            if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("CertificationsViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
                
                
                //aCell.TeamImage.image = UIImage()
                
                
                if teamNameToReturn != "" {
                    aCell.TeamName.text = teamNameToReturn
                    
                    if aCell.TeamAbbr != nil {
                        aCell.TeamAbbr.text = "\(teamNameToReturn[0])\(teamNameToReturn[1])"
                    }
                    
                }
                
                
                return aCell
            }
            return ThemeColorsCollectionViewCell()
            
            
            break
        default:
            teamNameToReturn = profileData.SupportingTeams[indexPath.row]
            
            
            if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("TeamCollectionViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
                
                
                aCell.TeamImage.image = UIImage()
                
                
                if teamNameToReturn != "" {
                    aCell.TeamName.text = teamNameToReturn
                    aCell.TeamAbbr.text = "\(teamNameToReturn[0])\(teamNameToReturn[1])"
                }
                
                
                return aCell
            }
            return ThemeColorsCollectionViewCell()
            
            break
            
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
