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
    @IBOutlet weak var exprOfCoach: UILabel!
    @IBOutlet weak var noTeamsLbl: UILabel!
    
    
    // for teams
    @IBOutlet weak var baseViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var coachTeams: UICollectionView!
    @IBOutlet weak var coachTeamsHeightConstraint: NSLayoutConstraint!
    
    var myCoachFrndNodeId = ""
    var myPlayersFrndNodeId = ""
    let currentTheme = cricTracTheme.currentTheme
    
    
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
    @IBOutlet weak var pendingRequests: UIButton!
    @IBOutlet weak var coachFrndBtnHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewAllBtnForTopBatting: UIButton!
    
    @IBOutlet weak var viewAllBtnForTopBattingHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewAllBtnForTopBowling: UIButton!
    
    @IBOutlet weak var viewAllBtnForTopBowlingHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var battingTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bowlingTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var noPlayersForBatting: UILabel!
    @IBOutlet weak var noPlayersForBowling: UILabel!
    
    var players = [String]()
    var batsmen = [String]()
    var bowlers = [String]()
    var wicketKeepers = [String]()
    var allRounders = [String]()
    
    
    //by sajith
    var avgAge:Float = 0
    var playerId = ""
    var name = ""
    var totalMatches = 0
    var totalBatInnings = 0
    var totalBowlInnings = 0
    var batAverage:Float = 0
    var bowlAverage:Float = 0
    var strikeRate:Float = 0
    var economy:Float = 0
    var totalRunsTaken = 0
    var totalWicketsTaken = 0
    var totalRunsGiven = 0
    var tempHS = 0
    var dispHS = ""
    var tempWicketsTaken = 0
    var tempRunsGiven = 0
    var dispBB = ""
    var totalNotouts = 0
    var totalOversBowled:Float = 0
    var totalBallsFaced = 0
    var matchData = [String:AnyObject]()
    var matches = [PlayerMatchesData]()
    var matchDataSource = [String:AnyObject]()
    
    
    
    @IBAction func CloseDashboardPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    var friendProfile:[String:AnyObject]?
    var userProfileData:Profile!
    var coverOrProfile = ""
    var friendId:String? = nil
    var currentUserId = ""
    
    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(animated)
        setBackgroundColor()

        coachTeams.reloadData()
        
        initView()
        updateCoachDashboard()
        updateCoachSummary()
//        self.topBattingtableView.reloadData()
//        self.topBowlingTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBannerAds()
        let currentTheme = cricTracTheme.currentTheme

        pendingRequests.layer.cornerRadius = 10
        pendingRequests.clipsToBounds = true
        pendingRequests.backgroundColor = currentTheme.bottomColor
        pendingRequests.layer.borderWidth = 2.0
        pendingRequests.layer.borderColor = UIColor.whiteColor().CGColor
        
        coachFrndButton.layer.cornerRadius = 10
        coachFrndButton.clipsToBounds = true
        coachFrndButton.backgroundColor = currentTheme.bottomColor
        coachFrndButton.layer.borderWidth = 2.0
        coachFrndButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        viewAllBtnForTopBatting.layer.cornerRadius = 10
        viewAllBtnForTopBatting.clipsToBounds = true
        viewAllBtnForTopBatting.backgroundColor = currentTheme.bottomColor
        viewAllBtnForTopBatting.layer.borderWidth = 2.0
        viewAllBtnForTopBatting.layer.borderColor = UIColor.whiteColor().CGColor
        
        viewAllBtnForTopBowling.layer.cornerRadius = 10
        viewAllBtnForTopBowling.clipsToBounds = true
        viewAllBtnForTopBowling.backgroundColor = currentTheme.bottomColor
        viewAllBtnForTopBowling.layer.borderWidth = 2.0
        viewAllBtnForTopBowling.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        coachTeams.delegate = self
        coachTeams.dataSource = self
        
        topBowlingTableView.separatorStyle = .None
        topBattingtableView.separatorStyle = .None
        
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
    
    func coachValidation() {
        
        if profileData.UserProfile == "Player" {
            
            coachFrndBtnHeightConstraint.constant = 30
            pendingRequests.hidden = true
            var coachExist = 0
            getMyCoaches({ (result) in
                for (_, req) in result {
                    if let data = req as? [String : AnyObject] {
                        let coachID = String(data["CoachID"]!)
                        let isAccepted = String(data["isAccepted"]!)
                        self.myPlayersFrndNodeId = String(data["CoachNodeIdOther"]!)
                        self.myCoachFrndNodeId = String(data["PlayerNodeID"]!)
                        if coachID == self.currentUserId {
                            coachExist = 1

                            if isAccepted == "0" {
                                
                                self.coachFrndButton.setTitle("Cancel Request", forState: .Normal)
                            }
                            else{
                                self.coachFrndButton.setTitle("Remove Coach", forState: .Normal)
                            }
                            break
                        }
                    }
                }
            })
            if coachExist == 0 {
                self.coachFrndButton.setTitle("Mark as my Coach", forState: .Normal)
            }
            
        }
       
        else if profileData.UserProfile == "Coach" {
            coachFrndButton.setTitle("My Players", forState: .Normal)
//            coachFrndBtnHeightConstraint.constant = 30
//            pendingRequests.hidden = false
            
        }
        else if profileData.UserProfile == "Cricket Fan" {
            coachFrndBtnHeightConstraint.constant = 0
            coachFrndButton.hidden = true
            pendingRequests.hidden = true
        }

    }
    
    func initView() {
        
        coachValidation()
        
        if let value = friendProfile{
            if profileData.UserProfile == "Coach" {
                coachFrndButton.hidden = true
                pendingRequests.hidden = true
                coachFrndBtnHeightConstraint.constant = 0
            }
          userProfileData = Profile(usrObj: value)
        }
        else{
            coachFrndButton.hidden = false
            pendingRequests.hidden = false
            coachFrndBtnHeightConstraint.constant = 30
            userProfileData = profileData
        }
        
        userProfileImage.layer.cornerRadius = userProfileImage.bounds.size.width/2
        userProfileImage.clipsToBounds = true
        
        let currentCountryList = CountriesList.filter({$0.name == userProfileData.Country})
        let currentISO = currentCountryList[0].iso
        
        let df = NSDateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        self.PlayerName.text = userProfileData.fullName
        
        var coachExpr = ""
        var coachLevel = ""
        if userProfileData.Experience != "-" {
             coachExpr =  userProfileData.Experience
        }
        if userProfileData.CoachingLevel != "-" {
            coachLevel = userProfileData.CoachingLevel
        }
        
        let formattedStr = NSMutableAttributedString()
        
        if coachExpr != "" {
            formattedStr.bold("Exp: \(coachExpr) Years", fontName: appFont_black, fontSize: 15)
        }
        if coachLevel != "" {
            formattedStr.bold("\nLevel: \(coachLevel)", fontName: appFont_black, fontSize: 15)
        }
        self.exprOfCoach.attributedText = formattedStr
        
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
    
    //Coach Summary
    
    func updateCoachSummary() {
        
        self.matches.removeAll()
        
        players.removeAll()
        batsmen.removeAll()
        bowlers.removeAll()
        wicketKeepers.removeAll()
        allRounders.removeAll()
        self.matchDataSource.removeAll()
        self.avgAge = 0
        
        getMyPlayers(currentUserId) { (data)  in
            if  data.isEmpty == false  {
                for(_,req) in data {
                    let playersData = req as! [String : AnyObject]
                    let isAcceptVal = playersData["isAccepted"]!
                    if isAcceptVal as! NSObject == 1 {
                        let playerId = playersData["PlayerID"]!
                        self.getMatchData(playerId as! String)
                        self.players.append(playerId as! String)
                        
                        fetchBasicProfile(playerId as! String) { (result) in
                            let playingRole = result["playingRole"]
                            
                            if playingRole == "Batsman" {
                                self.batsmen.append(playerId as! String)
                            }
                            else if playingRole == "Bowler" {
                                self.bowlers.append(playerId as! String)
                            }
                            else if playingRole == "All-rounder" || playingRole == "Batting all-rounder" || playingRole == "Bowling all-rounder" {
                                self.allRounders.append(playerId as! String)
                            }
                            else if playingRole == "Wicketkeeper" {
                                self.wicketKeepers.append(playerId as! String)
                            }
                            
                            //For age calculating
                            let  dob = result["dob"]
                            let dateFormater = NSDateFormatter()
                            dateFormater.dateFormat = "dd-MM-yyyy"
                            let birthdayDate = dateFormater.dateFromString(dob!)
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
                            let ageString = "\(years).\(months)"
                            self.avgAge += Float(ageString)!
                            
                            // Assigning values
                            self.totalPlayers.text = String(self.players.count)
                            self.totalBatsmen.text = String(self.batsmen.count)
                            self.totalBowlers.text = String(self.bowlers.count)
                            self.totalWickets.text = String(self.wicketKeepers.count)
                            self.totalAllRounders.text = String(self.allRounders.count)
                            self.totalAvgAge.text = String(format:"%.1f",self.avgAge/Float(self.players.count))
                        }
                    }
                }
            }
            else{
                // Assigning values
                self.totalPlayers.text = "0"
                self.totalBatsmen.text = "0"
                self.totalBowlers.text = "0"
                self.totalWickets.text = "0"
                self.totalAllRounders.text = "0"
                self.totalAvgAge.text = "0"
            }
        }
    }
    
    // Get all match data
    func getMatchData(playerId: String) {
        getAllMatchData(playerId) { (data) in
              if !data.isEmpty {
                self.matchDataSource = data
                self.makeCells(data)
            }
        }
    }
    
    func makeCells(data: [String: AnyObject]) {
        self.matchData = data
        
        totalMatches = 0
        totalBatInnings = 0
        totalBowlInnings = 0
        totalRunsTaken = 0
        totalBallsFaced = 0
        strikeRate = 0
        batAverage = 0
        tempHS = 0
        dispHS = "0"
        totalNotouts = 0
        totalBowlInnings = 0
        totalOversBowled = 0
        totalWicketsTaken = 0
        totalRunsGiven = 0
        tempWicketsTaken = 0
        tempRunsGiven = 0
        dispBB = "0-0"
        bowlAverage = 0
        economy = 0
        var matchdays = 0
        
        for (key,val) in data{
            matchdays = 0
            if  var value = val as? [String : AnyObject]{
                value += ["key":key]
                totalMatches += 1
                playerId = value["UserId"] as! String
                
                if let matchDat = value["MatchDate"]  {
                    let dateFormater = NSDateFormatter()
                    dateFormater.dateFormat = "dd-MM-yyyy"
                    let matchDate = dateFormater.dateFromString(matchDat as! String)
                    
                    let date = NSDate()
                    
                    let calender:NSCalendar  = NSCalendar.currentCalendar()
                    let days = calender.components(.Day, fromDate: matchDate!, toDate: date, options: [])
                    matchdays = days.day
                }

            if matchdays <= 365  {

                if value["RunsTaken"] as! String != "-" {
                    let runsTaken = Int(value["RunsTaken"] as! String)!
                    totalBatInnings += 1
                    let dismissal = value["Dismissal"] as? String
                    if  dismissal == "Not out" || dismissal == "Retired hurt" {
                        totalNotouts += 1
                    }
                    totalBallsFaced += Int(value["BallsFaced"] as! String)!
                    totalRunsTaken += Int(value["RunsTaken"] as! String)!
                    
                    if runsTaken >= tempHS {
                        if  dismissal == "Not out" || dismissal == "Retired hurt" {
                            tempHS = runsTaken
                            dispHS = String(runsTaken) + "*"
                        }
                        else {
                            tempHS = runsTaken
                            dispHS = String(runsTaken)
                        }
                    }
                }
                
                if value["OversBowled"] as! String != "-" {
                    let wicketsTaken = Int(value["WicketsTaken"] as! String)!
                    let runsGiven = Int(value["RunsGiven"] as! String)!
                    totalBowlInnings += 1
                    totalOversBowled += Float(value["OversBowled"] as! String)!
                    totalRunsGiven += Int(value["RunsGiven"] as! String)!
                    totalWicketsTaken += Int(value["WicketsTaken"] as! String)!
                    
                    if wicketsTaken > tempWicketsTaken {
                        tempWicketsTaken = wicketsTaken
                        tempRunsGiven = runsGiven
                        dispBB = String(wicketsTaken) + "-" + String(runsGiven)
                    }
                    else if wicketsTaken == tempWicketsTaken {
                        if runsGiven <= tempRunsGiven {
                            tempWicketsTaken = wicketsTaken
                            tempRunsGiven = runsGiven
                            dispBB = String(wicketsTaken) + "-" + String(runsGiven)
                        }
                    }
                }
                }

            }
            
        }
        
        self.matches.append(makeSummaryCell(data))

        self.topBattingtableView.reloadData()
        self.topBowlingTableView.reloadData()
    }
    
    func makeSummaryCell(value: [String : AnyObject]) -> PlayerMatchesData {
        
        let mData = PlayerMatchesData()
        
        if totalBallsFaced != 0 {
            strikeRate = (Float(totalRunsTaken))*100/Float(totalBallsFaced)
        }
        else {
            strikeRate = 0.0
        }
        
        if (totalBatInnings-totalNotouts) != 0 {
            batAverage = Float(totalRunsTaken)/Float(totalBatInnings - totalNotouts)
        }
        else {
            batAverage = 0.0
        }
        
        if totalOversBowled != 0 {
            economy = Float(totalRunsGiven)/Float(totalOversBowled)
        }
        else {
            economy = 0.0
        }
        
        if totalWicketsTaken != 0 {
            bowlAverage = Float(totalRunsGiven)/Float(totalWicketsTaken)
        }
        else {
            bowlAverage = 0.0
        }
        
        mData.playerId = playerId
        mData.totalMatches = totalMatches
        mData.totalBatInnings = totalBatInnings
        mData.totalRunsTaken = totalRunsTaken
        mData.strikeRate = strikeRate
        mData.batAverage = batAverage
        mData.dispHS = dispHS
        
        mData.totalBowlInnings = totalBowlInnings
        mData.totalOversBowled = totalOversBowled
        mData.totalWicketsTaken = totalWicketsTaken
        mData.bowlAverage = bowlAverage
        mData.economy = economy
        mData.dispBB = dispBB
        
        return mData
    }
 

    
    // Only players can see this button
    @IBAction func coachActionBtnTapped(sender: UIButton) {
        
        switch coachFrndButton.currentTitle! {
        case "Mark as my Coach":
            
            let actionSheetController = UIAlertController(title: "", message: "Coach will be allowed to view and edit all your matches. Are you sure to continue?", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
                // Just dismiss the action sheet
                actionSheetController.dismissViewControllerAnimated(true, completion: nil)
            }
            actionSheetController.addAction(cancelAction)
            
            let okAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
               
                markMyCoach(self.currentUserId)
                
                let alert = UIAlertController(title: "", message:"Coach Request Sent", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
                let delay = 1.0 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    alert.dismissViewControllerAnimated(true, completion: nil)
                })
                self.coachValidation()
                self.updateCoachSummary()
                self.topBattingtableView.reloadData()
                self.topBowlingTableView.reloadData()
                
            }
            actionSheetController.addAction(okAction)
            
            self.presentViewController(actionSheetController, animated: true, completion: nil)
                break
            
        case "Cancel Request":
        
            let actionSheetController = UIAlertController(title: "", message: "Are you sure you want to Cancel this request?", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
                // Just dismiss the action sheet
                actionSheetController.dismissViewControllerAnimated(true, completion: nil)
            }
            actionSheetController.addAction(cancelAction)
            
            let unfriendAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
                fireBaseRef.child("Users").child(self.currentUserId).child("MyPlayers").child(self.myPlayersFrndNodeId).removeValue()
                fireBaseRef.child("Users").child((currentUser?.uid)!).child("MyCoaches").child(self.myCoachFrndNodeId).removeValue()
                self.coachValidation()
                self.updateCoachSummary()
                
            }
            actionSheetController.addAction(unfriendAction)
            
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        
            break
            
        case "Remove Coach":
            
            let actionSheetController = UIAlertController(title: "", message: "Are you sure you want to Remove this Coach?", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
                // Just dismiss the action sheet
                actionSheetController.dismissViewControllerAnimated(true, completion: nil)
            }
            actionSheetController.addAction(cancelAction)
            
            let unfriendAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
                
                fireBaseRef.child("Users").child(self.currentUserId).child("MyPlayers").child(self.myPlayersFrndNodeId).removeValue()
                fireBaseRef.child("Users").child((currentUser?.uid)!).child("MyCoaches").child(self.myCoachFrndNodeId).removeValue()
                self.coachValidation()
                self.updateCoachSummary()
                self.topBattingtableView.reloadData()
                self.topBowlingTableView.reloadData()
                
            }
            actionSheetController.addAction(unfriendAction)
            
            self.presentViewController(actionSheetController, animated: true, completion: nil)
            
            break
            
        default:
            
            let dashBoard = viewControllerFrom("Main", vcid: "CoachPlayersListViewController") as! CoachPlayersListViewController
            dashBoard.title = "MY PLAYERS"
            self.navigationController?.pushViewController(dashBoard, animated: false)
            break
        }
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
                self.presentViewController(profileImageVc, animated: false) {}
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
                self.presentViewController(imagePicker, animated: false, completion: nil)
            }
        }
        
        alertController.addAction(TakePictureAction)
        
        let chooseExistingAction = UIAlertAction(title: "Choose Existing", style: .Default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: false, completion: nil)
            }
        }
        
        alertController.addAction(chooseExistingAction)
        
        self.presentViewController(alertController, animated: false) {
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
                self.presentViewController(imagePicker, animated: false, completion: nil)
            }
        }
        
        alertController.addAction(TakePictureAction)
        
        let chooseExistingAction = UIAlertAction(title: "Choose Existing", style: .Default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: false, completion: nil)
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
            self.presentViewController(profileImageVc, animated: false) {}
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        view.backgroundColor = currentTheme.topColor
       
        topBattingtableView.backgroundColor = UIColor.clearColor()
    }

    @IBAction func didMenuButtonTapp(sender: UIButton){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        if coverOrProfile == "Profile" {
            self.userProfileImage.image = image
            self.dismissViewControllerAnimated(false) {
                addProfileImageData(self.resizeImage(image, newWidth: 200))
            }
        }else {
            self.imgCoverPhoto.image = image
            self.dismissViewControllerAnimated(false) {
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
    
    //Sravani mark: For coach Teams
    func updateCoachDashboard(){
                if (userProfileData.CoachCurrentTeams.count) + (userProfileData.CoachPastTeams.count) == 0 {
                    self.coachTeamsHeightConstraint.constant = 0
                }
                else {
                    self.coachTeamsHeightConstraint.constant = 130
                }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var valueToReturn = 0
        valueToReturn = (userProfileData.CoachCurrentTeams.count) + userProfileData.CoachPastTeams.count
        if valueToReturn == 0 {
            noTeamsLbl.text = "No Teams"
        }
        else{
            noTeamsLbl.text = ""
        }
        return valueToReturn
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var teamNameToReturn = ""
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
                            aCell.baseView.backgroundColor = UIColor.clearColor()
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

    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
            if tableView == topBattingtableView || tableView == topBowlingTableView {
                battingTableViewHeightConstraint.constant = 0
                 bowlingTableViewHeightConstraint.constant = 0
                
                if matches.count == 0 {
                    if (userProfileData.CoachCurrentTeams.count) + (userProfileData.CoachPastTeams.count) == 0 {
                        baseViewHeightConstraint.constant = 730
                    }else{
                        baseViewHeightConstraint.constant = 850
                    }
                    if friendId != nil {
                        viewAllBtnForTopBatting.hidden = true
                        viewAllBtnForTopBowling.hidden = true
                        viewAllBtnForTopBattingHeightConstraint.constant = 0
                        viewAllBtnForTopBowlingHeightConstraint.constant = 0

                    }
                    else{
                        viewAllBtnForTopBatting.hidden = true
                        viewAllBtnForTopBowling.hidden = true
                        viewAllBtnForTopBattingHeightConstraint.constant = 0
                        viewAllBtnForTopBowlingHeightConstraint.constant = 0
                    }
                    noPlayersForBatting.text = "No Players"
                    noPlayersForBowling.text = "No Players"
                }
                else{
                    
                    noPlayersForBatting.text = ""
                    noPlayersForBowling.text = ""
                    
                    if  friendId != nil {
                        viewAllBtnForTopBatting.hidden = true
                        viewAllBtnForTopBowling.hidden = true
                        viewAllBtnForTopBattingHeightConstraint.constant = 0
                        viewAllBtnForTopBowlingHeightConstraint.constant = 0
                    }
                    else{
                        viewAllBtnForTopBatting.hidden = false
                        viewAllBtnForTopBowling.hidden = false
                        viewAllBtnForTopBattingHeightConstraint.constant = 30
                        viewAllBtnForTopBowlingHeightConstraint.constant = 30
                    }
                }
                if matches.count >= 5 {
                    if (userProfileData.CoachCurrentTeams.count) + (userProfileData.CoachPastTeams.count) == 0 {
                        baseViewHeightConstraint.constant = 790
                    }else{
                        baseViewHeightConstraint.constant = 900
                    }
                    battingTableViewHeightConstraint.constant = CGFloat(5 * 78)
                    bowlingTableViewHeightConstraint.constant = CGFloat(5 * 78)
                    baseViewHeightConstraint.constant += CGFloat(5 * 125)

                    return 5
                }
                else {
                    if (userProfileData.CoachCurrentTeams.count) + (userProfileData.CoachPastTeams.count) == 0 {
                        baseViewHeightConstraint.constant = 750
                    }else{
                        baseViewHeightConstraint.constant = 870
                    }
                    
                    battingTableViewHeightConstraint.constant += CGFloat(matches.count * 78)
                    bowlingTableViewHeightConstraint.constant += CGFloat(matches.count * 78)
                    baseViewHeightConstraint.constant += CGFloat(matches.count * 125)
                    return matches.count
                }
            }
        return matches.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let aView = UIView()
        aView.backgroundColor = UIColor.clearColor()
        return aView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.backgroundColor = UIColor.clearColor()
        //let currentTheme = cricTracTheme.currentTheme
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if tableView == topBattingtableView {
             self.matches.sortInPlace({ $0.totalRunsTaken > $1.totalRunsTaken })
            
                let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CoachTopBattingBowlingTableViewCell
            
                fetchBasicProfile(self.matches[indexPath.section].playerId, sucess: { (result) in
                    let name = "\(result["firstname"]!) \(result["lastname"]!)"
                    cell.topBattingPlayerName.text = name
                })
            
                cell.battingMatches.text = String(self.matches[indexPath.section].totalBatInnings)
                cell.battingRuns.text = String(self.matches[indexPath.section].totalRunsTaken)
                cell.battingHS.text = String(self.matches[indexPath.section].dispHS)
                cell.battingStrikeRate.text = String(format:"%.1f",self.matches[indexPath.section].strikeRate)
                cell.battingAvg.text = String(format:"%.1f",self.matches[indexPath.section].batAverage)
            
            
                cell.layer.cornerRadius = 10
                cell.layer.masksToBounds = true
                cell.backgroundColor = cricTracTheme.currentTheme.bottomColor
           
            
            return cell
        }
       if tableView == topBowlingTableView {
        
        self.matches.sortInPlace({ $0.totalWicketsTaken > $1.totalWicketsTaken })
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CoachTopBattingBowlingTableViewCell
        
            fetchBasicProfile(self.matches[indexPath.section].playerId, sucess: { (result) in
                let name = "\(result["firstname"]!) \(result["lastname"]!)"
                cell.topBowlingPlayerName.text = name
            })
        
            cell.bowlingMatches.text = String(matches[indexPath.section].totalBowlInnings)
            cell.wickets.text = String(matches[indexPath.section].totalWicketsTaken)
            cell.bestBowling.text = String(matches[indexPath.section].dispBB)
            cell.bowlingAve.text = String(format:"%.1f",matches[indexPath.section].bowlAverage)
            cell.economy.text = String(format:"%.2f",matches[indexPath.section].economy)
        
        
            cell.backgroundColor = cricTracTheme.currentTheme.bottomColor
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
        
        UIColor.whiteColor().CGColor
        
        return cell
        
        }
        return cell!
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CoachTopBattingBowlingTableViewCell
        
        if currentUserId == (currentUser?.uid)! {
            if tableView == topBattingtableView {
                
                self.matches.sortInPlace({ $0.batAverage > $1.batAverage })
                
                let summaryDetailsVC = viewControllerFrom("Main", vcid: "MatchSummaryViewController") as! MatchSummaryViewController
                summaryDetailsVC.playerID = matches[indexPath.section].playerId
                summaryDetailsVC.isCoach = true
                summaryDetailsVC.coachTappedPlayerName = cell.topBattingPlayerName.text!
                self.navigationController?.pushViewController(summaryDetailsVC, animated: false)
            }
            
            if tableView == topBowlingTableView {
                self.matches.sortInPlace({ $0.bowlAverage > $1.bowlAverage })
                
                let summaryDetailsVC = viewControllerFrom("Main", vcid: "MatchSummaryViewController") as! MatchSummaryViewController
                summaryDetailsVC.isCoach = true
                summaryDetailsVC.coachTappedPlayerName = cell.topBowlingPlayerName.text!
                summaryDetailsVC.playerID = matches[indexPath.section].playerId
                self.navigationController?.pushViewController(summaryDetailsVC, animated: false)
            }
        }
    }
   
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }

    @IBAction func pendingRequestsButtonTapped(sender: AnyObject) {
        let pendingRequests = viewControllerFrom("Main", vcid: "CoachPendingRequetsVC") as! CoachPendingRequetsVC
       self.navigationController?.pushViewController(pendingRequests, animated: false)
    }
    
    @IBAction func viewAllForBattingList(sender: UIButton) {
        let battingList = viewControllerFrom("Main", vcid: "TopBattingPlayersList") as! TopBattingPlayersList
        battingList.battingMatches = matches
        self.navigationController?.pushViewController(battingList, animated: false)
    }
    
    @IBAction func viewAllForBowlingList(sender: UIButton) {
        let bowlingList = viewControllerFrom("Main", vcid: "TopBowlingPlayersList") as! TopBowlingPlayersList
        bowlingList.bowlingMatches = matches
        self.navigationController?.pushViewController(bowlingList, animated: false)
    }
    
    @IBAction func CoachSummaryResultTapped(sender: UIButton) {
        
        switch sender.tag {
        case 1:
            if players.count != 0 {
            let playersList = viewControllerFrom("Main", vcid: "CoachPlayersListViewController") as! CoachPlayersListViewController
            playersList.playingRole = "AllPlayers"
            self.navigationController?.pushViewController(playersList, animated: false)
                if currentUserId != (currentUser?.uid)! {
                    self.presentViewController(playersList, animated: false, completion: nil)
                    playersList.friendID = self.friendId!
                }
            }
            
            break
        case 2 :
            
            if batsmen.count != 0 {
                let batsmenList = viewControllerFrom("Main", vcid: "CoachPlayersListViewController") as! CoachPlayersListViewController
                batsmenList.batsmen = batsmen
                batsmenList.playingRole = "Batsmen"
               self.navigationController?.pushViewController(batsmenList, animated: false)
                if currentUserId != (currentUser?.uid)! {
                    self.presentViewController(batsmenList, animated: false, completion: nil)
                    batsmenList.friendID = self.friendId!
                }
                
                
            }
            break
        case 3 :
             if bowlers.count != 0 {
                let bowlersList = viewControllerFrom("Main", vcid: "CoachPlayersListViewController") as! CoachPlayersListViewController
                bowlersList.bowlers = bowlers
                bowlersList.playingRole = "Bowlers"
               self.navigationController?.pushViewController(bowlersList, animated: false)
                if currentUserId != (currentUser?.uid)! {
                    self.presentViewController(bowlersList, animated: false, completion: nil)
                    bowlersList.friendID = self.friendId!
                }
                
             }
            
            break
        case 4 :
             if wicketKeepers.count != 0 {
                let wicketsList = viewControllerFrom("Main", vcid: "CoachPlayersListViewController") as! CoachPlayersListViewController
                wicketsList.wicketsKeepers = wicketKeepers
                wicketsList.playingRole = "WicketKeeper"
                self.navigationController?.pushViewController(wicketsList, animated: false)
                if currentUserId != (currentUser?.uid)! {
                    self.presentViewController(wicketsList, animated: false, completion: nil)
                    wicketsList.friendID = self.friendId!
                }
             }
            break
            

        default:
            
            if allRounders.count != 0 {
                let allRoundersList = viewControllerFrom("Main", vcid: "CoachPlayersListViewController") as! CoachPlayersListViewController
                allRoundersList.allrounders = allRounders
                allRoundersList.playingRole = "AllRounder"
                self.navigationController?.pushViewController(allRoundersList, animated: false)
                if currentUserId != (currentUser?.uid)! {
                    self.presentViewController(allRoundersList, animated: false, completion: nil)
                    allRoundersList.friendID = self.friendId!
                }
            }
            break
        }
     }
  
}
