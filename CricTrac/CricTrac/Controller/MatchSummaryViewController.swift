//
//  MatchSummaryViewController.swift
//  CricTrac
//
//  Created by Renjith on 8/20/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import KRProgressHUD
import SwiftyStoreKit

class MatchSummaryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ThemeChangeable{
    
    @IBOutlet weak var yearDropdown: UITextField!
    @IBOutlet weak var levelDropdown: UITextField!
    @IBOutlet weak var ageGroupDropdown: UITextField!
    @IBOutlet weak var upgradeBtnHeight: NSLayoutConstraint!
    @IBOutlet var matchSummaryTable:UITableView!
    @IBOutlet weak var noMatchesHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var noMatchesLabel: UILabel!
    //For dropdowns
    @IBOutlet weak var levelDropDownButton: UIButton!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView1HeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var ageDropdownButton: UIButton!
    @IBOutlet weak var tableview2: UITableView!
    @IBOutlet weak var tableView2HeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var yearDropdownButton: UIButton!
    @IBOutlet weak var tableView3: UITableView!
    @IBOutlet weak var tableView3HeightConstraint: NSLayoutConstraint!
    
    // For TotalMatches
     @IBOutlet weak var totalMatchesLabel: UILabel!
    @IBOutlet weak var totalMatchesText: UILabel!
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var strikeRate: UILabel!
    @IBOutlet weak var battingAvg: UILabel!
    @IBOutlet weak var battingMatches: UILabel!
    @IBOutlet weak var runs: UILabel!
    @IBOutlet weak var bowlingMatches: UILabel!
    @IBOutlet weak var wickets: UILabel!
    @IBOutlet weak var economy: UILabel!
    @IBOutlet weak var bowlingAvg: UILabel!
    
    //height constraints
    @IBOutlet weak var view1HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var view2HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var view3HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var view4heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var baseViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var horizontalDividerView: NSLayoutConstraint!
    @IBOutlet weak var verticalDividerView: NSLayoutConstraint!
    
    @IBOutlet weak var subView3: UIView!
    @IBOutlet weak var subView4: UIView!
    @IBOutlet weak var subView1: UIView!
    @IBOutlet weak var subView2: UIView!
    
    
    var matchData = [String:AnyObject]()
    var matches = [MatchSummaryData]()
    var matchDataSource = [[String:AnyObject]]()
    
    var filterYear = [String]()
    var filterLevel = [String]()
    var filterAgeGroup = [String]()
    
    var filterCurrentMatch = [[String:AnyObject]]()
    
    var userProfileData:Profile!
    
    var toatalBowlingMatches = 0
    var toatalBattingmatches = 0
    
    var TotalWicketsTaken = 0
    var totalRunsGiven = 0
    var totalRuns = 0
    var totalDismissal = 0
    var totalOvers = 0
    var totalBallsFaced = 0
    
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        baseView.backgroundColor = currentTheme.bottomColor
        baseView.layer.cornerRadius = 10
        baseView.clipsToBounds = true
        
        self.tableView1.backgroundColor = currentTheme.topColor
        self.tableview2.backgroundColor = currentTheme.topColor
        self.tableView3.backgroundColor = currentTheme.topColor
        // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    var inAppProductPrice : String?
    @IBOutlet var upgradeButton : UIButton!
    
    override func viewWillAppear(animated: Bool) {
        UpdateDashboardDetails()
        getMatchData()
        //getDashboardData()
        setBackgroundColor()
        self.matchSummaryTable.reloadData()
        self.tableView1.reloadData()
        setNavigationBarProperties()
        
       // baseView.hidden = false
        tableView1.hidden = true
        tableview2.hidden = true
        tableView3.hidden = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        upgradeButton.setTitle("UPGRADE", forState: UIControlState.Normal)
        
        userProfileData = profileData
        if userProfileData.UserStatus == "Premium" {
            //upgradeButton.hidden=true
            upgradeBtnHeight.constant = 0
        }
        else {
            //upgradeButton.hidden = false
            upgradeBtnHeight.constant = 66
            
        }
        
        //In App Purchase
        fetchProductInfo()
        
        self.automaticallyAdjustsScrollViewInsets = false

        setBackgroundColor()
        // getMatchData()
        matchSummaryTable.registerNib(UINib.init(nibName:"SummaryDetailsCell", bundle: nil), forCellReuseIdentifier: "SummaryDetailsCell")
        matchSummaryTable.allowsSelection = true
        matchSummaryTable.separatorStyle = .None
        
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MatchSummaryViewController.newDataAdded), name: "MatchDataChanged" , object: nil)
        // Do any additional setup after loading the view.
        
        
        //For dropdowns
        self.ageGroupDropdown.text = "Age Group"
        self.ageGroupDropdown.font = UIFont(name: "SourceSansPro-Bold", size: 15)
        self.ageGroupDropdown.textColor = UIColor.blackColor()
        
        self.levelDropdown.text = "Level"
        self.levelDropdown.font = UIFont(name: "SourceSansPro-Bold", size: 15)
        self.levelDropdown.textColor = UIColor.blackColor()
        
        self.yearDropdown.text = "Year"
        self.yearDropdown.font = UIFont(name: "SourceSansPro-Bold", size: 15)
        self.yearDropdown.textColor = UIColor.blackColor()
        
        
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
        title = "SCOREBOARD"
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
        //KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        getAllMatchData { (data) in
            self.matchDataSource.removeAll()
            self.filterLevel.removeAll()
            self.filterAgeGroup.removeAll()
            self.filterYear.removeAll()
           
            self.toatalBattingmatches = 0
            self.toatalBowlingMatches = 0
            self.totalRunsGiven = 0
            self.totalOvers = 0
            self.totalRuns = 0
            self.TotalWicketsTaken = 0
            self.totalBallsFaced = 0
            self.totalDismissal = 0
          //  self.filterCurrentMatch.removeAll()
            self.makeCells(data)
            //KRProgressHUD.dismiss()
        }
    }
    
    
    func makeCells(data: [String: AnyObject]) {
        self.matchData = data
        self.matches.removeAll()
        self.filterAgeGroup.append("Age Group")
        self.filterLevel.append("Level")
        self.filterYear.append("Year")
       
        
        for (key,val) in data{
            if  var value = val as? [String : AnyObject]{
                value += ["key":key]
                
                if filterLevel.indexOf(value["Level"] as! String) == nil {
                    self.filterLevel.append(value["Level"] as! String)
                }
                
                if filterAgeGroup.indexOf(value["AgeGroup"] as! String) == nil {
                    self.filterAgeGroup.append(value["AgeGroup"] as! String)
                }
                
                let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
                let matchDate = value["MatchDate"] as? String
                
                let dateFormater = NSDateFormatter()
                dateFormater.dateFormat = "dd-MM-yyyy"
                dateFormater.locale =  NSLocale(localeIdentifier: "en_US_POSIX")
                let matchDate2 = dateFormater.dateFromString(matchDate!)
                let match = calendar.components(.Year, fromDate: matchDate2!)
                let matchYear = match.year
                if filterYear.indexOf(String(matchYear)) == nil {

                    filterYear.append(String(matchYear))

                }
                
            if ageGroupDropdown.text == "Age Group" && levelDropdown.text == "Level" && yearDropdown.text == "Year" {
                self.matchDataSource.append(value)
                
                self.matches.append(makeSummaryCell(value))
                self.totalMatchesLabel.text = String(self.matchDataSource.count)
                
                if value["RunsTaken"] as! String != "-" {
                    toatalBattingmatches += 1
                    let dismissal = value["Dismissal"] as? String
                    if  dismissal == "Not out" || dismissal == "Retired hurt" {
                        totalDismissal += 1
                    }
                    totalBallsFaced += Int(value["BallsFaced"] as! String)!
                    totalRuns += Int(value["RunsTaken"] as! String)!
                    }
                    self.battingMatches.text = String(toatalBattingmatches)
                    self.runs.text = String(totalRuns)
                    self.battingAvg.text = String(totalDismissal)
                
                if value["OversBowled"] as! String != "-" {
                    toatalBowlingMatches += 1
                    totalOvers += Int(value["OversBowled"] as! String)!
                    totalRunsGiven += Int(value["RunsGiven"] as! String)!
                    TotalWicketsTaken += Int(value["WicketsTaken"] as! String)!
                    }
                    self.bowlingMatches.text = String(toatalBowlingMatches)
                    self.wickets.text = String(TotalWicketsTaken)
                }
            
            else if ageGroupDropdown.text != "Age Group" && levelDropdown.text != "Level" && yearDropdown.text != "Year"{
                
                if ageGroupDropdown.text == value["AgeGroup"] as? String && levelDropdown.text == value["Level"] as? String && yearDropdown.text == String(matchYear) {
                    self.matchDataSource.append(value)
                    self.matches.append(makeSummaryCell(value))
                    self.totalMatchesLabel.text =  String(self.matchDataSource.count)
                    
                    if value["RunsTaken"] as! String != "-" {
                        toatalBattingmatches += 1
                        let dismissal = value["Dismissal"] as? String
                      if dismissal == "Not out" || dismissal == "Retired hurt" {
                            totalDismissal += 1
                        }
                        totalBallsFaced += Int(value["BallsFaced"] as! String)!
                        totalRuns += Int(value["RunsTaken"] as! String)!
                        }
                        self.battingMatches.text = String(toatalBattingmatches)
                        self.runs.text = String(totalRuns)
                        self.battingAvg.text = String(totalDismissal)
 
                    if value["OversBowled"] as! String != "-" {
                       toatalBowlingMatches += 1
                        totalOvers += Int(value["OversBowled"] as! String)!
                        totalRunsGiven += Int(value["RunsGiven"] as! String)!
                        TotalWicketsTaken += Int(value["WicketsTaken"] as! String)!
                        }
                        self.bowlingMatches.text = String(toatalBowlingMatches)
                        self.wickets.text = String(TotalWicketsTaken)
                    }
                else {
                    self.totalMatchesLabel.text =  String(self.matchDataSource.count)
                    }

                }
                
        else {
            if ageGroupDropdown.text != "Age Group"   && levelDropdown.text != "Level" {
                if ageGroupDropdown.text == value["AgeGroup"] as? String && levelDropdown.text == value["Level"] as? String {
                    self.matchDataSource.append(value)
                    self.matches.append(makeSummaryCell(value))
                    self.totalMatchesLabel.text =  String(self.matchDataSource.count)
                
                if value["RunsTaken"] as! String != "-" {
                    toatalBattingmatches += 1
                    let dismissal = value["Dismissal"] as? String
                    if  dismissal == "Not out" || dismissal == "Retired hurt" {
                        totalDismissal += 1
                    }
                    totalBallsFaced += Int(value["BallsFaced"] as! String)!
                    totalRuns += Int(value["RunsTaken"] as! String)!
                    }
                    self.battingMatches.text = String(toatalBattingmatches)
                    self.runs.text = String(totalRuns)
                    self.battingAvg.text = String(totalDismissal)
                
                if value["OversBowled"] as! String != "-" {
                    toatalBowlingMatches += 1
                    totalOvers += Int(value["OversBowled"] as! String)!
                    totalRunsGiven += Int(value["RunsGiven"] as! String)!
                    TotalWicketsTaken += Int(value["WicketsTaken"] as! String)!
                    }
                    self.bowlingMatches.text = String(toatalBowlingMatches)
                    self.wickets.text = String(TotalWicketsTaken)
                }
            else {
                self.totalMatchesLabel.text =  String(self.matchDataSource.count)
                }
            }
            
        else if ageGroupDropdown.text != "Age Group"  && yearDropdown.text != "Year" {
                if ageGroupDropdown.text == value["AgeGroup"] as? String && yearDropdown.text == String(matchYear) {
                    self.matchDataSource.append(value)
                    self.matches.append(makeSummaryCell(value))
                    self.totalMatchesLabel.text =  String(self.matchDataSource.count)
                    
                    if value["RunsTaken"] as! String != "-" {
                        toatalBattingmatches += 1
                        let dismissal = value["Dismissal"] as? String
                        if  dismissal == "Not out" || dismissal == "Retired hurt" {
                            totalDismissal += 1
                        }
                        totalBallsFaced += Int(value["BallsFaced"] as! String)!
                        totalRuns += Int(value["RunsTaken"] as! String)!
                        }
                        self.battingMatches.text = String(toatalBattingmatches)
                        self.runs.text = String(totalRuns)
                        self.battingAvg.text = String(totalDismissal)
                    
                    if value["OversBowled"] as! String != "-" {
                        toatalBowlingMatches += 1
                        totalOvers += Int(value["OversBowled"] as! String)!
                        totalRunsGiven += Int(value["RunsGiven"] as! String)!
                        TotalWicketsTaken += Int(value["WicketsTaken"] as! String)!
                        }
                        self.bowlingMatches.text = String(toatalBowlingMatches)
                        self.wickets.text = String(TotalWicketsTaken)
                   
                    }
                else {
                    self.totalMatchesLabel.text =  String(self.matchDataSource.count)
                    }
                }
            
        else if levelDropdown.text != "Level" && yearDropdown.text != "Year" {
            if levelDropdown.text == value["Level"] as? String && yearDropdown.text == String(matchYear) {
                self.matchDataSource.append(value)
                self.matches.append(makeSummaryCell(value))
                self.totalMatchesLabel.text =  String(self.matchDataSource.count)
                if value["RunsTaken"] as! String != "-" {
                    toatalBattingmatches += 1
                    let dismissal = value["Dismissal"] as? String
                    if  dismissal == "Not out" || dismissal == "Retired hurt" {
                        totalDismissal += 1
                    }
                    totalBallsFaced += Int(value["BallsFaced"] as! String)!
                    totalRuns += Int(value["RunsTaken"] as! String)!
                    }
                    self.battingMatches.text = String(toatalBattingmatches)
                    self.runs.text = String(totalRuns)
                    self.battingAvg.text = String(totalDismissal)
                
                if value["OversBowled"] as! String != "-" {
                    toatalBowlingMatches += 1
                    totalOvers += Int(value["OversBowled"] as! String)!
                    totalRunsGiven += Int(value["RunsGiven"] as! String)!
                    TotalWicketsTaken += Int(value["WicketsTaken"] as! String)!
                    }
                    self.bowlingMatches.text = String(toatalBowlingMatches)
                    self.wickets.text = String(TotalWicketsTaken)
                }
            else {
                 self.totalMatchesLabel.text =  String(self.matchDataSource.count)
                }
            
            }
        else if ageGroupDropdown.text != "Age Group" {
            if ageGroupDropdown.text == value["AgeGroup"] as? String {
                self.matchDataSource.append(value)
                self.matches.append(makeSummaryCell(value))
                self.totalMatchesLabel.text =  String(self.matchDataSource.count)
               
                if value["RunsTaken"] as! String != "-" {
                    toatalBattingmatches += 1
                    let dismissal = value["Dismissal"] as? String
                    if  dismissal == "Not out" || dismissal == "Retired hurt" {
                        totalDismissal += 1
                    }
                     totalBallsFaced += Int(value["BallsFaced"] as! String)!
                     totalRuns += Int(value["RunsTaken"] as! String)!
                    }
                    self.battingMatches.text = String(toatalBattingmatches)
                    self.runs.text = String(totalRuns)
                    self.battingAvg.text = String(totalDismissal)

                if value["OversBowled"] as! String != "-" {
                    toatalBowlingMatches += 1
                    totalOvers += Int(value["OversBowled"] as! String)!
                    totalRunsGiven += Int(value["RunsGiven"] as! String)!
                    TotalWicketsTaken += Int(value["WicketsTaken"] as! String)!
                    }
                    self.bowlingMatches.text = String(toatalBowlingMatches)
                    self.wickets.text = String(TotalWicketsTaken)
                
                }
        }
            
        else if levelDropdown.text != "Level" {
          if levelDropdown.text == value["Level"] as? String {
            self.matchDataSource.append(value)
            self.matches.append(makeSummaryCell(value))
            self.totalMatchesLabel.text =  String(self.matchDataSource.count)
            
            if value["RunsTaken"] as! String != "-" {
                toatalBattingmatches += 1
                let dismissal = value["Dismissal"] as? String
              if dismissal == "Not out" || dismissal == "Retired hurt" {
                    totalDismissal += 1
                }
                totalBallsFaced += Int(value["BallsFaced"] as! String)!
                totalRuns += Int(value["RunsTaken"] as! String)!
                }
                self.battingMatches.text = String(toatalBattingmatches)
                self.runs.text = String(totalRuns)
                self.battingAvg.text = String(totalDismissal)
            
            if value["OversBowled"] as! String != "-" {
                toatalBowlingMatches += 1
                totalOvers += Int(value["OversBowled"] as! String)!
                totalRunsGiven += Int(value["RunsGiven"] as! String)!
                TotalWicketsTaken += Int(value["WicketsTaken"] as! String)!
                }
                self.bowlingMatches.text = String(toatalBowlingMatches)
                self.wickets.text = String(TotalWicketsTaken)
            }
        }
            
        else if yearDropdown.text != "Year" {
          if yearDropdown.text == String(matchYear) {
            self.matchDataSource.append(value)
            self.matches.append(makeSummaryCell(value))
            self.totalMatchesLabel.text =  String(self.matchDataSource.count)
            
            if value["RunsTaken"] as! String != "-" {
                toatalBattingmatches += 1
                let dismissal = value["Dismissal"] as? String
                if  dismissal == "Not out" || dismissal == "Retired hurt" {
                    totalDismissal += 1
                }
                totalBallsFaced += Int(value["BallsFaced"] as! String)!
                totalRuns += Int(value["RunsTaken"] as! String)!
                }
                self.battingMatches.text = String(toatalBattingmatches)
                self.runs.text = String(totalRuns)
                self.battingAvg.text = String(totalDismissal)
            
            if value["OversBowled"] as! String != "-" {
                toatalBowlingMatches += 1
                totalOvers += Int(value["OversBowled"] as! String)!
                totalRunsGiven += Int(value["RunsGiven"] as! String)!
                TotalWicketsTaken += Int(value["WicketsTaken"] as! String)!
                }
                self.bowlingMatches.text = String(toatalBowlingMatches)
                self.wickets.text = String(TotalWicketsTaken)
            }
          }
        }
      }
    }

        //Total Economy & TotalBowlingAvg
            if totalRunsGiven != 0 {
                self.bowlingAvg.text = String(format: "%.1f",Float(totalRunsGiven) / Float(TotalWicketsTaken))
                self.economy.text = String(format: "%.1f",Float(totalRunsGiven) / Float(totalOvers))
                }
                else{
                 self.bowlingAvg.text = "-"
                 self.economy.text = "-"
                }
        // TotalBattingAvg
            if (toatalBattingmatches - totalDismissal) > 0 {
                self.battingAvg.text = String(format: "%.1f",(Float(totalRuns))/Float(toatalBattingmatches - totalDismissal))
               // String(totalRuns / (toatalBattingmatches - totalDismissal))
                }
                else{
                 self.battingAvg.text = "-"
                }
          // TotalStrikeRate
            if totalBallsFaced != 0 {
                let strikeRate = String(format: "%.1f",(Float(totalRuns))*100/Float(totalBallsFaced))
                 self.strikeRate.text = strikeRate
            }
            else{
               self.strikeRate.text = "-"
            }
 
        
        self.matches.sortInPlace({ $0.matchDate.compare($1.matchDate) == NSComparisonResult.OrderedDescending })
               self.matchSummaryTable.reloadData()
        self.totalMatchesLabel.text =  String(self.matchDataSource.count)
}
    
    func makeSummaryCell(value: [String : AnyObject]) -> MatchSummaryData {
        let battingBowlingScore = NSMutableAttributedString()
        var matchVenueAndDate = ""
        var opponentName = ""
        var ageGroupName = ""
        var levelName = ""
        
        let mData = MatchSummaryData()
        mData.matchId = value["key"] as! String
        
        if let runsTaken = value["RunsTaken"]{
            mData.BattingSectionHidden = (runsTaken as! String == "-")
            if mData.BattingSectionHidden == false {
                if let dismissal = value["Dismissal"] as? String where dismissal == "Not out"{
                    battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: 25).bold("*", fontName: appFont_black, fontSize: 25).bold("\nRUNS", fontName: appFont_black, fontSize: 10)
                }
                else{
                    battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: 25).bold("\nRUNS", fontName: appFont_black, fontSize: 10)
                }
            }
        }
        
        if let wicketsTaken = value["WicketsTaken"], let runsGiven = value["RunsGiven"] {
            mData.BowlingSectionHidden = (runsGiven as! String == "-")
            if mData.BowlingSectionHidden == false {
                if battingBowlingScore.length > 0 {
                    battingBowlingScore.bold("\n\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: 25).bold("\nWICKETS", fontName: appFont_black, fontSize: 10)
                }
                else{
                    battingBowlingScore.bold("\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: 25).bold("\nWICKETS", fontName: appFont_black, fontSize: 10)
                }
            }
        }
        
        if battingBowlingScore.length == 0 {
            battingBowlingScore.bold("DNB", fontName: appFont_black, fontSize: 30)
        }
        
        if let date = value["MatchDate"]{

            let DateFormatter = NSDateFormatter()
            DateFormatter.dateFormat = "dd-MM-yyyy"
            DateFormatter.locale =  NSLocale(localeIdentifier: "en_US_POSIX")
            let dateFromString = DateFormatter.dateFromString(date as! String)
            mData.matchDate = dateFromString
            matchVenueAndDate.appendContentsOf(date as? String ?? "NA")
        }
        
        if let group = value["AgeGroup"]{
            matchVenueAndDate.appendContentsOf(" | \(group)")
        }
        
        var groundData = ""
        
        let ground = value["Ground"] as? String
        if ground != "-" {
            groundData = ground! + " "
        }
        
        let venue = value["Venue"] as? String
        if venue != "-" {
            groundData = groundData + venue!
        }
        
        if ground == "-" && venue == "-" {
            groundData = (value["Level"] as? String)! + " Match"
        }
        
        mData.ground = groundData

        
//        if let ground = value["Ground"]{
//            mData.ground = ground as! String
//            
//            if let venue = value["Venue"] as? String where venue != "-" {
//                mData.ground = "\(ground), \(venue)"
//            }
//        }
        
        if let ballsFaced = value["BallsFaced"] as? String where ballsFaced != "-", let runsScored = value["RunsTaken"] as? String where runsScored != "-" && mData.BattingSectionHidden == false {
            
            if ballsFaced == "0" {
                mData.strikerate = Float("0.00")
            }
            else {
                let strikeRate = String(format: "%.1f",(Float(runsScored)!)*100/Float(ballsFaced)!)
                mData.strikerate = Float(strikeRate)
            }
        }
        
        if let oversBowled = value["OversBowled"] as? String where oversBowled != "-", let runsGiven = value["RunsGiven"] as? String where runsGiven != "-" && mData.BowlingSectionHidden == false {
            
            let economy = String(format: "%.1f",(Float(runsGiven)!)/Float(oversBowled)!)
            mData.economy = Float(economy)
            //matchVenueAndDate.appendContentsOf("\n Economy: \(economy)")
        }
        
        if let opponent  = value["Opponent"]{
            //opponentName = opponent.uppercaseString
            opponentName = opponent as! String
        }
        
        if let ageGroup = value["AgeGroup"] {
            ageGroupName = ageGroup as! String
        }
        
        if let level = value["Level"] {
            levelName = level as! String
        }
        mData.battingBowlingScore = battingBowlingScore
        mData.matchDateAndVenue = matchVenueAndDate
        mData.opponentName = opponentName
        mData.ageGroup = ageGroupName
        mData.level = levelName
        
        return mData
    }
    
    func getCellForRow(indexPath:NSIndexPath)->SummaryDetailsCell{
        
      
        if let aCell =  matchSummaryTable.dequeueReusableCellWithIdentifier("SummaryDetailsCell", forIndexPath: indexPath) as? SummaryDetailsCell {
            
            
            aCell.backgroundColor = UIColor.clearColor()
            
            aCell.baseView.backgroundColor = cricTracTheme.currentTheme.bottomColor
            
            aCell.baseView.alpha = 1
            
            let currentMatch = self.matches[indexPath.row]
           
            aCell.BattingOrBowlingScore.attributedText = currentMatch.battingBowlingScore
            aCell.matchDateAndVenue.text = currentMatch.matchDateAndVenue
            aCell.oponentName.text = currentMatch.opponentName
            aCell.stadiumLabel.text = currentMatch.ground
            
            if let isHidden = currentMatch.BattingSectionHidden where isHidden == true{
                
                if let isHidden = currentMatch.BowlingSectionHidden where isHidden == false{
                    aCell.strikeRateLabel.text = "Economy : \(currentMatch.economy!)"
                    aCell.strikeRateLabel.hidden = false
                }else{
                    aCell.strikeRateLabel.hidden = true
                }
                aCell.economyLabel.hidden = true
                
            }
            else
            {
                if let sRate = currentMatch.strikerate {
                    aCell.strikeRateLabel.hidden = false
                    aCell.economyLabel.hidden = true
                    aCell.strikeRateLabel.text = "Strike Rate : \(sRate)"
                }
                
                if let economy = currentMatch.economy {
                    aCell.economyLabel.hidden = false
                    aCell.economyLabel.text = "Economy : \(economy)"
                }
            }
            
            
         return aCell
        }
        else
        {
            return SummaryDetailsCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       
        
        if tableView == tableView1 {
           
            return filterLevel.count
        }
        
        if tableView == tableview2 {
            return filterAgeGroup.count
        }
        
        if tableView == tableView3 {
            return filterYear.count
        }
   
        if self.matchDataSource.count == 0 {
            noMatchesHeightConstraint.constant = 21
            self.noMatchesLabel.text = "No Matches"
            self.baseViewHeightConstraint.constant = 0
        }
        else {
            
            if toatalBowlingMatches == 0 && toatalBattingmatches != 0 {
                self.baseViewHeightConstraint.constant = 40
                self.subView3.hidden = true
                self.subView4.hidden = true
                self.subView1.hidden = false
                self.subView2.hidden = false
                self.view1HeightConstraint.constant = 36
                self.view2HeightConstraint.constant = 36
                self.view3HeightConstraint.constant = 0
                self.view4heightConstraint.constant = 0
                self.horizontalDividerView.constant = 0
                
            }
            else if toatalBattingmatches == 0 && toatalBowlingMatches != 0 {
                self.baseViewHeightConstraint.constant = 40
                
                self.subView1.hidden = true
                self.subView2.hidden = true
                self.subView3.hidden = false
                self.subView4.hidden = false
                self.view1HeightConstraint.constant = 0
                self.view2HeightConstraint.constant = 0
                self.view3HeightConstraint.constant = 36
                self.view4heightConstraint.constant = 36
                self.horizontalDividerView.constant = 0

            }
           else if toatalBowlingMatches == 0 && toatalBattingmatches == 0 {
                 self.baseViewHeightConstraint.constant = 0
            }
            else {
                self.baseViewHeightConstraint.constant = 80
                self.subView1.hidden = false
                self.subView2.hidden = false
                self.subView3.hidden = false
                self.subView4.hidden = false

                self.view1HeightConstraint.constant = 36
                self.view2HeightConstraint.constant = 36
                self.view3HeightConstraint.constant = 36
                self.view4heightConstraint.constant = 36

                self.horizontalDividerView.constant = 1

            }
            noMatchesHeightConstraint.constant = 0
            self.noMatchesLabel.text = ""
            
        }
       
        return self.matchDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentTheme = cricTracTheme.currentTheme
        
        if tableView == tableView1 {
            let cell = tableView1.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.textLabel?.text = filterLevel[indexPath.row]
            cell.backgroundColor = currentTheme.topColor
            if filterLevel[indexPath.row] == "Level"{
                cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 15)
                cell.textLabel?.textColor = UIColor.blackColor()
            }
            else {
                cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 16)
                cell.textLabel?.textColor = UIColor.whiteColor()
                cell.textLabel?.sizeToFit()
                
            }
           
            return cell
        }
        
        if tableView == tableview2 {
            let cell = tableview2.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.backgroundColor = currentTheme.topColor
            cell.textLabel?.text = filterAgeGroup[indexPath.row]
            
            if filterAgeGroup[indexPath.row] == "Age Group"{
                cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 15)
                cell.textLabel?.textColor = UIColor.blackColor()
            }
            else {
                cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 16)
                cell.textLabel?.textColor = UIColor.whiteColor()
            }
            return cell
        }
        
        if tableView == tableView3 {
            let cell = tableView3.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.backgroundColor = currentTheme.topColor
            filterYear = filterYear.sort { $0 > $1 }
            
            if filterYear[indexPath.row] == "Year" {
                cell.textLabel?.text = "Year"
                cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 15)
                cell.textLabel?.textColor = UIColor.blackColor()
            }
            else  {
                cell.textLabel?.text = filterYear[indexPath.row]
                cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 16)
                cell.textLabel?.textColor = UIColor.whiteColor()
            }
            
            return cell
        }
  
       return getCellForRow(indexPath)
    }
    

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        if tableView == tableView1 || tableView == tableview2 || tableView == tableView3
        {
              return 30
        }
        
        let currentMatch = self.matches[indexPath.row]
        
        if currentMatch.BattingSectionHidden == false && currentMatch.BowlingSectionHidden == false {
            return 120
        }
        else if currentMatch.BattingSectionHidden == false {
            return 105
        }
        else if currentMatch.BowlingSectionHidden == false {
            return 105
        }
            
        else {
            return 90
        }
 
      
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == tableView1 {
            let cell = tableView1.cellForRowAtIndexPath(indexPath)
            levelDropdown.text = cell?.textLabel?.text
            
            getMatchData()
            self.matchSummaryTable.reloadData()
            tableView1.hidden = true
        }
            
        else if tableView == tableview2 {
            let cell = tableview2.cellForRowAtIndexPath(indexPath)
            ageGroupDropdown.text = cell?.textLabel?.text
            getMatchData()
            self.matchSummaryTable.reloadData()
            tableview2.hidden = true
        }
            
        else if tableView == tableView3 {
            let cell = tableView3.cellForRowAtIndexPath(indexPath)
            yearDropdown.text = cell?.textLabel?.text
            
            getMatchData()
            self.matchSummaryTable.reloadData()
            tableView3.hidden = true
        }
        
        else if tableView == matchSummaryTable {
        
        //        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SummaryDetailsCell
        let summaryDetailsVC = viewControllerFrom("Main", vcid: "SummaryMatchDetailsViewController") as! SummaryMatchDetailsViewController
        
        summaryDetailsVC.battingViewHidden = matches[indexPath.row].BattingSectionHidden
        summaryDetailsVC.bowlingViewHidden = matches[indexPath.row].BowlingSectionHidden
        
        let selectedDataSource = self.matchDataSource.filter { (dat) -> Bool in
            return dat["MatchId"]! as! String == matches[indexPath.row].matchId
        }
        
        summaryDetailsVC.matchDetailsData = selectedDataSource.first
        //  presentViewController(summaryDetailsVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(summaryDetailsVC, animated: true)
        CFRunLoopWakeUp(CFRunLoopGetCurrent())
        
        }
        
    }
    
    //MARK: In App purchase
    
    // Optional: Use this methode to fetch product info.
    private func fetchProductInfo(){
        
        SwiftyStoreKit.retrieveProductsInfo(["CricTrac_Premium_Player"]) { result in
            if let product = result.retrievedProducts.first {
                let numberFormatter = NSNumberFormatter()
                numberFormatter.locale = product.priceLocale
                numberFormatter.numberStyle = .CurrencyStyle
                let priceString = numberFormatter.stringFromNumber(product.price ?? 0) ?? ""
                print("Product: \(product.localizedDescription), price: \(priceString)")
                self.inAppProductPrice = priceString
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                //return alertWithTitle("Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)")
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(result.error)")
            }
        }
    }
    
    @IBAction func didTapPurchaseButton(){
        
        if let msg = inAppProductPrice {
            let message =  "\n\n\n\n\n\n\n\n"
            
            let refreshAlert = UIAlertController(title: "Premium Account", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
            let rect  = CGRect(x: 0, y: 50, width: 270, height: 150)
            let textView    = UITextView(frame: rect)
            
            textView.font               = UIFont(name: "Helvetica", size: 15)
            textView.textColor          = UIColor.blackColor()
            textView.backgroundColor    = UIColor.clearColor()
            textView.layer.borderColor  = UIColor.lightGrayColor().CGColor
            textView.layer.borderWidth  = 1.0
            textView.text               = "  Free version allows only maximum 5 matches. Add unlimited matches by upgrading to premium by paying:\(msg) \n \n   You can also upgrade from CricTrac.com website with multiple payment options."
            textView.delegate = self as? UITextViewDelegate
            textView.editable = false
            textView.dataDetectorTypes = UIDataDetectorTypes.Link
            refreshAlert.view.addSubview(textView)
 
            
            refreshAlert.addAction(UIAlertAction(title: "Upgrade", style: .Default, handler: { (action: UIAlertAction!) in
                self.doPurchase()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Later", style: .Cancel, handler: { (action: UIAlertAction!) in
                //print("Handle Cancel Logic here")
            }))
            
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
        else {
            
            self.fetchProductInfo()
            
            let refreshAlert = UIAlertController(title: "Sorry", message: "Please try again", preferredStyle: UIAlertControllerStyle.Alert)
            refreshAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction!) in
            }))
            self.presentViewController(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func doPurchase(){
        
        SwiftyStoreKit.purchaseProduct("CricTrac_Premium_Player") { result in
            switch result {
            case .Success(let productId):
                upgradePlayer()
                self.userProfileData.UserStatus = "Premium"
                //print("Purchase Success: \(productId)")
                self.upgradeButton.setTitle("", forState: UIControlState.Normal)
                let refreshAlert = UIAlertController(title: "Success", message: "Congratulations for upgrading your account.", preferredStyle: UIAlertControllerStyle.Alert)
                refreshAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction!) in
                    self.upgradeBtnHeight.constant = 0
                }))
                self.presentViewController(refreshAlert, animated: true, completion: nil)
                
            case .Error(let error):
                print("Purchase Failed: \(error)")
            }
        }
    }
    
    @IBAction func levelDropDownButtonTapped(sender: UIButton) {
        if sender.tag == 2 {
            if tableView1.hidden == true {
            tableView3.hidden = true
            tableview2.hidden = true
            self.tableView1.reloadData()
               tableView1HeightConstraint.constant = CGFloat(filterLevel.count * 30)
            tableView1.hidden = false
            }
            else {
            tableView1HeightConstraint.constant = 0
            tableView1.hidden = true

            }
        }
        
        if sender.tag == 1 {
            if tableview2.hidden == true {
                tableView1.hidden = true
                tableView3.hidden = true
                self.tableview2.reloadData()
                tableView2HeightConstraint.constant = CGFloat(filterAgeGroup.count * 30)
                tableview2.hidden = false

            }
            else {
                tableView2HeightConstraint.constant = 0
                tableview2.hidden = true
                self.totalMatchesLabel.textColor = UIColor.whiteColor()
                self.totalMatchesText.textColor = UIColor.blackColor()
            }
        }
        
        if sender.tag == 3 {
            if tableView3.hidden == true {
                tableView1.hidden = true
                tableview2.hidden = true
                self.totalMatchesLabel.textColor = UIColor.whiteColor()
                self.totalMatchesText.textColor = UIColor.blackColor()
                self.tableView3.reloadData()
                tableView3HeightConstraint.constant = CGFloat(filterYear.count * 30)
                tableView3.hidden = false

            }
            else {
                tableView3HeightConstraint.constant = 0
                tableView3.hidden = true

            }
        }
        
    }
    
    
}








