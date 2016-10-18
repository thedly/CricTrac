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

class SummaryMatchDetailsViewController: UIViewController,CTAlertDelegate {

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
    
    @IBOutlet weak var runsGiven: UILabel!
    @IBOutlet weak var oversBowled: UILabel!
    
    var matchDetailsData : [String:String]!
    
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
        let matchKey = matchDetailsData["key"]!
        
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
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIBackgroundTheme(self.view)
        
        setColorForViewsWithSameTag(battingView)
        setColorForViewsWithSameTag(bowlingView)
    
        
//        for view in viewsWithSameTagId {
//            view?.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: bottomColor))
//        }
        
        self.summarizedView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: bottomColor))
        
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
    
    func initializeView() {
        
        
        if let Runs = matchDetailsData["Runs"] {
            batRuns.text = Runs
        }
        if let Fours = matchDetailsData["Fours"] {
            fours.text = Fours
        }
        if let Sixes = matchDetailsData["Sixes"] {
            sixes.text = Sixes
        }
        if let Overs = matchDetailsData["OversBalled"] { // in overs eg: 2, 3, 4
            
            if let oversInt = Int(Overs) {
                
                let totalBalls = 6*oversInt
                
                let oversFromBallsInt = Int(totalBalls/6) // 12, 18
                let oversFromBallsRealRemaining = totalBalls - (6*oversFromBallsInt)
                
                
                if let RunsGiven = matchDetailsData["RunsGiven"] where RunsGiven != "-" {
                    let ec = (Double(RunsGiven)!/Double(totalBalls)).roundToPlaces(2)
                    economy.text = String(ec)
                }
                overs.text = String("\(oversFromBallsInt).\(oversFromBallsRealRemaining)")
            }
            
        }
        
        
        
        
        if (bowlingViewHidden == true) {
            self.bowlingView.hidden = true
            
            self.screenShotHeightConstraint.constant -= 200
            
        }
        
        if (battingViewHidden == true) {
            self.battingView.hidden = true
            self.screenShotHeightConstraint.constant -= 200
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
        
        if let tournament = matchDetailsData["Tournamnet"]{
            
            if tournament == "-"{
                if let opponent = matchDetailsData["Opponent"] {
                    tournamentName.text = "VS \(opponent)"
                }
                else
                {
                    tournamentName.text = "Unknown Tournament"
                }
            }
            else{
                tournamentName.text = tournament
            }
            
        }
        
        var firstTeamScore = "-"
        var secondTeamScore = "-"
        
        if let hTeam = matchDetailsData["Team"] {
            if hTeam != "-" {
                homeTeam.text = hTeam
            }
            else
            {
                homeTeam.text = "Unknown"
            }
            
            if let opponent = matchDetailsData["Opponent"] {
                if opponent != "-" {
                    awayTeam.text = opponent
                }
                else
                {
                    awayTeam.text = "Unknown"
                }
            }
            
            
            
            
            if let firstScore = matchDetailsData["FirstScore"] {
                if let firstWickets = matchDetailsData["FirstWickets"] {
                    
                    let firstTeamOvers = matchDetailsData["FirstOvers"] ?? "-"
                    homeTeam.text?.appendContentsOf("\n\(firstScore)/\(firstWickets)\n(\(firstTeamOvers))")
                }
                
                firstTeamScore = firstScore
            }
            
            if let secondScore = matchDetailsData["SecondScore"] {
                if let secondWickets = matchDetailsData["SecondWickets"] {
                    
                    let secondTeamOvers = matchDetailsData["SecondOvers"] ?? "-"
                    
                    awayTeam.text?.appendContentsOf("\n\(secondScore)/\(secondWickets)\n(\(secondTeamOvers))")
                }
                
                secondTeamScore = secondScore
            }

        }
        
        
        if let firstScore = Int(firstTeamScore), let secondScore = Int(secondTeamScore) {
            if firstScore > secondScore {
                result.text = "\(matchDetailsData["Team"]!) Won the match by \(firstScore - secondScore) runs"
            }
            else if firstScore < secondScore
            {
                result.text = "\(matchDetailsData["Opponent"]!) Won the match by \(secondScore - firstScore) runs"
            }
            else if firstScore == secondScore {
                result.text = "Match tied"
            }
        }
        
        if let wicketstaken = matchDetailsData["Wickets"] {
            
            if let RunsGiven = matchDetailsData["RunsGiven"] {
                
                 totalWickets.text = "\(wicketstaken)-\(RunsGiven)"
            }
            else
            
            {
                totalWickets.text = "\(wicketstaken)-NA"
            }

            
           
        }
        
        if let Balls = matchDetailsData["Balls"] {
            ballsFaced.text = Balls
        }
        if let Position = matchDetailsData["Position"] {
            batPos.text = Position
        }
//        if let Dismissal = matchDetailsData["Dismissal"] {
//            dismissal.text = Dismissal.lowercaseString
//        }
//        if let OversBalled = matchDetailsData["OversBalled"] {
//            oversBowled.text = OversBalled
//        }
        
        if let Wides = matchDetailsData["Wides"] {
            wides.text = Wides
        }
        if let Noballs = matchDetailsData["Noballs"] {
            noBalls.text = Noballs
        }
        
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
