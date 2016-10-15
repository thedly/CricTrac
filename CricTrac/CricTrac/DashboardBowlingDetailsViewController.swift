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

class DashboardBowlingDetailsViewController: UIViewController,IndicatorInfoProvider {
    
    @IBOutlet weak var performanceTable: UITableView!
    var bowlingDetails: [String:String]!
    var recentMatches: [String:String]!
    
    
    
    
    @IBOutlet weak var bowlingMatches: UILabel!
    @IBOutlet weak var bowlingInnings: UILabel!
    @IBOutlet weak var totalOvers: UILabel!
    @IBOutlet weak var totalWickets: UILabel!
    @IBOutlet weak var totalRunsGiven: UILabel!
    @IBOutlet weak var bowlingAverage: UILabel!
    @IBOutlet weak var bowlingEconomy: UILabel!
    
    @IBOutlet weak var recentBest: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIElements()
        //getPerformanceDetails()
        
//        performanceTable.dataSource = self
//        performanceTable.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "BOWLING")
    }
    
    
    func setUIElements() {
        if matchDataSource.count > 0 {
            self.bowlingMatches.text = String(matchDataSource.count)
            self.totalOvers.text = String(0)
            self.bowlingInnings.text = String(0)
            self.bowlingEconomy.text = String(0)
            self.bowlingAverage.text = String(0)
            self.totalWickets.text = String(0)
            self.totalRunsGiven.text = String(0)
            var top3MatchesArray = [NSMutableAttributedString]()
            var top3MatchCount = 0
            for matchData in matchDataSource {
                
                if matchData["OversBalled"] != nil && matchData["OversBalled"] != "-", let oversbowled = matchData["OversBalled"]  {
                    var oversCount = Int(self.totalOvers.text!)!
                    var inningsCount = Int(self.bowlingInnings.text!)!
                    inningsCount = inningsCount + 1
                    oversCount = oversCount + Int(oversbowled)!
                    self.totalOvers.text = String(oversCount)
                    self.bowlingInnings.text = String(oversCount)
                }
                
                
                if matchData["Wickets"] != nil && matchData["Wickets"] != "-", let wicketsTaken = matchData["Wickets"]{
                    var wicketCount = Int(self.totalWickets.text!)!
                    wicketCount = wicketCount + Int(wicketsTaken)!
                    self.totalWickets.text = String(wicketCount)
                }
                
                if matchData["RunsGiven"] != nil && matchData["RunsGiven"] != "-", let runsGiven = matchData["RunsGiven"]{
                    var runsGivenCount = Int(self.totalRunsGiven.text!)!
                    runsGivenCount = runsGivenCount + Int(runsGiven)!
                    self.totalRunsGiven.text = String(runsGivenCount)
                }
                
                if matchData["Wickets"] != nil && matchData["Wickets"] != "-" && matchData["Opponent"] != nil && matchData["Opponent"] != "-" && top3MatchCount < 3, let wicketstaken = matchData["Wickets"], let opponentFaced = matchData["Opponent"] {
                    top3MatchCount = top3MatchCount + 1
                    
                    let formattedString = NSMutableAttributedString()
                    
                    formattedString.bold("\(wicketstaken)",fontName: "SFUIText-Bold", fontSize: 17).normal(" wickets against \(opponentFaced)\n", fontName: "SFUIText-Regular", fontSize: 15)
                    
                    top3MatchesArray.append(formattedString)
                }
                
            }
            
            
            
            if self.totalRunsGiven.text != nil && self.totalRunsGiven.text != "-" && self.totalWickets.text != nil && self.totalWickets.text != "-", let totRunsGiven = Int(self.totalRunsGiven.text!), let totWickets = Int(self.totalWickets.text!) {
                
                if totWickets > 0 {
                    self.bowlingAverage.text = String(Float(totRunsGiven/totWickets))
                }
                
            
            }
            
            
            
            
            if self.totalRunsGiven.text != nil && self.totalRunsGiven.text != "-" && self.totalOvers.text != nil && self.totalOvers.text != "-", let runsGiven = Int(self.totalRunsGiven.text!), let overs = Int(self.totalOvers.text!) {
                
                if overs > 0 {
                    self.bowlingEconomy.text = String(Float(runsGiven/overs))
                }
                
            
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


