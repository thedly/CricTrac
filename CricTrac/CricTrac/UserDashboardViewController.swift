//
//  UserDashboardViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 06/11/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseAuth
import GoogleMobileAds
import Kingfisher
import SwiftCountryPicker

class UserDashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ThemeChangeable {

    //MARK: - Variable declaration
    
    @IBOutlet weak var playerInfoLabel: UILabel!
    @IBOutlet weak var imgCoverPhoto: UIImageView!
    var battingDetails: [String:String]!
    var bowlingDetails: [String:String]!
    var recentMatches: [String:String]!
    var recentMatchesBowling: [String:String]!
    private var _currentTheme:String = CurrentTheme
    
    @IBOutlet weak var bannerView: GADBannerView!
     @IBOutlet weak var bannerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var topBarViewHeightConstraint: NSLayoutConstraint!
    
    var coverOrProfile = ""
    var friendId:String? = nil
    var currentUserId = ""
    
    var isFriendDashboard = false
    
    var clearColor = UIColor.clearColor()
    var darkerThemeColor = UIColor().darkerColorForColor(UIColor(hex: topColor))
    var matches = [MatchSummaryData]()
    
    var friendProfile:[String:AnyObject]?
    
    var userProfileData:Profile!
    
//    var currentUserProfileImage = UIImage()
//    var currentUserCoverImage = UIImage()
    
    // MARK: - Plumbing
    
   @IBOutlet weak var vsView: UIView!
    
    @IBOutlet weak var FirstRecentMatchSummary: UIView!
    @IBOutlet weak var SecondRecentMatchSummary: UIView!
    @IBOutlet weak var recentMatchesNotAvailable: UILabel!
    @IBOutlet weak var topBattingNotAvailable: UILabel!
    @IBOutlet weak var topBowlingNotAvailable: UILabel!
    @IBOutlet weak var firstRecentMatchDateAndVenue: UILabel!
    @IBOutlet weak var secondRecentMatchDateAndVenue: UILabel!
    @IBOutlet weak var firstRecentMatchScoreCard: UILabel!
    @IBOutlet weak var secondRecentMatchScoreCard: UILabel!
    @IBOutlet weak var firstRecentMatchOpponentName: UILabel!
    @IBOutlet weak var secondRecentMatchOpponentName: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var winPerc: UILabel!
    @IBOutlet weak var BB: UILabel!
    @IBOutlet weak var PlayerLocation: UILabel!
    @IBOutlet weak var PlayerName: UILabel!
    @IBOutlet weak var totalRunsScored: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var TeamsTable: UICollectionView!
    @IBOutlet weak var MatchesView: UIView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var battingMatches: UILabel!
    @IBOutlet weak var bowlingInnings: UILabel!
    //@IBOutlet weak var notOuts: UILabel!
    @IBOutlet weak var highScore: UILabel!
    @IBOutlet weak var battingAverage: UILabel!
    @IBOutlet weak var strikeRate: UILabel!
    @IBOutlet weak var hundreds: UILabel!
    @IBOutlet weak var fours: UILabel!
    @IBOutlet weak var sixes: UILabel!
    @IBOutlet weak var fifties: UILabel!
    @IBOutlet weak var recentBest: UILabel!
    @IBOutlet weak var battingInnings: UILabel!
    // bowling
    @IBOutlet weak var totalWickets: UILabel!
    @IBOutlet weak var bowlingAverage: UILabel!
    @IBOutlet weak var bowlingEconomy: UILabel!
    @IBOutlet weak var TotalThreeWicketsPerMatch: UILabel!
    @IBOutlet weak var recentBestBowling: UILabel!
    @IBOutlet weak var TotalMaidens: UILabel!
    @IBOutlet weak var TotalFiveWicketsPerMatch: UILabel!
    @IBOutlet weak var PlayerOversBowld: UILabel!
    @IBOutlet weak var FirstRecentMatchView: UIView!
    @IBOutlet weak var SecondRecentMatchView: UIView!
    @IBOutlet weak var FirstRecentMatchBowlingView: UIView!
    @IBOutlet weak var SecondRecentMatchBowlingView: UIView!
    @IBOutlet weak var FirstRecentMatchScore: UILabel!
    @IBOutlet weak var FirstRecentMatchOpponent: UILabel!
    @IBOutlet weak var FirstRecentMatchDateAndLocation: UILabel!
    @IBOutlet weak var SecondRecentMatchScore: UILabel!
    @IBOutlet weak var SecondRecentMatchOpponent: UILabel!
    @IBOutlet weak var SecondRecentMatchDateAndLocation: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBAction func CloseDashboardPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var TopMenu: UIView!
    @IBOutlet weak var FirstRecentMatchBowlingScore: UILabel!
    @IBOutlet weak var FirstRecentMatchBowlingOpponent: UILabel!
    @IBOutlet weak var FirstRecentMatchBowlingDateAndLocation: UILabel!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    @IBOutlet weak var SecondRecentMatchBowlingScore: UILabel!
    @IBOutlet weak var SecondRecentMatchBowlingOpponent: UILabel!
    @IBOutlet weak var SecondRecentMatchBowlingDateAndLocation: UILabel!
    
    @IBOutlet weak var FirstRecentMatchGroundVenue: UILabel!
    @IBOutlet weak var FirstRecentMatchStrikeRate: UILabel!
    @IBOutlet weak var SecondRecentMatchGroundVenue: UILabel!
    @IBOutlet weak var SecondRecentMatchStrikeRate: UILabel!
    @IBOutlet weak var FirstRecentMatchBattingGroundVenue: UILabel!
    @IBOutlet weak var FirstRecentMatchBattingStrikeRate: UILabel!
    @IBOutlet weak var SecondRecentMatchBattingGroundVenue: UILabel!
    @IBOutlet weak var SecondRecentMatchBattingStrikeRate: UILabel!
    @IBOutlet weak var FirstRecentMatchBowlingGroundVenue: UILabel!
    @IBOutlet weak var FirstRecentMatchBowlingEconomy: UILabel!
    @IBOutlet weak var SecondRecentMatchBowlingGroundVenue: UILabel!
    @IBOutlet weak var SecondRecentMatchBowlingEconomy: UILabel!
    @IBOutlet weak var summaryViewHeightConstraint1 : NSLayoutConstraint!
    @IBOutlet weak var summaryViewHeightConstraint2 : NSLayoutConstraint!
    @IBOutlet weak var summaryStackViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var topBattingStackViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var topBallingStackViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var battingSummaryViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var teamsViewHeightConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var scrollViewBottomElementConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var myCoachesButton: UIButton!
    
    var alertMessage = "Change picture"
    
    var sizeOne:CGFloat = 10
    var sizeTwo:CGFloat = 15
    var sizeThree:CGFloat = 18
    var sizeFour:CGFloat = 20
    var sizeFive:CGFloat = 25
    
    @IBAction func editImageBtnPressed(sender: AnyObject) {
        
        if friendId == nil {
            // network reachability test
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            if !appDelegate.reachability.isReachable()  {
                let alert = UIAlertController(title: "", message: networkErrorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }

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
        
        let viewPhotoAction = UIAlertAction(title: "View Photo", style: .Default) { (action) in
            
            self.viewImage(option)
            
        }
        
        alertController.addAction(viewPhotoAction)
        
        
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
        
        
//        let chooseFromFacebookAction = UIAlertAction(title: "Choose Default", style: .Default) { (action) in
//            
//            let userProviderData = currentUser?.providerData
//            
//            for usr: FIRUserInfo in userProviderData! {
//                if (usr.providerID == "facebook.com" || usr.providerID == "google.com") {
//                    
//                    self.activityInd.startAnimating()
//                    
//                    let image:UIImage = getImageFromFacebook()
//                    
//                    self.userProfileImage.image = image
//                    
//                    addProfileImageData(self.resizeImage(image, newWidth: 200))
//                    self.activityInd.stopAnimating()
//                    
//                }
//            }
//        }
        
//        alertController.addAction(chooseFromFacebookAction)
//        
//        
//        let removePhotoAction = UIAlertAction(title: "Remove Photo", style: .Default) { (action) in
//            
//            let image:UIImage = UIImage(named: "User")!
//            
//            self.userProfileImage.image = image
//            addProfileImageData(self.resizeImage(image, newWidth: 200))
//            
//        }
//        
//        alertController.addAction(removePhotoAction)
//        
//        
        let viewPhotoAction = UIAlertAction(title: "View Photo", style: .Default) { (action) in
            self.viewImage(option)
        }
        
        alertController.addAction(viewPhotoAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    func playerInfoUpdating(){
        let formattedStr = NSMutableAttributedString()
        
        let batImageAttachment = NSTextAttachment()
        batImageAttachment.image = UIImage(named: "BatIcon")
        batImageAttachment.bounds = CGRect(x: 0, y: -2, width: 15, height: 15)
        let imageAttachmentString = NSAttributedString(attachment: batImageAttachment)
        
        let ballImageAttachment = NSTextAttachment()
        ballImageAttachment.image = UIImage(named: "BallIcon")
        ballImageAttachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
        let ballImageAttachmentString = NSAttributedString(attachment: ballImageAttachment)
        
        if userProfileData.BattingStyle == "Right-hand" {
            formattedStr.appendAttributedString(imageAttachmentString)
            formattedStr.bold(" RH", fontName: appFont_bold, fontSize: 15)
        }
        else{
            formattedStr.appendAttributedString(imageAttachmentString)
            formattedStr.bold(" LH", fontName: appFont_bold, fontSize: 15)
        }
        formattedStr.bold(" - \(userProfileData.PlayingRole)   ", fontName: appFont_bold, fontSize: 15)
        if userProfileData.BowlingStyle != "-" {
            formattedStr.appendAttributedString(ballImageAttachmentString)
            formattedStr.bold(" \(userProfileData.BowlingStyle)", fontName: appFont_bold, fontSize: 15)
        }
        playerInfoLabel.attributedText = formattedStr
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        playerInfoUpdating()
        
        /*

         CGRect contentRect = CGRectZero;
         for (UIView *view in self.scrollView.subviews) {
         contentRect = CGRectUnion(contentRect, view.frame);
         }
         self.scrollView.contentSize = contentRect.size;
 */
        
        var contentRect = CGRectZero
        for view in scrollView.subviews {
            contentRect = CGRectUnion(contentRect, view.frame)
        }
        //scrollView.contentSize = contentRect.size
    }

    func setNavigationBarProperties(){
            var currentTheme:CTTheme!
            currentTheme = cricTracTheme.currentTheme
            let menuButton: UIButton = UIButton(type:.Custom)
            menuButton.setImage(UIImage(named: "menu-icon"), forState: UIControlState.Normal)
            menuButton.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
            menuButton.frame = CGRectMake(0, 0, 40, 40)
            let leftbarButton = UIBarButtonItem(customView: menuButton)
            navigationItem.leftBarButtonItem = leftbarButton

        if let navigation = navigationController{
            topBarViewHeightConstraint.constant = 0
            navigation.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
            title = "SIGHTSCREEN"
       }
       else {
              topBarViewHeightConstraint.constant = 56
              self.topBarView.backgroundColor = currentTheme.topColor
        }
        self.view.backgroundColor = currentTheme.topColor
    }
    
    
    @IBAction func didMenuButtonTapp(sender: UIButton){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    func stopAnimation() {
        if self.activityInd.isAnimating() {
            self.activityInd.stopAnimating()
        }
    }
    
    // sravani - for image crop re-writing dis fun
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//             if coverOrProfile == "Profile" {
//            //dispatch_async(dispatch_get_main_queue(),{
//
//            //self.userProfileImage.image = image
//            self.dismissViewControllerAnimated(true) {
//                addProfileImageData(self.resizeImage(image, newWidth: 200))
//                //self.initView()
//            }
//            //})
//        }
//        else {
//            self.imgCoverPhoto.image = image
//            self.dismissViewControllerAnimated(true) {
//                addCoverImageData(self.resizeImage(image, newWidth: 800))
//            }
//        }
//    }
    
    // sravani - for image crop
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var image : UIImage!
        if coverOrProfile == "Profile" {
            //dispatch_async(dispatch_get_main_queue(),{
            
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
            
            //self.userProfileImage.image = image
            self.dismissViewControllerAnimated(true) {
                addProfileImageData(self.resizeImage(image, newWidth: 200))
                //self.initView()
            }
            //})
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
            
           // self.imgCoverPhoto.image = image
            self.dismissViewControllerAnimated(true) {
                addCoverImageData(self.resizeCoverImage(image, newWidth: 800))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //disable ADs for Premium users
        if showAds == "1" {
            if profileData.UserStatus == "Premium" {
                showAds = "0"
            }
        }
        
        addTapGestureToUserName()
        TeamsTable.reloadData()
        
        myCoachesButton.layer.cornerRadius = 10
        myCoachesButton.clipsToBounds = true
       // myCoachesButton.layer.borderWidth = 2.0
       // myCoachesButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        if friendId == nil {
            myCoachesButton.hidden = false
        }
        else {
            myCoachesButton.hidden = true
        }
        
        loadBannerAds()
    }
    
    @IBAction func myCoachesButtonTapped(sender: AnyObject) {
        let myCoachesVC = viewControllerFrom("Main", vcid: "PlayerCoachesListVC") as! PlayerCoachesListVC
        self.navigationController?.pushViewController(myCoachesVC, animated: false)
    }
    
    func initView() {
        if let value = friendProfile{
            userProfileData = Profile(usrObj: value)
           // closeButton.hidden = false
        }
        else{
           userProfileData = profileData
           // closeButton.hidden = true
        }
        
        //   setBackgroundColor()
        
        //setUIBackgroundTheme(self.view)
        
        userProfileImage.layer.cornerRadius = userProfileImage.bounds.size.width/2
        MatchesView.layer.cornerRadius = 10
        
        MatchesView.alpha = 1
         MatchesView.backgroundColor = cricTracTheme.currentTheme.bottomColor

        self.SecondRecentMatchSummary.alpha = 1
        self.SecondRecentMatchSummary.backgroundColor = cricTracTheme.currentTheme.bottomColor
        
        self.FirstRecentMatchSummary.alpha = 1
        self.FirstRecentMatchSummary.backgroundColor = cricTracTheme.currentTheme.bottomColor
        
        self.FirstRecentMatchView.alpha = 1
        self.FirstRecentMatchView.backgroundColor = cricTracTheme.currentTheme.bottomColor
        
        self.SecondRecentMatchView.alpha = 1
        self.SecondRecentMatchView.backgroundColor = cricTracTheme.currentTheme.bottomColor
        
        self.FirstRecentMatchBowlingView.alpha = 1
        self.FirstRecentMatchBowlingView.backgroundColor = cricTracTheme.currentTheme.bottomColor
        
        self.SecondRecentMatchBowlingView.alpha = 1
        self.SecondRecentMatchBowlingView.backgroundColor = cricTracTheme.currentTheme.bottomColor
        
        userProfileImage.clipsToBounds = true
        
        TeamsTable.delegate = self
        TeamsTable.dataSource = self
        
        let currentCountryList = CountriesList.filter({$0.name == userProfileData.Country})
        let currentISO = currentCountryList[0].iso
        
        //calculating age
        let  dob = userProfileData.DateOfBirth
        
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        let birthdayDate = dateFormater.dateFromString(dob)
        
        let date = NSDate()

        let calender:NSCalendar  = NSCalendar.currentCalendar()
        
        let currentMonth = calender.component(.Month, fromDate: date)
        let birthmonth = calender.component(.Month, fromDate: birthdayDate!)
       
        var years = calender.component(.Year, fromDate: date) - calender.component(.Year, fromDate: birthdayDate!)
        
        var months = currentMonth - birthmonth
        
        if months < 0 {
            years = years - 1
            months = 12 - birthmonth + currentMonth
            if calender.component(.Day, fromDate: date) < calender.component(.Day, fromDate: birthdayDate!){
                months = months - 1
            }
        }
        else if months == 0 && calender.component(.Day, fromDate: date) < calender.component(.Day, fromDate: birthdayDate!)
        {
            years = years - 1
            months = 11
        }
        let ageString = "\(years) yrs \(months) months"

        
        let df = NSDateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        self.PlayerName.text = userProfileData.fullName
        let formattedString = NSMutableAttributedString()
        let locationText = formattedString.bold("\(userProfileData.City)\n", fontName: appFont_black, fontSize: 15).bold("\(userProfileData.State), ", fontName: appFont_black, fontSize: 15).bold("\(currentISO)\n", fontName: appFont_black, fontSize: 15).bold("\(userProfileData.DateOfBirth)\n", fontName: appFont_black, fontSize: 15).bold("Age: \(ageString)\n", fontName: appFont_black, fontSize: 15)
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
        
        // Do any additional setup after loading the view.
        setNavigationBarProperties()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCoverPhoto))
        tapGesture.numberOfTapsRequired = 1
        imgCoverPhoto.addGestureRecognizer(tapGesture)
    }
    
    //MARK: Ads related
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

    func tapCoverPhoto()  {
        if friendId == nil {
            // network reachability test
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if !appDelegate.reachability.isReachable()  {
                let alert = UIAlertController(title: "", message: networkErrorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }

            alertMessage = "Change your cover photo"
            self.photoOptionsToCoverPic("CoverPhoto")
            coverOrProfile = "Cover"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //UpdateDashboardDetails()
        
        let currentTheme = cricTracTheme.currentTheme
        myCoachesButton.backgroundColor = currentTheme.bottomColor

        setBackgroundColor()
        initView()
        setDashboardData()
        TeamsTable.reloadData()
        
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
            sizeTwo = 16
            sizeThree = 20
            sizeFour = 25
            sizeFive = 28
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
        let scale =  image.size.width
        let newHeight = image.size.height
        UIGraphicsBeginImageContext(CGSizeMake(scale, newHeight))
        image.drawInRect(CGRectMake(0, 0, scale, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func changeThemeSettigs() {
      //  let currentTheme = cricTracTheme.currentTheme
        MatchesView.backgroundColor = UIColor.blackColor()
        MatchesView.alpha = 0.3
//        if let _ = navigationController{
//            navigationController!.navigationBar.barTintColor = currentTheme.topColor
//        }
        
        //currentTheme.boxColor
        //baseView.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewImage(option:String){
        
        let profileImageVc = viewControllerFrom("Main", vcid: "ProfileImageExpandingVC") as! ProfileImageExpandingVC
        if option == "ProfilePhoto" {
            profileImageVc.imageString = profileData.ProfileImageURL
         }
        if option == "CoverPhoto" {
            profileImageVc.imageString = profileData.CoverPhotoURL
        }
        
        if profileData.ProfileImageURL != "-" {
             self.presentViewController(profileImageVc, animated: true) {}
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(UserDashboardViewController.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        //        self.view.addSubview(navBarView)
        self.view.addSubview(newImageView)
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    
func setDashboardData(){
    //KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")

    //reset values
    self.FirstRecentMatchSummary.hidden = false
    self.SecondRecentMatchSummary.hidden = false
    
    self.FirstRecentMatchView.hidden = false
    self.SecondRecentMatchView.hidden = false
    
    self.FirstRecentMatchBowlingView.hidden = false
    self.SecondRecentMatchBowlingView.hidden = false

    //self.topBattingNotAvailable.hidden = false
    //self.topBowlingNotAvailable.hidden = false
    
    getAllDashboardData(friendId) { (data) in
        DashboardDetails = DashboardData(dataObj: data)
        if DashboardDetails != nil {
            UIView.animateWithDuration(0.0, animations: {
                //data for Top box on dashboard
                self.battingMatches.text = String(DashboardDetails.TotalMatches)
                
                if String(DashboardDetails.TopBatting1stMatchID) != "-" {
                    self.highScore.text = String(DashboardDetails.TopBatting1stMatchDispScore)
                }
                else {
                    self.highScore.text = "-"
                }
                
                if String(DashboardDetails.TopBowling1stMatchID) != "-" {
                    self.BB.text = String(DashboardDetails.TopBowling1stMatchScore)
                }
                else {
                    self.BB.text = "-"
                }
                
                let winPercent = Double(String(DashboardDetails.WinPercentage))
                self.winPerc.text = String(format:"%.1f",winPercent!)
                
                //data for Batting Card
                self.totalRunsScored.text = String(DashboardDetails.TotalRuns)
                self.battingInnings.text = String(DashboardDetails.BattingInnings)
                let battingAverage = Double(String(DashboardDetails.TotalBattingAverage))
                self.battingAverage.text = String(format:"%.1f",battingAverage!)
                let strikeRate = Double(String(DashboardDetails.TotalStrikeRate))
                self.strikeRate.text = String(format:"%.1f",strikeRate!)
                self.hundreds.text = String(DashboardDetails.Total100s)
                self.fifties.text = String(DashboardDetails.Total50s)
                self.sixes.text = String(DashboardDetails.Total6s)
                self.fours.text = String(DashboardDetails.Total4s)
                
                //data for Bowling Card
                self.bowlingInnings.text = String(DashboardDetails.BowlingInnings)
                self.totalWickets.text = String(DashboardDetails.TotalWickets)
                let bowlingAverageDouble = Double(String(DashboardDetails.TotalBowlingAverage))
                self.bowlingAverage.text = String(format:"%.1f",bowlingAverageDouble!)
                let bowlingEconomyDouble = Double(String(DashboardDetails.TotalEconomy))
                self.bowlingEconomy.text = String(format:"%.2f",bowlingEconomyDouble!)
                self.TotalThreeWicketsPerMatch.text = String(DashboardDetails.Total3Wkts)
                self.TotalMaidens.text = String(DashboardDetails.TotalMaidens)
                self.TotalFiveWicketsPerMatch.text = String(DashboardDetails.Total5Wkts)
                let PlayerOversBowldDouble = Double(String(DashboardDetails.TotalOvers))
                self.PlayerOversBowld.text = String(format:"%.1f",PlayerOversBowldDouble!)
                
                dispatch_async(dispatch_get_main_queue(),{
                    //sajith - new code for Recent First Match
                    self.FirstRecentMatchSummary.hidden = true
                    self.SecondRecentMatchSummary.hidden = true
                    self.FirstRecentMatchView.hidden = true
                    self.SecondRecentMatchView.hidden = true
                    self.FirstRecentMatchBowlingView.hidden = true
                    self.SecondRecentMatchBowlingView.hidden = true
                   
                    self.TeamsTable.reloadData()
                    self.updateDashBoardMatches()
                })
                

                if String(DashboardDetails.Recent1stMatchID) != "-" {
                    /*getSelectedMatchData(String(DashboardDetails.Recent1stMatchID), friendId: self.friendId) { (data) in
                    }*/
                    
                    let matchId:String = (String(DashboardDetails.Recent1stMatchID) ?? nil)!
                    let userId:String = self.friendId ?? currentUser!.uid
                    fireBaseRef.child("Users").child(userId).child("Matches").child(matchId).observeEventType(.Value, withBlock: { snapshot in
                        
                        if let data = snapshot.value! as? [String:AnyObject]{
                           let battingBowlingScore = NSMutableAttributedString()
                            var matchVenueAndDate = ""
                            var opponentName = ""
                            var groundVenue = ""
                            var srEconomy = ""
                            let mData = MatchSummaryData()
                            
                            //code for Double Innings
                            var matchFormat = ""
                            var batting1 = false
                            var batting2 = false
                            var bowling1 = false
                            var bowling2 = false
                            
                            if data["MatchFormat"] as? String != "" && data["MatchFormat"] != nil {
                                matchFormat = data["MatchFormat"] as! String
                            }

                            if matchFormat == "Double Innings" {
                                //data for first innings
                                if let runsTaken = data["RunsTaken"]{
                                    mData.BattingSectionHidden = (runsTaken as! String == "-")
                                    if mData.BattingSectionHidden == false {
                                        batting1 = true
                                        if let dismissal = data["Dismissal"] as? String where dismissal == "Not out"{
                                            battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: self.sizeThree).bold("*", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                        else{
                                            battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                    }
                                }
                                //data for second innings
                                if let runsTaken2 = data["RunsTaken2"]{
                                    mData.BattingSectionHidden = (runsTaken2 as! String == "-")
                                    if mData.BattingSectionHidden == false {
                                        if batting1 == true {
                                            battingBowlingScore.bold(", ", fontName: appFont_black, fontSize: self.sizeTwo)
                                        }
                                        else {
                                            battingBowlingScore.bold("DNB, ", fontName: appFont_black, fontSize: self.sizeTwo)
                                        }
                                        batting2 = true
                                        if let dismissal2 = data["Dismissal2"] as? String where dismissal2 == "Not out"{
                                            battingBowlingScore.bold(runsTaken2 as! String, fontName: appFont_black, fontSize: self.sizeThree).bold("*", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                        else{
                                            battingBowlingScore.bold(runsTaken2 as! String, fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                    }
                                }
                                
                                if batting1 == true || batting2 == true {
                                    mData.BattingSectionHidden = false
                                    battingBowlingScore.bold("\nRUNS", fontName: appFont_black, fontSize: self.sizeOne)
                                }
                            }
                            else {
                                if let runsTaken = data["RunsTaken"]{
                                    mData.BattingSectionHidden = (runsTaken as! String == "-")
                                    if mData.BattingSectionHidden == false {
                                        batting1 = true
                                        if let dismissal = data["Dismissal"] as? String where dismissal == "Not out"{
                                            battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: self.sizeFive).bold("*", fontName: appFont_black, fontSize: self.sizeFive).bold("\nRUNS", fontName: appFont_black, fontSize: self.sizeOne)
                                        }
                                        else{
                                            battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: self.sizeFive).bold("\nRUNS", fontName: appFont_black, fontSize: self.sizeOne)
                                        }
                                    }
                                }
                            }
                            
                            if matchFormat == "Double Innings" {
                                //data for first innings
                                if let wicketsTaken = data["WicketsTaken"], let runsGiven = data["RunsGiven"] {
                                    mData.BowlingSectionHidden = (runsGiven as! String == "-")
                                    if mData.BowlingSectionHidden == false {
                                        bowling1 = true
                                        if battingBowlingScore.length > 0 {
                                            battingBowlingScore.bold("\n\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                        else{
                                            battingBowlingScore.bold("\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                    }
                                }
                                //data for second innings
                                if let wicketsTaken2 = data["WicketsTaken2"], let runsGiven2 = data["RunsGiven2"] {
                                    mData.BowlingSectionHidden = (runsGiven2 as! String == "-")
                                    if mData.BowlingSectionHidden == false {
                                        if bowling1 == true {
                                            battingBowlingScore.bold(", ", fontName: appFont_black, fontSize: self.sizeTwo)
                                        }
                                        else {
                                            battingBowlingScore.bold("\nDNB, ", fontName: appFont_black, fontSize: self.sizeTwo)
                                        }
                                        bowling2 = true
                                        if battingBowlingScore.length > 0 {
                                            battingBowlingScore.bold("\n\(wicketsTaken2)-\(runsGiven2)", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                        else{
                                            battingBowlingScore.bold("\(wicketsTaken2)-\(runsGiven2)", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                    }
                                }
                                
                               if bowling1 == true || bowling2 == true {
                                    mData.BowlingSectionHidden = false
                                    battingBowlingScore.bold("\nWICKETS", fontName: appFont_black, fontSize: self.sizeOne)
                                }
                            }
                            else {
                                if let wicketsTaken = data["WicketsTaken"], let runsGiven = data["RunsGiven"] {
                                    mData.BowlingSectionHidden = (runsGiven as! String == "-")
                                    if mData.BowlingSectionHidden == false {
                                        if battingBowlingScore.length > 0 {
                                            bowling1 = true
                                            battingBowlingScore.bold("\n\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: self.sizeFive).bold("\nWICKETS", fontName: appFont_black, fontSize: self.sizeOne)
                                        }
                                        else{
                                            battingBowlingScore.bold("\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: self.sizeFive).bold("\nWICKETS", fontName: appFont_black, fontSize: self.sizeOne)
                                        }
                                    }
                                }
                            }
                            
                            if battingBowlingScore.length == 0 {
                                battingBowlingScore.bold("DNB", fontName: appFont_black, fontSize: self.sizeFive)
                            }
                            
                            
                            if let date = data["MatchDate"]{
                                let DateFormatter = NSDateFormatter()
                                DateFormatter.dateFormat = "dd-MM-yyyy"
                                DateFormatter.locale =  NSLocale(localeIdentifier: "en_US_POSIX")
                                let dateFromString = DateFormatter.dateFromString(date as! String)
                                mData.matchDate = dateFromString
                                matchVenueAndDate.appendContentsOf(date as? String ?? "NA")
                            }
                            
                            if let group = data["AgeGroup"]{
                                matchVenueAndDate.appendContentsOf(" | \(group)")
                            }
                            
                            var groundData = ""
                            
                            let ground = data["Ground"] as? String
                            if ground != "-" {
                                groundData = ground! + " "
                            }
                            
                            let venue = data["Venue"] as? String
                            if venue != "-" {
                                groundData = groundData + venue!
                            }
                            
                            if ground == "-" && venue == "-" {
                                groundData = (data["Level"] as? String)! + " Match"
                            }
                            
                            groundVenue = groundData
                            
                            self.summaryViewHeightConstraint1.constant = 70
                            self.summaryStackViewHeightConstraint.constant = 80
                            
                            if (batting1 == true || batting2 == true) && mData.BattingSectionHidden == false {
                                //if let ballsFaced = data["BallsFaced"] as? String where ballsFaced != "-", let runsScored = data["RunsTaken"] as? String where runsScored != "-" && mData.BattingSectionHidden == false {
                                
                                var totalStrikeRate = Float("0.00")
                                var strikerate1 = Float("0.00")
                                var strikerate2 = Float("0.00")
                                
                                if batting1 == true {
                                    let ballsFaced1 = data["BallsFaced"] as? String
                                    let runsScored1 = data["RunsTaken"] as? String
                                    
                                    if ballsFaced1 == "0" {
                                        strikerate1 = Float("0.00")
                                    }
                                    else {
                                        let strikeRate1 = String(format: "%.1f",(Float(runsScored1!))!*100/Float(ballsFaced1!)!)
                                        strikerate1 = Float(strikeRate1)
                                    }
                                }
                                if batting2 == true {
                                    let ballsFaced2 = data["BallsFaced2"] as? String
                                    let runsScored2 = data["RunsTaken2"] as? String
                                    
                                    if ballsFaced2 == "0" {
                                        strikerate2 = Float("0.00")
                                    }
                                    else {
                                        let strikeRate2 = String(format: "%.1f",(Float(runsScored2!))!*100/Float(ballsFaced2!)!)
                                        strikerate2 = Float(strikeRate2)
                                    }
                                }
                                
                                if batting1 == true && batting2 == true {
                                    totalStrikeRate = (strikerate1! + strikerate2!)/2
                                }
                                else {
                                    totalStrikeRate = strikerate1! + strikerate2!
                                }
                                srEconomy = ("Strike Rate: \(String(format: "%.1f",totalStrikeRate!))")
                                
                                self.summaryViewHeightConstraint1.constant = 90
                                self.summaryStackViewHeightConstraint.constant = self.summaryStackViewHeightConstraint.constant + 20
                            }
                            
                            
//                            if let ballsFaced = data["BallsFaced"] as? String where ballsFaced != "-", let runsScored = data["RunsTaken"] as? String where runsScored != "-" && mData.BattingSectionHidden == false {
//                                
//                                if ballsFaced == "0" {
//                                    mData.strikerate = Float("0.00")
//                                }
//                                else {
//                                    let strikeRate = String(format: "%.1f",(Float(runsScored)!)*100/Float(ballsFaced)!)
//                                    mData.strikerate = Float(strikeRate)
//                                    srEconomy = ("Strike Rate: \(strikeRate)")
//                                    
//                                }
//                                self.summaryViewHeightConstraint1.constant = 90
//                                self.summaryStackViewHeightConstraint.constant = self.summaryStackViewHeightConstraint.constant + 20
//                            }
                            
                            if (bowling1 == true || bowling2 == true) && mData.BowlingSectionHidden == false {
                                //if let oversBowled = data["OversBowled"] as? String where oversBowled != "-", let runsGiven = data["RunsGiven"] as? String where runsGiven != "-" && mData.BowlingSectionHidden == false {
                                
                                var totalEconomy = Float("0.00")
                                var economy1 = Float("0.00")
                                var economy2 = Float("0.00")
                                
                                if bowling1 == true {
                                    let runsGiven1 = data["RunsGiven"] as? String
                                    let oversBowled1 = data["OversBowled"] as? String
                                    let econ1 = String(format: "%.2f",(Float(runsGiven1!)!)/Float(oversBowled1!)!)
                                    economy1 = Float(econ1)
                                }
                                if bowling2 == true {
                                    let runsGiven2 = data["RunsGiven2"] as? String
                                    let oversBowled2 = data["OversBowled2"] as? String
                                    let econ2 = String(format: "%.2f",(Float(runsGiven2!)!)/Float(oversBowled2!)!)
                                    economy2 = Float(econ2)
                                }
                                
                                if bowling1 == true && bowling2 == true {
                                    totalEconomy = (economy1! + economy2!)/2
                                }
                                else {
                                    totalEconomy = economy1! + economy2!
                                }
                                let economy = String(format: "%.2f",totalEconomy!)
                                
                                mData.economy = Float(economy)
                                if srEconomy.length > 0 {
                                    srEconomy.appendContentsOf("\nEconomy: \(economy)")
                                     self.summaryViewHeightConstraint1.constant = 110
                                    self.summaryStackViewHeightConstraint.constant = self.summaryStackViewHeightConstraint.constant + 20
                                }
                                else {
                                    srEconomy = ("Economy: \(economy)")
                                     self.summaryViewHeightConstraint1.constant = 90
                                    self.summaryStackViewHeightConstraint.constant = self.summaryStackViewHeightConstraint.constant + 20
                                }
                            }

                            let formattedStringName = NSMutableAttributedString()
                            let formattedOpponentName = formattedStringName.bold((data["Opponent"] as? String)!, fontName: appFont_black, fontSize: self.sizeThree)
                            
                            let formattedStringDate = NSMutableAttributedString()
                            let formattedDate = formattedStringDate.bold(matchVenueAndDate, fontName: appFont_black, fontSize: self.sizeTwo)
                            
                            let formattedStringGround = NSMutableAttributedString()
                            let formattedGround = formattedStringGround.bold(groundVenue, fontName: appFont_black, fontSize: self.sizeTwo)
                            
                            let formattedStringSR = NSMutableAttributedString()
                            let formattedSR = formattedStringSR.bold(srEconomy, fontName: appFont_black, fontSize: self.sizeTwo)
                            
                            self.firstRecentMatchScoreCard.attributedText = battingBowlingScore
                            self.firstRecentMatchOpponentName.attributedText = formattedOpponentName
                            self.firstRecentMatchDateAndVenue.attributedText = formattedDate
                            self.FirstRecentMatchGroundVenue.attributedText = formattedGround
                            self.FirstRecentMatchStrikeRate.attributedText = formattedSR
                        }
                    })
                    dispatch_async(dispatch_get_main_queue(),{
                        self.FirstRecentMatchSummary.hidden = false
                        self.recentMatchesNotAvailable.hidden = true
                        
                        //self.TeamsTable.reloadData()
                        self.updateDashBoardMatches()
                    })
                }
                
                //sajith - new code for Recent Second Match
                if String(DashboardDetails.Recent2ndMatchID) != "-" {
                    let matchId:String = (String(DashboardDetails.Recent2ndMatchID) ?? nil)!
                    let userId:String = self.friendId ?? currentUser!.uid
                    fireBaseRef.child("Users").child(userId).child("Matches").child(matchId).observeEventType(.Value, withBlock: { snapshot in
                        
                        if let data = snapshot.value! as? [String:AnyObject]{
                            let battingBowlingScore = NSMutableAttributedString()
                            var matchVenueAndDate = ""
                            var opponentName = ""
                            var groundVenue = ""
                            var srEconomy = ""
                            let mData = MatchSummaryData()
                            
                            //code for Double Innings
                            var matchFormat = ""
                            var batting1 = false
                            var batting2 = false
                            var bowling1 = false
                            var bowling2 = false
                            
                            if data["MatchFormat"] as? String != "" && data["MatchFormat"] != nil {
                                matchFormat = data["MatchFormat"] as! String
                            }

                            if matchFormat == "Double Innings" {
                                //data for first innings
                                if let runsTaken = data["RunsTaken"]{
                                    mData.BattingSectionHidden = (runsTaken as! String == "-")
                                    if mData.BattingSectionHidden == false {
                                        batting1 = true
                                        if let dismissal = data["Dismissal"] as? String where dismissal == "Not out"{
                                            battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: self.sizeThree).bold("*", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                        else{
                                            battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                    }
                                }
                                //data for second innings
                                if let runsTaken2 = data["RunsTaken2"]{
                                    mData.BattingSectionHidden = (runsTaken2 as! String == "-")
                                    if mData.BattingSectionHidden == false {
                                        if batting1 == true {
                                            battingBowlingScore.bold(", ", fontName: appFont_black, fontSize: self.sizeTwo)
                                        }
                                        else {
                                            battingBowlingScore.bold("DNB, ", fontName: appFont_black, fontSize: self.sizeTwo)
                                        }
                                        batting2 = true
                                        if let dismissal2 = data["Dismissal2"] as? String where dismissal2 == "Not out"{
                                            battingBowlingScore.bold(runsTaken2 as! String, fontName: appFont_black, fontSize: self.sizeThree).bold("*", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                        else{
                                            battingBowlingScore.bold(runsTaken2 as! String, fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                    }
                                }
                                
                                if batting1 == true || batting2 == true {
                                    mData.BattingSectionHidden = false
                                    battingBowlingScore.bold("\nRUNS", fontName: appFont_black, fontSize: self.sizeOne)
                                }
                            }
                            else {
                                if let runsTaken = data["RunsTaken"]{
                                    mData.BattingSectionHidden = (runsTaken as! String == "-")
                                    if mData.BattingSectionHidden == false {
                                        batting1 = true
                                        if let dismissal = data["Dismissal"] as? String where dismissal == "Not out"{
                                            battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: self.sizeFive).bold("*", fontName: appFont_black, fontSize: self.sizeFive).bold("\nRUNS", fontName: appFont_black, fontSize: self.sizeOne)
                                        }
                                        else{
                                            battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: self.sizeFive).bold("\nRUNS", fontName: appFont_black, fontSize: self.sizeOne)
                                        }
                                    }
                                }
                            }
                            
                            if matchFormat == "Double Innings" {
                                //data for first innings
                                if let wicketsTaken = data["WicketsTaken"], let runsGiven = data["RunsGiven"] {
                                    mData.BowlingSectionHidden = (runsGiven as! String == "-")
                                    if mData.BowlingSectionHidden == false {
                                        bowling1 = true
                                        if battingBowlingScore.length > 0 {
                                            battingBowlingScore.bold("\n\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                        else{
                                            battingBowlingScore.bold("\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                    }
                                }
                                //data for second innings
                                if let wicketsTaken2 = data["WicketsTaken2"], let runsGiven2 = data["RunsGiven2"] {
                                    mData.BowlingSectionHidden = (runsGiven2 as! String == "-")
                                    if mData.BowlingSectionHidden == false {
                                        if bowling1 == true {
                                            battingBowlingScore.bold(", ", fontName: appFont_black, fontSize: self.sizeTwo)
                                        }
                                        else {
                                            battingBowlingScore.bold("\nDNB, ", fontName: appFont_black, fontSize: self.sizeTwo)
                                        }
                                        bowling2 = true
                                        if battingBowlingScore.length > 0 {
                                            battingBowlingScore.bold("\n\(wicketsTaken2)-\(runsGiven2)", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                        else{
                                            battingBowlingScore.bold("\(wicketsTaken2)-\(runsGiven2)", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                    }
                                }
                                
                                if bowling1 == true || bowling2 == true {
                                    mData.BowlingSectionHidden = false
                                    battingBowlingScore.bold("\nWICKETS", fontName: appFont_black, fontSize: self.sizeOne)
                                }
                            }
                            else {
                                if let wicketsTaken = data["WicketsTaken"], let runsGiven = data["RunsGiven"] {
                                    mData.BowlingSectionHidden = (runsGiven as! String == "-")
                                    if mData.BowlingSectionHidden == false {
                                        if battingBowlingScore.length > 0 {
                                            bowling1 = true
                                            battingBowlingScore.bold("\n\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: self.sizeFive).bold("\nWICKETS", fontName: appFont_black, fontSize: self.sizeOne)
                                        }
                                        else{
                                            battingBowlingScore.bold("\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: self.sizeFive).bold("\nWICKETS", fontName: appFont_black, fontSize: self.sizeOne)
                                        }
                                    }
                                }
                            }
                            
                            if battingBowlingScore.length == 0 {
                                battingBowlingScore.bold("DNB", fontName: appFont_black, fontSize: self.sizeFive)
                            }
                            
                            
                            if let date = data["MatchDate"]{
                                let DateFormatter = NSDateFormatter()
                                DateFormatter.dateFormat = "dd-MM-yyyy"
                                DateFormatter.locale =  NSLocale(localeIdentifier: "en_US_POSIX")
                                let dateFromString = DateFormatter.dateFromString(date as! String)
                                mData.matchDate = dateFromString
                                matchVenueAndDate.appendContentsOf(date as? String ?? "NA")
                            }
                            
                            if let group = data["AgeGroup"]{
                                matchVenueAndDate.appendContentsOf(" | \(group)")
                            }
                            
                            var groundData = ""
                            
                            let ground = data["Ground"] as? String
                            if ground != "-" {
                                groundData = ground! + " "
                            }
                            
                            let venue = data["Venue"] as? String
                            if venue != "-" {
                                groundData = groundData + venue!
                            }
                            
                            if ground == "-" && venue == "-" {
                                groundData = (data["Level"] as? String)! + " Match"
                            }
                            
                            groundVenue = groundData
                            
                            self.summaryViewHeightConstraint2.constant = 70
                            self.summaryStackViewHeightConstraint.constant = self.summaryStackViewHeightConstraint.constant + 70
                            
                            if (batting1 == true || batting2 == true) && mData.BattingSectionHidden == false {
                            //if let ballsFaced = data["BallsFaced"] as? String where ballsFaced != "-", let runsScored = data["RunsTaken"] as? String where runsScored != "-" && mData.BattingSectionHidden == false {
                                
                                var totalStrikeRate = Float("0.00")
                                var strikerate1 = Float("0.00")
                                var strikerate2 = Float("0.00")
                                
                                if batting1 == true {
                                    let ballsFaced1 = data["BallsFaced"] as? String
                                    let runsScored1 = data["RunsTaken"] as? String
                                    
                                    if ballsFaced1 == "0" {
                                        strikerate1 = Float("0.00")
                                    }
                                    else {
                                        let strikeRate1 = String(format: "%.1f",(Float(runsScored1!))!*100/Float(ballsFaced1!)!)
                                        strikerate1 = Float(strikeRate1)
                                    }
                                }
                                if batting2 == true {
                                    let ballsFaced2 = data["BallsFaced2"] as? String
                                    let runsScored2 = data["RunsTaken2"] as? String
                                    
                                    if ballsFaced2 == "0" {
                                        strikerate2 = Float("0.00")
                                    }
                                    else {
                                        let strikeRate2 = String(format: "%.1f",(Float(runsScored2!))!*100/Float(ballsFaced2!)!)
                                        strikerate2 = Float(strikeRate2)
                                    }
                                }
                                
                                if batting1 == true && batting2 == true {
                                    totalStrikeRate = (strikerate1! + strikerate2!)/2
                                }
                                else {
                                    totalStrikeRate = strikerate1! + strikerate2!
                                }
                                srEconomy = ("Strike Rate: \(String(format: "%.1f",totalStrikeRate!))")
                                
                                self.summaryViewHeightConstraint2.constant = 90
                                self.summaryStackViewHeightConstraint.constant = self.summaryStackViewHeightConstraint.constant + 20
                            }
                            
                            if (bowling1 == true || bowling2 == true) && mData.BowlingSectionHidden == false {
                            //if let oversBowled = data["OversBowled"] as? String where oversBowled != "-", let runsGiven = data["RunsGiven"] as? String where runsGiven != "-" && mData.BowlingSectionHidden == false {
                                
                                var totalEconomy = Float("0.00")
                                var economy1 = Float("0.00")
                                var economy2 = Float("0.00")
                                
                                if bowling1 == true {
                                    let runsGiven1 = data["RunsGiven"] as? String
                                    let oversBowled1 = data["OversBowled"] as? String
                                    let econ1 = String(format: "%.2f",(Float(runsGiven1!)!)/Float(oversBowled1!)!)
                                    economy1 = Float(econ1)
                                }
                                if bowling2 == true {
                                    let runsGiven2 = data["RunsGiven2"] as? String
                                    let oversBowled2 = data["OversBowled2"] as? String
                                    let econ2 = String(format: "%.2f",(Float(runsGiven2!)!)/Float(oversBowled2!)!)
                                    economy2 = Float(econ2)
                                }
                                
                                if bowling1 == true && bowling2 == true {
                                    totalEconomy = (economy1! + economy2!)/2
                                }
                                else {
                                    totalEconomy = economy1! + economy2!
                                }
                                let economy = String(format: "%.2f",totalEconomy!)
                                
                                //let economy = String(format: "%.2f",(Float(runsGiven)!)/Float(oversBowled)!)
                                mData.economy = Float(economy)
                                if srEconomy.length > 0 {
                                    srEconomy.appendContentsOf("\nEconomy: \(economy)")
                                     self.summaryViewHeightConstraint2.constant = 110
                                    self.summaryStackViewHeightConstraint.constant = self.summaryStackViewHeightConstraint.constant + 20
                                }
                                else {
                                    srEconomy = ("Economy: \(economy)")
                                     self.summaryViewHeightConstraint2.constant = 90
                                    self.summaryStackViewHeightConstraint.constant = self.summaryStackViewHeightConstraint.constant + 20
                                }
                            }
                            
                            let formattedStringName = NSMutableAttributedString()
                            let formattedOpponentName = formattedStringName.bold((data["Opponent"] as? String)!, fontName: appFont_black, fontSize: self.sizeThree)
                            
                            let formattedStringDate = NSMutableAttributedString()
                            let formattedDate = formattedStringDate.bold(matchVenueAndDate, fontName: appFont_black, fontSize: self.sizeTwo)
                            
                            let formattedStringGround = NSMutableAttributedString()
                            let formattedGround = formattedStringGround.bold(groundVenue, fontName: appFont_black, fontSize: self.sizeTwo)
                            
                            let formattedStringSR = NSMutableAttributedString()
                            let formattedSR = formattedStringSR.bold(srEconomy, fontName: appFont_black, fontSize: self.sizeTwo)
                            
                            self.secondRecentMatchScoreCard.attributedText = battingBowlingScore
                            self.secondRecentMatchOpponentName.attributedText = formattedOpponentName
                            self.secondRecentMatchDateAndVenue.attributedText = formattedDate
                            self.SecondRecentMatchGroundVenue.attributedText = formattedGround
                            self.SecondRecentMatchStrikeRate.attributedText = formattedSR
                        }
                    })
    
                    dispatch_async(dispatch_get_main_queue(),{
                        self.SecondRecentMatchSummary.hidden = false
                        self.recentMatchesNotAvailable.hidden = true
                        
                         //self.TeamsTable.reloadData()
                        self.updateDashBoardMatches()
                        
                    })
                }
                
                //Display Top Batting First Match card
                /*if !self.FirstRecentMatchView.hidden {
                    self.FirstRecentMatchScore.text = String(DashboardDetails.TopBatting1stMatchScore)
                    self.FirstRecentMatchOpponent.text = String(DashboardDetails.TopBatting1stMatchOpp)
                    let formattedString = NSMutableAttributedString()
                    formattedString.bold("\(DashboardDetails.TopBatting1stMatchDate), at \(DashboardDetails.TopBatting1stMatchGround)",fontName: appFont_bold, fontSize: 12)
                    self.FirstRecentMatchDateAndLocation.attributedText = formattedString
                }*/
                
                //sajith - new code for Top Batting First Match
                if String(DashboardDetails.TopBatting1stMatchID) != "-" {
                    let matchId:String = (String(DashboardDetails.TopBatting1stMatchID) ?? nil)!
                    let userId:String = self.friendId ?? currentUser!.uid
                    fireBaseRef.child("Users").child(userId).child("Matches").child(matchId).observeEventType(.Value, withBlock: { snapshot in
                        
                        if let data = snapshot.value! as? [String:AnyObject]{
            
                            let battingBowlingScore = NSMutableAttributedString()
                            var matchVenueAndDate = ""
                            var opponentName = ""
                            var groundVenue = ""
                            var srEconomy = ""
                            let mData = MatchSummaryData()
                            
                            //code for Double Innings
                            var matchFormat = ""
                            var batting1 = false
                            var batting2 = false
                            
                            if data["MatchFormat"] as? String != "" && data["MatchFormat"] != nil {
                                matchFormat = data["MatchFormat"] as! String
                            }
                            
                            if matchFormat == "Double Innings" {
                                //data for first innings
                                if let runsTaken = data["RunsTaken"]{
                                    mData.BattingSectionHidden = (runsTaken as! String == "-")
                                    if mData.BattingSectionHidden == false {
                                        batting1 = true
                                        if let dismissal = data["Dismissal"] as? String where dismissal == "Not out"{
                                            battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: self.sizeThree).bold("*", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                        else{
                                            battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                    }
                                }
                                //data for second innings
                                if let runsTaken2 = data["RunsTaken2"]{
                                    mData.BattingSectionHidden = (runsTaken2 as! String == "-")
                                    if mData.BattingSectionHidden == false {
                                        if batting1 == true {
                                            battingBowlingScore.bold(", ", fontName: appFont_black, fontSize: self.sizeTwo)
                                        }
                                        else {
                                            battingBowlingScore.bold("DNB, ", fontName: appFont_black, fontSize: self.sizeTwo)
                                        }
                                        batting2 = true
                                        if let dismissal2 = data["Dismissal2"] as? String where dismissal2 == "Not out"{
                                            battingBowlingScore.bold(runsTaken2 as! String, fontName: appFont_black, fontSize: self.sizeThree).bold("*", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                        else{
                                            battingBowlingScore.bold(runsTaken2 as! String, fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                    }
                                }
                                
                                if batting1 == true || batting2 == true {
                                    mData.BattingSectionHidden = false
                                    battingBowlingScore.bold("\nRUNS", fontName: appFont_black, fontSize: self.sizeOne)
                                }
                            }
                            else {
                                if let runsTaken = data["RunsTaken"]{
                                    mData.BattingSectionHidden = (runsTaken as! String == "-")
                                    if mData.BattingSectionHidden == false {
                                        batting1 = true
                                        if let dismissal = data["Dismissal"] as? String where dismissal == "Not out"{
                                            battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: self.sizeFive).bold("*", fontName: appFont_black, fontSize: self.sizeFive).bold("\nRUNS", fontName: appFont_black, fontSize: self.sizeOne)
                                        }
                                        else{
                                            battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: self.sizeFive).bold("\nRUNS", fontName: appFont_black, fontSize: self.sizeOne)
                                        }
                                    }
                                }
                            }
                            
                            if battingBowlingScore.length == 0 {
                                battingBowlingScore.bold("DNB", fontName: appFont_black, fontSize: self.sizeFive)
                            }
                            
                            if let date = data["MatchDate"]{
                                let DateFormatter = NSDateFormatter()
                                DateFormatter.dateFormat = "dd-MM-yyyy"
                                DateFormatter.locale =  NSLocale(localeIdentifier: "en_US_POSIX")
                                let dateFromString = DateFormatter.dateFromString(date as! String)
                                mData.matchDate = dateFromString
                                matchVenueAndDate.appendContentsOf(date as? String ?? "NA")
                            }
                            
                            if let group = data["AgeGroup"]{
                                matchVenueAndDate.appendContentsOf(" | \(group)")
                            }
                            
                            var groundData = ""
                            
                            let ground = data["Ground"] as? String
                            if ground != "-" {
                                groundData = ground! + " "
                            }
                            
                            let venue = data["Venue"] as? String
                            if venue != "-" {
                                groundData = groundData + venue!
                            }
                            
                            if ground == "-" && venue == "-" {
                                groundData = (data["Level"] as? String)! + " Match"
                            }
                            
                            groundVenue = groundData
                            
                            if (batting1 == true || batting2 == true) && mData.BattingSectionHidden == false {
                                //if let ballsFaced = data["BallsFaced"] as? String where ballsFaced != "-", let runsScored = data["RunsTaken"] as? String where runsScored != "-" && mData.BattingSectionHidden == false {
                                
                                var totalStrikeRate = Float("0.00")
                                var strikerate1 = Float("0.00")
                                var strikerate2 = Float("0.00")
                                
                                if batting1 == true {
                                    let ballsFaced1 = data["BallsFaced"] as? String
                                    let runsScored1 = data["RunsTaken"] as? String
                                    
                                    if ballsFaced1 == "0" {
                                        strikerate1 = Float("0.00")
                                    }
                                    else {
                                        let strikeRate1 = String(format: "%.1f",(Float(runsScored1!))!*100/Float(ballsFaced1!)!)
                                        strikerate1 = Float(strikeRate1)
                                    }
                                }
                                if batting2 == true {
                                    let ballsFaced2 = data["BallsFaced2"] as? String
                                    let runsScored2 = data["RunsTaken2"] as? String
                                    
                                    if ballsFaced2 == "0" {
                                        strikerate2 = Float("0.00")
                                    }
                                    else {
                                        let strikeRate2 = String(format: "%.1f",(Float(runsScored2!))!*100/Float(ballsFaced2!)!)
                                        strikerate2 = Float(strikeRate2)
                                    }
                                }
                                
                                if batting1 == true && batting2 == true {
                                    totalStrikeRate = (strikerate1! + strikerate2!)/2
                                }
                                else {
                                    totalStrikeRate = strikerate1! + strikerate2!
                                }
                                srEconomy = ("Strike Rate: \(String(format: "%.1f",totalStrikeRate!))")
                                
                                let formattedStringName = NSMutableAttributedString()
                                let formattedOpponentName = formattedStringName.bold((data["Opponent"] as? String)!, fontName: appFont_black, fontSize: self.sizeThree)
                                
                                let formattedStringDate = NSMutableAttributedString()
                                let formattedDate = formattedStringDate.bold(matchVenueAndDate, fontName: appFont_black, fontSize: self.sizeTwo)
                                
                                let formattedStringGround = NSMutableAttributedString()
                                let formattedGround = formattedStringGround.bold(groundVenue, fontName: appFont_black, fontSize: self.sizeTwo)
                                
                                let formattedStringSR = NSMutableAttributedString()
                                let formattedSR = formattedStringSR.bold(srEconomy, fontName: appFont_black, fontSize: self.sizeTwo)
                                
                                self.FirstRecentMatchScore.attributedText = battingBowlingScore
                                self.FirstRecentMatchOpponent.attributedText = formattedOpponentName
                                self.FirstRecentMatchDateAndLocation.attributedText = formattedDate
                                self.FirstRecentMatchBattingGroundVenue.attributedText = formattedGround
                                self.FirstRecentMatchBattingStrikeRate.attributedText = formattedSR
                            }
                        }
                    })
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        self.FirstRecentMatchView.hidden = false
                        
                         //self.TeamsTable.reloadData()
                        self.updateDashBoardMatches()
                    })
                }

                //Display Top Batting Second Match card
                /*if !self.SecondRecentMatchView.hidden {
                    self.SecondRecentMatchScore.text = String(DashboardDetails.TopBatting2ndMatchScore)
                    self.SecondRecentMatchOpponent.text = String(DashboardDetails.TopBatting2ndMatchOpp)
                    let formattedString_2 = NSMutableAttributedString()
                    formattedString_2.bold("\(DashboardDetails.TopBatting2ndMatchDate), at \(DashboardDetails.TopBatting2ndMatchGround)",fontName: appFont_bold, fontSize: 12)
                    self.SecondRecentMatchDateAndLocation.attributedText = formattedString_2
                }*/
                
                //sajith - new code for Top Batting Second Match
                if String(DashboardDetails.TopBatting2ndMatchID) != "-" {
                    let matchId:String = (String(DashboardDetails.TopBatting2ndMatchID) ?? nil)!
                    let userId:String = self.friendId ?? currentUser!.uid
                    fireBaseRef.child("Users").child(userId).child("Matches").child(matchId).observeEventType(.Value, withBlock: { snapshot in
                        
                        if let data = snapshot.value! as? [String:AnyObject]{
                            
                            let battingBowlingScore = NSMutableAttributedString()
                            var matchVenueAndDate = ""
                            var opponentName = ""
                            var groundVenue = ""
                            var srEconomy = ""
                            let mData = MatchSummaryData()
                            
                            //code for Double Innings
                            var matchFormat = ""
                            var batting1 = false
                            var batting2 = false
                            
                            if data["MatchFormat"] as? String != "" && data["MatchFormat"] != nil {
                                matchFormat = data["MatchFormat"] as! String
                            }
                            
                            if matchFormat == "Double Innings" {
                                //data for first innings
                                if let runsTaken = data["RunsTaken"]{
                                    mData.BattingSectionHidden = (runsTaken as! String == "-")
                                    if mData.BattingSectionHidden == false {
                                        batting1 = true
                                        if let dismissal = data["Dismissal"] as? String where dismissal == "Not out"{
                                            battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: self.sizeThree).bold("*", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                        else{
                                            battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                    }
                                }
                                //data for second innings
                                if let runsTaken2 = data["RunsTaken2"]{
                                    mData.BattingSectionHidden = (runsTaken2 as! String == "-")
                                    if mData.BattingSectionHidden == false {
                                        if batting1 == true {
                                            battingBowlingScore.bold(", ", fontName: appFont_black, fontSize: self.sizeTwo)
                                        }
                                        else {
                                            battingBowlingScore.bold("DNB, ", fontName: appFont_black, fontSize: self.sizeTwo)
                                        }
                                        batting2 = true
                                        if let dismissal2 = data["Dismissal2"] as? String where dismissal2 == "Not out"{
                                            battingBowlingScore.bold(runsTaken2 as! String, fontName: appFont_black, fontSize: self.sizeThree).bold("*", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                        else{
                                            battingBowlingScore.bold(runsTaken2 as! String, fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                    }
                                }
                                
                                if batting1 == true || batting2 == true {
                                    mData.BattingSectionHidden = false
                                    battingBowlingScore.bold("\nRUNS", fontName: appFont_black, fontSize: self.sizeOne)
                                }
                            }
                            else {
                                if let runsTaken = data["RunsTaken"]{
                                    mData.BattingSectionHidden = (runsTaken as! String == "-")
                                    if mData.BattingSectionHidden == false {
                                        batting1 = true
                                        if let dismissal = data["Dismissal"] as? String where dismissal == "Not out"{
                                            battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: self.sizeFive).bold("*", fontName: appFont_black, fontSize: self.sizeFive).bold("\nRUNS", fontName: appFont_black, fontSize: self.sizeOne)
                                        }
                                        else{
                                            battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: self.sizeFive).bold("\nRUNS", fontName: appFont_black, fontSize: self.sizeOne)
                                        }
                                    }
                                }
                            }
                            
                            if battingBowlingScore.length == 0 {
                                battingBowlingScore.bold("DNB", fontName: appFont_black, fontSize: self.sizeFive)
                            }
                            
                            if let date = data["MatchDate"]{
                                let DateFormatter = NSDateFormatter()
                                DateFormatter.dateFormat = "dd-MM-yyyy"
                                DateFormatter.locale =  NSLocale(localeIdentifier: "en_US_POSIX")
                                let dateFromString = DateFormatter.dateFromString(date as! String)
                                mData.matchDate = dateFromString
                                matchVenueAndDate.appendContentsOf(date as? String ?? "NA")
                            }
                            
                            if let group = data["AgeGroup"]{
                                matchVenueAndDate.appendContentsOf(" | \(group)")
                            }
                            
                            var groundData = ""
                            
                            let ground = data["Ground"] as? String
                            if ground != "-" {
                                groundData = ground! + " "
                            }
                            
                            let venue = data["Venue"] as? String
                            if venue != "-" {
                                groundData = groundData + venue!
                            }
                            
                            if ground == "-" && venue == "-" {
                                groundData = (data["Level"] as? String)! + " Match"
                            }
                            
                            groundVenue = groundData
                            
                            if (batting1 == true || batting2 == true) && mData.BattingSectionHidden == false {
                                //if let ballsFaced = data["BallsFaced"] as? String where ballsFaced != "-", let runsScored = data["RunsTaken"] as? String where runsScored != "-" && mData.BattingSectionHidden == false {
                                
                                var totalStrikeRate = Float("0.00")
                                var strikerate1 = Float("0.00")
                                var strikerate2 = Float("0.00")
                                
                                if batting1 == true {
                                    let ballsFaced1 = data["BallsFaced"] as? String
                                    let runsScored1 = data["RunsTaken"] as? String
                                    
                                    if ballsFaced1 == "0" {
                                        strikerate1 = Float("0.00")
                                    }
                                    else {
                                        let strikeRate1 = String(format: "%.1f",(Float(runsScored1!))!*100/Float(ballsFaced1!)!)
                                        strikerate1 = Float(strikeRate1)
                                    }
                                }
                                if batting2 == true {
                                    let ballsFaced2 = data["BallsFaced2"] as? String
                                    let runsScored2 = data["RunsTaken2"] as? String
                                    
                                    if ballsFaced2 == "0" {
                                        strikerate2 = Float("0.00")
                                    }
                                    else {
                                        let strikeRate2 = String(format: "%.1f",(Float(runsScored2!))!*100/Float(ballsFaced2!)!)
                                        strikerate2 = Float(strikeRate2)
                                    }
                                }
                                
                                if batting1 == true && batting2 == true {
                                    totalStrikeRate = (strikerate1! + strikerate2!)/2
                                }
                                else {
                                    totalStrikeRate = strikerate1! + strikerate2!
                                }
                                srEconomy = ("Strike Rate: \(String(format: "%.1f",totalStrikeRate!))")
                                
                                let formattedStringName = NSMutableAttributedString()
                                let formattedOpponentName = formattedStringName.bold((data["Opponent"] as? String)!, fontName: appFont_black, fontSize: self.sizeThree)
                                
                                let formattedStringDate = NSMutableAttributedString()
                                let formattedDate = formattedStringDate.bold(matchVenueAndDate, fontName: appFont_black, fontSize: self.sizeTwo)
                                
                                let formattedStringGround = NSMutableAttributedString()
                                let formattedGround = formattedStringGround.bold(groundVenue, fontName: appFont_black, fontSize: self.sizeTwo)
                                
                                let formattedStringSR = NSMutableAttributedString()
                                let formattedSR = formattedStringSR.bold(srEconomy, fontName: appFont_black, fontSize: self.sizeTwo)
                                
                                self.SecondRecentMatchScore.attributedText = battingBowlingScore
                                self.SecondRecentMatchOpponent.attributedText = formattedOpponentName
                                self.SecondRecentMatchDateAndLocation.attributedText = formattedDate
                                self.SecondRecentMatchBattingGroundVenue.attributedText = formattedGround
                                self.SecondRecentMatchBattingStrikeRate.attributedText = formattedSR
                            }
                        }
                    })
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        self.SecondRecentMatchView.hidden = false
                        // self.TeamsTable.reloadData()
                        self.updateDashBoardMatches()
                    })
                }

                
                //Display Top Bowling First Match card
                /*if !self.FirstRecentMatchBowlingView.hidden {
                    self.FirstRecentMatchBowlingScore.text = String(DashboardDetails.TopBowling1stMatchScore)
                    self.FirstRecentMatchBowlingOpponent.text = String(DashboardDetails.TopBowling1stMatchOpp)
                    let formattedString_Bowling = NSMutableAttributedString()
                    formattedString_Bowling.bold("\(DashboardDetails.TopBowling1stMatchDate), at \(DashboardDetails.TopBowling1stMatchGround)",fontName: appFont_bold, fontSize: 12)
                    self.FirstRecentMatchBowlingDateAndLocation.attributedText = formattedString_Bowling
                }*/
                
                //sajith - new code for Top Bowling 1st Match
                if String(DashboardDetails.TopBowling1stMatchID) != "-" {
                    let matchId:String = (String(DashboardDetails.TopBowling1stMatchID) ?? nil)!
                    let userId:String = self.friendId ?? currentUser!.uid
                    fireBaseRef.child("Users").child(userId).child("Matches").child(matchId).observeEventType(.Value, withBlock: { snapshot in
                        
                        if let data = snapshot.value! as? [String:AnyObject]{
                            
                            let battingBowlingScore = NSMutableAttributedString()
                            var matchVenueAndDate = ""
                            var opponentName = ""
                            var groundVenue = ""
                            var srEconomy = ""
                            let mData = MatchSummaryData()
                            
                            //code for Double Innings
                            var matchFormat = ""
                            var bowling1 = false
                            var bowling2 = false
                            
                            if data["MatchFormat"] as? String != "" && data["MatchFormat"] != nil {
                                matchFormat = data["MatchFormat"] as! String
                            }
                            
                            if matchFormat == "Double Innings" {
                                //data for first innings
                                if let wicketsTaken = data["WicketsTaken"], let runsGiven = data["RunsGiven"] {
                                    mData.BowlingSectionHidden = (runsGiven as! String == "-")
                                    if mData.BowlingSectionHidden == false {
                                        bowling1 = true
                                        //if battingBowlingScore.length > 0 {
                                          //  battingBowlingScore.bold("\n\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: self.sizeThree)
                                        //}
                                        //else{
                                            battingBowlingScore.bold("\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: self.sizeThree)
                                        //}
                                    }
                                }
                                //data for second innings
                                if let wicketsTaken2 = data["WicketsTaken2"], let runsGiven2 = data["RunsGiven2"] {
                                    mData.BowlingSectionHidden = (runsGiven2 as! String == "-")
                                    if mData.BowlingSectionHidden == false {
                                        if bowling1 == true {
                                            battingBowlingScore.bold(", ", fontName: appFont_black, fontSize: self.sizeTwo)
                                        }
                                        else {
                                            battingBowlingScore.bold("\nDNB, ", fontName: appFont_black, fontSize: self.sizeTwo)
                                        }
                                        bowling2 = true
                                        if battingBowlingScore.length > 0 {
                                            battingBowlingScore.bold("\n\(wicketsTaken2)-\(runsGiven2)", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                        else{
                                            battingBowlingScore.bold("\(wicketsTaken2)-\(runsGiven2)", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                    }
                                }
                                if bowling1 == true || bowling1 == true {
                                    mData.BowlingSectionHidden = false
                                    battingBowlingScore.bold("\nWICKETS", fontName: appFont_black, fontSize: self.sizeOne)
                                }
                            }
                            else {
                                if let wicketsTaken = data["WicketsTaken"], let runsGiven = data["RunsGiven"] {
                                    mData.BowlingSectionHidden = (runsGiven as! String == "-")
                                    if mData.BowlingSectionHidden == false {
                                        bowling1 = true
                                        battingBowlingScore.bold("\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: self.sizeFive).bold("\nWICKETS", fontName: appFont_black, fontSize: self.sizeOne)
                                    }
                                }
                            }
                            
                            if battingBowlingScore.length == 0 {
                                battingBowlingScore.bold("DNB", fontName: appFont_black, fontSize: self.sizeFive)
                            }
                            
                            
                            if let date = data["MatchDate"]{
                                let DateFormatter = NSDateFormatter()
                                DateFormatter.dateFormat = "dd-MM-yyyy"
                                DateFormatter.locale =  NSLocale(localeIdentifier: "en_US_POSIX")
                                let dateFromString = DateFormatter.dateFromString(date as! String)
                                mData.matchDate = dateFromString
                                matchVenueAndDate.appendContentsOf(date as? String ?? "NA")
                            }
                            
                            if let group = data["AgeGroup"]{
                                matchVenueAndDate.appendContentsOf(" | \(group)")
                            }
                            
                            var groundData = ""
                            
                            let ground = data["Ground"] as? String
                            if ground != "-" {
                                groundData = ground! + " "
                            }
                            
                            let venue = data["Venue"] as? String
                            if venue != "-" {
                                groundData = groundData + venue!
                            }
                            
                            if ground == "-" && venue == "-" {
                                groundData = (data["Level"] as? String)! + " Match"
                            }
                            
                            groundVenue = groundData
                            
                            if (bowling1 == true || bowling2 == true) && mData.BowlingSectionHidden == false {
                                //if let oversBowled = data["OversBowled"] as? String where oversBowled != "-", let runsGiven = data["RunsGiven"] as? String where runsGiven != "-" && mData.BowlingSectionHidden == false {
                                
                                var totalEconomy = Float("0.00")
                                var economy1 = Float("0.00")
                                var economy2 = Float("0.00")
                                
                                if bowling1 == true {
                                    let runsGiven1 = data["RunsGiven"] as? String
                                    let oversBowled1 = data["OversBowled"] as? String
                                    let econ1 = String(format: "%.2f",(Float(runsGiven1!)!)/Float(oversBowled1!)!)
                                    economy1 = Float(econ1)
                                }
                                if bowling2 == true {
                                    let runsGiven2 = data["RunsGiven2"] as? String
                                    let oversBowled2 = data["OversBowled2"] as? String
                                    let econ2 = String(format: "%.2f",(Float(runsGiven2!)!)/Float(oversBowled2!)!)
                                    economy2 = Float(econ2)
                                }
                                
                                if bowling1 == true && bowling2 == true {
                                    totalEconomy = (economy1! + economy2!)/2
                                }
                                else {
                                    totalEconomy = economy1! + economy2!
                                }
                                
                                let economy = String(format: "%.2f",totalEconomy!)
                                mData.economy = Float(economy)
                                srEconomy = ("Economy: \(economy)")
                            }
                            
                            let formattedStringName = NSMutableAttributedString()
                            let formattedOpponentName = formattedStringName.bold((data["Opponent"] as? String)!, fontName: appFont_black, fontSize: self.sizeThree)
                            
                            let formattedStringDate = NSMutableAttributedString()
                            let formattedDate = formattedStringDate.bold(matchVenueAndDate, fontName: appFont_black, fontSize: self.sizeTwo)
                            
                            let formattedStringGround = NSMutableAttributedString()
                            let formattedGround = formattedStringGround.bold(groundVenue, fontName: appFont_black, fontSize: self.sizeTwo)
                            
                            let formattedStringSR = NSMutableAttributedString()
                            let formattedSR = formattedStringSR.bold(srEconomy, fontName: appFont_black, fontSize: self.sizeTwo)
                            
                            self.FirstRecentMatchBowlingScore.attributedText = battingBowlingScore
                            self.FirstRecentMatchBowlingOpponent.attributedText = formattedOpponentName
                            self.FirstRecentMatchBowlingDateAndLocation.attributedText = formattedDate
                            self.FirstRecentMatchBowlingGroundVenue.attributedText = formattedGround
                            self.FirstRecentMatchBowlingEconomy.attributedText = formattedSR
                        }
                    })
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        self.FirstRecentMatchBowlingView.hidden = false
                        //  self.TeamsTable.reloadData()
                        self.updateDashBoardMatches()
                    })
                }

                
                //Display Top Bowling Second Match card
                /*if !self.SecondRecentMatchBowlingView.hidden {
                    self.SecondRecentMatchBowlingScore.text = String(DashboardDetails.TopBowling2ndMatchScore)
                    self.SecondRecentMatchBowlingOpponent.text = String(DashboardDetails.TopBowling2ndMatchOpp)
                    let formattedString_Bowling_2 = NSMutableAttributedString()
                    formattedString_Bowling_2.bold("\(DashboardDetails.TopBowling2ndMatchDate), at \(DashboardDetails.TopBowling2ndMatchGround)",fontName: appFont_bold, fontSize: 12)
                    self.SecondRecentMatchBowlingDateAndLocation.attributedText = formattedString_Bowling_2
                }*/
                
                //sajith - new code for Top Bowling 2nd Match
                if String(DashboardDetails.TopBowling2ndMatchID) != "-" {
                    let matchId:String = (String(DashboardDetails.TopBowling2ndMatchID) ?? nil)!
                    let userId:String = self.friendId ?? currentUser!.uid
                    fireBaseRef.child("Users").child(userId).child("Matches").child(matchId).observeEventType(.Value, withBlock: { snapshot in
                        
                        if let data = snapshot.value! as? [String:AnyObject]{
                            
                            let battingBowlingScore = NSMutableAttributedString()
                            var matchVenueAndDate = ""
                            var opponentName = ""
                            var groundVenue = ""
                            var srEconomy = ""
                            let mData = MatchSummaryData()
                            
                            //code for Double Innings
                            var matchFormat = ""
                            var bowling1 = false
                            var bowling2 = false
                            
                            if data["MatchFormat"] as? String != "" && data["MatchFormat"] != nil {
                                matchFormat = data["MatchFormat"] as! String
                            }

                            if matchFormat == "Double Innings" {
                                //data for first innings
                                if let wicketsTaken = data["WicketsTaken"], let runsGiven = data["RunsGiven"] {
                                    mData.BowlingSectionHidden = (runsGiven as! String == "-")
                                    if mData.BowlingSectionHidden == false {
                                        bowling1 = true
                                        //if battingBowlingScore.length > 0 {
                                          //  battingBowlingScore.bold("\n\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: self.sizeThree)
                                        //}
                                        //else{
                                            battingBowlingScore.bold("\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: self.sizeThree)
                                        //}
                                    }
                                }
                                //data for second innings
                                if let wicketsTaken2 = data["WicketsTaken2"], let runsGiven2 = data["RunsGiven2"] {
                                    mData.BowlingSectionHidden = (runsGiven2 as! String == "-")
                                    if mData.BowlingSectionHidden == false {
                                        if bowling1 == true {
                                            battingBowlingScore.bold(", ", fontName: appFont_black, fontSize: self.sizeTwo)
                                        }
                                        else {
                                            battingBowlingScore.bold("\nDNB, ", fontName: appFont_black, fontSize: self.sizeTwo)
                                        }
                                        bowling2 = true
                                        if battingBowlingScore.length > 0 {
                                            battingBowlingScore.bold("\n\(wicketsTaken2)-\(runsGiven2)", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                        else{
                                            battingBowlingScore.bold("\(wicketsTaken2)-\(runsGiven2)", fontName: appFont_black, fontSize: self.sizeThree)
                                        }
                                    }
                                }
                            
                                battingBowlingScore.bold("\nWICKETS", fontName: appFont_black, fontSize: self.sizeOne)
                            }
                            else {
                                if let wicketsTaken = data["WicketsTaken"], let runsGiven = data["RunsGiven"] {
                                    mData.BowlingSectionHidden = (runsGiven as! String == "-")
                                    if mData.BowlingSectionHidden == false {
                                        bowling1 = true
                                        battingBowlingScore.bold("\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: self.sizeFive).bold("\nWICKETS", fontName: appFont_black, fontSize: self.sizeOne)
                                    }
                                }
                            }
                            
                            if battingBowlingScore.length == 0 {
                                battingBowlingScore.bold("DNB", fontName: appFont_black, fontSize: self.sizeFive)
                            }
                            
                            
                            if let date = data["MatchDate"]{
                                let DateFormatter = NSDateFormatter()
                                DateFormatter.dateFormat = "dd-MM-yyyy"
                                DateFormatter.locale =  NSLocale(localeIdentifier: "en_US_POSIX")
                                let dateFromString = DateFormatter.dateFromString(date as! String)
                                mData.matchDate = dateFromString
                                matchVenueAndDate.appendContentsOf(date as? String ?? "NA")
                            }
                            
                            if let group = data["AgeGroup"]{
                                matchVenueAndDate.appendContentsOf(" | \(group)")
                            }
                            
                            var groundData = ""
                            
                            let ground = data["Ground"] as? String
                            if ground != "-" {
                                groundData = ground! + " "
                            }
                            
                            let venue = data["Venue"] as? String
                            if venue != "-" {
                                groundData = groundData + venue!
                            }
                            
                            if ground == "-" && venue == "-" {
                                groundData = (data["Level"] as? String)! + " Match"
                            }
                            
                            groundVenue = groundData
                            
                            if (bowling1 == true || bowling2 == true) && mData.BowlingSectionHidden == false {
                                //if let oversBowled = data["OversBowled"] as? String where oversBowled != "-", let runsGiven = data["RunsGiven"] as? String where runsGiven != "-" && mData.BowlingSectionHidden == false {
                                
                                var totalEconomy = Float("0.00")
                                var economy1 = Float("0.00")
                                var economy2 = Float("0.00")
                                
                                if bowling1 == true {
                                    let runsGiven1 = data["RunsGiven"] as? String
                                    let oversBowled1 = data["OversBowled"] as? String
                                    let econ1 = String(format: "%.2f",(Float(runsGiven1!)!)/Float(oversBowled1!)!)
                                    economy1 = Float(econ1)
                                }
                                if bowling2 == true {
                                    let runsGiven2 = data["RunsGiven2"] as? String
                                    let oversBowled2 = data["OversBowled2"] as? String
                                    let econ2 = String(format: "%.2f",(Float(runsGiven2!)!)/Float(oversBowled2!)!)
                                    economy2 = Float(econ2)
                                }
                                
                                if bowling1 == true && bowling2 == true {
                                    totalEconomy = (economy1! + economy2!)/2
                                }
                                else {
                                    totalEconomy = economy1! + economy2!
                                }
                                
                                let economy = String(format: "%.2f",totalEconomy!)
                                mData.economy = Float(economy)
                                srEconomy = ("Economy: \(economy)")
                            }
                            
                            let formattedStringName = NSMutableAttributedString()
                            let formattedOpponentName = formattedStringName.bold((data["Opponent"] as? String)!, fontName: appFont_black, fontSize: self.sizeThree)
                            
                            let formattedStringDate = NSMutableAttributedString()
                            let formattedDate = formattedStringDate.bold(matchVenueAndDate, fontName: appFont_black, fontSize: self.sizeTwo)
                            
                            let formattedStringGround = NSMutableAttributedString()
                            let formattedGround = formattedStringGround.bold(groundVenue, fontName: appFont_black, fontSize: self.sizeTwo)
                            
                            let formattedStringSR = NSMutableAttributedString()
                            let formattedSR = formattedStringSR.bold(srEconomy, fontName: appFont_black, fontSize: self.sizeTwo)
                            
                            self.SecondRecentMatchBowlingScore.attributedText = battingBowlingScore
                            self.SecondRecentMatchBowlingOpponent.attributedText = formattedOpponentName
                            self.SecondRecentMatchBowlingDateAndLocation.attributedText = formattedDate
                            self.SecondRecentMatchBowlingGroundVenue.attributedText = formattedGround
                            self.SecondRecentMatchBowlingEconomy.attributedText = formattedSR
                        }
                    })
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        self.SecondRecentMatchBowlingView.hidden = false
                       // self.TeamsTable.reloadData()
                        self.updateDashBoardMatches()
                    })
                }
            },
            completion: { (val) in
                // KRProgressHUD.dismiss()
            })
        }
    }
}

    func updateDashBoardMatches() {
        
        //Data for Top Batting section
        self.FirstRecentMatchView.hidden = (DashboardDetails.TopBatting1stMatchDispScore == nil || String(DashboardDetails.TopBatting1stMatchDispScore) == "-")
        self.SecondRecentMatchView.hidden = (DashboardDetails.TopBatting2ndMatchDispScore == nil || String(DashboardDetails.TopBatting2ndMatchDispScore) == "-")
        
        //Data for Top Bowling section
        self.FirstRecentMatchBowlingView.hidden = (DashboardDetails.TopBowling1stMatchScore == nil || DashboardDetails.TopBowling1stMatchScore as! String == "0-9999")
        self.SecondRecentMatchBowlingView.hidden = (DashboardDetails.TopBowling2ndMatchScore == nil || DashboardDetails.TopBowling2ndMatchScore as! String == "0-9999")
        
        self.topBattingNotAvailable.hidden = !(self.FirstRecentMatchView.hidden && self.SecondRecentMatchView.hidden)
        self.topBowlingNotAvailable.hidden = !(self.FirstRecentMatchBowlingView.hidden && self.SecondRecentMatchBowlingView.hidden)
        
        self.recentMatchesNotAvailable.hidden = !(self.FirstRecentMatchSummary.hidden && self.SecondRecentMatchSummary.hidden)
        
        //*****Reduce view height if not available******
        
        //Summary view
        if !self.recentMatchesNotAvailable.hidden {
            
            self.summaryViewHeightConstraint1.constant = 0
            self.summaryViewHeightConstraint2.constant = 0
            self.summaryStackViewHeightConstraint.constant = 0
        }
        else {
            if String(DashboardDetails.Recent1stMatchID) != "-" {
                self.summaryViewHeightConstraint1.constant = 70
                self.summaryViewHeightConstraint2.constant = 0
                self.summaryStackViewHeightConstraint.constant = 110
            }
            if String(DashboardDetails.Recent2ndMatchID) != "-" {
                self.summaryViewHeightConstraint1.constant = 70
                self.summaryViewHeightConstraint2.constant = 70
                self.summaryStackViewHeightConstraint.constant = 210
            }
        }
        
        //Top batting view
        if !self.topBattingNotAvailable.hidden {
            self.topBattingStackViewHeightConstraint.constant = 0
        }
        else {
            if String(DashboardDetails.TopBatting1stMatchID) != "-" {
                self.topBattingStackViewHeightConstraint.constant = 85
            }
            if String(DashboardDetails.TopBatting2ndMatchID) != "-" {
                self.topBattingStackViewHeightConstraint.constant = 170
            }
        }
        
        //Top bowling view
        if !self.topBowlingNotAvailable.hidden {
            self.topBallingStackViewHeightConstraint.constant = 0
        }
        else {
            if String(DashboardDetails.TopBowling1stMatchID) != "-" {
                self.topBallingStackViewHeightConstraint.constant = 85
            }
            if String(DashboardDetails.TopBowling2ndMatchID) != "-" {
                self.topBallingStackViewHeightConstraint.constant = 170
            }
        }
        
        //Check for team count.If team count = 0, make view height to 0
        
        if ((self.userProfileData.PlayerCurrentTeams.count) + (self.userProfileData.PlayerPastTeams.count)) == 0 {
            self.teamsViewHeightConstraint.constant = 0
        }
        else {
            self.teamsViewHeightConstraint.constant = 130
        }
        
        //self.scrollViewBottomElementConstraint.constant = 10
        //self.view.layoutIfNeeded()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        //getMatchData()
        //setDashboardData()
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y > 300) {
            if TopMenu.backgroundColor != darkerThemeColor {
                TopMenu.backgroundColor = darkerThemeColor
            }
        }
        else {
            if TopMenu.backgroundColor != clearColor {
                TopMenu.backgroundColor = clearColor
            }
        }
    }

    // MARK: - Collection view delegates
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var valueToReturn = 0
        
        switch userProfileData.UserProfile {
        case userProfileType.Player.rawValue:
            
            valueToReturn = (userProfileData.PlayerCurrentTeams.count) + (userProfileData.PlayerPastTeams.count)
            break
        case userProfileType.Coach.rawValue:
            valueToReturn = userProfileData.CoachCurrentTeams.count
            break
        case userProfileType.Fan.rawValue:
            valueToReturn = userProfileData.SupportingTeams.count
            break
        default:
            valueToReturn = 0
            break
        }
        return valueToReturn // //themeColors.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
//        let allCells = collectionView.visibleCells() as! [ThemeColorsCollectionViewCell]
//        
//        allCells.forEach({ cell in
//            cell.cellIsSelected = false
//        })
//        
//        let currentCell = collectionView.cellForItemAtIndexPath(indexPath) as! ThemeColorsCollectionViewCell
//        
//        currentCell.cellIsSelected = true
//        _currentTheme = currentCell.ThemeTitle.text!
//        self.view.backgroundColor = currentCell.contentView.backgroundColor
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("TeamCollectionViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
        
//            let intIndex = indexPath.row // where intIndex < myDictionary.count
//            let index = themeColors.startIndex.advancedBy(intIndex) // index 1
            
            //aCell.ThemeTitle.text = themeColors.keys[index]
            
            
//            if let colorObject = themeColors[themeColors.keys[index]] {
//                
              //  aCell.TeamImage.image = UIImage()
            
            var teamNameToReturn = ""
            
            
            switch userProfileData.UserProfile {
            case userProfileType.Player.rawValue:
                if indexPath.row < (userProfileData.PlayerCurrentTeams.count) {
                    teamNameToReturn = userProfileData.PlayerCurrentTeams[indexPath.row]
                   
                      aCell.baseView.backgroundColor = cricTracTheme.currentTheme.bottomColor
                     aCell.baseView.alpha = 1
                    aCell.TeamAbbr.textColor = UIColor.whiteColor()
                   
                }
                else if (indexPath.row - (userProfileData.PlayerCurrentTeams.count)) < (userProfileData.PlayerPastTeams.count) {
                 
                    teamNameToReturn = userProfileData.PlayerPastTeams[(indexPath.row - userProfileData.PlayerCurrentTeams.count)]
                     aCell.baseView.backgroundColor = UIColor.grayColor()
                    aCell.baseView.alpha = 1
                    aCell.TeamAbbr.textColor = UIColor.blackColor()
                    
                }
                
                break
            case userProfileType.Coach.rawValue:
                teamNameToReturn = userProfileData.CoachCurrentTeams[indexPath.row]
                break
            case userProfileType.Fan.rawValue:
                teamNameToReturn = userProfileData.SupportingTeams[indexPath.row]
                break
            default:
                teamNameToReturn = ""
                break
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
//            }
//            else
//            {
//                return ThemeColorsCollectionViewCell()
//            }
        }
        return ThemeColorsCollectionViewCell()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   
 
    func addTapGestureToUserName() {
        let gesture1 = UITapGestureRecognizer(target: self,action: #selector(UserDashboardViewController.didTapRecent1stMatchID))
        FirstRecentMatchSummary.userInteractionEnabled = true
        FirstRecentMatchSummary.addGestureRecognizer(gesture1)
        
         let gesture2 = UITapGestureRecognizer(target: self,action: #selector(UserDashboardViewController.didTapRecent2ndMatchID))
        SecondRecentMatchSummary.userInteractionEnabled = true
        SecondRecentMatchSummary.addGestureRecognizer(gesture2)
        
        let gesture3 = UITapGestureRecognizer(target: self,action: #selector(UserDashboardViewController.didTapTopBatting1stMatchID))
        FirstRecentMatchView.userInteractionEnabled = true
        FirstRecentMatchView.addGestureRecognizer(gesture3)
        
        let gesture4 = UITapGestureRecognizer(target: self,action: #selector(UserDashboardViewController.didTapTopBatting2ndMatchID))
        SecondRecentMatchView.userInteractionEnabled = true
        SecondRecentMatchView.addGestureRecognizer(gesture4)
        
        let gesture5 = UITapGestureRecognizer(target: self,action: #selector(UserDashboardViewController.didTapTopBowling1stMatchID))
        FirstRecentMatchBowlingView.userInteractionEnabled = true
        FirstRecentMatchBowlingView.addGestureRecognizer(gesture5)
        
        let gesture6 = UITapGestureRecognizer(target: self,action: #selector(UserDashboardViewController.didTapTopBowling2ndMatchID))
        SecondRecentMatchBowlingView.userInteractionEnabled = true
        SecondRecentMatchBowlingView.addGestureRecognizer(gesture6)
    
    }
  
    func didTapRecent1stMatchID() {
        if String(DashboardDetails.Recent1stMatchID) != "-" {

            let matchId:String = (String(DashboardDetails.Recent1stMatchID) ?? nil)!
            let userId:String = self.friendId ?? currentUser!.uid
            fireBaseRef.child("Users").child(userId).child("Matches").child(matchId).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
                if let data = snapshot.value! as? [String:AnyObject]{
                    
                let summaryDetailsVC = viewControllerFrom("Main", vcid: "SummaryMatchDetailsViewController") as! SummaryMatchDetailsViewController
                    summaryDetailsVC.matchDetailsData = data
                    summaryDetailsVC.friendDOB = self.userProfileData.DateOfBirth
                    summaryDetailsVC.isFriendDashboard = true
                    
                    if let _ = self.friendProfile {
                        summaryDetailsVC.friendProfile = true

                        self.presentViewController(summaryDetailsVC, animated: true, completion: nil)
                    }
                    else {
                        self.navigationController?.pushViewController(summaryDetailsVC, animated: true)
                    }
                }
            })
        }
    }
    
    func didTapRecent2ndMatchID() {
        if String(DashboardDetails.Recent2ndMatchID) != "-" {
            let matchId:String = (String(DashboardDetails.Recent2ndMatchID) ?? nil)!
            let userId:String = self.friendId ?? currentUser!.uid
            fireBaseRef.child("Users").child(userId).child("Matches").child(matchId).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if let data = snapshot.value! as? [String:AnyObject]{
                let summaryDetailsVC = viewControllerFrom("Main", vcid: "SummaryMatchDetailsViewController") as! SummaryMatchDetailsViewController
                    summaryDetailsVC.matchDetailsData = data
                    summaryDetailsVC.friendDOB = self.userProfileData.DateOfBirth
                    summaryDetailsVC.isFriendDashboard = true
                    if let _ = self.friendProfile {
                        summaryDetailsVC.friendProfile = true
                        self.presentViewController(summaryDetailsVC, animated: true, completion: nil)
                    }
                    else {
                        self.navigationController?.pushViewController(summaryDetailsVC, animated: true)
                        
//                        let window = getCurrentWindow()
//                        UIView.transitionWithView(window, duration: 0.5, options: .TransitionFlipFromLeft, animations: {
//                            //window.rootViewController = summaryDetailsVC
//                            self.navigationController?.pushViewController(summaryDetailsVC, animated: true)
//                            }, completion: nil)
                    }
                }
            })
        }
    }
    
    func didTapTopBatting1stMatchID() {
        if String(DashboardDetails.TopBatting1stMatchID) != "-" {
            let matchId:String = (String(DashboardDetails.TopBatting1stMatchID) ?? nil)!
            let userId:String = self.friendId ?? currentUser!.uid
            fireBaseRef.child("Users").child(userId).child("Matches").child(matchId).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if let data = snapshot.value! as? [String:AnyObject]{
                    let summaryDetailsVC = viewControllerFrom("Main", vcid: "SummaryMatchDetailsViewController") as! SummaryMatchDetailsViewController
                    summaryDetailsVC.matchDetailsData = data
                    summaryDetailsVC.friendDOB = self.userProfileData.DateOfBirth
                    summaryDetailsVC.isFriendDashboard = true
                    if let _ = self.friendProfile {
                        summaryDetailsVC.friendProfile = true
                        self.presentViewController(summaryDetailsVC, animated: true, completion: nil)
                    }
                    else {
                        self.navigationController?.pushViewController(summaryDetailsVC, animated: true)
                    }
                }
            })
        }
    }
    
    func didTapTopBatting2ndMatchID() {
        if String(DashboardDetails.TopBatting2ndMatchID) != "-" {
            let matchId:String = (String(DashboardDetails.TopBatting2ndMatchID) ?? nil)!
            let userId:String = self.friendId ?? currentUser!.uid
            fireBaseRef.child("Users").child(userId).child("Matches").child(matchId).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if let data = snapshot.value! as? [String:AnyObject]{
                    let summaryDetailsVC = viewControllerFrom("Main", vcid: "SummaryMatchDetailsViewController") as! SummaryMatchDetailsViewController
                    summaryDetailsVC.matchDetailsData = data
                    summaryDetailsVC.friendDOB = self.userProfileData.DateOfBirth
                    summaryDetailsVC.isFriendDashboard = true
                    if let _ = self.friendProfile {
                        summaryDetailsVC.friendProfile = true
                        self.presentViewController(summaryDetailsVC, animated: true, completion: nil)
                    }
                    else {
                        self.navigationController?.pushViewController(summaryDetailsVC, animated: true)
                  }
                }
            })
        }
    }

  func didTapTopBowling1stMatchID() {
        if String(DashboardDetails.TopBowling1stMatchID) != "-" {
            let matchId:String = (String(DashboardDetails.TopBowling1stMatchID) ?? nil)!
            let userId:String = self.friendId ?? currentUser!.uid
            fireBaseRef.child("Users").child(userId).child("Matches").child(matchId).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if let data = snapshot.value! as? [String:AnyObject]{
                    let summaryDetailsVC = viewControllerFrom("Main", vcid: "SummaryMatchDetailsViewController") as! SummaryMatchDetailsViewController
                    summaryDetailsVC.matchDetailsData = data
                    summaryDetailsVC.friendDOB = self.userProfileData.DateOfBirth
                    summaryDetailsVC.isFriendDashboard = true
                    if let _ = self.friendProfile {
                        summaryDetailsVC.friendProfile = true
                        self.presentViewController(summaryDetailsVC, animated: true, completion: nil)
                    }
                    else {
                        self.navigationController?.pushViewController(summaryDetailsVC, animated: true)
                    }
                }
            })
        }
    }
    
    func didTapTopBowling2ndMatchID() {
        if String(DashboardDetails.TopBowling2ndMatchID) != "-" {
            let matchId:String = (String(DashboardDetails.TopBowling2ndMatchID) ?? nil)!
            let userId:String = self.friendId ?? currentUser!.uid
            fireBaseRef.child("Users").child(userId).child("Matches").child(matchId).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if let data = snapshot.value! as? [String:AnyObject]{
                let summaryDetailsVC = viewControllerFrom("Main", vcid: "SummaryMatchDetailsViewController") as! SummaryMatchDetailsViewController
                    summaryDetailsVC.matchDetailsData = data
                    summaryDetailsVC.friendDOB = self.userProfileData.DateOfBirth
                    summaryDetailsVC.isFriendDashboard = true
                    if let _ = self.friendProfile {
                        summaryDetailsVC.friendProfile = true
                        self.presentViewController(summaryDetailsVC, animated: true, completion: nil)
                    }
                    else {
                        self.navigationController?.pushViewController(summaryDetailsVC, animated: true)
                    }
                }
            })
        }
    }
    
}



