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
    @IBOutlet weak var maidens: UILabel!
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
    
    var battingViewHidden2 : Bool! = true
    var bowlingViewHidden2 : Bool!  = true
    
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
    
    // Second Innings
    @IBOutlet weak var battingView2: UIView!
    @IBOutlet weak var batRuns2: UILabel!
    @IBOutlet weak var ballsFaced2: UILabel!
    @IBOutlet weak var fours2: UILabel!
    @IBOutlet weak var sixes2: UILabel!
    @IBOutlet weak var strikeRateText2: UILabel!
    @IBOutlet weak var dismissal2: UILabel!
    
    @IBOutlet weak var bowlingView2: UIView!
    @IBOutlet weak var economy2: UILabel!
    @IBOutlet weak var wides2: UILabel!
    @IBOutlet weak var totalWickets2: UILabel!
    @IBOutlet weak var noBalls2: UILabel!
    @IBOutlet weak var maidens2: UILabel!
    @IBOutlet weak var secondInningsTextLabel: UILabel!
    
    @IBOutlet weak var firstInningsLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var secondInningsLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var firstInningsStackView: UIStackView!
    
    @IBOutlet weak var secondInningsStatckView: UIStackView!
    
    
    var isFriendDashboard: Bool!  = false
    var isCoach: Bool! = false
    var playerDob = ""
    
    var sizeOne:CGFloat = 10
    var sizeTwo:CGFloat = 20
    var sizeThree:CGFloat = 30
    var sizeFour:CGFloat = 40
    var sizeFive:CGFloat = 50
    
    
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
        
        //        if matchDetailsData["MatchFormat"] as? String != "Double Innings" {
        //            battingView2.hidden = true
        //            bowlingView2.hidden = true
        //            secondInningsTextLabel.hidden = true
        //        }
        //        else {
        //            battingView2.hidden = false
        //            bowlingView2.hidden = false
        //            secondInningsTextLabel.hidden = false
        //        }
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
                //self.bannerViewHeightConstraint.constant = 50
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
            setPlainShadow(barView, color: currentTheme.bottomColor.CGColor)
            matchDetailsTitle.text! = "SCORECARD"
            matchEditButton.hidden = true
            matchDetailsBack.addTarget(self, action: #selector(didTapCancelOthers), forControlEvents: UIControlEvents.TouchUpInside)
            //self.bannerViewHeightConstraint.constant = 50
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
        //print(self.ScreenShot.bounds.size)
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
        self.view.backgroundColor = currentTheme.topColor
        // navigationController!.navigationBar.barTintColor = currentTheme.topColor
        setPlainShadow(firstInningsStackView, color: currentTheme.bottomColor.CGColor)
        setPlainShadow(secondInningsStatckView, color: currentTheme.bottomColor.CGColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if screensize == "1" {
            sizeOne = 10
            sizeTwo = 12
            sizeThree = 20
            sizeFour = 30
            sizeFive = 50
        }
        else if screensize == "2" {
            sizeOne = 10
            sizeTwo = 14
            sizeThree = 20
            sizeFour = 30
            sizeFive = 50
        }
        else if screensize == "3" {
            sizeOne = 10
            sizeTwo = 15
            sizeThree = 30
            sizeFour = 40
            sizeFive = 60
        }
        else if screensize == "4" {
            sizeOne = 20
            sizeTwo = 18
            sizeThree = 40
            sizeFour = 60
            sizeFive = 80
        }
        
        
        setBackgroundColor()
        setNavigationBarProperties()
        //setUIBackgroundTheme(self.view)
        setColorForViewsWithSameTag(battingView)
        setColorForViewsWithSameTag(bowlingView)
        setColorForViewsWithSameTag(battingView2)
        setColorForViewsWithSameTag(bowlingView2)
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
    
    func setStrikeRate2(){
        if let runs = matchDetailsData["RunsTaken2"] as? String where runs != "-" {
            if let balls = matchDetailsData["BallsFaced2"] as? String {
                if balls == "0" {
                    strikeRateText2.text = "0.0"
                }
                else {
                    strikeRateText2.text = String(format: "%.1f",(Float(runs)!)*100/Float(balls)!)
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
    
    func setEconomy2(){
        if let balls = matchDetailsData["OversBowled2"] as? String where balls != "-" {
            if let runs = matchDetailsData["RunsGiven2"] as? String {
                guard let ball = Float(balls) where ball > 0 else {
                    return
                }
                economy2.text = String(format: "%.1f",(Float(runs)!)/Float(balls)!)
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
        
        if matchDetailsData["Stumpings"] != nil && matchDetailsData["Catches"] != nil && matchDetailsData["Runouts"] != nil {
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
            //selfAnalysisTextView.textColor = UIColor.whiteColor()
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
            //selfAnalysisTextView.textColor = UIColor.whiteColor()
            selfAnalysisTextView.font = UIFont(name:"SourceSansPro-Bold",size: 15)
            
            //coachAnalysisTextView.textColor = UIColor.whiteColor()
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
                formattedString.bold(runs+"*" , fontName: appFont_black, fontSize: sizeFive)
            }
            else{
                formattedString.bold(runs , fontName: appFont_black, fontSize: sizeFive)
            }
            
            let fullRange = NSRange(location: 0,length: formattedString.length)
            
            if let Balls = matchDetailsData["BallsFaced"] {
                formattedString.bold("(\(Balls))", fontName: appFont_bold, fontSize: sizeThree)
                formattedString.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(float:-14), range: fullRange)
            }
            
            batRuns.attributedText = formattedString
            
            if let Fours = matchDetailsData["Fours"] as? String{
                fours.text = Fours
            }
            if let Sixes = matchDetailsData["Sixes"] as? String{
                sixes.text = Sixes
            }
            
            if let position = matchDetailsData["Position"] as? String {
                ballsFaced.text = position
            }
            
            setStrikeRate()
        }
        
        //second innings
        if matchDetailsData["MatchFormat"] as? String == "Double Innings" && matchDetailsData["MatchFormat"]  != nil {
            if let runs = matchDetailsData["RunsTaken2"] as? String  where runs != "-" {
                let formattedString = NSMutableAttributedString()
                if let dismissal = matchDetailsData["Dismissal2"] as? String where dismissal != "Not out" {
                    self.dismissal2.text = "(\(dismissal))"
                }
                if  let dismissal = matchDetailsData["Dismissal2"] as? String where dismissal == "Not out"{
                    formattedString.bold(runs+"*" , fontName: appFont_black, fontSize: sizeFive)
                }
                else{
                    formattedString.bold(runs , fontName: appFont_black, fontSize: sizeFive)
                }
                
                let fullRange = NSRange(location: 0,length: formattedString.length)
                
                if let Balls = matchDetailsData["BallsFaced2"] {
                    formattedString.bold("(\(Balls))", fontName: appFont_bold, fontSize: sizeThree)
                    formattedString.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(float:-14), range: fullRange)
                }
                
                batRuns2.attributedText = formattedString
                
                if let Fours = matchDetailsData["Fours2"] as? String{
                    fours2.text = Fours
                }
                if let Sixes = matchDetailsData["Sixes2"] as? String{
                    sixes2.text = Sixes
                }
                
                if let position = matchDetailsData["Position2"] as? String {
                    ballsFaced2.text = position
                }
                
                setStrikeRate2()
            }
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
            firstInningsLabelHeightConstraint.constant = 0
            self.screenShotHeightConstraint.constant -= 240
        }
        else {
            if matchDetailsData["MatchFormat"] as? String == "Double Innings" {
                firstInningsLabelHeightConstraint.constant = 22
            }
            self.screenShotHeightConstraint.constant += 240
        }
        
        // second innings
        if matchDetailsData["MatchFormat"] as? String == "Double Innings" && matchDetailsData["MatchFormat"]  != nil {
            if let runs = matchDetailsData["RunsTaken2"] as? String where runs == "-" {
                battingViewHidden2 = true
                self.battingView2.hidden = true
            }
            else {
                battingViewHidden2 = false
                self.battingView2.hidden = false
            }
            
        }
        
        if (battingViewHidden2 == true) {
           self.battingView2.hidden = true
            secondInningsLabelHeightConstraint.constant = 0
            self.screenShotHeightConstraint.constant -= 190
        }
        else {
             self.battingView2.hidden = false
            secondInningsLabelHeightConstraint.constant = 22
            self.screenShotHeightConstraint.constant += 190
        }
        
        
        //bowling section
        if let oversBowled = matchDetailsData["OversBowled"] as? String  where oversBowled != "-" {
            let formattedString = NSMutableAttributedString()
            formattedString.bold(matchDetailsData["WicketsTaken"] as! String, fontName: appFont_black, fontSize: sizeFive)
            
            if let runsGiven = matchDetailsData["RunsGiven"] {
                formattedString.bold("-\(runsGiven)", fontName: appFont_bold, fontSize: sizeFive)
            }
            
            let fullRange = NSRange(location: 0,length: formattedString.length)
            formattedString.bold("(\(String(format: "%.1f",(Float(oversBowled)!))))", fontName: appFont_bold, fontSize: sizeThree)
            formattedString.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(float:-14), range: fullRange)
            totalWickets.attributedText = formattedString
            
            
            if let Maidens: String = matchDetailsData["Maidens"] as? String {
                maidens.text = Maidens
            }
            
            if let Wides = matchDetailsData["Wides"] as? String{
                wides.text = Wides
            }
            if let Noballs = matchDetailsData["NoBalls"] as? String{
                noBalls.text = Noballs
            }
            
            setEconomy()
        }
        
        //second innings - bowling section
        if matchDetailsData["MatchFormat"] as? String == "Double Innings" && matchDetailsData["MatchFormat"]  != nil {
            
            if let oversBowled = matchDetailsData["OversBowled2"] as? String  where oversBowled != "-" {
                let formattedString = NSMutableAttributedString()
                formattedString.bold(matchDetailsData["WicketsTaken2"] as! String, fontName: appFont_black, fontSize: sizeFive)
                
                if let runsGiven = matchDetailsData["RunsGiven2"] {
                    formattedString.bold("-\(runsGiven)", fontName: appFont_bold, fontSize: sizeFive)
                }
                
                let fullRange = NSRange(location: 0,length: formattedString.length)
                formattedString.bold("(\(String(format: "%.1f",(Float(oversBowled)!))))", fontName: appFont_bold, fontSize: sizeThree)
                formattedString.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(float:-14), range: fullRange)
                totalWickets2.attributedText = formattedString
                
                
                if let Maidens: String = matchDetailsData["Maidens2"] as? String {
                    maidens2.text = Maidens
                }
                
                if let Wides = matchDetailsData["Wides2"] as? String{
                    wides2.text = Wides
                }
                if let Noballs = matchDetailsData["NoBalls2"] as? String{
                    noBalls2.text = Noballs
                }
                
                setEconomy2()
            }
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
            firstInningsLabelHeightConstraint.constant = 0
            self.screenShotHeightConstraint.constant -= 280
        }
        else{
            if matchDetailsData["MatchFormat"] as? String == "Double Innings" {
                firstInningsLabelHeightConstraint.constant = 22
            }
            self.screenShotHeightConstraint.constant += 240
        }
        
        // second innings
        if matchDetailsData["MatchFormat"] as? String == "Double Innings" && matchDetailsData["MatchFormat"]  != nil {
            
            if let oversBowled = matchDetailsData["OversBowled2"] as? String where oversBowled == "-" {
                bowlingViewHidden2 = true
                self.bowlingView2.hidden = true
            }
            else {
                bowlingViewHidden2 = false
                self.bowlingView2.hidden = false
            }
        }
        
        if (bowlingViewHidden2 == true) {
            self.bowlingView2.hidden = true
            secondInningsLabelHeightConstraint.constant = 0
            self.screenShotHeightConstraint.constant -= 190
        }
        else{
             self.bowlingView2.hidden = false
            secondInningsLabelHeightConstraint.constant = 22
            self.screenShotHeightConstraint.constant += 190
        }
        
        if (bowlingViewHidden2 == true && battingViewHidden2 == false) || (bowlingViewHidden2 == false && battingViewHidden2 == true) {
            secondInningsLabelHeightConstraint.constant = 22
        }
        
        // single Innings label 
        if matchDetailsData["MatchFormat"] as? String == "Double Innings" {
            if (bowlingViewHidden == true && battingViewHidden == false) || (bowlingViewHidden == false && battingViewHidden == true)  {
               
                firstInningsLabelHeightConstraint.constant = 22
            }
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
            else {
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
            //formattedString.appendAttributedString(dateAttachmentString)
            formattedString.bold("  \(dat)  ", fontName: appFont_bold, fontSize: sizeTwo)
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
            
            formattedString.bold(" |  \(ageStr)\n", fontName: appFont_bold, fontSize: sizeTwo)
            
            let groundData = matchDetailsData["Ground"] as? String
            let formattedString1 = NSMutableAttributedString()
            if let grnd = matchDetailsData["Ground"] as? String where grnd != "-" {
                //formattedString1.appendAttributedString(groundAttachmentString)
                formattedString1.bold("Venue: \(grnd)", fontName: appFont_bold, fontSize: sizeTwo)
            }
            
            if let venue = matchDetailsData["Venue"] as? String where venue != "-"  {
                //                if groundData == "-" {
                //                    formattedString1.appendAttributedString(groundAttachmentString)
                //                }
                formattedString1.bold(" \(venue)", fontName: appFont_bold, fontSize: sizeTwo)
            }
            ground.attributedText = formattedString1
            matchDateAndVenue.attributedText = formattedString
        }
        
        if let dat = matchDetailsData["Achievements"] as? String {
            // if dat != "" {
            self.achievements.text = dat
            // }
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
        
        tournamentText = formattedString.bold("\(group)", fontName: appFont_bold, fontSize: sizeTwo)
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
            
            // for second innings
            
            if matchDetailsData["MatchFormat"] as? String == "Double Innings" && matchDetailsData["MatchFormat"]  != nil {
                
                if let firstScore = matchDetailsData["FirstBattingScore2"] {
                    if let firstWickets = matchDetailsData["FirstBattingWickets2"] {
                        let firstTeamOvers: String = (matchDetailsData["FirstBattingOvers2"] ?? "-") as! String
                        homeTeam.text?.appendContentsOf("\n\(firstScore)/\(firstWickets)\n\(firstTeamOvers) Overs")
                    }
                    firstTeamScore = firstScore as! String
                }
                
                if let secondScore = matchDetailsData["SecondBattingScore2"] {
                    if let secondWickets = matchDetailsData["SecondBattingWickets2"] {
                        let secondTeamOvers: String = (matchDetailsData["SecondBattingOvers2"] ?? "-") as! String
                        awayTeam.text?.appendContentsOf("\n\(secondScore)/\(secondWickets)\n\(secondTeamOvers) Overs")
                        
                    }
                    secondTeamScore = secondScore as! String
                }
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
    }
    
    func refresh(data:AnyObject){
        if let value = data as? [String : AnyObject]{
            matchDetailsData = value
            initializeView()
        }
    }
}