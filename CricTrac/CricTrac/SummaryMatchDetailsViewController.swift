  //
//  SummaryMatchDetailsViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 23/07/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import SCLAlertView
import KRProgressHUD
import GoogleMobileAds

class SummaryMatchDetailsViewController: UIViewController,ThemeChangeable,previousRefershable,UIActionSheetDelegate {
    @IBOutlet weak var matchDetailsTbl: UITableView!
    @IBOutlet weak var screenShotHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ScreenShot: UIView!
    @IBAction func backBtnPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    // MARK: - Variables and constants
    @IBOutlet weak var batRuns: UILabel!
    @IBOutlet weak var ballsFaced: UILabel!
    @IBOutlet weak var sixes: UILabel!
    @IBOutlet weak var matchDateAndVenue: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var matchBetween: UILabel!
    @IBOutlet weak var ground: UILabel!
    @IBOutlet weak var tournamentName: UILabel!
    @IBOutlet weak var overs: UILabel!
    @IBOutlet weak var totalWickets: UILabel!
    @IBOutlet weak var wides: UILabel!
    @IBOutlet weak var batPos: UILabel!
    @IBOutlet weak var fours: UILabel!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var toss: UILabel!
    @IBOutlet weak var economy: UILabel!
    @IBOutlet weak var noBalls: UILabel!
    @IBOutlet weak var dismissal: UILabel!
    @IBOutlet weak var awayTeam: UILabel!
    @IBOutlet weak var homeTeam: UILabel!
    @IBOutlet weak var strikeRateText: UILabel!
    @IBOutlet weak var runsGiven: UILabel!
    @IBOutlet weak var oversBowled: UILabel!
    @IBOutlet weak var achievements: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var ageGroup: UILabel!
    var matchDetailsData : [String:AnyObject]!
    var battingViewHidden : Bool! = false
    var bowlingViewHidden : Bool!  = false
    @IBOutlet weak var battingView: UIView!
    @IBOutlet weak var bowlingView: UIView!
    @IBOutlet weak var summarizedView: UIView!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var barViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var matchEditButton: UIButton!
    var friendProfile: Bool!  = false
    @IBOutlet weak var matchDetailsTitle: UILabel!
    @IBOutlet weak var matchDetailsBack: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var firstTeamTossBtn: UIButton!
    @IBOutlet weak var secondTeamTossBtn: UIButton!
    
    // palyer and coach analysis
    @IBOutlet weak var selfAnalysisHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selfAnalysisTextView: UITextView!
    var friendDOB = ""
    @IBOutlet weak var selfAnalysisTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var coachAnalysisViewHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var coachAnalysisTextView: UITextView!
    @IBOutlet weak var coachAnalysisTextViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var selfAnalysisView: UIView!
    @IBOutlet weak var coachAnalysisView: UIView!
    @IBOutlet weak var additionalInfoView: UIView!
    
    // Fielding
    @IBOutlet weak var fieldingRole: UILabel!
    @IBOutlet weak var sumpingsText: UILabel!
    @IBOutlet weak var catchesText: UILabel!
    @IBOutlet weak var runoutsText: UILabel!
    @IBOutlet weak var additionalInfoViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var fieldingRoleView: UIView!
    @IBOutlet weak var fieldingRoleViewHeightConstaraint: NSLayoutConstraint!
    
    var isFriendDashboard: Bool!  = false
    var isCoach: Bool! = false
    var playerDob = ""

    
    @IBAction func deleteActionPressed(sender: UIButton) {
        
        let actionSheetController = UIAlertController(title: "", message: "Are you sure you want to delete this match?", preferredStyle: .ActionSheet)
        
        // Create and add the Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            // Just dismiss the action sheet
            actionSheetController.dismissViewControllerAnimated(true, completion: nil)
        }
        actionSheetController.addAction(cancelAction)
        
        // Create and add first option action
        let takePictureAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
            self.deleteMatch()
        }
        actionSheetController.addAction(takePictureAction)

        // We need to provide a popover sourceView when using it on iPad
        actionSheetController.popoverPresentationController?.sourceView = sender as UIView
        
        // Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if isFriendDashboard == false {
            UpdateDashboardDetails()
        }
        setNavigationBarProperties()
        setBackgroundColor()
    }
    
    func deleteMatch(){
        //KRProgressHUD.show(progressHUDStyle: .White, message: "Deleting...")
        if let matchKey = matchDetailsData["MatchId"] as? String{
            deleteMatchData(matchKey) { (error) in
                //KRProgressHUD.dismiss()
                if error != nil{
                    SCLAlertView().showError("Error",subTitle:error!.localizedDescription)
                }
                else{
                    NSNotificationCenter.defaultCenter().postNotificationName("MatchDataChanged", object: self)
                    self.dismissViewControllerAnimated(true, completion: { })
                    self.navigationController?.popViewControllerAnimated(true)
                }
                //UpdateDashboardDetails()
            }
        }
    }
    
    func setNavigationBarProperties(){
        var currentTheme:CTTheme!
        currentTheme = cricTracTheme.currentTheme
        let menuButton: UIButton = UIButton(type:.Custom)
        menuButton.setImage(UIImage(named: "Back-100"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: #selector(didTapCancel), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        //assign button to navigationbar
        
        navigationItem.leftBarButtonItem = leftbarButton
        
        if isFriendDashboard == false {
            
            let addNewMatchButton: UIButton = UIButton(type:.Custom)
            addNewMatchButton.frame = CGRectMake(0, 0, 40, 40)
            addNewMatchButton.setImage(UIImage(named: "Edit-100"), forState: UIControlState.Normal)
            addNewMatchButton.titleLabel?.font = UIFont(name: appFont_bold, size: 15)
            addNewMatchButton.addTarget(self, action: #selector(didTapEditButton), forControlEvents:UIControlEvents.TouchUpInside)
            let righttbarButton = UIBarButtonItem(customView: addNewMatchButton)
            navigationItem.rightBarButtonItem = righttbarButton

            navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
            title = "SCORECARD"

            if profileData.UserProfile == "Coach" {
                self.bottomView.hidden = true
                self.bannerViewHeightConstraint.constant = 50
                self.bottomViewHeightConstraint.constant = 0
            }
            else {
                self.bottomView.hidden = false
                self.bannerViewHeightConstraint.constant = 0
                self.bottomViewHeightConstraint.constant = 50
            }
            
        }
        else {
            barView.backgroundColor = currentTheme.topColor
            matchDetailsTitle.text! = "SCORECARD"
            matchEditButton.hidden = true
            matchDetailsBack.addTarget(self, action: #selector(didTapCancelOthers), forControlEvents: UIControlEvents.TouchUpInside)
            self.bannerViewHeightConstraint.constant = 50
            self.bottomView.hidden = true
            self.bottomViewHeightConstraint.constant = 0
        }
         title = "SCORECARD"
       
//        if friendProfile == false {
//            self.bottomView.hidden = false
//        }
//        else {
//           self.bottomView.hidden = true
//        }
        //let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    
    
    @IBAction func didTapEditButton(sender: AnyObject) {
        let editMatch = viewController("AddMatchDetailsViewController") as! AddMatchDetailsViewController
        editMatch.selecetedData = matchDetailsData
        editMatch.previous = self
        editMatch.matchBeingEdited = true
        self.navigationController?.pushViewController(editMatch, animated: true)
        //presentViewController(editMatch, animated: true) {}
       // presentViewController(editMatch, animated: true) {}
    }
    
    @IBAction func didTapCancelOthers(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func didTapCancel(sender: AnyObject) {
        //dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func ShareActionPressed(sender: UIButton) {
        print(self.ScreenShot.bounds.size)
        UIGraphicsBeginImageContext(self.ScreenShot.bounds.size);
        self.ScreenShot.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
        let itemsToShare = screenShot
        let actCtrl = UIActivityViewController(activityItems: [itemsToShare!], applicationActivities: nil)
        actCtrl.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeMessage, UIActivityTypeMail]
        presentViewController(actCtrl, animated: true, completion: nil)
    }
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.boxColor
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setNavigationBarProperties()
        //setUIBackgroundTheme(self.view)
        setColorForViewsWithSameTag(battingView)
        setColorForViewsWithSameTag(bowlingView)
        setColorForViewsWithSameTag(bottomView)
        setColorForViewsWithSameTag(selfAnalysisView)
        setColorForViewsWithSameTag(coachAnalysisView)
        setColorForViewsWithSameTag(additionalInfoView)
        setColorForViewsWithSameTag(fieldingRoleView)

        self.summarizedView.alpha = 1
        self.summarizedView.backgroundColor = cricTracTheme.currentTheme.bottomColor
        initializeView()
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = true
        
        loadBannerAds()
    }
    
        override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
          if  matchDetailsData["SelfAnalysis"] as? String != "" && matchDetailsData["SelfAnalysis"] != nil {
        let contentSize = self.selfAnalysisTextView.sizeThatFits(self.selfAnalysisTextView.bounds.size)
        var frame = self.selfAnalysisTextView.frame
        frame.size.height = contentSize.height
        
            self.selfAnalysisTextView.frame = frame
            let aspectRatioTextViewConstraint = NSLayoutConstraint(item: self.selfAnalysisTextView, attribute: .Height, relatedBy: .Equal, toItem: self.selfAnalysisTextView, attribute: .Width, multiplier: selfAnalysisTextView.bounds.height/selfAnalysisTextView.bounds.width, constant: 1)
            self.selfAnalysisTextView.addConstraint(aspectRatioTextViewConstraint)
             self.selfAnalysisHeightConstraint.constant = contentSize.height + 15
            }
        
        // coach analysis
            if matchDetailsData["CoachAnalysis"] as? String != "" && matchDetailsData["CoachAnalysis"] != nil {
                let contentSize1 = self.coachAnalysisTextView.sizeThatFits(self.coachAnalysisTextView.bounds.size)
                var frame1 = self.coachAnalysisTextView.frame
                frame1.size.height = contentSize1.height
                
                    self.coachAnalysisTextView.frame = frame1
                    
                    let aspectRatioTextViewConstraint1 = NSLayoutConstraint(item: self.coachAnalysisTextView, attribute: .Height, relatedBy: .Equal, toItem: self.coachAnalysisTextView, attribute: .Width, multiplier: coachAnalysisTextView.bounds.height/coachAnalysisTextView.bounds.width, constant: 1)
                    self.coachAnalysisTextView.addConstraint(aspectRatioTextViewConstraint1)
                    self.coachAnalysisTextViewHeightConstraint.constant = contentSize1.height
                    self.coachAnalysisViewHeightConstarint.constant = contentSize1.height + 15
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setStrikeRate(){
        if let runs = matchDetailsData["RunsTaken"] as? String where runs != "-" {
            if let balls = matchDetailsData["BallsFaced"] as? String {
                if balls == "0" {
                    strikeRateText.text = "0.0"
                }
                else {
                    strikeRateText.text = String(format: "%.1f",(Float(runs)!)*100/Float(balls)!)
                }
            }
        }
    }
    
    func setEconomy(){
        if let balls = matchDetailsData["OversBowled"] as? String where balls != "-" {
            if let runs = matchDetailsData["RunsGiven"] as? String {
                guard let ball = Float(balls) where ball > 0 else {
                    return
                }
                economy.text = String(format: "%.1f",(Float(runs)!)/Float(balls)!)
            }
        }
    }
    
    func setResult(){
        
        if matchDetailsData["Result"]! as! String == "Abandoned" {
            result.text = "Match Abandoned"
        }
        else if matchDetailsData["Result"]! as! String == "No Result" {
            result.text = "No Result"
        }
        else if matchDetailsData["Result"]! as! String == "Tied" {
           result.text = "Match Tied"
        }
        else {
            result.text = "\(matchDetailsData["Team"]!) \(matchDetailsData["Result"]!)"
        }
        
        // for feilding
        
        if matchDetailsData["FieldingRole"] != nil {
            // fieldingRole.text!.uppercaseString
            if matchDetailsData["FieldingRole"] as! String != "-" {
                let roleText = matchDetailsData["FieldingRole"] as! String
                fieldingRole.text! = roleText.uppercaseString
                fieldingRoleViewHeightConstaraint.constant = 22
            }
            else {
                fieldingRoleViewHeightConstaraint.constant = 0
                 fieldingRole.text = ""
            }
            
            //fieldingRole.textColor = UIColor.whiteColor()
           
        }
        else {
            fieldingRoleViewHeightConstaraint.constant = 0
        }
        
        if matchDetailsData["Stumpings"] != nil && matchDetailsData["Catches"]  != nil && matchDetailsData["Runouts"] != nil {
            if (matchDetailsData["Stumpings"]!) as! String == "0" && (matchDetailsData["Catches"]!) as! String == "0" && (matchDetailsData["Runouts"]!) as! String == "0" {
                additionalInfoView.hidden = true
                additionalInfoViewHeightConstraint.constant = 0
            }
            else {
                additionalInfoView.hidden = false
                additionalInfoViewHeightConstraint.constant = 84
                sumpingsText.text = (matchDetailsData["Stumpings"]!) as? String
                catchesText.text = (matchDetailsData["Catches"]!) as? String
                runoutsText.text = (matchDetailsData["Runouts"]!) as? String
            }
        }
        else {
            additionalInfoView.hidden = true
            additionalInfoViewHeightConstraint.constant = 0
        }
        // sravani for self and coach analysis
        
        if matchDetailsData["SelfAnalysis"] as? String != "" && matchDetailsData["SelfAnalysis"] != nil {
            selfAnalysisTextView.text = (matchDetailsData["SelfAnalysis"]!) as! String
            selfAnalysisTextView.textColor = UIColor.whiteColor()
            selfAnalysisTextView.font = UIFont(name:"SourceSansPro-Bold",size: 15)
            selfAnalysisHeightConstraint.constant = 60
            selfAnalysisView.hidden = false
        }
        else {
            selfAnalysisHeightConstraint.constant = 0
             selfAnalysisView.hidden = true
        }
        if matchDetailsData["CoachAnalysis"] as? String != "" && matchDetailsData["CoachAnalysis"] != nil {
        coachAnalysisTextView.text = (matchDetailsData["CoachAnalysis"]!) as! String
        selfAnalysisTextView.textColor = UIColor.whiteColor()
        selfAnalysisTextView.font = UIFont(name:"SourceSansPro-Bold",size: 15)
        
        coachAnalysisTextView.textColor = UIColor.whiteColor()
        coachAnalysisTextView.font = UIFont(name:"SourceSansPro-Bold",size: 15)
        coachAnalysisViewHeightConstarint.constant = 60
            coachAnalysisView.hidden = false
        }
        else {
           coachAnalysisViewHeightConstarint.constant = 0
            coachAnalysisView.hidden = true
        }

    }
    
    func initializeView() {
        if let runs = matchDetailsData["RunsTaken"] as? String  where runs != "-" {
            let formattedString = NSMutableAttributedString()
            if let dismissal = matchDetailsData["Dismissal"] as? String where dismissal != "Not out" {
                self.dismissal.text = "(\(dismissal))"
            }
            if  let dismissal = matchDetailsData["Dismissal"] as? String where dismissal == "Not out"{
                formattedString.bold(runs+"*" , fontName: appFont_black, fontSize: 83)
            }
            else{
                 formattedString.bold(runs , fontName: appFont_black, fontSize: 83)
            }
            
            let fullRange = NSRange(location: 0,length: formattedString.length)
           // let batLength = formattedString.length
            
            if let Balls = matchDetailsData["BallsFaced"] {
                formattedString.bold("(\(Balls))", fontName: appFont_bold, fontSize: 30)
//                let ballRange = NSRange(location: batLength,length: formattedString.length-batLength)
                formattedString.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(float:-14), range: fullRange)
//                formattedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(hex: "1a6a00") , range: ballRange)
            }
                
            batRuns.attributedText = formattedString
        }
        if let Fours = matchDetailsData["Fours"] as? String{
            fours.text = Fours
        }
        if let Sixes = matchDetailsData["Sixes"] as? String{
            sixes.text = Sixes
        }
        
        if let eco = matchDetailsData["Economy"] as? String {
            economy.text = eco
        }
        if let position = matchDetailsData["Position"] as? String {
            ballsFaced.text = position
        }
        if let Wides = matchDetailsData["Wides"] as? String{
            wides.text = Wides
        }
        if let Noballs = matchDetailsData["NoBalls"] as? String{
            noBalls.text = Noballs
        }
        
        if let dat = matchDetailsData["MatchDate"] {
            var dob = ""
                if isFriendDashboard == false {
                        if isCoach == true {
                            dob = playerDob
                        }
                        else{
                             dob = profileData.DateOfBirth
                        }
                    }
               
                else{
                    dob = friendDOB
                }
            
            let dateFormater = NSDateFormatter()
            dateFormater.dateFormat = "dd-MM-yyyy"
            let birthdayDate = dateFormater.dateFromString(dob)
            
            let date = dat
            let matchDate = dateFormater.dateFromString(date as! String)
            
            let dateImageAttachment = NSTextAttachment()
            dateImageAttachment.image = UIImage(named: "Calendar-100")
            let dateAttachmentString = NSAttributedString(attachment: dateImageAttachment)
            
            let groundImageAttachment = NSTextAttachment()
            groundImageAttachment.image = UIImage(named: "Marker-100 (1)")
            let groundAttachmentString = NSAttributedString(attachment: groundImageAttachment)
            
            let formattedString = NSMutableAttributedString()
            formattedString.appendAttributedString(dateAttachmentString)
            formattedString.bold("  \(dat)  ", fontName: appFont_bold, fontSize: 15)
            let calender:NSCalendar  = NSCalendar.currentCalendar()
            
            let matchMonth = calender.component(.Month, fromDate: matchDate!)
            let birthmonth = calender.component(.Month, fromDate: birthdayDate!)
            
            var years = calender.component(.Year, fromDate: matchDate!) - calender.component(.Year, fromDate: birthdayDate!)
            
            var months = matchMonth - birthmonth
            
            if months < 0 {
                years = years - 1
                months = 12 - birthmonth + matchMonth
                if calender.component(.Day, fromDate: matchDate!) < calender.component(.Day, fromDate: birthdayDate!){
                    months = months - 1
                }
            }
            else if months == 0 && calender.component(.Day, fromDate: matchDate!) < calender.component(.Day, fromDate: birthdayDate!)
            {
                years = years - 1
                months = 11
            }
            
            let ageStr = "Age on Match: \(years) yrs \(months) months"
           
            formattedString.bold(" |  \(ageStr)\n", fontName: appFont_bold, fontSize: 15)
            
            let groundData = matchDetailsData["Ground"] as? String
            let formattedString1 = NSMutableAttributedString()
            if let grnd = matchDetailsData["Ground"] as? String where grnd != "-" {
                formattedString1.appendAttributedString(groundAttachmentString)
                formattedString1.bold(" \(grnd)", fontName: appFont_bold, fontSize: 15)
            }
            
            if let venue = matchDetailsData["Venue"] as? String where venue != "-"  {
                if groundData == "-" {
                    formattedString1.appendAttributedString(groundAttachmentString)
                }
                    formattedString1.bold(" \(venue)", fontName: appFont_bold, fontSize: 15)
            }
            ground.attributedText = formattedString1
            matchDateAndVenue.attributedText = formattedString
        }
        
        if let dat = matchDetailsData["Achievements"] as? String {
           // if dat != "" {
                self.achievements.text = dat
           // }
        }
        
        setStrikeRate()
        //calculateStrikeRate()
        
        if let Overs: String = matchDetailsData["Maidens"] as? String { // in overs eg: 2, 3, 4
            overs.text = Overs
        }
        
        if let oversBowled = matchDetailsData["OversBowled"] as? String where oversBowled == "-" {
            bowlingViewHidden = true
            self.bowlingView.hidden = true
        }
        else {
            bowlingViewHidden = false
            self.bowlingView.hidden = false
        }
        
        if (bowlingViewHidden == true) {
            //self.bowlingView.hidden = true
            self.screenShotHeightConstraint.constant -= 280
        }
        else{
            self.screenShotHeightConstraint.constant += 240
        }
        
        if let runs = matchDetailsData["RunsTaken"] as? String where runs == "-" {
            battingViewHidden = true
            self.battingView.hidden = true
        }
        else {
            battingViewHidden = false
            self.battingView.hidden = false
        }
        
        if (battingViewHidden == true) {
            //self.battingView.hidden = true
            self.screenShotHeightConstraint.constant -= 240
        }
        else {
            self.screenShotHeightConstraint.constant += 240
        }
        
        var group = ""
        
            let formattedString = NSMutableAttributedString()
            var tournamentText = NSAttributedString()
        
            if let tournament = matchDetailsData["Tournament"] as? String where tournament != "-" {
                group.appendContentsOf("\(tournament)\n")
            }
        
            if let agegroup = matchDetailsData["AgeGroup"] as? String where agegroup != "-"  {
                group.appendContentsOf("\(agegroup)")
            }
        
            if let level = matchDetailsData["Level"] as? String where level != "-"  {
                group.appendContentsOf("  |  \(level)")
            }
            
            if let stage = matchDetailsData["MatchStage"] as? String where stage != "-"  {
                group.appendContentsOf("  |  \(stage)")
            }
        
            if let overs = matchDetailsData["MatchOvers"] as? String where overs != "-"  {
                group.appendContentsOf("  |  \(overs) Overs")
            }
            
            //if let val =  tournament as? String where val != "-"{
               //tournamentText = formattedString.bold("\(tournament)", fontName: appFont_black, fontSize: 19).bold("\n\(group)", fontName: appFont_bold, fontSize: 15)
            //}
            tournamentText = formattedString.bold("\(group)", fontName: appFont_bold, fontSize: 15)
               tournamentName.attributedText = tournamentText
        
        var firstTeamScore = "-"
        var secondTeamScore = "-"
        
        if let hTeam: String = matchDetailsData["FirstBatting"] as? String {
            if hTeam != "-" {
                if hTeam == matchDetailsData["TossWonBy"] as? String {
                    firstTeamTossBtn.hidden = false
                   
                }
                else {
                    firstTeamTossBtn.hidden = true
                }
                if hTeam.length > 15 {
                    var subString =  hTeam[hTeam.startIndex.advancedBy(0)...hTeam.startIndex.advancedBy(15)]
                    subString = subString.stringByAppendingString("..")
                    homeTeam.text = subString
                }
                else {
                    homeTeam.text = hTeam
                }
            }
            else
            {
                homeTeam.text = "Unknown"
            }
            
            if let opponent: String = matchDetailsData["SecondBatting"] as? String {
                if opponent != "-" {
                    if opponent == matchDetailsData["TossWonBy"] as? String {
                        secondTeamTossBtn.hidden = false
                    }
                    else {
                        secondTeamTossBtn.hidden = true
                    }
                    if opponent.length > 15 {
                        var subString =  opponent[opponent.startIndex.advancedBy(0)...opponent.startIndex.advancedBy(15)]
                        subString = subString.stringByAppendingString("..")
                        awayTeam.text = subString
                    }
                    else {
                        awayTeam.text = opponent
                    }
                }
                else
                {
                    awayTeam.text = "Unknown"
                    
                }
            }
            
            if let firstScore = matchDetailsData["FirstBattingScore"] {
                if let firstWickets = matchDetailsData["FirstBattingWickets"] {
                    let firstTeamOvers: String = (matchDetailsData["FirstBattingOvers"] ?? "-") as! String
                    homeTeam.text?.appendContentsOf("\n\(firstScore)/\(firstWickets)\n\(firstTeamOvers) Overs")
                }
                firstTeamScore = firstScore as! String
            }
            
            if let secondScore = matchDetailsData["SecondBattingScore"] {
                if let secondWickets = matchDetailsData["SecondBattingWickets"] {
                    let secondTeamOvers: String = (matchDetailsData["SecondBattingOvers"] ?? "-") as! String
                    awayTeam.text?.appendContentsOf("\n\(secondScore)/\(secondWickets)\n\(secondTeamOvers) Overs")
                    
                }
                secondTeamScore = secondScore as! String
            }
            
            //set White Color for Player's Team and Gray Color for Opponent team
            
            if hTeam == matchDetailsData["Team"] as? String {
               homeTeam.textColor = UIColor.whiteColor()
                awayTeam.textColor = UIColor.blackColor()
            }
            else {
                awayTeam.textColor = UIColor.whiteColor()
                homeTeam.textColor = UIColor.blackColor()
            }

            
        }
        setResult()
        
        //sajith modified the bowling section
        if let oversBowled = matchDetailsData["OversBowled"] as? String  where oversBowled != "-" {
            let formattedString = NSMutableAttributedString()
            formattedString.bold(matchDetailsData["WicketsTaken"] as! String, fontName: appFont_black, fontSize: 83)
            
            if let runsGiven = matchDetailsData["RunsGiven"] {
                formattedString.bold("-\(runsGiven)", fontName: appFont_bold, fontSize: 83)
            }
            
            let fullRange = NSRange(location: 0,length: formattedString.length)
                formattedString.bold("(\(String(format: "%.1f",(Float(oversBowled)!))))", fontName: appFont_bold, fontSize: 30)
                formattedString.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(float:-14), range: fullRange)
            totalWickets.attributedText = formattedString
        }
        setEconomy()
    }
    
    func refresh(data:AnyObject){
        if let value = data as? [String : AnyObject]{
            matchDetailsData = value
            initializeView()
        }
    }
}
