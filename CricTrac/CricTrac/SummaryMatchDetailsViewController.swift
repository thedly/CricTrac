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
    
    
    
    @IBAction func deleteActionPressed(sender: UIButton) {
        
        let actionSheetController = UIAlertController(title: "", message: "Are you sure to delete ?", preferredStyle: .ActionSheet)
        
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
        setNavigationBarProperties()
        
    }
    
    func deleteMatch(){
        
        KRProgressHUD.show(progressHUDStyle: .White, message: "Deleting...")
        if let matchKey = matchDetailsData["MatchId"] as? String{
            
            deleteMatchData(matchKey) { (error) in
                
                KRProgressHUD.dismiss()
                
                if error != nil{
                    SCLAlertView().showError("Error",subTitle:error!.localizedDescription)
                }
                else{
                    NSNotificationCenter.defaultCenter().postNotificationName("MatchDataChanged", object: self)
                    self.dismissViewControllerAnimated(true, completion: { })
                    
                    self.navigationController?.popViewControllerAnimated(true)
                }
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
        let addNewMatchButton: UIButton = UIButton(type:.Custom)
        addNewMatchButton.frame = CGRectMake(0, 0, 40, 40)
        addNewMatchButton.setImage(UIImage(named: "Edit-100"), forState: UIControlState.Normal)
        addNewMatchButton.titleLabel?.font = UIFont(name: appFont_bold, size: 15)
        addNewMatchButton.addTarget(self, action: #selector(didTapEditButton), forControlEvents: UIControlEvents.TouchUpInside)
        let righttbarButton = UIBarButtonItem(customView: addNewMatchButton)
        
        //assign button to navigationbar
        
        navigationItem.leftBarButtonItem = leftbarButton
        navigationItem.rightBarButtonItem = righttbarButton
        navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
        title = "MATCH DETAILS"
        //let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    
    @IBAction func didTapEditButton(sender: AnyObject) {
        
        let editMatch = viewController("AddMatchDetailsViewController") as! AddMatchDetailsViewController
        
        editMatch.selecetedData = matchDetailsData
        editMatch.previous = self
        editMatch.matchBeingEdited = true
        self.navigationController?.pushViewController(editMatch, animated: true)
      //  presentViewController(editMatch, animated: true) {}
      
       // presentViewController(editMatch, animated: true) {}
    }
    
    @IBAction func didTapCancel(sender: AnyObject) {
       // dismissViewControllerAnimated(true, completion: nil)
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
        
        //setUIBackgroundTheme(self.view)
        
        setColorForViewsWithSameTag(battingView)
        setColorForViewsWithSameTag(bowlingView)

        self.summarizedView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: UIColor().hexFromUIColor(cricTracTheme.currentTheme.bottomColor)))
        self.summarizedView.alpha = 0.8
        initializeView()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func calculateStrikeRate(){
        
        if batRuns.text?.trimWhiteSpace.length == 0{
           strikeRateText.text = ""
        }
        else if ballsFaced.text?.trimWhiteSpace.length == 0{
            strikeRateText.text = ""
        }
        else{
            setStrikeRate()
        }
    }*/
    
    func setStrikeRate(){
        
        if let runs = matchDetailsData["RunsTaken"] as? String where runs != "-" {
            if let balls = matchDetailsData["BallsFaced"] as? String {
                
                //guard let ball = Float(balls) where ball > 0 else {
                //    return
                //}
                
                if balls == "0" {
                    strikeRateText.text = "0.0"
                }
                else {
                    strikeRateText.text = String(format: "%.2f",(Float(runs)!)*100/Float(balls)!)
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
                economy.text = String(format: "%.2f",(Float(runs)!)/Float(balls)!)
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

        
    }
    
    func initializeView() {
        
        
        if let runs = matchDetailsData["RunsTaken"] as? String{
            
            let formattedString = NSMutableAttributedString()
            
            
            
            if let dismissal = matchDetailsData["Dismissal"] as? String where dismissal == "Not out"{
                
                formattedString.bold(runs+"*" , fontName: appFont_black, fontSize: 83)
            }else{
                
                 formattedString.bold(runs , fontName: appFont_black, fontSize: 83)
            }
            
            let fullRange = NSRange(location: 0,length: formattedString.length)
            let batLength = formattedString.length
            
            
            if let Balls = matchDetailsData["BallsFaced"] {
                formattedString.bold("(\(Balls))", fontName: appFont_bold, fontSize: 30)
                let ballRange = NSRange(location: batLength,length: formattedString.length-batLength)
                formattedString.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(float:-14), range: fullRange)
                formattedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(hex: "1a6a00") , range: ballRange)
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
        
            let dateImageAttachment = NSTextAttachment()
            dateImageAttachment.image = UIImage(named: "Calendar-100")
            let dateAttachmentString = NSAttributedString(attachment: dateImageAttachment)
            
            
            let groundImageAttachment = NSTextAttachment()
            groundImageAttachment.image = UIImage(named: "Marker-100 (1)")
            let groundAttachmentString = NSAttributedString(attachment: groundImageAttachment)
            
            let formattedString = NSMutableAttributedString()
            formattedString.appendAttributedString(dateAttachmentString)
            
            formattedString.bold("  \(dat)  ", fontName: appFont_bold, fontSize: 15)
            
            if let grnd = matchDetailsData["Ground"] {
                
                formattedString.appendAttributedString(groundAttachmentString)
                formattedString.bold("  \(grnd)", fontName: appFont_bold, fontSize: 15)
                
            }
            
            if let venue = matchDetailsData["Venue"] as? String where venue != "-"  {
                
                formattedString.bold(", \(venue)", fontName: appFont_bold, fontSize: 15)
                
            }
            
            
            matchDateAndVenue.attributedText = formattedString
        }
        
        
        if let dat = matchDetailsData["Achievements"] as? String {
            if dat != "-" {
                self.achievements.text = dat
            }
            
        }
        
        setStrikeRate()
        //calculateStrikeRate()
        
        if let Overs: String = matchDetailsData["Maidens"] as? String { // in overs eg: 2, 3, 4
            overs.text = Overs
            
        }
        
        if (bowlingViewHidden == true) {
            self.bowlingView.hidden = true
            
            self.screenShotHeightConstraint.constant -= 240
            
        }
        
        if (battingViewHidden == true) {
            self.battingView.hidden = true
            self.screenShotHeightConstraint.constant -= 240
        }

        
        var group = ""
        
        //if let tournament = matchDetailsData["Tournament"]{
            
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
            
            if let stage = matchDetailsData["Stage"] as? String where stage != "-"  {
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
        //}
        
        

        
        var firstTeamScore = "-"
        var secondTeamScore = "-"
        
        if let hTeam: String = matchDetailsData["FirstBatting"] as? String {
            if hTeam != "-" {
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
                print(firstTeamScore)
            }
            
            if let secondScore = matchDetailsData["SecondBattingScore"] {
                if let secondWickets = matchDetailsData["SecondBattingWickets"] {
                    
                    let secondTeamOvers: String = (matchDetailsData["SecondBattingOvers"] ?? "-") as! String
                    
                    awayTeam.text?.appendContentsOf("\n\(secondScore)/\(secondWickets)\n\(secondTeamOvers) Overs")
                }
                
                secondTeamScore = secondScore as! String
                print(secondTeamScore)
            }

        }
        
        
//        if let firstScore = Int(firstTeamScore), let secondScore = Int(secondTeamScore) {
//            if firstScore > secondScore {
//                result.text = "\(matchDetailsData["Team"]!) Won"
//            }
//            else if firstScore < secondScore
//            {
//                result.text = "\(matchDetailsData["Opponent"]!) Won"
//            }
//            else if firstScore == secondScore {
//                result.text = "Match tied"
//            }
//        }
        
        setResult()
        
        if let wicketstaken = matchDetailsData["WicketsTaken"] {
            
            let formattedString = NSMutableAttributedString()
            
            formattedString.bold(wicketstaken as! String, fontName: appFont_black, fontSize: 83)
            
            if let runsGiven = matchDetailsData["RunsGiven"] {
                formattedString.bold("-\(runsGiven)", fontName: appFont_bold, fontSize: 83)
            }
            
            let fullRange = NSRange(location: 0,length: formattedString.length)
            let wicketLength = formattedString.length
            
            if let oversBowled = matchDetailsData["OversBowled"] as? String {
                
                if let oversInt = Int(oversBowled) {
                    
                    let totalBalls = 6*oversInt
                    
                    let oversFromBallsInt = Int(totalBalls/6) // 12, 18
                    let oversFromBallsRealRemaining = totalBalls - (6*oversFromBallsInt)
                    
                   formattedString.bold("(\(oversFromBallsInt).\(oversFromBallsRealRemaining))", fontName: appFont_bold, fontSize: 30)
                    let ballRange = NSRange(location: wicketLength,length: formattedString.length-wicketLength)
                    formattedString.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(float:-14), range: fullRange)
                    formattedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(hex: "1a6a00") , range: ballRange)
                }
            }
            
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
    
    //MARK: Actionsheet delegate
//    
//    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
//    {
//        switch (buttonIndex){
//            
//        case 0:
//            print("Cancel")
//        case 1:
//            print("Save")
//        case 2:
//            print("Delete")
//        default:
//            print("Default")
//            //Some code here..
//            
//        }
//    }
    
}
