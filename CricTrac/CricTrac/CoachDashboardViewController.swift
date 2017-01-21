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
   
    @IBOutlet weak var PastTeams: UICollectionView!
    
    @IBOutlet weak var PlayedFor: UICollectionView!
    
    
    @IBOutlet weak var Certifications: UICollectionView!
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var PlayerName: UILabel!
    @IBOutlet weak var PlayerLocation: UILabel!
    
    @IBOutlet weak var CoachExperience: UILabel!
    
    
    @IBOutlet weak var CoachLevel: UILabel!
    
    
    @IBAction func CloseDashboardPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setBackgroundColor()
        
        userProfileImage.layer.cornerRadius = userProfileImage.bounds.size.width/2
        MatchesView.layer.cornerRadius = 10
        userProfileImage.clipsToBounds = true
        
        CurrentTeams.delegate = self
        CurrentTeams.dataSource = self
        
        PastTeams.delegate = self
        PastTeams.dataSource = self
        
        PlayedFor.delegate = self
        PlayedFor.dataSource = self
        
        Certifications.delegate = self
        Certifications.dataSource = self
        
        
        CoachExperience.text = profileData.Experience
        
        CoachLevel.text = profileData.CoachingLevel
        
        
        let df = NSDateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        self.PlayerName.text = profileData.fullName.uppercaseString
        let formattedString = NSMutableAttributedString()
        let locationText = formattedString.bold("\(profileData.City.uppercaseString)\n", fontName: appFont_black, fontSize: 15).bold("\(profileData.State.uppercaseString)\n", fontName: appFont_black, fontSize: 15).bold("\(profileData.Country.uppercaseString) ", fontName: appFont_black, fontSize: 15)
        self.PlayerLocation.attributedText = locationText
        self.userProfileImage.image = LoggedInUserImage
        
        
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
        //currentTheme.boxColor
        //baseView.backgroundColor = UIColor.clearColor()
    }

    
    // MARK: - Collection view delegates
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var valueToReturn = 0
        
        switch collectionView {
            
        case CurrentTeams:
            valueToReturn = profileData.CoachCurrentTeams.count
            break
        case PastTeams:
            valueToReturn = profileData.CoachPastTeams.count
            break;
        case PlayedFor:
            valueToReturn = profileData.CoachPlayedFor.count
            break
        case Certifications:
            valueToReturn = profileData.Certifications.count
            break
        default:
            valueToReturn = profileData.CoachCurrentTeams.count
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
            teamNameToReturn = profileData.CoachCurrentTeams[indexPath.row]
            
            
            if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("CoachCurrentTeamsViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
                
                
                aCell.TeamImage.image = UIImage()
                
                
                if teamNameToReturn != "" {
                    aCell.TeamName.text = teamNameToReturn
                    aCell.TeamAbbr.text = "\(teamNameToReturn[0])\(teamNameToReturn[1])"
                }
                
                
                return aCell
            }
            return ThemeColorsCollectionViewCell()
            
            
            
            break
        case PastTeams:
            teamNameToReturn = profileData.CoachPastTeams[indexPath.row]
            
            
            if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("CoachPastTeamsViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
                
                
                aCell.TeamImage.image = UIImage()
                
                
                if teamNameToReturn != "" {
                    aCell.TeamName.text = teamNameToReturn
                    aCell.TeamAbbr.text = "\(teamNameToReturn[0])\(teamNameToReturn[1])"
                }
                
                
                return aCell
            }
            return ThemeColorsCollectionViewCell()
            
            
            break;
        case PlayedFor:
            teamNameToReturn = profileData.CoachPlayedFor[indexPath.row]
            
            if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("CoachPlayedForViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
                
                
                aCell.TeamImage.image = UIImage()
                
                
                if teamNameToReturn != "" {
                    aCell.TeamName.text = teamNameToReturn
                    aCell.TeamAbbr.text = "\(teamNameToReturn[0])\(teamNameToReturn[1])"
                }
                
                
                return aCell
            }
            return ThemeColorsCollectionViewCell()
            
            
            break
        case Certifications:
            teamNameToReturn = profileData.Certifications[indexPath.row]
            
            if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("CertificationsViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
                
                
                aCell.TeamImage.image = UIImage()
                
                
                if teamNameToReturn != "" {
                    aCell.TeamName.text = teamNameToReturn
                    aCell.TeamAbbr.text = "\(teamNameToReturn[0])\(teamNameToReturn[1])"
                }
                
                
                return aCell
            }
            return ThemeColorsCollectionViewCell()
            
            
            break
        default:
            teamNameToReturn = profileData.CoachCurrentTeams[indexPath.row]
            
            
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
