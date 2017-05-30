//
//  FanUDashboardViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 21/01/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftCountryPicker
import GoogleMobileAds

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
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var topBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerViewHeightConstraint: NSLayoutConstraint!
  
    var friendProfile:[String:AnyObject]?
    var userProfileData:Profile!
    var coverOrProfile = ""
    var friendId:String? = nil
    var currentUserId = ""

    override func viewWillAppear(animated: Bool) {
        setBackgroundColor()
        initView()
        self.updateFanDashBoard()
        SupportingTeams.reloadData()
        InterestedSports.reloadData()
        Hobbies.reloadData()
        FavoritePlayers.reloadData()
    }
    
    @IBAction func CloseDashboardPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var alertMessage = "Change picture"
    
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
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadBannerAds()
        
     // Do any additional setup after loading the view.
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
       // navigationController?.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
       // title = "SIGHTSCREEN"
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
        //navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    
    func changeThemeSettigs() {
      //  let currentTheme = cricTracTheme.currentTheme
      //  navigationController?.navigationBar.barTintColor = currentTheme.topColor
        //currentTheme.boxColor
        //baseView.backgroundColor = UIColor.clearColor()
    }
    
    @IBAction func didMenuButtonTapp(sender: UIButton){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    // MARK: - Collection view delegates
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        if coverOrProfile == "Profile" {
            self.userProfileImage.image = image
            self.dismissViewControllerAnimated(true) {
                addProfileImageData(self.resizeImage(image, newWidth: 200))
            }
        }
        else {
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
    
    func initView() {
        if let value = friendProfile{
            userProfileData = Profile(usrObj: value)
           // closeButton.hidden = false
        }else{
            userProfileData = profileData
           // closeButton.hidden = true
        }
        
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
    
    func tapCoverPhoto()  {
        if friendId == nil {
            alertMessage = "Change your cover photo"
            self.photoOptions("CoverPhoto")
            coverOrProfile = "Cover"
        }
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(FanDashboardViewController.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        //        self.view.addSubview(navBarView)
        self.view.addSubview(newImageView)
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }


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
        
        //self.view.layoutIfNeeded()
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
