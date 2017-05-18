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
    
    @IBOutlet weak var imgCoverPhoto: UIImageView!
    var battingDetails: [String:String]!
    var bowlingDetails: [String:String]!
    var recentMatches: [String:String]!
    var recentMatchesBowling: [String:String]!
    private var _currentTheme:String = CurrentTheme
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    var coverOrProfile = ""
    var friendId:String? = nil
    
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
//        let viewPhotoAction = UIAlertAction(title: "View Photo", style: .Default) { (action) in
//            
//            self.viewImage(option)
//            
//        }
//        
//        alertController.addAction(viewPhotoAction)
        
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
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
            
            
        
            //assign button to navigationbar
            
            navigationItem.leftBarButtonItem = leftbarButton
        if let navigation = navigationController{
            
            navigation.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
            title = "SIGHTSCREEN"
        }
    
            //let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            //navigationController!.navigationBar.titleTextAttributes = titleDict
    
    }
    
    
    @IBAction func didMenuButtonTapp(sender: UIButton){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    func stopAnimation() {
        if self.activityInd.isAnimating() {
            self.activityInd.stopAnimating()
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        if coverOrProfile == "Profile" {
            //dispatch_async(dispatch_get_main_queue(),{
            self.userProfileImage.image = image
            self.dismissViewControllerAnimated(true) {
                    addProfileImageData(self.resizeImage(image, newWidth: 200))
                //self.initView()
                }
            //})
            
        }else {
            self.imgCoverPhoto.image = image
            self.dismissViewControllerAnimated(true) {
                addCoverImageData(self.resizeImage(image, newWidth: 200))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToUserName()
        TeamsTable.reloadData()
        
        loadBannerAds()

    }
    
    func initView() {
        
        if let value = friendProfile{
            userProfileData = Profile(usrObj: value)
            closeButton.hidden = false
        }
        else{
           userProfileData = profileData
            closeButton.hidden = true
        }
        
        //   setBackgroundColor()
        
        //setUIBackgroundTheme(self.view)
        
        userProfileImage.layer.cornerRadius = userProfileImage.bounds.size.width/2
        MatchesView.layer.cornerRadius = 10
        
        MatchesView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: UIColor().hexFromUIColor(cricTracTheme.currentTheme.bottomColor)))
        
        MatchesView.alpha = 0.8
        
        
        self.SecondRecentMatchSummary.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: UIColor().hexFromUIColor(cricTracTheme.currentTheme.bottomColor)))
        self.SecondRecentMatchSummary.alpha = 0.8
        
        self.FirstRecentMatchSummary.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: UIColor().hexFromUIColor(cricTracTheme.currentTheme.bottomColor)))
        self.FirstRecentMatchSummary.alpha = 0.8
        
        self.FirstRecentMatchView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: UIColor().hexFromUIColor(cricTracTheme.currentTheme.bottomColor)))
        self.FirstRecentMatchView.alpha = 0.8
        
        self.SecondRecentMatchView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: UIColor().hexFromUIColor(cricTracTheme.currentTheme.bottomColor)))
        self.SecondRecentMatchView.alpha = 0.8
        
        self.FirstRecentMatchBowlingView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: UIColor().hexFromUIColor(cricTracTheme.currentTheme.bottomColor)))
        self.FirstRecentMatchBowlingView.alpha = 0.8
        
        self.SecondRecentMatchBowlingView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: UIColor().hexFromUIColor(cricTracTheme.currentTheme.bottomColor)))
        self.SecondRecentMatchBowlingView.alpha = 0.8
        
        userProfileImage.clipsToBounds = true
        
        TeamsTable.delegate = self
        TeamsTable.dataSource = self
        
        let currentCountryList = CountriesList.filter({$0.name == userProfileData.Country})
        let currentISO = currentCountryList[0].iso
        
        let df = NSDateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        self.PlayerName.text = userProfileData.fullName
        let formattedString = NSMutableAttributedString()
        let locationText = formattedString.bold("\(userProfileData.City)\n", fontName: appFont_black, fontSize: 15).bold("\(userProfileData.State), ", fontName: appFont_black, fontSize: 15).bold("\(currentISO)\n", fontName: appFont_black, fontSize: 15).bold("\(userProfileData.DateOfBirth)\n", fontName: appFont_black, fontSize: 15)
        self.PlayerLocation.attributedText = locationText
//        self.userProfileImage.image = LoggedInUserImage
//        self.imgCoverPhoto.image = LoggedInUserCoverImage
        
        let proPic = userProfileData.ProfileImageURL
        if proPic == "-"{
            let imageName = defaultProfileImage
            let image = UIImage(named: imageName)
            userProfileImage.image = image!
        }else{
            if let imageURL = NSURL(string:proPic){
                userProfileImage.kf_setImageWithURL(imageURL)
            }
        }
        
        let coverPic = userProfileData.CoverPhotoURL
        if coverPic == "-"{
            let imageName = defaultProfileImage
            let image = UIImage(named: imageName)
            imgCoverPhoto.image = image!
        }else{
            if let imageURL = NSURL(string:coverPic){
                imgCoverPhoto.kf_setImageWithURL(imageURL)
            }
        }
        
//        if userProfileData.ProfileImageURL != "-" {
//                getImageFromFirebase(userProfileData.ProfileImageURL) { (imgData) in
//                    self.currentUserProfileImage = imgData
//            }
//        }
//        else {
//            let imageName = defaultProfileImage
//            let image = UIImage(named: imageName)
//            self.currentUserProfileImage = image!
//        }
//        
//        if userProfileData.CoverPhotoURL != "-" {
//            getImageFromFirebase(userProfileData.CoverPhotoURL) { (imgData) in
//                self.currentUserCoverImage = imgData
//            }
//        }
//        else {
//            let imageName = defaultProfileImage
//            let image = UIImage(named: imageName)
//            self.currentUserCoverImage = image!
//        }
//        
//        self.userProfileImage.image = currentUserProfileImage
//        self.imgCoverPhoto.image = currentUserCoverImage
        
        //getMatchData()
                
        //setBackgroundColor()
        
        // Do any additional setup after loading the view.
        setNavigationBarProperties()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCoverPhoto))
        tapGesture.numberOfTapsRequired = 1
        imgCoverPhoto.addGestureRecognizer(tapGesture)
    }
    
    //MARK: Ads related
    
    func loadBannerAds() {
        
        bannerView.adUnitID = adUnitId
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
    }
    
    
    func tapCoverPhoto()  {
        if friendId == nil {
            alertMessage = "Change your cover photo"
            self.photoOptions("CoverPhoto")
            coverOrProfile = "Cover"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UpdateDashboardDetails()
        setBackgroundColor()
        initView()
        setDashboardData()
        TeamsTable.reloadData()
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
    
    
    // MARK: - Methods
    
    
    
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(UserDashboardViewController.dismissFullscreenImage(_:)))
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(UserDashboardViewController.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        //        self.view.addSubview(navBarView)
        self.view.addSubview(newImageView)
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    
    //commmented by sajith
    /*func getMatchData(){
        
        recentMatchesNotAvailable.hidden = true
        KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        
        getAllMatchData(friendId) { (data) in
            
            
            for (key,val) in data{
                
                //var dataDict = val as! [String:String]
                //dataDict["key"] = key
                
                if  var value = val as? [String : AnyObject]{
                    
                    value += ["key":key]
                    
                    let battingBowlingScore = NSMutableAttributedString()
                    var matchVenueAndDate = ""
                    var opponentName = ""
                    
                    let mData = MatchSummaryData()
                    if let runsTaken = value["RunsTaken"]{
                        
                        mData.BattingSectionHidden = (runsTaken as! String == "-")
                        
                        if mData.BattingSectionHidden == false {
                            
                            battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: 30).bold("\nRUNS", fontName: appFont_black, fontSize: 12)
                            
                        }
                    }
                    
                    if let wicketsTaken = value["WicketsTaken"], let runsGiven = value["RunsGiven"] {
                        
                        
                        mData.BowlingSectionHidden = (runsGiven as! String == "-")
                        
                        
                        if mData.BowlingSectionHidden == false {
                            if battingBowlingScore.length > 0 {
                                
                                battingBowlingScore.bold("\n\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: 30).bold("\nWICKETS", fontName: appFont_black, fontSize: 12)
                                
                            }
                            else{
                                battingBowlingScore.bold("\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: 53).bold("\nWICKETS", fontName: appFont_black, fontSize: 12)
                            }
                            
                            
                        }
                        
                    }
                    
                    
                    if battingBowlingScore.length == 0 {
                        battingBowlingScore.bold("DNP", fontName: appFont_black, fontSize: 30)
                    }
                    
                    
                    
                    if let date = value["MatchDate"]{
                        
                        
                        
                        let DateFormatter = NSDateFormatter()
                        DateFormatter.dateFormat = "dd-MM-yyyy"
                        DateFormatter.locale =  NSLocale(localeIdentifier: "en_US_POSIX")
                        let dateFromString = DateFormatter.dateFromString(date as! String)
                        
                        mData.matchDate = dateFromString
                        
                        
                        //matchVenueAndDate.appendContentsOf(date as? String ?? "NA")
                    }
                    if let venue = value["Ground"]{
                        matchVenueAndDate.appendContentsOf("\(venue)")
                    }
                    
                    if let opponent  = value["Opponent"]{
                        opponentName = opponent.uppercaseString
                    }
                    
                    
                    mData.battingBowlingScore = battingBowlingScore
                    mData.matchDateAndVenue = matchVenueAndDate
                    mData.opponentName = opponentName
                    
                    self.matches.append(mData)
                    
                }
            }
            
            self.matches.sortInPlace({ $0.matchDate.compare($1.matchDate) == NSComparisonResult.OrderedDescending })
            
            self.SecondRecentMatchSummary.hidden = true
            self.FirstRecentMatchSummary.hidden = true
 
            
            if self.matches.count > 0 {
                self.firstRecentMatchScoreCard.attributedText = self.matches[0].battingBowlingScore
                
                
                self.firstRecentMatchOpponentName.text = self.matches[0].opponentName
                
                self.firstRecentMatchDateAndVenue.text = self.matches[0].matchDateAndVenue
                
                self.FirstRecentMatchSummary.hidden = false
                
                if self.matches.count > 1 {
                    self.secondRecentMatchScoreCard.attributedText = self.matches[1].battingBowlingScore
                    self.secondRecentMatchOpponentName.text = self.matches[1].opponentName
                    self.secondRecentMatchDateAndVenue.text = self.matches[1].matchDateAndVenue
                    
                    self.SecondRecentMatchSummary.hidden = (self.matches[1].battingBowlingScore == nil || self.matches[1].battingBowlingScore == "0")
                    
                }
                
            }
            else
            {
                self.FirstRecentMatchSummary.hidden = true
                self.SecondRecentMatchSummary.hidden = true
                self.recentMatchesNotAvailable.hidden = false
            }
            
            KRProgressHUD.dismiss()
            
        }
    }*/
   
    
    
func setDashboardData(){
    //KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")

    //reset values
    self.FirstRecentMatchView.hidden = false
    self.SecondRecentMatchView.hidden = false
    self.FirstRecentMatchBowlingView.hidden = false
    self.SecondRecentMatchSummary.hidden = false
    self.topBattingNotAvailable.hidden = false
    self.topBowlingNotAvailable.hidden = false
    
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
                    self.highScore.text = "NA"
                }
                
                if String(DashboardDetails.TopBowling1stMatchID) != "-" {
                    self.BB.text = String(DashboardDetails.TopBowling1stMatchScore)
                }
                else {
                    self.BB.text = "NA"
                }
                
                let winPercent = Double(String(DashboardDetails.WinPercentage))
                self.winPerc.text = String(format:"%.1f",winPercent!)
                //self.winPerc.text = String(DashboardDetails.WinPercentage)
                
                //data for Batting Card
                self.totalRunsScored.text = String(DashboardDetails.TotalRuns)
                self.battingInnings.text = String(DashboardDetails.BattingInnings)
                let battingAverage = Double(String(DashboardDetails.TotalBattingAverage))
                self.battingAverage.text = String(format:"%.1f",battingAverage!)
                //self.battingAverage.text = String(DashboardDetails.TotalBattingAverage)
                let strikeRate = Double(String(DashboardDetails.TotalStrikeRate))
                self.strikeRate.text = String(format:"%.1f",strikeRate!)
                //self.strikeRate.text = String(DashboardDetails.TotalStrikeRate)
                self.hundreds.text = String(DashboardDetails.Total100s)
                self.fifties.text = String(DashboardDetails.Total50s)
                self.sixes.text = String(DashboardDetails.Total6s)
                self.fours.text = String(DashboardDetails.Total4s)
                
                //data for Bowling Card
                self.bowlingInnings.text = String(DashboardDetails.BowlingInnings)
                self.totalWickets.text = String(DashboardDetails.TotalWickets)
                let bowlingAverageDouble = Double(String(DashboardDetails.TotalBowlingAverage))
                self.bowlingAverage.text = String(format:"%.1f",bowlingAverageDouble!)
                //self.bowlingAverage.text = String(DashboardDetails.TotalBowlingAverage)
                
                let bowlingEconomyDouble = Double(String(DashboardDetails.TotalEconomy))
                self.bowlingEconomy.text = String(format:"%.1f",bowlingEconomyDouble!)
                //self.bowlingEconomy.text = String(DashboardDetails.TotalEconomy)
                self.TotalThreeWicketsPerMatch.text = String(DashboardDetails.Total3Wkts)
                self.TotalMaidens.text = String(DashboardDetails.TotalMaidens)
                self.TotalFiveWicketsPerMatch.text = String(DashboardDetails.Total5Wkts)
                self.PlayerOversBowld.text = String(DashboardDetails.TotalOvers)
                
                dispatch_async(dispatch_get_main_queue(),{
                    
                    //sajith - new code for Recent First Match
                    self.FirstRecentMatchSummary.hidden = true
                    self.SecondRecentMatchSummary.hidden = true
                    
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
                            
                            if let runsTaken = data["RunsTaken"]{
                                mData.BattingSectionHidden = (runsTaken as! String == "-")
                                if mData.BattingSectionHidden == false {
                                    if let dismissal = data["Dismissal"] as? String where dismissal == "Not out"{
                                        battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: 25).bold("*", fontName: appFont_black, fontSize: 25).bold("\nRUNS", fontName: appFont_black, fontSize: 10)
                                    }
                                    else{
                                        battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: 25).bold("\nRUNS", fontName: appFont_black, fontSize: 10)
                                    }
                                }
                            }
                            if let wicketsTaken = data["WicketsTaken"], let runsGiven = data["RunsGiven"] {
                                mData.BowlingSectionHidden = (runsGiven as! String == "-")
                                if mData.BowlingSectionHidden == false {
                                    if battingBowlingScore.length > 0 {
                                        battingBowlingScore.bold("\n\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: 25).bold("\nWICKETS", fontName: appFont_black, fontSize: 10)
                                    }
                                    else{
                                        battingBowlingScore.bold("\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: 25).bold("\nWICKETS", fontName: appFont_black, fontSize: 10)
                                    }
                                }
                            }
                            
                            if battingBowlingScore.length == 0 {
                                battingBowlingScore.bold("DNB", fontName: appFont_black, fontSize: 30)
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
                            
                            if let ground = data["Ground"]{
                                mData.ground = ground as! String
                                
                                if let venue = data["Venue"] as? String where venue != "-" {
                                    mData.ground = "\(ground), \(venue)"
                                }
                                groundVenue = ("\(mData.ground)")
                            }
                            
                            if let ballsFaced = data["BallsFaced"] as? String where ballsFaced != "-", let runsScored = data["RunsTaken"] as? String where runsScored != "-" && mData.BattingSectionHidden == false {
                                
                                if ballsFaced == "0" {
                                    mData.strikerate = Float("0.00")
                                }
                                else {
                                    let strikeRate = String(format: "%.1f",(Float(runsScored)!)*100/Float(ballsFaced)!)
                                    mData.strikerate = Float(strikeRate)
                                    srEconomy = ("Strike Rate: \(strikeRate)")
                                }
                            }
                            
                            if let oversBowled = data["OversBowled"] as? String where oversBowled != "-", let runsGiven = data["RunsGiven"] as? String where runsGiven != "-" && mData.BowlingSectionHidden == false {
                                
                                let economy = String(format: "%.1f",(Float(runsGiven)!)/Float(oversBowled)!)
                                mData.economy = Float(economy)
                                if srEconomy.length > 0 {
                                    srEconomy.appendContentsOf("\nEconomy: \(economy)")
                                }
                                else {
                                    srEconomy = ("Economy: \(economy)")
                                }
                            }
                            
                            if let opponent  = data["Opponent"]{
                                opponentName = opponent as! String
                            }
                            
                            self.firstRecentMatchScoreCard.attributedText = battingBowlingScore
                            self.firstRecentMatchOpponentName.text = opponentName
                            self.firstRecentMatchDateAndVenue.text = matchVenueAndDate
                            self.FirstRecentMatchGroundVenue.text = groundVenue
                            self.FirstRecentMatchStrikeRate.text = srEconomy
                        }
                    })
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        self.FirstRecentMatchSummary.hidden = false
                        self.recentMatchesNotAvailable.hidden = true
                        
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
                            
                            if let runsTaken = data["RunsTaken"]{
                                mData.BattingSectionHidden = (runsTaken as! String == "-")
                                if mData.BattingSectionHidden == false {
                                    if let dismissal = data["Dismissal"] as? String where dismissal == "Not out"{
                                        battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: 25).bold("*", fontName: appFont_black, fontSize: 25).bold("\nRUNS", fontName: appFont_black, fontSize: 10)
                                    }
                                    else{
                                        battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: 25).bold("\nRUNS", fontName: appFont_black, fontSize: 10)
                                    }
                                }
                            }
                            if let wicketsTaken = data["WicketsTaken"], let runsGiven = data["RunsGiven"] {
                                mData.BowlingSectionHidden = (runsGiven as! String == "-")
                                if mData.BowlingSectionHidden == false {
                                    if battingBowlingScore.length > 0 {
                                        battingBowlingScore.bold("\n\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: 25).bold("\nWICKETS", fontName: appFont_black, fontSize: 10)
                                    }
                                    else{
                                        battingBowlingScore.bold("\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: 25).bold("\nWICKETS", fontName: appFont_black, fontSize: 10)
                                    }
                                }
                            }
                            
                            if battingBowlingScore.length == 0 {
                                battingBowlingScore.bold("DNB", fontName: appFont_black, fontSize: 30)
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
                            
                            if let ground = data["Ground"]{
                                mData.ground = ground as! String
                                
                                if let venue = data["Venue"] as? String where venue != "-" {
                                    mData.ground = "\(ground), \(venue)"
                                }
                                groundVenue = ("\(mData.ground)")
                            }
                            
                            if let ballsFaced = data["BallsFaced"] as? String where ballsFaced != "-", let runsScored = data["RunsTaken"] as? String where runsScored != "-" && mData.BattingSectionHidden == false {
                                
                                if ballsFaced == "0" {
                                    mData.strikerate = Float("0.00")
                                }
                                else {
                                    let strikeRate = String(format: "%.1f",(Float(runsScored)!)*100/Float(ballsFaced)!)
                                    mData.strikerate = Float(strikeRate)
                                    srEconomy = ("Strike Rate: \(strikeRate)")
                                }
                            }
                            
                            if let oversBowled = data["OversBowled"] as? String where oversBowled != "-", let runsGiven = data["RunsGiven"] as? String where runsGiven != "-" && mData.BowlingSectionHidden == false {
                                
                                let economy = String(format: "%.1f",(Float(runsGiven)!)/Float(oversBowled)!)
                                mData.economy = Float(economy)
                                if srEconomy.length > 0 {
                                    srEconomy.appendContentsOf("\nEconomy: \(economy)")
                                }
                                else {
                                    srEconomy = ("Economy: \(economy)")
                                }
                            }
                            
                            if let opponent  = data["Opponent"]{
                                opponentName = opponent as! String
                            }
                            
                            self.secondRecentMatchScoreCard.attributedText = battingBowlingScore
                            self.secondRecentMatchOpponentName.text = opponentName
                            self.secondRecentMatchDateAndVenue.text = matchVenueAndDate
                            self.SecondRecentMatchGroundVenue.text = groundVenue
                            self.SecondRecentMatchStrikeRate.text = srEconomy
                        }
                    })
    
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        self.SecondRecentMatchSummary.hidden = false
                        self.recentMatchesNotAvailable.hidden = true
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
                            
                            if let runsTaken = data["RunsTaken"]{
                                mData.BattingSectionHidden = (runsTaken as! String == "-")
                                if mData.BattingSectionHidden == false {
                                    if let dismissal = data["Dismissal"] as? String where dismissal == "Not out"{
                                        battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: 25).bold("*", fontName: appFont_black, fontSize: 25).bold("\nRUNS", fontName: appFont_black, fontSize: 10)
                                    }
                                    else{
                                        battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: 25).bold("\nRUNS", fontName: appFont_black, fontSize: 10)
                                    }
                                }
                            }
                            
                            if battingBowlingScore.length == 0 {
                                battingBowlingScore.bold("DNB", fontName: appFont_black, fontSize: 30)
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
                            
                            if let ground = data["Ground"]{
                                mData.ground = ground as! String
                                
                                if let venue = data["Venue"] as? String where venue != "-" {
                                    mData.ground = "\(ground), \(venue)"
                                }
                                groundVenue = ("\(mData.ground)")
                            }
                            
                            if let ballsFaced = data["BallsFaced"] as? String where ballsFaced != "-", let runsScored = data["RunsTaken"] as? String where runsScored != "-" && mData.BattingSectionHidden == false {
                                
                                if ballsFaced == "0" {
                                    mData.strikerate = Float("0.00")
                                }
                                else {
                                    let strikeRate = String(format: "%.1f",(Float(runsScored)!)*100/Float(ballsFaced)!)
                                    mData.strikerate = Float(strikeRate)
                                    srEconomy = ("Strike Rate: \(strikeRate)")
                                }
                            }
                            
                            if let opponent  = data["Opponent"]{
                                opponentName = opponent as! String
                            }
                            
                            self.FirstRecentMatchScore.attributedText = battingBowlingScore
                            self.FirstRecentMatchOpponent.text = opponentName
                            self.FirstRecentMatchDateAndLocation.text = matchVenueAndDate
                            self.FirstRecentMatchBattingGroundVenue.text = groundVenue
                            self.FirstRecentMatchBattingStrikeRate.text = srEconomy

                        }
                    })
                    
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        self.FirstRecentMatchView.hidden = false
                        
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
                            
                            if let runsTaken = data["RunsTaken"]{
                                mData.BattingSectionHidden = (runsTaken as! String == "-")
                                if mData.BattingSectionHidden == false {
                                    if let dismissal = data["Dismissal"] as? String where dismissal == "Not out"{
                                        battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: 25).bold("*", fontName: appFont_black, fontSize: 25).bold("\nRUNS", fontName: appFont_black, fontSize: 10)
                                    }
                                    else{
                                        battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: 25).bold("\nRUNS", fontName: appFont_black, fontSize: 10)
                                    }
                                }
                            }
                            
                            if battingBowlingScore.length == 0 {
                                battingBowlingScore.bold("DNB", fontName: appFont_black, fontSize: 30)
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
                            
                            if let ground = data["Ground"]{
                                mData.ground = ground as! String
                                
                                if let venue = data["Venue"] as? String where venue != "-" {
                                    mData.ground = "\(ground), \(venue)"
                                }
                                groundVenue = ("\(mData.ground)")
                            }
                            
                            if let ballsFaced = data["BallsFaced"] as? String where ballsFaced != "-", let runsScored = data["RunsTaken"] as? String where runsScored != "-" && mData.BattingSectionHidden == false {
                                
                                if ballsFaced == "0" {
                                    mData.strikerate = Float("0.00")
                                }
                                else {
                                    let strikeRate = String(format: "%.1f",(Float(runsScored)!)*100/Float(ballsFaced)!)
                                    mData.strikerate = Float(strikeRate)
                                    srEconomy = ("Strike Rate: \(strikeRate)")
                                }
                            }
                            
                            if let opponent  = data["Opponent"]{
                                opponentName = opponent as! String
                            }
                            
                            self.SecondRecentMatchScore.attributedText = battingBowlingScore
                            self.SecondRecentMatchOpponent.text = opponentName
                            self.SecondRecentMatchDateAndLocation.text = matchVenueAndDate
                            self.SecondRecentMatchBattingGroundVenue.text = groundVenue
                            self.SecondRecentMatchBattingStrikeRate.text = srEconomy
                        }
                    })
                    
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        self.SecondRecentMatchView.hidden = false
                        
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
                            
                            if let wicketsTaken = data["WicketsTaken"], let runsGiven = data["RunsGiven"] {
                                mData.BowlingSectionHidden = (runsGiven as! String == "-")
                                if mData.BowlingSectionHidden == false {
                                    battingBowlingScore.bold("\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: 25).bold("\nWICKETS", fontName: appFont_black, fontSize: 10)
                                }
                            }
                            
                            if battingBowlingScore.length == 0 {
                                battingBowlingScore.bold("DNB", fontName: appFont_black, fontSize: 30)
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
                            
                            if let ground = data["Ground"]{
                                mData.ground = ground as! String
                                
                                if let venue = data["Venue"] as? String where venue != "-" {
                                    mData.ground = "\(ground), \(venue)"
                                }
                                groundVenue = ("\(mData.ground)")
                            }
                            
                            if let oversBowled = data["OversBowled"] as? String where oversBowled != "-", let runsGiven = data["RunsGiven"] as? String where runsGiven != "-" && mData.BowlingSectionHidden == false {
                                
                                let economy = String(format: "%.1f",(Float(runsGiven)!)/Float(oversBowled)!)
                                mData.economy = Float(economy)
                                srEconomy = ("Economy: \(economy)")
                            }
                            
                            if let opponent  = data["Opponent"]{
                                opponentName = opponent as! String
                            }
                            
                            self.FirstRecentMatchBowlingScore.attributedText = battingBowlingScore
                            self.FirstRecentMatchBowlingOpponent.text = opponentName
                            self.FirstRecentMatchBowlingDateAndLocation.text = matchVenueAndDate
                            self.FirstRecentMatchBowlingGroundVenue.text = groundVenue
                            self.FirstRecentMatchBowlingEconomy.text = srEconomy
                        }
                    })
                    
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        self.FirstRecentMatchBowlingView.hidden = false
                        
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
                            
                            if let wicketsTaken = data["WicketsTaken"], let runsGiven = data["RunsGiven"] {
                                mData.BowlingSectionHidden = (runsGiven as! String == "-")
                                if mData.BowlingSectionHidden == false {
                                    battingBowlingScore.bold("\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: 25).bold("\nWICKETS", fontName: appFont_black, fontSize: 10)
                                }
                            }
                            
                            if battingBowlingScore.length == 0 {
                                battingBowlingScore.bold("DNB", fontName: appFont_black, fontSize: 30)
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
                            
                            if let ground = data["Ground"]{
                                mData.ground = ground as! String
                                
                                if let venue = data["Venue"] as? String where venue != "-" {
                                    mData.ground = "\(ground), \(venue)"
                                }
                                groundVenue = ("\(mData.ground)")
                            }
                            
                            if let oversBowled = data["OversBowled"] as? String where oversBowled != "-", let runsGiven = data["RunsGiven"] as? String where runsGiven != "-" && mData.BowlingSectionHidden == false {
                                
                                let economy = String(format: "%.1f",(Float(runsGiven)!)/Float(oversBowled)!)
                                mData.economy = Float(economy)
                                srEconomy = ("Economy: \(economy)")
                            }
                            
                            if let opponent  = data["Opponent"]{
                                opponentName = opponent as! String
                            }
                            
                            self.SecondRecentMatchBowlingScore.attributedText = battingBowlingScore
                            self.SecondRecentMatchBowlingOpponent.text = opponentName
                            self.SecondRecentMatchBowlingDateAndLocation.text = matchVenueAndDate
                            self.SecondRecentMatchBowlingGroundVenue.text = groundVenue
                            self.SecondRecentMatchBowlingEconomy.text = srEconomy
                            
                        }
                    })
                    
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        self.SecondRecentMatchBowlingView.hidden = false
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
        self.FirstRecentMatchView.hidden = (DashboardDetails.TopBatting1stMatchScore == nil || String(DashboardDetails.TopBatting1stMatchScore) == "0")
        self.SecondRecentMatchView.hidden = (DashboardDetails.TopBatting2ndMatchScore == nil || String(DashboardDetails.TopBatting2ndMatchScore) == "0")
        
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
                self.summaryViewHeightConstraint1.constant = 90
                self.summaryViewHeightConstraint2.constant = 0
                self.summaryStackViewHeightConstraint.constant = 110
            }
            if String(DashboardDetails.Recent2ndMatchID) != "-" {
                self.summaryViewHeightConstraint1.constant = 100
                self.summaryViewHeightConstraint2.constant = 100
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
        
        //Top Balling view
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
            self.teamsViewHeightConstraint.constant = 180
        }
        
        //self.scrollViewBottomElementConstraint.constant = 10
        self.view.layoutIfNeeded()
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
                aCell.TeamImage.image = UIImage()
            
            var teamNameToReturn = ""
            
            
            switch userProfileData.UserProfile {
            case userProfileType.Player.rawValue:
                if indexPath.row < (userProfileData.PlayerCurrentTeams.count) {
                    teamNameToReturn = userProfileData.PlayerCurrentTeams[indexPath.row]
                   
                    aCell.baseView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: UIColor().hexFromUIColor(cricTracTheme.currentTheme.boxColor)))
                    aCell.TeamAbbr.textColor = UIColor.whiteColor()
                   
                }
                else if (indexPath.row - (userProfileData.PlayerCurrentTeams.count)) < (userProfileData.PlayerPastTeams.count) {
                 
                    teamNameToReturn = userProfileData.PlayerPastTeams[(indexPath.row - userProfileData.PlayerCurrentTeams.count)]
                     aCell.baseView.backgroundColor = UIColor.grayColor()
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
                    
                        summaryDetailsVC.isFriendDashboard = true
                    if let _ = self.friendProfile {
                        summaryDetailsVC.friendProfile = true

                        self.presentViewController(summaryDetailsVC, animated: false, completion: nil)
                    }
                    else {
                        self.navigationController?.pushViewController(summaryDetailsVC, animated: false)
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
                    summaryDetailsVC.isFriendDashboard = true
                    if let _ = self.friendProfile {
                        summaryDetailsVC.friendProfile = true
                        self.presentViewController(summaryDetailsVC, animated: false, completion: nil)
                    }
                    else {
                        self.navigationController?.pushViewController(summaryDetailsVC, animated: false)
                        
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
                    summaryDetailsVC.isFriendDashboard = true
                    if let _ = self.friendProfile {
                        summaryDetailsVC.friendProfile = true
                        self.presentViewController(summaryDetailsVC, animated: false, completion: nil)
                    }
                    else {
                        self.navigationController?.pushViewController(summaryDetailsVC, animated: false)
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
                    summaryDetailsVC.isFriendDashboard = true
                    if let _ = self.friendProfile {
                        summaryDetailsVC.friendProfile = true
                        self.presentViewController(summaryDetailsVC, animated: false, completion: nil)
                    }
                    else {
                        self.navigationController?.pushViewController(summaryDetailsVC, animated: false)
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
                    summaryDetailsVC.isFriendDashboard = true
                    if let _ = self.friendProfile {
                        summaryDetailsVC.friendProfile = true
                        self.presentViewController(summaryDetailsVC, animated: false, completion: nil)
                    }
                    else {
                        self.navigationController?.pushViewController(summaryDetailsVC, animated: false)
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
                    summaryDetailsVC.isFriendDashboard = true
                    if let _ = self.friendProfile {
                        summaryDetailsVC.friendProfile = true
                        self.presentViewController(summaryDetailsVC, animated: false, completion: nil)
                    }
                    else {
                        self.navigationController?.pushViewController(summaryDetailsVC, animated: false)
                    }
                }
            })
        }
    }
}



