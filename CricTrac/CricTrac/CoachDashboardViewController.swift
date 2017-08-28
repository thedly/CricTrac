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

class CoachDashboardViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, ThemeChangeable,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var imgCoverPhoto: UIImageView!
    @IBOutlet weak var PlayerName: UILabel!
    @IBOutlet weak var PlayerLocation: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var topBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerViewHeightConstraint: NSLayoutConstraint!
    // for teams
    @IBOutlet weak var coachTeams: UICollectionView!
    @IBOutlet weak var coachTeamsHeightConstraint: NSLayoutConstraint!
    
    
    // for new features
    @IBOutlet weak var totalPlayers: UILabel!
    @IBOutlet weak var totalBatsmen: UILabel!
    @IBOutlet weak var totalBowlers: UILabel!
    @IBOutlet weak var totalWickets: UILabel!
    @IBOutlet weak var totalAllRounders: UILabel!
    @IBOutlet weak var totalAvgAge: UILabel!
    @IBOutlet weak var topBowlingTableView: UITableView!
    @IBOutlet weak var topBattingtableView: UITableView!
    @IBOutlet weak var coachFrndButton: UIButton!
    
    @IBOutlet weak var battingTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bowlingTableViewHeightConstraint: NSLayoutConstraint!
    
    var topBattingnames = ["Arjun Kumar","Kushal Rajiv","Krit Gupta","Noel Phlip","Lochan goudal"]
    
    @IBAction func CloseDashboardPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var friendProfile:[String:AnyObject]?
    var userProfileData:Profile!
    var coverOrProfile = ""
    var friendId:String? = nil
    var currentUserId = ""
    var isSelect:Bool?
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setBackgroundColor()
        
        initView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBannerAds()
        coachFrndButton.layer.cornerRadius = 10
        coachFrndButton.clipsToBounds = true
        isSelect = true
        coachTeams.delegate = self
        coachTeams.dataSource = self
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
        
        if let value = friendProfile{
            userProfileData = Profile(usrObj: value)
           // closeButton.hidden = false
            }
            else{
                userProfileData = profileData
                //  closeButton.hidden = true
            }
        
        userProfileImage.layer.cornerRadius = userProfileImage.bounds.size.width/2
        userProfileImage.clipsToBounds = true
        
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
    
    @IBAction func markMyCoachBtnTapped(sender: AnyObject) {
        
//        if isSelect == true {
//            markMyCoach(friendId!)
//            coachFrndButton.setTitle("Cancel coach request", forState: .Normal)
//            isSelect = false
//        }
//        else{
            coachFrndButton.setTitle("Mark as my Coach", forState: .Normal)
        cancelCoachRequest(currentUserId,type: "Player")
            isSelect = true
        //}
        
    }
    
    
    var alertMessage = "Change picture"
    
    func tapCoverPhoto()  {
        if friendId == nil {
            alertMessage = "Change your cover photo"
            self.photoOptionsToCoverPic("CoverPhoto")
            coverOrProfile = "Cover"
        }
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeThemeSettigs() {
        //let currentTheme = cricTracTheme.currentTheme
        topBattingtableView.backgroundColor = UIColor.clearColor()
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
    
//    func viewImage(option:String){
//        let newImageView = UIImageView()
//        if option == "CoverPhoto" {
//            newImageView.image = imgCoverPhoto.image
//        }else {
//            newImageView.image = userProfileImage.image
//        }
//        newImageView.frame = self.view.frame
//        newImageView.backgroundColor = .blackColor()
//        newImageView.contentMode = .ScaleAspectFit
//        newImageView.userInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(CoachDashboardViewController.dismissFullscreenImage(_:)))
//        newImageView.addGestureRecognizer(tap)
//        //        self.view.addSubview(navBarView)
//        self.view.addSubview(newImageView)
//    }
    
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
    
    // mark: For coach Teams
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    // tableview functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == topBattingtableView {
            return 6
        }
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.backgroundColor = UIColor.clearColor()
        //let currentTheme = cricTracTheme.currentTheme
        
        if tableView == topBattingtableView {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
                //cell.backgroundColor = currentTheme.bottomColor
                return cell
                }
            else{
                let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! CoachTopBattingBowlingTableViewCell
                cell.topBattingPlayerName.text = topBattingnames[indexPath.row - 1]
                return cell
                }
        }
        if indexPath.row == 0 {
             let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
           // cell.backgroundColor = currentTheme.bottomColor
             return cell
            }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! CoachTopBattingBowlingTableViewCell
            cell.topBowlingPlayerName.text = topBattingnames[indexPath.row - 1]
            
            return cell
            }
    }
   
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    
}
