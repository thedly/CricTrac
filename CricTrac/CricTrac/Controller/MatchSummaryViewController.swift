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
        self.view.backgroundColor = currentTheme.topColor
        navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    override func viewWillAppear(animated: Bool) {
        getMatchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false

        setBackgroundColor()
       // getMatchData()
    matchSummaryTable.registerNib(UINib.init(nibName:"SummaryDetailsCell", bundle: nil), forCellReuseIdentifier: "SummaryDetailsCell")
        matchSummaryTable.allowsSelection = true
        matchSummaryTable.separatorStyle = .None
        setNavigationBarProperties()
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

    func setNavigationBarProperties(){
        var currentTheme:CTTheme!
        currentTheme = cricTracTheme.currentTheme
        let menuButton: UIButton = UIButton(type:.Custom)
        menuButton.setImage(UIImage(named: "menu-icon"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        navigationItem.leftBarButtonItem = leftbarButton
        navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
        title = "MATCH SUMMARY"
       // let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
       // navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    @IBAction func didTapCancel(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true) {}
    }
    
    @IBAction func didMenuButtonTapp(sender: UIButton){
        sliderMenu.setDrawerState(.Opened, animated: true)
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
            battingBowlingScore.bold("DNB", fontName: appFont_black, fontSize: 30)
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
        
        if let ground = value["Ground"]{
            mData.ground = ground as! String
            
            if let venue = value["Venue"]{
                mData.ground = "\(ground) \(venue)"
            }
        }
        
        if let ballsFaced = value["BallsFaced"] as? String where ballsFaced != "-", let runsScored = value["RunsTaken"] as? String where runsScored != "-" && mData.BattingSectionHidden == false {
            
            let strinkeRate = String(format: "%.2f",(Float(runsScored)!)*100/Float(ballsFaced)!)
            mData.strikerate = Float(strinkeRate)
            //matchVenueAndDate.appendContentsOf("\n Strike rate: \(strinkeRate)")
        }
        
        if let oversBowled = value["OversBowled"] as? String where oversBowled != "-", let runsGiven = value["RunsGiven"] as? String where runsGiven != "-" && mData.BowlingSectionHidden == false {
            
            let economy = String(format: "%.2f",(Float(runsGiven)!)/Float(oversBowled)!)
            mData.economy = Float(economy)
            //matchVenueAndDate.appendContentsOf("\n Economy: \(economy)")
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
                aCell.stadiumLabel.text = currentMatch.ground
                if let sRate = currentMatch.strikerate {
                    aCell.strikeRateLabel.text = "Strike Rate : \(sRate)"
                }
                if let economy = currentMatch.economy {
                    
                    aCell.economyLabel.text = "Economy : \(economy)"
                }
    
                //aCell.stadiumLabel.text = currentMatch.
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
          //  presentViewController(summaryDetailsVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(summaryDetailsVC, animated: true)
        CFRunLoopWakeUp(CFRunLoopGetCurrent())
    }

}
