//
//  MatchSummaryViewController.swift
//  CricTrac
//
//  Created by Renjith on 8/20/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import KRProgressHUD

class MatchSummaryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ThemeChangeable {

    @IBOutlet var matchSummaryTable:UITableView!
    
    var matchData = [String:AnyObject]()
    var matches = [MatchSummaryData]()
    var matchDataSource = [[String:AnyObject]]()
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.boxColor
    }
    
    override func viewWillAppear(animated: Bool) {
        getMatchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
       // getMatchData()
    matchSummaryTable.registerNib(UINib.init(nibName:"SummaryDetailsCell", bundle: nil), forCellReuseIdentifier: "SummaryDetailsCell")
        matchSummaryTable.allowsSelection = true
        matchSummaryTable.separatorStyle = .None
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MatchSummaryViewController.newDataAdded), name: "MatchDataChanged" , object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func newDataAdded(){
        getMatchData()
    }

    @IBAction func didTapCancel(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true) {}
    }
    
    
    
    func getMatchData(){
        
        KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        getAllMatchData { (data) in
            
            self.matchDataSource.removeAll()
            
            self.makeCells(data)
            
            KRProgressHUD.dismiss()
            
            
        }
    }
    
    
    func makeCells(data: [String: AnyObject]) {
        
        self.matchData = data
        self.matches.removeAll()
        for (key,val) in data{
            
            if  var value = val as? [String : AnyObject]{
                
                value += ["key":key]
                
                self.matchDataSource.append(value)
                self.matches.append(makeSummaryCell(value))
                
            }
        }
        
        self.matches.sortInPlace({ $0.matchDate.compare($1.matchDate) == NSComparisonResult.OrderedDescending })
        self.matchSummaryTable.reloadData()
    }

    
    
    func makeSummaryCell(value: [String : AnyObject]) -> MatchSummaryData {
        
        let battingBowlingScore = NSMutableAttributedString()
        var matchVenueAndDate = ""
        var opponentName = ""
        
        let mData = MatchSummaryData()
        
        mData.matchId = value["key"] as! String
        
        
        if let runsTaken = value["RunsTaken"]{
            
            mData.BattingSectionHidden = (runsTaken as! String == "-")
            
            if mData.BattingSectionHidden == false {
                
                battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: 30).bold("\nRUNS", fontName: appFont_black, fontSize: 12)
                
            }
        }
        
        if let wicketsTaken = value["WicketsTaken"], let runsGiven = value["RunsGiven"] {
            
            
            mData.BowlingSectionHidden = (runsGiven as! String == "-")
            
            
            if mData.BowlingSectionHidden == false {
                if battingBowlingScore.length > 0 {
                    
                    battingBowlingScore.bold("\n\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: 30).bold("\nWICKETS", fontName: appFont_black, fontSize: 12)
                    
                }
                else{
                    battingBowlingScore.bold("\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: 30).bold("\nWICKETS", fontName: appFont_black, fontSize: 12)
                }
                
                
            }
            
        }
        
        
        if battingBowlingScore.length == 0 {
            battingBowlingScore.bold("DNP", fontName: appFont_black, fontSize: 30)
        }
        
        
        
        if let date = value["MatchDate"]{
            
            
            
            var DateFormatter = NSDateFormatter()
            DateFormatter.dateFormat = "dd-MM-yyyy"
            DateFormatter.locale =  NSLocale(localeIdentifier: "en_US_POSIX")
            var dateFromString = DateFormatter.dateFromString(date as! String)
            
            mData.matchDate = dateFromString
            
            
            matchVenueAndDate.appendContentsOf(date as? String ?? "NA")
        }
        
        if let group = value["AgeGroup"]{
            matchVenueAndDate.appendContentsOf(" | \(group)")
        }
        
        if let venue = value["Ground"]{
            matchVenueAndDate.appendContentsOf("\n@ \(venue)")
        }
        
        if let ballsFaced = value["BallsFaced"] as? String where ballsFaced != "-", let runsScored = value["RunsTaken"] as? String where runsScored != "-" && mData.BattingSectionHidden == false {
            
            let strinkeRate = (Int(runsScored)!/Int(ballsFaced)!)*100
            matchVenueAndDate.appendContentsOf("\n Strike rate: \(strinkeRate)")
        }
        
        if let oversBowled = value["OversBowled"] as? String where oversBowled != "-", let runsGiven = value["RunsGiven"] as? String where runsGiven != "-" && mData.BowlingSectionHidden == false {
            
            
            let economy = Float(runsGiven)!/Float(oversBowled)!
            matchVenueAndDate.appendContentsOf("\n Economy: \(economy)")
        }
        
        if let opponent  = value["Opponent"]{
            opponentName = opponent.uppercaseString
        }
        
        
        mData.battingBowlingScore = battingBowlingScore
        mData.matchDateAndVenue = matchVenueAndDate
        mData.opponentName = opponentName
        
        
        return mData
    }
    
    
    func getCellForRow(indexPath:NSIndexPath)->SummaryDetailsCell{
        if let aCell =  matchSummaryTable.dequeueReusableCellWithIdentifier("SummaryDetailsCell", forIndexPath: indexPath) as? SummaryDetailsCell {
            
            aCell.backgroundColor = UIColor.clearColor()
            
            if let currentMatch = self.matches[indexPath.row] as? MatchSummaryData {
                
                aCell.BattingOrBowlingScore.attributedText = currentMatch.battingBowlingScore
                aCell.matchDateAndVenue.text = currentMatch.matchDateAndVenue
                aCell.oponentName.text = currentMatch.opponentName
            }
            return aCell
        }
        else
        {
            return SummaryDetailsCell()
        }
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.matchDataSource.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return getCellForRow(indexPath)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 120
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SummaryDetailsCell
                let summaryDetailsVC = viewControllerFrom("Main", vcid: "SummaryMatchDetailsViewController") as! SummaryMatchDetailsViewController
        
        summaryDetailsVC.battingViewHidden = matches[indexPath.row].BattingSectionHidden
        summaryDetailsVC.bowlingViewHidden = matches[indexPath.row].BowlingSectionHidden
        
        
        var selectedDataSource = self.matchDataSource.filter { (dat) -> Bool in
            return dat["MatchId"]! as! String == matches[indexPath.row].matchId
        }
        
        summaryDetailsVC.matchDetailsData = selectedDataSource.first
            presentViewController(summaryDetailsVC, animated: true, completion: nil)
        CFRunLoopWakeUp(CFRunLoopGetCurrent())
    }

}
