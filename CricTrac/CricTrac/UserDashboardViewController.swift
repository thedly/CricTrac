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
    
    var isFriendDashboard = false
    
    var clearColor = UIColor.clearColor()
    var darkerThemeColor = UIColor().darkerColorForColor(UIColor(hex: topColor))
    var matches = [MatchSummaryData]()
    var friendId:String? = nil
    
    var friendProfile:[String:AnyObject]?
    
    var userProfileData:Profile!
    
    // MARK: - Plumbing
    
   
    
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
//    @IBOutlet weak var notOuts: UILabel!
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
    
    
    @IBAction func editImageBtnPressed(sender: AnyObject) {
        
        self.photoOptions("ProfilePhoto")
        coverOrProfile = "Profile"
        
    }
    
    func photoOptions(option:String)  {
        
        let alertController = UIAlertController(title: nil, message: "Change your picture", preferredStyle: .ActionSheet)
        
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
        
        
        let chooseFromFacebookAction = UIAlertAction(title: "Choose Default", style: .Default) { (action) in
            
            let userProviderData = currentUser?.providerData
            
            for usr: FIRUserInfo in userProviderData! {
                if (usr.providerID == "facebook.com" || usr.providerID == "google.com") {
                    
                    self.activityInd.startAnimating()
                    
                    let image:UIImage = getImageFromFacebook()
                    
                    self.userProfileImage.image = image
                    
                    addProfileImageData(self.resizeImage(image, newWidth: 200))
                    self.activityInd.stopAnimating()
                    
                }
            }
            
            
            
            
        }
        
        alertController.addAction(chooseFromFacebookAction)
        
        
        let removePhotoAction = UIAlertAction(title: "Remove Photo", style: .Default) { (action) in
            
            let image:UIImage = UIImage(named: "User")!
            
            self.userProfileImage.image = image
            addProfileImageData(self.resizeImage(image, newWidth: 200))
            
        }
        
        alertController.addAction(removePhotoAction)
        
        
        let viewPhotoAction = UIAlertAction(title: "View Photo", style: .Default) { (action) in
            
            self.viewImage(option)
            
        }
        
        alertController.addAction(viewPhotoAction)
        
        
        
        
        
        
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
            title = "DASHBOARD"
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
           
            self.userProfileImage.image = image
            self.dismissViewControllerAnimated(true) {
                addProfileImageData(self.resizeImage(image, newWidth: 200))
            }
        }else {
            self.imgCoverPhoto.image = image
            self.dismissViewControllerAnimated(true) {
                addCoverImageData(self.resizeImage(image, newWidth: 200))
            }
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadBannerAds()
        if let value = friendProfile{
            userProfileData = Profile(usrObj: value)
            closeButton.hidden = false
        }else{
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
        
        
        
        
        
        let df = NSDateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        self.PlayerName.text = userProfileData.fullName
        let formattedString = NSMutableAttributedString()
        let locationText = formattedString.bold("\(userProfileData.City)\n", fontName: appFont_black, fontSize: 15).bold("\(userProfileData.State)\n", fontName: appFont_black, fontSize: 15).bold("\(userProfileData.Country)\n", fontName: appFont_black, fontSize: 15).bold("\(userProfileData.DateOfBirth)\n", fontName: appFont_black, fontSize: 15)
        self.PlayerLocation.attributedText = locationText
        self.userProfileImage.image = LoggedInUserImage
        self.imgCoverPhoto.image = LoggedInUserCoverImage

        
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
        self.photoOptions("CoverPhoto")
        coverOrProfile = "Cover"

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackgroundColor()

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
        let currentTheme = cricTracTheme.currentTheme
        MatchesView.backgroundColor = UIColor.blackColor()
        MatchesView.alpha = 0.3
        if let _ = navigationController{
            navigationController!.navigationBar.barTintColor = currentTheme.topColor
        }
        
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
    
    
    
    func getMatchData(){
        
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
    }

    
    
    func setDashboardData(){
        
        //KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        
        topBattingNotAvailable.hidden = true
        topBowlingNotAvailable.hidden = true
        
       
        getAllDashboardData(friendId) { (data) in
            
            DashboardDetails = DashboardData(dataObj: data)
            if DashboardDetails != nil {
                
                
                
                UIView.animateWithDuration(3.0, animations: {
                    
                    self.winPerc.text = String(DashboardDetails.WinPercentage)
                    self.BB.text = String(DashboardDetails.TopBowling1stMatchScore)
                    self.totalRunsScored.text = String(DashboardDetails.TotalRuns)
                    
                    self.battingMatches.text = String(DashboardDetails.TotalMatches)
                    self.battingInnings.text = String(DashboardDetails.BattingInnings)
                    self.bowlingInnings.text = String(DashboardDetails.BowlingInnings)
                    //    self.notOuts = DashboardDetails
                    
                    self.highScore.text = String(DashboardDetails.TopBatting1stMatchScore)
                    self.battingAverage.text = String(DashboardDetails.TotalBattingAverage)
                    self.strikeRate.text = String(DashboardDetails.TotalStrikeRate)
                    self.hundreds.text = String(DashboardDetails.Total100s)
                    self.fifties.text = String(DashboardDetails.Total50s)
                    
                    self.sixes.text = String(DashboardDetails.Total6s)
                    self.fours.text = String(DashboardDetails.Total4s)
                    
                  //
                   // self.ballsFacedDuringBat.text = String(DashboardDetails.TotalBallsFaced)
                    
                    // bowling
                    
                    self.totalWickets.text = String(DashboardDetails.TotalWickets)
                    self.bowlingAverage.text = String(DashboardDetails.TotalBowlingAverage)
                    self.bowlingEconomy.text = String(DashboardDetails.TotalEconomy)
                    
                    self.TotalThreeWicketsPerMatch.text = String(DashboardDetails.Total3Wkts)
                    
                    self.TotalMaidens.text = String(DashboardDetails.TotalMaidens)
                    self.TotalFiveWicketsPerMatch.text = String(DashboardDetails.Total5Wkts)
                    
                    self.PlayerOversBowld.text = String(DashboardDetails.TotalOvers)
                    
                    
                    self.FirstRecentMatchView.hidden = (DashboardDetails.TopBatting1stMatchScore == nil || String(DashboardDetails.TopBatting1stMatchScore) == "0")
                    
                    
                    self.SecondRecentMatchView.hidden = (DashboardDetails.TopBatting2ndMatchScore == nil || String(DashboardDetails.TopBatting2ndMatchScore) == "0")
                    
                    
                    
                    self.FirstRecentMatchBowlingView.hidden = (DashboardDetails.TopBowling1stMatchScore == nil || DashboardDetails.TopBowling1stMatchScore as! String == "0-0")
                    
                    
                    self.SecondRecentMatchBowlingView.hidden = (DashboardDetails.TopBowling2ndMatchScore == nil || DashboardDetails.TopBowling2ndMatchScore as! String == "0-0")
                    
                    
                    self.topBattingNotAvailable.hidden = !(self.FirstRecentMatchView.hidden && self.SecondRecentMatchView.hidden)
                    self.topBowlingNotAvailable.hidden = !(self.FirstRecentMatchBowlingView.hidden && self.SecondRecentMatchBowlingView.hidden)
                    
                    
                    if !self.FirstRecentMatchView.hidden {
                        self.FirstRecentMatchScore.text = String(DashboardDetails.TopBatting1stMatchScore)
                        self.FirstRecentMatchOpponent.text = String(DashboardDetails.TopBatting1stMatchOpp)
                        
                        let formattedString = NSMutableAttributedString()
                        formattedString.bold("\(DashboardDetails.TopBatting1stMatchDate), at \(DashboardDetails.TopBatting1stMatchGround)",fontName: appFont_bold, fontSize: 12)
                        self.FirstRecentMatchDateAndLocation.attributedText = formattedString
                    }
                    
                    
                    
                    
                    if !self.SecondRecentMatchView.hidden {
                        
                        self.SecondRecentMatchScore.text = String(DashboardDetails.TopBatting2ndMatchScore)
                        self.SecondRecentMatchOpponent.text = String(DashboardDetails.TopBatting2ndMatchOpp)
                        
                        let formattedString_2 = NSMutableAttributedString()
                        formattedString_2.bold("\(DashboardDetails.TopBatting2ndMatchDate), at \(DashboardDetails.TopBatting2ndMatchGround)",fontName: appFont_bold, fontSize: 12)
                        self.SecondRecentMatchDateAndLocation.attributedText = formattedString_2
                        
                    }
                    
                    
                    if !self.FirstRecentMatchBowlingView.hidden {
                        self.FirstRecentMatchBowlingScore.text = String(DashboardDetails.TopBowling1stMatchScore)
                        self.FirstRecentMatchBowlingOpponent.text = String(DashboardDetails.TopBowling1stMatchOpp)
                        
                        let formattedString_Bowling = NSMutableAttributedString()
                        formattedString_Bowling.bold("\(DashboardDetails.TopBowling1stMatchDate), at \(DashboardDetails.TopBowling1stMatchGround)",fontName: appFont_bold, fontSize: 12)
                        self.FirstRecentMatchBowlingDateAndLocation.attributedText = formattedString_Bowling
                    }
                    
                    
                    
                    if !self.SecondRecentMatchBowlingView.hidden {
                        
                        self.SecondRecentMatchBowlingScore.text = String(DashboardDetails.TopBowling2ndMatchScore)
                        self.SecondRecentMatchBowlingOpponent.text = String(DashboardDetails.TopBowling2ndMatchOpp)
                        
                        let formattedString_Bowling_2 = NSMutableAttributedString()
                        formattedString_Bowling_2.bold("\(DashboardDetails.TopBowling2ndMatchDate), at \(DashboardDetails.TopBowling2ndMatchGround)",fontName: appFont_bold, fontSize: 12)
                        self.SecondRecentMatchBowlingDateAndLocation.attributedText = formattedString_Bowling_2
                    }
                    
                    }, completion: { (val) in
                        
                       // KRProgressHUD.dismiss()
                })
            }
            
            //self.setUIElements()
            //self.setBowlingUIElements()
            
            
            
            
        }
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

            getMatchData()
            setDashboardData()
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

                }
                else if (indexPath.row - (userProfileData.PlayerCurrentTeams.count)) < (userProfileData.PlayerPastTeams.count) {
                 teamNameToReturn = userProfileData.PlayerPastTeams[(indexPath.row - userProfileData.PlayerCurrentTeams.count)]
                    
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
                aCell.TeamAbbr.text = "\(teamNameToReturn[0])\(teamNameToReturn[1])"
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
    
    

}
