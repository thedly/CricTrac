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
                
            }
            
            
            self.bowlingAverage.text = String(Double(Int(self.totalRunsGiven.text!)!/Int(self.totalWickets.text!)!))
            self.bowlingEconomy.text = String(Double(Int(self.totalRunsGiven.text!)!/Int(self.totalOvers.text!)!))
        }
    }
    
    
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
//        
//        if let cell = tableView.dequeueReusableCellWithIdentifier("performanceCell", forIndexPath: indexPath) as? performanceCell {
//            
//            //print(battingDetails)
//            
//            var currentKey :String?
//            var currentvalue :String?
//            
//            if indexPath.section == 0
//            {
//                
//                let index = bowlingDetails.startIndex.advancedBy(indexPath.row) as DictionaryIndex<String,String>
//                currentKey = bowlingDetails.keys[index]
//                currentvalue = bowlingDetails[currentKey!]!
//            }
//            else
//            {
//                let index = recentMatches.startIndex.advancedBy(indexPath.row) as DictionaryIndex<String,String>
//                currentKey = recentMatches.keys[index]
//                currentvalue = recentMatches[currentKey!]!
//                
//            }
//            
//            cell.configureCell(currentKey!, pValue: currentvalue!)
//            return cell
//        }
//        else
//        {
//            return UITableViewCell()
//            
//            
//            
//        }
//        
//        
//        
//    }
//    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 1 {
//            return "Recent Matches"
//        }
//        else
//        {
//            return ""
//        }
//    }
//    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 1 {
//            let vw = UIView()
//            let headerLbl = UILabel(frame: CGRectMake(20, 10, UIScreen.mainScreen().bounds.size.width, 30))
//            headerLbl.textColor = UIColor(hex: "6D9447")
//            headerLbl.backgroundColor = UIColor.whiteColor()
//            headerLbl.font = UIFont(name: "SFUIText-Bold", size: 20)
//            //headerLbl.font = UIFont.boldSystemFontOfSize(20)
//            headerLbl.text = "Recent Matches"
//            vw.addSubview(headerLbl)
//            
//            vw.backgroundColor = UIColor.clearColor()
//            return vw
//        }
//        return nil
//    }
//    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return CGFloat.min
//        }
//        return 50
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//        return section == 0 ? bowlingDetails.count : 3
//    }
//    
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 2
//    }
    
    
    // MARK: Service Calls
    
    func getPerformanceDetails() {
        
        
        
        // Make API call
        
        bowlingDetails = [
            "Overs": "12",
            "Wickets": "5",
            "Runs Given": "36",
            "Bowling Average": "24.16"
        ]
        
        recentMatches = [
            "Against DPS South": "46",
            "Against ISB" : "41",
            "Against JOJO Mysore": "30"
        ]
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


