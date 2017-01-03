//
//  MatchSummaryViewController.swift
//  CricTrac
//
//  Created by Renjith on 8/20/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import KRProgressHUD

class MatchSummaryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var matchSummaryTable:UITableView!
    
    var matchData:[String:AnyObject]!
    var matchDataSource = [[String:String]]()
    var matches = [MatchSummaryData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIBackgroundTheme(self.view)
        getMatchData()
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
            
            self.matchData = data
            self.matchDataSource.removeAll()
            for (key,val) in data{
                
                //var dataDict = val as! [String:String]
                //dataDict["key"] = key
                
                if  var value = val as? [String : String]{
                    
                    value += ["key":key]
                    
                    self.matchDataSource.append(value)
                    var battingBowlingScore = ""
                    var matchVenueAndDate = ""
                    var opponentName = ""
                    
                    let mData = MatchSummaryData()
                    
                    
                    if let runsTaken = value["RunsTaken"]{
                        
                        mData.BattingSectionHidden = (runsTaken == "-")
                        
                        if mData.BattingSectionHidden == false {
                            battingBowlingScore.appendContentsOf(runsTaken)
                        }
                    }
                    
                    if let wicketsTaken = value["WicketsTaken"], let runsGiven = value["RunsGiven"] {
                        
                        
                        mData.BowlingSectionHidden = (runsGiven == "-")
                        
                        
                        if mData.BowlingSectionHidden == false {
                            if battingBowlingScore.length > 0 {
                                battingBowlingScore.appendContentsOf("\n\(wicketsTaken)-\(runsGiven)")
                            }
                            else{
                                battingBowlingScore.appendContentsOf("\(wicketsTaken)-\(runsGiven)")
                            }
                            
                            
                        }
                        
                    }
                    
                    
                    
                    if let date = value["MatchDate"]{
                        matchVenueAndDate.appendContentsOf(date as? String ?? "NA")
                    }
                    if let venue = value["Ground"]{
                        matchVenueAndDate.appendContentsOf("\n@ \(venue)")
                    }
                    
                    if let opponent  = value["Opponent"]{
                        opponentName = opponent.uppercaseString
                    }
                    
                    
                    mData.battingBowlingScore = battingBowlingScore
                    mData.matchDateAndVenue = matchVenueAndDate
                    mData.opponentName = opponentName
                    
                    self.matches.append(mData)
                    
                }
            }
            KRProgressHUD.dismiss()
            self.matchSummaryTable.reloadData()
            
        }
    }

    
    
    
    func getCellForRow(indexPath:NSIndexPath)->SummaryDetailsCell{
        if let aCell =  matchSummaryTable.dequeueReusableCellWithIdentifier("SummaryDetailsCell", forIndexPath: indexPath) as? SummaryDetailsCell {
            
            aCell.backgroundColor = UIColor.clearColor()
            
            if let currentMatch = matches[indexPath.row] as? MatchSummaryData {
                
                aCell.BattingOrBowlingScore.text = currentMatch.battingBowlingScore
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
        
        
       summaryDetailsVC.matchDetailsData = matchDataSource[indexPath.row]
            presentViewController(summaryDetailsVC, animated: true, completion: nil)
        CFRunLoopWakeUp(CFRunLoopGetCurrent())
    }

}
