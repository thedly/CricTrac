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
  
    @IBOutlet weak var FollowingCount: UILabel!
    @IBOutlet weak var FollowersCount: UILabel!
    
    var friendProfile:[String:AnyObject]?
    var userProfileData:Profile!
    var coverOrProfile = ""
    var friendId:String? = nil
    var currentUserId = ""
    
    var sizeOne:CGFloat = 10
    var sizeTwo:CGFloat = 15
    var sizeThree:CGFloat = 18
    var sizeFour:CGFloat = 20
    var sizeFive:CGFloat = 25

    override func viewWillAppear(animated: Bool) {
        if friendId == nil {
            followCount((currentUser?.uid)!)
        }
        
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
        else{
            let profileImageVc = viewControllerFrom("Main", vcid: "ProfileImageExpandingVC") as! ProfileImageExpandingVC
            
            profileImageVc.imageString = userProfileData.ProfileImageURL
            if userProfileData.ProfileImageURL != "-" {
                self.presentViewController(profileImageVc, animated: true) {}
            }
        }
    }
    
    func photoOptionsToCoverPic(option:String)  {
        
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
                imagePicker.allowsEditing = true
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        
        alertController.addAction(TakePictureAction)
        
        let chooseExistingAction = UIAlertAction(title: "Choose Existing", style: .Default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.allowsEditing = true
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        
        alertController.addAction(chooseExistingAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
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
                imagePicker.allowsEditing = true
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        
        alertController.addAction(TakePictureAction)
        
        let chooseExistingAction = UIAlertAction(title: "Choose Existing", style: .Default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.allowsEditing = true
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        
        alertController.addAction(chooseExistingAction)
        
        let viewPhotoAction = UIAlertAction(title: "View Photo", style: .Default) { (action) in
            
            self.viewImage(option)
        }
        
        alertController.addAction(viewPhotoAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    func viewImage(option:String){
        
        let profileImageVc = viewControllerFrom("Main", vcid: "ProfileImageExpandingVC") as! ProfileImageExpandingVC
        
        profileImageVc.imageString = profileData.ProfileImageURL
        if profileData.ProfileImageURL != "-" {
            self.presentViewController(profileImageVc, animated: true) {}
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadBannerAds()
        
        // Do any additional setup after loading the view.
        if screensize == "1" {
            sizeOne = 10
            sizeTwo = 13
            sizeThree = 15
            sizeFour = 16
            sizeFive = 20
        }
        else if screensize == "2" {
            sizeOne = 10
            sizeTwo = 14
            sizeThree = 16
            sizeFour = 18
            sizeFive = 20
        }
        else if screensize == "3" {
            sizeOne = 10
            sizeTwo = 15
            sizeThree = 18
            sizeFour = 20
            sizeFive = 25
        }
        else if screensize == "4" {
            sizeOne = 12
            sizeTwo = 15
            sizeThree = 18
            sizeFour = 25
            sizeFive = 28
        }
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
        let currentTheme = cricTracTheme.currentTheme
        navigationController?.navigationBar.barTintColor = currentTheme.topColor
        currentTheme.boxColor
        self.view.backgroundColor = currentTheme.topColor
    }
    
    @IBAction func didMenuButtonTapp(sender: UIButton){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    // MARK: - Collection view delegates
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var image : UIImage!
        if coverOrProfile == "Profile" {
            if let img = info[UIImagePickerControllerEditedImage] as? UIImage
            {
                image = img
                self.userProfileImage.image = img
            }
            else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                image = img
                self.userProfileImage.image = img
            }
            
            self.dismissViewControllerAnimated(true) {
                addProfileImageData(self.resizeImage(image, newWidth: 200))
            }
        }
        else {
            if let img = info[UIImagePickerControllerEditedImage] as? UIImage
            {
                image = img
                self.imgCoverPhoto.image = image
                
            }
            else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                image = img
                self.imgCoverPhoto.image = image
            }
            
            self.dismissViewControllerAnimated(true) {
                addCoverImageData(self.resizeCoverImage(image, newWidth: 800))
            }
        }
    }
    
    func resizeCoverImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale =  newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
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
        
        let formattedStringName = NSMutableAttributedString()
        let nameText = formattedStringName.bold(userProfileData.fullName, fontName: appFont_black, fontSize: sizeTwo)
        self.PlayerName.attributedText = nameText
        //self.PlayerName.text = userProfileData.fullName.uppercaseString
        
        let formattedString = NSMutableAttributedString()
        let locationText = formattedString.bold("\(userProfileData.City)\n", fontName: appFont_black, fontSize: sizeTwo).bold("\(userProfileData.State), ", fontName: appFont_black, fontSize: sizeTwo).bold("\(currentISO) ", fontName: appFont_black, fontSize: sizeTwo)
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
        
        //set the Follower/Following counts
        getFollowersCount(currentUserId, sucess: { (result) in
            let followersCount = result
            var followersDisp = "0"
            if Double(followersCount)! > 999999 {
                let followersCountValue = Double(followersCount)!/1000000
                let followersCountComponent = String(followersCountValue).componentsSeparatedByString(".")
                let followersCountInt = followersCountComponent[0]
                let followersCountDec = followersCountComponent[1]
                let followersCountDecExtract = String(followersCountDec.characters[followersCountDec.characters.startIndex])
                followersDisp = followersCountInt + "." + followersCountDecExtract + " M"
            }
            else if Double(followersCount)! > 999 {
                let followersCountValue = Double(followersCount)!/1000
                let followersCountComponent = String(followersCountValue).componentsSeparatedByString(".")
                let followersCountInt = followersCountComponent[0]
                //let followersCountDec = followersCountComponent[1]
                followersDisp = followersCountInt + " K"
            }
            else {
                followersDisp = followersCount
            }
            self.FollowersCount.text = followersDisp
            self.FollowersCount.sizeToFit()
        })
        
        getFollowingCount(currentUserId, sucess: { (result) in
            let followingCount = result
            var followingDisp = "0"
            if Double(followingCount)! > 999999 {
                let followingCountValue = Double(followingCount)!/1000000
                let followingCountComponent = String(followingCountValue).componentsSeparatedByString(".")
                let followingCountInt = followingCountComponent[0]
                let followingCountDec = followingCountComponent[1]
                let followingCountDecExtract = String(followingCountDec.characters[followingCountDec.characters.startIndex])
                followingDisp = followingCountInt + "." + followingCountDecExtract + " M"
            }
            else if Double(followingCount)! > 999 {
                let followingCountValue = Double(followingCount)!/1000
                let followingCountComponent = String(followingCountValue).componentsSeparatedByString(".")
                let followingCountInt = followingCountComponent[0]
                followingDisp = followingCountInt + " K"
            }
            else {
                followingDisp = followingCount
            }
            self.FollowingCount.text = followingDisp
            self.FollowingCount.sizeToFit()
        })
    }
    
    func tapCoverPhoto()  {
        if friendId == nil {
            alertMessage = "Change your cover photo"
            self.photoOptionsToCoverPic("CoverPhoto")
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
            self.supportingTeamHeightConstraint.constant = 130
        }
        
        if userProfileData.FavoritePlayers.count == 0 {
            self.favouritePlayerHeightConstraint.constant = 0
        }
        else{
            self.favouritePlayerHeightConstraint.constant = 130
        }
        
        if userProfileData.Hobbies.count == 0 {
            self.hobbiesHeightConstraint.constant = 0
        }
        else {
            self.hobbiesHeightConstraint.constant = 130
        }
        
        if userProfileData.InterestedSports.count == 0 {
            self.interstedSportsheightConstraint.constant = 0
        }
        else {
            self.interstedSportsheightConstraint.constant = 130
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
