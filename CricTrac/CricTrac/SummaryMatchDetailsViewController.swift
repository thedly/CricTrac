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

class SummaryMatchDetailsViewController: UIViewController,CTAlertDelegate,ThemeChangeable {

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
        
        showCTAlert("Match Data will be Permanantly Deleted from the Database")
       
    }
    
    
    func cancelClicked() {
        
    }
    
    func okClicked() {
        
    deleteMatch()
        
    }
    
    func deleteMatch(){
        
        KRProgressHUD.show(progressHUDStyle: .White, message: "Deleting...")
        let matchKey = matchDetailsData["key"]! as! String
        
        deleteMatchData(matchKey) { (error) in
            
            KRProgressHUD.dismiss()
            
            if error != nil{
                SCLAlertView().showError("Error",subTitle:error!.localizedDescription)
            }
            else{
                NSNotificationCenter.defaultCenter().postNotificationName("MatchDataChanged", object: self)
                self.dismissViewControllerAnimated(true, completion: { })
            }
        }
        
    }
    
    
    @IBAction func didTapEditButton(sender: AnyObject) {
        
        let editMatch = viewController("AddMatchDetailsViewController") as! AddMatchDetailsViewController
        
        editMatch.selecetedData = matchDetailsData
        
        presentViewController(editMatch, animated: true) {}
    }
    
    @IBAction func didTapCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        
        //setUIBackgroundTheme(self.view)
        
        setColorForViewsWithSameTag(battingView)
        setColorForViewsWithSameTag(bowlingView)
        
//        for view in viewsWithSameTagId {
//            view?.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: bottomColor))
//        }
        
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
    
    func calculateStrikeRate(){
        
        if batRuns.text?.trimWhiteSpace.length == 0{
           strikeRateText.text = ""
        }
        else if ballsFaced.text?.trimWhiteSpace.length == 0{
            strikeRateText.text = ""
        }
        else{
            setStrikeRate()
        }
    }
    
    func setStrikeRate(){
        
        if let runs = Double((batRuns.text?.trimWhiteSpace)!){
            if let balls = Double((ballsFaced.text?.trimWhiteSpace)!){
                
                strikeRateText.text = String(format: "%.0f",((runs*100)/balls))
            }
            
        }
    }
    
    func initializeView() {
        
        
        if let Runs = matchDetailsData["RunsTaken"] {
            
            let formattedString = NSMutableAttributedString()
            
            formattedString.bold(Runs as! String, fontName: appFont_black, fontSize: 83)
            
            if let Balls = matchDetailsData["BallsFaced"] {
                formattedString.bold("(\(Balls))", fontName: appFont_bold, fontSize: 30)
            }
                
            batRuns.attributedText = formattedString
            
        }
        if let Fours = matchDetailsData["Fours"] {
            fours.text = Fours as! String
        }
        if let Sixes = matchDetailsData["Sixes"] {
            sixes.text = Sixes as! String
        }
        
        if let eco = matchDetailsData["Economy"] {
            economy.text = eco as! String
        }
        if let position = matchDetailsData["Position"] {
            ballsFaced.text = position as! String
        }
        if let Wides = matchDetailsData["Wides"] {
            wides.text = Wides as! String
        }
        if let Noballs = matchDetailsData["NoBalls"] {
            noBalls.text = Noballs as! String
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
            
            formattedString.bold("  \(dat)  ", fontName: appFont_bold, fontSize: 12)
            
            if let grnd = matchDetailsData["Ground"] {
                
                formattedString.appendAttributedString(groundAttachmentString)
                formattedString.bold("  \(grnd)", fontName: appFont_bold, fontSize: 12)
                
            }
            
            
            matchDateAndVenue.attributedText = formattedString
            
            
            
            //self.date.text = dat as! String
        }
        
        
        if let dat = matchDetailsData["Achievements"] {
            self.achievements.text = dat as! String
        }
        
        
        calculateStrikeRate()
        
        if let Overs: String = matchDetailsData["Maidens"] as! String { // in overs eg: 2, 3, 4
            
//            if let oversInt = Int(Overs) {
//                
//                let totalBalls = 6*oversInt
//                
//                let oversFromBallsInt = Int(totalBalls/6) // 12, 18
//                let oversFromBallsRealRemaining = totalBalls - (6*oversFromBallsInt)
//                
//                overs.text = String("\(oversFromBallsInt).\(oversFromBallsRealRemaining)")
//            }
            
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

//        if let Ground = matchDetailsData["Ground"] {
//            ground.text = "@ \(Ground)"
//        }
        
        
        
//        if let toss = matchDetailsData["Toss"]{
//            
//            if toss != "-" {
//                self.toss.text = "Toss won by \(toss)"
//            }
//            else
//            {
//                self.toss.text = "Toss details NA"
//            }
//        }
        
        if let tournament = matchDetailsData["Tournament"]{
            
            let formattedString = NSMutableAttributedString()
            
            var tournamentText = NSAttributedString()
            
            
            var group = ""
            
            if let dat = matchDetailsData["Level"] {
                group.appendContentsOf("\(dat)")
            }
            
            if let stage = matchDetailsData["Stage"] {
                group.appendContentsOf("  |  \(stage)")
                
            }
            
            if let dat = matchDetailsData["AgeGroup"] {
                group.appendContentsOf("  |  \(dat)")
                
            }
            
            if let ovrs = matchDetailsData["MatchOvers"] {
                group.appendContentsOf("  |  \(ovrs) Overs")
                
            }
            
            
            
            if tournament as! String == "-"{
                if let opponent = matchDetailsData["Opponent"] {
                    
                    tournamentText = formattedString.bold("VS \(opponent)", fontName: appFont_black, fontSize: 17).bold("\n\(group)", fontName: appFont_bold, fontSize: 13)
                    
                }
                else
                {
                    tournamentText = formattedString.bold("Unknown Tournament", fontName: appFont_black, fontSize: 17).bold("\n\(group)", fontName: appFont_bold, fontSize: 13)
                    
                }
            }
            else{
                
                tournamentText = formattedString.bold("\(tournament)", fontName: appFont_black, fontSize: 17).bold("\n\(group)", fontName: appFont_bold, fontSize: 13)
                
            }
            
            
            tournamentName.attributedText = tournamentText
            
            
            
        }
        
        var firstTeamScore = "-"
        var secondTeamScore = "-"
        
        if let hTeam: String = matchDetailsData["Team"] as! String {
            if hTeam != "-" {
                homeTeam.text = hTeam as! String
            }
            else
            {
                homeTeam.text = "Unknown"
            }
            
            if let opponent: String = matchDetailsData["Opponent"] as! String {
                if opponent != "-" {
                    awayTeam.text = opponent as! String
                }
                else
                {
                    awayTeam.text = "Unknown"
                }
            }
            
            
            
            
            if let firstScore = matchDetailsData["FirstBattingScore"] {
                if let firstWickets = matchDetailsData["FirstBattingWickets"] {
                    
                    let firstTeamOvers: String = (matchDetailsData["FirstBattingOvers"] ?? "-") as! String
                    homeTeam.text?.appendContentsOf("\n\(firstScore)/\(firstWickets)\n(\(firstTeamOvers))")
                }
                
                firstTeamScore = firstScore as! String
            }
            
            if let secondScore = matchDetailsData["SecondBattingScore"] {
                if let secondWickets = matchDetailsData["SecondBattingWickets"] {
                    
                    let secondTeamOvers: String = (matchDetailsData["SecondBattingOvers"] ?? "-") as! String
                    
                    awayTeam.text?.appendContentsOf("\n\(secondScore)/\(secondWickets)\n(\(secondTeamOvers))")
                }
                
                secondTeamScore = secondScore as! String
            }

        }
        
        
        if let firstScore = Int(firstTeamScore), let secondScore = Int(secondTeamScore) {
            if firstScore > secondScore {
                result.text = "\(matchDetailsData["Team"]!) Won"
            }
            else if firstScore < secondScore
            {
                result.text = "\(matchDetailsData["Opponent"]!) Won"
            }
            else if firstScore == secondScore {
                result.text = "Match tied"
            }
        }
        
        if let wicketstaken = matchDetailsData["WicketsTaken"] {
            
            let formattedString = NSMutableAttributedString()
            
            formattedString.bold(wicketstaken as! String, fontName: appFont_black, fontSize: 83)
            
            if let runsGiven = matchDetailsData["RunsGiven"] {
                formattedString.bold("-\(runsGiven)", fontName: appFont_bold, fontSize: 83)
            }
            
            if let oversBowled = matchDetailsData["OversBowled"] as? String {
                
                if let oversInt = Int(oversBowled) {
                    
                    let totalBalls = 6*oversInt
                    
                    let oversFromBallsInt = Int(totalBalls/6) // 12, 18
                    let oversFromBallsRealRemaining = totalBalls - (6*oversFromBallsInt)
                    
                   formattedString.bold("(\(oversFromBallsInt).\(oversFromBallsRealRemaining))", fontName: appFont_bold, fontSize: 30)
                }
                
                
                
            }
            
            totalWickets.attributedText = formattedString
            
            
//            if let RunsGiven = matchDetailsData["RunsGiven"] {
//                
//                 totalWickets.text = "\(wicketstaken)-\(RunsGiven)"
//            }
//            else
//            
//            {
//                totalWickets.text = "\(wicketstaken)-NA"
//            }
            
            
            
            
            
           
        }
        
        
//        if let Position = matchDetailsData["Position"] {
//            batPos.text = Position
//        }
//        if let Dismissal = matchDetailsData["Dismissal"] {
//            dismissal.text = Dismissal.lowercaseString
//        }
//        if let OversBalled = matchDetailsData["OversBalled"] {
//            oversBowled.text = OversBalled
//        }
        
        
//        if let date = matchDetailsData["Date"]{
//            let dateArray = date.characters.split{$0 == "/"}.map(String.init)
//            self.date.text = "\(dateArray[0]) \(dateArray[1].monthName) \(dateArray[2])"
//        }
    
    }
    
    // MARK: - Table Delegate methods
    
    
    
    //MARK: - Service Calls 
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
