//
//  SummaryMatchDetailsViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 23/07/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class SummaryMatchDetailsViewController: UIViewController {

    @IBOutlet weak var matchDetailsTbl: UITableView!
    
    @IBOutlet weak var screenShot: UIView!
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
    
    @IBOutlet weak var screenshot: UIView!
   
    @IBOutlet weak var runsGiven: UILabel!
    @IBOutlet weak var oversBowled: UILabel!
    
    var matchDetailsData : [String:String]!
    
    @IBAction func ShareActionPressed(sender: UIButton) {
        
        
        UIGraphicsBeginImageContext(self.screenshot.bounds.size);
        self.screenshot.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        var screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
        var itemsToShare = screenShot
        
        
        var actCtrl = UIActivityViewController(activityItems: [itemsToShare], applicationActivities: nil)
        
        
        actCtrl.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeMessage, UIActivityTypeMail]
        
        presentViewController(actCtrl, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        
        // Do any additional setup after loading the view.
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
        if let Overs = matchDetailsData["Overs"] {
            overs.text = "\(Overs) overs"
        }

        if let Ground = matchDetailsData["Ground"] {
            ground.text = "@ \(Ground)"
        }
        
        if let res = matchDetailsData["Result"] {
            if res != "-" {
                result.text = res
            }
            else
            {
                result.text = "Results NA"
            }
            
        }
        
        if let toss = matchDetailsData["Toss"]{
            
            if toss != "-" {
                self.toss.text = "Toss won by \(toss)"
            }
            else
            {
                self.toss.text = "Toss details NA"
            }
        }
        
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
        
        if let homeTeam = matchDetailsData["Team"] {
            if homeTeam != "-" {
                matchBetween.text = homeTeam
            }
            else
            {
                matchBetween.text = "Unknown"
            }
            
            if let opponent = matchDetailsData["Opponent"] {
                if opponent != "-" {
                    matchBetween.text?.appendContentsOf("\n VS \n \(opponent)")
                }
                else
                {
                    matchBetween.text?.appendContentsOf("\n VS \n Unknown")
                }
            }
            
        }
        
        if let wicketstaken = matchDetailsData["Wickets"] {
            totalWickets.text = wicketstaken
        }
        
        if let Balls = matchDetailsData["Balls"] {
            ballsFaced.text = Balls
        }
        if let Position = matchDetailsData["Position"] {
            batPos.text = Position
        }
        if let Dismissal = matchDetailsData["Dismissal"] {
            dismissal.text = Dismissal.lowercaseString
        }
        if let OversBalled = matchDetailsData["OversBalled"] {
            oversBowled.text = OversBalled
        }
        
        if let RunsGiven = matchDetailsData["RunsGiven"] {
            runsGiven.text = RunsGiven
        }
        if let Wides = matchDetailsData["Wides"] {
            wides.text = Wides
        }
        if let Noballs = matchDetailsData["Noballs"] {
            noBalls.text = Noballs
        }
        
        if let date = matchDetailsData["Date"]{
            let dateArray = date.characters.split{$0 == "/"}.map(String.init)
            self.date.text = "\(dateArray[0]) \(dateArray[1].monthName) \(dateArray[2])"
        }
    
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
