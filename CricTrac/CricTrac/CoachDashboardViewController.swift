//
//  CoachDashboardViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 21/01/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseAuth
import GoogleMobileAds
import Kingfisher
import SwiftCountryPicker

class CoachDashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ThemeChangeable {
    
    @IBOutlet weak var MatchesView: UIView!
    @IBOutlet weak var CurrentTeams: UICollectionView!
    // @IBOutlet weak var PastTeams: UICollectionView!
    @IBOutlet weak var PlayedFor: UICollectionView!
    @IBOutlet weak var Certifications: UICollectionView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var imgCoverPhoto: UIImageView!
    @IBOutlet weak var PlayerName: UILabel!
    @IBOutlet weak var PlayerLocation: UILabel!
    @IBOutlet weak var CoachExperience: UILabel!
    @IBOutlet weak var CoachLevel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var coachCurrentTeamsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var coachPlayedHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var coachCertificationHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var topBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerViewHeightConstraint: NSLayoutConstraint!
    
    @IBAction func CloseDashboardPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var friendProfile:[String:AnyObject]?
    var userProfileData:Profile!
    var coverOrProfile = ""
    var friendId:String? = nil
    var currentUserId = ""
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setBackgroundColor()
        initView()
        self.updateCoachDashboard()
        CurrentTeams.reloadData()
        PlayedFor.reloadData()
        Certifications.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBannerAds()
    }
    
    func loadBannerAds() {
        if showAds == "1" {
            self.bannerViewHeightConstraint.constant = 50
            bannerView.adUnitID = adUnitId
            bannerView.rootViewController = self
            bannerView.loadRequest(GADRequest())
        }
        else {
            self.bannerViewHeightConstraint.constant = 0
        }
    }

    
    func initView() {
        //super.viewDidLoad()
        
        if let value = friendProfile{
            userProfileData = Profile(usrObj: value)
           // closeButton.hidden = false
        }
        else{
            userProfileData = profileData
          //  closeButton.hidden = true
        }
        
        //setBackgroundColor()
        
        userProfileImage.layer.cornerRadius = userProfileImage.bounds.size.width/2
        MatchesView.layer.cornerRadius = 10
        userProfileImage.clipsToBounds = true
        
         MatchesView.alpha = 1
        
          MatchesView.backgroundColor = cricTracTheme.currentTheme.bottomColor
        
        CurrentTeams.delegate = self
        CurrentTeams.dataSource = self
        
        //        PastTeams.delegate = self
        //        PastTeams.dataSource = self
        
        PlayedFor.delegate = self
        PlayedFor.dataSource = self
        Certifications.delegate = self
        Certifications.dataSource = self
        CoachExperience.text = userProfileData.Experience
        CoachLevel.text = userProfileData.CoachingLevel
        
        
        let currentCountryList = CountriesList.filter({$0.name == userProfileData.Country})
        let currentISO = currentCountryList[0].iso
        
        let df = NSDateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        self.PlayerName.text = userProfileData.fullName.uppercaseString
        let formattedString = NSMutableAttributedString()
        let locationText = formattedString.bold("\(userProfileData.City)\n", fontName: appFont_black, fontSize: 15).bold("\(userProfileData.State), ", fontName: appFont_black, fontSize: 15).bold("\(currentISO) ", fontName: appFont_black, fontSize: 15)
        self.PlayerLocation.attributedText = locationText
        
        if friendId == nil {
            currentUserId = (currentUser?.uid)!
        }
        else {
            currentUserId = friendId!
        }
        
        fetchBasicProfile(currentUserId, sucess: { (result) in
            let proPic = result["proPic"]
            
            if proPic! == "-"{
                let imageName = defaultProfileImage
                let image = UIImage(named: imageName)
                self.userProfileImage.image = image
            }
            else{
                if let imageURL = NSURL(string:proPic!){
                    self.userProfileImage.kf_setImageWithURL(imageURL)
                }
            }
        })
        
        fetchCoverPhoto(currentUserId, sucess: { (result) in
            let coverPic = result["coverPic"]
            
            if coverPic! == "-"{
                let imageName = defaultCoverImage
                let image = UIImage(named: imageName)
                self.imgCoverPhoto.image = image
            }
            else{
                if let imageURL = NSURL(string:coverPic!){
                    self.imgCoverPhoto.kf_setImageWithURL(imageURL)
                }
            }
        })
        
        setNavigationBarProperties()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCoverPhoto))
        tapGesture.numberOfTapsRequired = 1
        imgCoverPhoto.addGestureRecognizer(tapGesture)
    }
    
    var alertMessage = "Change picture"
    
    func tapCoverPhoto()  {
        if friendId == nil {
            alertMessage = "Change your cover photo"
            self.photoOptions("CoverPhoto")
            coverOrProfile = "Cover"
        }
    }
    
    @IBAction func editImageBtnPressed(sender: AnyObject) {
        if friendId == nil {
            alertMessage = "Change your profile photo"
            self.photoOptions("ProfilePhoto")
            coverOrProfile = "Profile"
        }
    }
    
    func photoOptions(option:String)  {
        let alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let TakePictureAction = UIAlertAction(title: "Take Photo", style: .Default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        
        alertController.addAction(TakePictureAction)
        
        let chooseExistingAction = UIAlertAction(title: "Choose Existing", style: .Default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        
        alertController.addAction(chooseExistingAction)
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeThemeSettigs() {
       // let currentTheme = cricTracTheme.currentTheme
        MatchesView.backgroundColor = UIColor.blackColor()
        MatchesView.alpha = 0.3
       // navigationController?.navigationBar.barTintColor = currentTheme.topColor
        //currentTheme.boxColor
        //baseView.backgroundColor = UIColor.clearColor()
    }
    
    @IBAction func didMenuButtonTapp(sender: UIButton){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        if coverOrProfile == "Profile" {
            self.userProfileImage.image = image
            self.dismissViewControllerAnimated(true) {
                addProfileImageData(self.resizeImage(image, newWidth: 200))
            }
        }else {
            self.imgCoverPhoto.image = image
            self.dismissViewControllerAnimated(true) {
                addCoverImageData(self.resizeImage(image, newWidth: 800))
            }
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func viewImage(option:String){
        let newImageView = UIImageView()
        if option == "CoverPhoto" {
            newImageView.image = imgCoverPhoto.image
        }else {
            newImageView.image = userProfileImage.image
        }
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = .blackColor()
        newImageView.contentMode = .ScaleAspectFit
        newImageView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(CoachDashboardViewController.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        //        self.view.addSubview(navBarView)
        self.view.addSubview(newImageView)
    }
    
    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        //        let navBarView = UIView(frame: CGRectMake(0, 0, (sender.view?.frame.size.width)!, 50))
        //        navBarView.backgroundColor = UIColor(hex: "#D4D4D4")
        //        let editBtn = UIButton(frame: CGRectMake((sender.view?.frame.size.width)! - 100, 10, 50, 20))
        //        editBtn.setBackgroundImage(UIImage(named: "EditPencil-100"), forState: .Normal)
        //        navBarView.addSubview(editBtn)
        
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = .blackColor()
        newImageView.contentMode = .ScaleAspectFit
        newImageView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(CoachDashboardViewController.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        //        self.view.addSubview(navBarView)
        self.view.addSubview(newImageView)
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
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
        
        if let navigation = navigationController{
          //  navigation.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
          //  title = "SIGHTSCREEN"
            if let navigation = navigationController{
                topBarHeightConstraint.constant = 0
                
                navigation.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
                title = "SIGHTSCREEN"
            }
            else {
                topBarHeightConstraint.constant = 56
                self.topBarView.backgroundColor = currentTheme.topColor
            }
        //let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //// navigationController!.navigationBar.titleTextAttributes = titleDict
        }
    }
    func updateCoachDashboard(){
        if (userProfileData.CoachCurrentTeams.count) + (userProfileData.CoachPastTeams.count) == 0 {
            self.coachCurrentTeamsHeightConstraint.constant = 0
        }
        else {
            self.coachCurrentTeamsHeightConstraint.constant = 160
        }
        
        if userProfileData.CoachPlayedFor.count == 0{
            self.coachPlayedHeightConstraint.constant = 0
        }
        else {
            self.coachPlayedHeightConstraint.constant = 150
        }
        
        if userProfileData.Certifications.count == 0 {
            self.coachCertificationHeightConstraint.constant = 0
        }
        else {
            self.coachCertificationHeightConstraint.constant = 150
        }
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
                //aCell.TeamImage.image = UIImage()
                
                if indexPath.row < (userProfileData.CoachCurrentTeams.count) {
                    teamNameToReturn = userProfileData.CoachCurrentTeams[indexPath.row]
                    
                    aCell.baseView.backgroundColor = cricTracTheme.currentTheme.bottomColor
                    aCell.baseView.alpha = 1
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
            
            case PlayedFor:
            teamNameToReturn = userProfileData.CoachPlayedFor[indexPath.row]
            
            if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("CoachPlayedForViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
                //aCell.TeamImage.image = UIImage()
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
                //aCell.TeamImage.image = UIImage()
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
                //aCell.TeamImage.image = UIImage()
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
