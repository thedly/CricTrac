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
        return IndicatorInfo(title: "BATTING")
    }
    
    
    func getMatchData(){
        
        KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        getAllMatchData { (data) in
            
            matchDataSource.removeAll()
            for (key,val) in data{
                
                //var dataDict = val as! [String:String]
                //dataDict["key"] = key
                
                if  var value = val as? [String : String]{
                    
                    value += ["key":key]
                    
                    matchDataSource.append(value)
                }
            }
            print(matchDataSource)
            
            let df = NSDateFormatter()
            df.dateFormat = "dd/MM/yyyy"
            
            matchDataSource.sortInPlace{
                if $0["Date"] != nil && $1["Date"] != nil, let firstDate = $0["Date"], let seconddate = $1["Date"] {
                    return df.dateFromString(firstDate)!.compare(df.dateFromString(seconddate)!) == .OrderedDescending
                }
                return false
                
            }
            
            
            //matchDataSource.sortInPlace({ $0.Date.compare($1.Date) == NSComparisonResult.OrderedDescending })
            print("after sorting")
            
            print(matchDataSource)
            KRProgressHUD.dismiss()
            self.setUIElements()
            
        }
    }
    
    
    func setUIElements() {
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
                
                if let curruns = matchData["Runs"] {
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
                
            }
            
            if runs.count > 0 && self.notOuts.text != nil && self.notOuts.text != "-" , let notOuts = Int(self.notOuts.text!) {
                var notOutsAvg = (runs.count - notOuts)
                var avg = runs.reduce(0, combine: +)
                
                if notOutsAvg > 0 {
                    avg = avg/notOutsAvg
                }
               
                self.battingAverage.text = String(Float(avg))
            }
            
            if runs.count > 0 && self.ballsFacedDuringBat.text != nil && self.ballsFacedDuringBat.text != "-" {
                self.strikeRate.text = String(Float((runs.reduce(0, combine: +)/(Int(self.ballsFacedDuringBat.text!)!))*100))
            }
            
            if runs.count > 0 {
                self.highScore.text = String(runs.reduce(Int.min, combine: { max($0, $1) }))
            }
            
            if top3MatchesArray.count > 0 {
                self.recentBest.attributedText = top3MatchesArray.joinWithSeparator("\n")
            }
            
            
            
            
            
            
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
//                let index = battingDetails.startIndex.advancedBy(indexPath.row) as DictionaryIndex<String,String>
//                currentKey = battingDetails.keys[index]
//                currentvalue = battingDetails[currentKey!]!
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
//            headerLbl.backgroundColor = UIColor.whiteColor()
//            headerLbl.textColor = UIColor(hex: "6D9447")
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
//        return section == 0 ? battingDetails.count : 3
//    }
//    
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 2
//    }

    
    // MARK: Service Calls
    
    func getPerformanceDetails() {
        
        
        
        // Make API call
        
        battingDetails = [
            "Matches": "123",
            "Innings": "116",
            "Not Out": "12",
            "Runs": "1028",
            "High Score": "80",
            "Average": "32",
            "Balls Faced": "-",
            "SR": "-",
            "100s": "0",
            "50s": "1",
            "4s": "25",
            "6s": "15"
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
