//
//  DashboardBattingDetailsViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 08/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import AnimatedTextInput
import KRProgressHUD

class DashboardBattingDetailsViewController: UIViewController,IndicatorInfoProvider {

    @IBOutlet weak var performanceTable: UITableView!
    var battingDetails: [String:String]!
    var bowlingDetails: [String:String]!
    var recentMatches: [String:String]!
    
    
    
    
    
    @IBOutlet weak var battingMatches: UILabel!
    @IBOutlet weak var battingInnings: UILabel!
    @IBOutlet weak var notOuts: UILabel!
    @IBOutlet weak var highScore: UILabel!
    @IBOutlet weak var battingAverage: UILabel!
    @IBOutlet weak var strikeRate: UILabel!
    @IBOutlet weak var hundreds: UILabel!
    @IBOutlet weak var fifties: UILabel!
    @IBOutlet weak var fours: UILabel!
    @IBOutlet weak var sixes: UILabel!
    @IBOutlet weak var best: UILabel!
    
    @IBOutlet weak var ballsFacedDuringBat: UILabel!
    
    @IBOutlet weak var recentBest: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMatchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "BATTING")
    }
    
    
    func getMatchData(){
        
        KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        getAllMatchData { (data) in
            
            matchDataSource.removeAll()
            for (key,val) in data{
                
                if  var value = val as? [String : String]{
                    
                    value += ["key":key]
                    
                    matchDataSource.append(value)
                }
            }
            
            let df = NSDateFormatter()
            df.dateFormat = "dd/MM/yyyy"
            
//            matchDataSource.sortInPlace{
//                if $0["Date"] != nil && $1["Date"] != nil, let firstDate = $0["Date"], let seconddate = $1["Date"] {
//                    return df.dateFromString(firstDate)!.compare(df.dateFromString(seconddate)!) == .OrderedDescending
//                }
//                return false
//                
//            }
            
            
           
            self.setUIElements()
            
            KRProgressHUD.dismiss()
        }
    }
    
    
    func setUIElements() {
        KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        if matchDataSource.count > 0 {
            var runs = [Int]()
            var top3MatchesArray = [NSMutableAttributedString]()
            self.battingMatches.text = String(matchDataSource.count)
            self.notOuts.text = String(0)
            self.sixes.text = String(0)
            self.fours.text = String(0)
            self.fifties.text = String(0)
            self.hundreds.text = String(0)
            self.ballsFacedDuringBat.text = String(0)
            self.battingInnings.text = String(0)
            self.battingAverage.text = String(0)
            var top3MatchCount = 0
            for matchData in matchDataSource {
                
                if matchData["Dismissal"] != nil && !dismissals.contains(matchData["Dismissal"]!){
                    var dismissalCount = Int(self.notOuts.text!)!
                    dismissalCount = dismissalCount + 1
                    self.notOuts.text = String(dismissalCount)
                }
                
                if matchData["Runs"] != nil  && matchData["Runs"] != "-", let curruns = matchData["Runs"] {
                    runs.append(Int(curruns)!)
                }
                
                if matchData["Runs"] != nil && matchData["Runs"] != "-" && matchData["Runs"] != "0" {
                    var inningsCount = Int(self.battingInnings.text!)!
                    inningsCount = inningsCount + 1
                    self.battingInnings.text = String(inningsCount)
                }
                
                if matchData["Sixes"] != nil && matchData["Sixes"] != "-"{
                    var sixCount = Int(self.sixes.text!)!
                    sixCount = sixCount + 1
                    self.sixes.text = String(sixCount)
                }
                
                if matchData["Fours"] != nil && matchData["Fours"] != "-"{
                    var fourCount = Int(self.fours.text!)!
                    fourCount = fourCount + 1
                    self.fours.text = String(fourCount)
                }
                
                if matchData["Balls"] != nil && matchData["Balls"] != "-", let ballCount = matchData["Balls"]{
                    var ballsCount = Int(self.ballsFacedDuringBat.text!)!
                    ballsCount = ballsCount + Int(ballCount)!
                    self.ballsFacedDuringBat.text = String(ballsCount)
                }
                if matchData["Runs"] != nil && matchData["Runs"] != "-" && Int(matchData["Runs"]!)! >= 50 && Int(matchData["Runs"]!)! < 100 {
                    var fiftyCount = Int(self.fifties.text!)!
                    fiftyCount = fiftyCount + 1
                    self.fifties.text = String(fiftyCount)
                }
                
                if matchData["Runs"] != nil && matchData["Runs"] != "-" && Int(matchData["Runs"]!)! >= 100 {
                    var hundredCount = Int(self.hundreds.text!)!
                    hundredCount = hundredCount + 1
                    self.hundreds.text = String(hundredCount)
                }
                
                if matchData["Dismissal"] != nil && matchData["Runs"] != nil && matchData["Runs"] != "-" && matchData["Opponent"] != nil && matchData["Opponent"] != "-" && top3MatchCount < 3, let runsScored = matchData["Runs"], let opponentFaced = matchData["Opponent"], let dismissedBy = matchData["Dismissal"] {
                    top3MatchCount = top3MatchCount + 1
                    
                    let formattedString = NSMutableAttributedString()
                    
                    if dismissedBy != "-" {
                        formattedString.bold("\(runsScored) ").normal(" against \(opponentFaced)\n")
                    }
                    else
                    {
                        formattedString.bold("\(runsScored)* ").normal(" against \(opponentFaced)\n")
                    }
                    
                    
                    top3MatchesArray.append(formattedString)
                }
                KRProgressHUD.dismiss()
            }
            
            if runs.count > 0 && self.notOuts.text != nil && self.notOuts.text != "-" , let notOuts = Int(self.notOuts.text!) {
                let notOutsAvg = (runs.count - notOuts)
                var avg = runs.reduce(0, combine: +)
                
                if notOutsAvg > 0 {
                    avg = avg/notOutsAvg
                }
               
                self.battingAverage.text = String(Float(avg))
            }
            
            if runs.count > 0 && self.ballsFacedDuringBat.text != nil && self.ballsFacedDuringBat.text != "-" {
                
                let ballsFacedDureingbat = Int(self.ballsFacedDuringBat.text!)!
                
                var totalruns = runs.reduce(0, combine: +)
                
                
                if ballsFacedDureingbat > 0 {
                    totalruns = totalruns/ballsFacedDureingbat
                }
                
                self.strikeRate.text = String(Float(totalruns*100))
                
            }
            
            if runs.count > 0 {
                self.highScore.text = String(runs.reduce(Int.min, combine: { max($0, $1) }))
            }
            
            if top3MatchesArray.count > 0 {
                self.recentBest.attributedText = top3MatchesArray.joinWithSeparator("\n")
            }
            
            
            
            
            
            
        }
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
