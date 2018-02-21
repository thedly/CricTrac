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
    
    @IBOutlet weak var upgradeBtnHeight: NSLayoutConstraint!
    @IBOutlet var matchSummaryTable:UITableView!
    @IBOutlet weak var noMatchesHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var noMatchesLabel: UILabel!
    
    @IBOutlet weak var matchFilterView: UIView!
    @IBOutlet weak var filterViewHeightConstarint: NSLayoutConstraint!
    //For dropdowns
    
    @IBOutlet weak var yearDropdown: UITextField!
    @IBOutlet weak var levelDropdown: UITextField!
    @IBOutlet weak var ageGroupDropdown: UITextField!

    @IBOutlet weak var levelDropDownButton: UIButton!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView1HeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var ageDropdownButton: UIButton!
    @IBOutlet weak var tableview2: UITableView!
    @IBOutlet weak var tableView2HeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var yearDropdownButton: UIButton!
    @IBOutlet weak var tableView3: UITableView!
    @IBOutlet weak var tableView3HeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var topBarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topBarLabelText: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    var matchData = [String:AnyObject]()
    var matches = [MatchSummaryData]()
    var matchDataSource = [[String:AnyObject]]()
    
    var filterYear = [String]()
    var filterLevel = [String]()
    var filterAgeGroup = [String]()
    
    var userProfileData:Profile!
    var isCoach: Bool = false
    var coachTappedPlayerName = ""
    
    var toatalBowlingMatches = 0
    var toatalBattingmatches = 0
    
    var TotalWicketsTaken = 0
    var totalRunsGiven = 0
    var totalRuns = 0
    var totalDismissal = 0
    var totalOvers:Float = 0
    var totalBallsFaced = 0
    var playerID = ""
    var playerDob = ""
    
    var sizeOne:CGFloat = 10
    var sizeTwo:CGFloat = 15
    var sizeThree:CGFloat = 18
    var sizeFour:CGFloat = 20
    var sizeFive:CGFloat = 25
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        self.topBarView.backgroundColor = currentTheme.topColor
     
        self.tableView1.backgroundColor = currentTheme.topColor
        self.tableview2.backgroundColor = currentTheme.topColor
        self.tableView3.backgroundColor = currentTheme.bottomColor
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
        setColorForViewsWithSameTag(bottomView)
        
        tableView1.hidden = true
        tableview2.hidden = true
        tableView3.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if screensize == "1" {
            sizeOne = 10
            sizeTwo = 13
            sizeThree = 15
            sizeFour = 16
            sizeFive = 20
        }
        else if screensize == "2" {
            sizeOne = 10
            sizeTwo = 13
            sizeThree = 16
            sizeFour = 18
            sizeFive = 20
        }
        else if screensize == "3" {
            sizeOne = 10
            sizeTwo = 15
            sizeThree = 18
            sizeFour = 20
            sizeFive = 25
        }
        else if screensize == "4" {
            sizeOne = 12
            sizeTwo = 16
            sizeThree = 20
            sizeFour = 23
            sizeFive = 28
        }

        upgradeButton.setTitle("UPGRADE", forState: UIControlState.Normal)
        
        userProfileData = profileData
        if userProfileData.UserStatus == "Premium" || userProfileData.UserProfile != "Player" {
            //upgradeButton.hidden=true
            upgradeBtnHeight.constant = 0
        }
        else {
            setColorForViewsWithSameTag(bottomView)
            //upgradeButton.hidden = false
            upgradeBtnHeight.constant = 50
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
//        menuButton.setImage(UIImage(named: "menu-icon"), forState: UIControlState.Normal)
//        menuButton.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        
        if isCoach == true {
            topBarHeightConstraint.constant = 0
            topBarView.hidden = true
            menuButton.setImage(UIImage(named: "Back-100"), forState: UIControlState.Normal)
            menuButton.addTarget(self, action: #selector(didTapCancel), forControlEvents: UIControlEvents.TouchUpInside)
            navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
            title = coachTappedPlayerName
        }

        else if isCoach == false  {
            topBarHeightConstraint.constant = 0
            topBarView.hidden = true
            menuButton.setImage(UIImage(named: "menu-icon"), forState: UIControlState.Normal)
            menuButton.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
            navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
            title = "SCOREBOARD"
        }
        
         navigationItem.leftBarButtonItem = leftbarButton
        
    }
    @IBAction func didTapCancel(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func didMenuButtonTapp(sender: UIButton){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    func getMatchData(){
        //KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        if playerID == "" {
            playerID = (currentUser?.uid)!
        }
        
        fetchFriendDOB(playerID) { (dob) in
            self.playerDob = dob
        }
        
       getAllMatchData(playerID) { (data) in
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
                
                if value["RunsTaken"] as! String != "-" {
                    toatalBattingmatches += 1
                    let dismissal = value["Dismissal"] as? String
                    if  dismissal == "Not out" || dismissal == "Retired hurt" {
                        totalDismissal += 1
                    }
                    totalBallsFaced += Int(value["BallsFaced"] as! String)!
                    totalRuns += Int(value["RunsTaken"] as! String)!
                }
                
                //second innings
                if value["RunsTaken2"] != nil && value["RunsTaken2"] as! String != "-" {
                    toatalBattingmatches += 1
                    let dismissal2 = value["Dismissal2"] as? String
                    if  dismissal2 == "Not out" || dismissal2 == "Retired hurt" {
                        totalDismissal += 1
                    }
                    totalBallsFaced += Int(value["BallsFaced2"] as! String)!
                    totalRuns += Int(value["RunsTaken2"] as! String)!
                }
                
                if value["OversBowled"] as! String != "-" {
                    toatalBowlingMatches += 1
                    totalOvers += Float(value["OversBowled"] as! String)!
                    totalRunsGiven += Int(value["RunsGiven"] as! String)!
                    TotalWicketsTaken += Int(value["WicketsTaken"] as! String)!
                }
                
                //second innings
                if value["OversBowled2"] != nil && value["OversBowled2"] as! String != "-" {
                    toatalBowlingMatches += 1
                    totalOvers += Float(value["OversBowled2"] as! String)!
                    totalRunsGiven += Int(value["RunsGiven2"] as! String)!
                    TotalWicketsTaken += Int(value["WicketsTaken2"] as! String)!
                }
            }
            
            else if ageGroupDropdown.text != "Age Group" && levelDropdown.text != "Level" && yearDropdown.text != "Year"{
                
                if ageGroupDropdown.text == value["AgeGroup"] as? String && levelDropdown.text == value["Level"] as? String && yearDropdown.text == String(matchYear) {
                    self.matchDataSource.append(value)
                    self.matches.append(makeSummaryCell(value))
                    
                    if value["RunsTaken"] as! String != "-" {
                        toatalBattingmatches += 1
                        let dismissal = value["Dismissal"] as? String
                        if dismissal == "Not out" || dismissal == "Retired hurt" {
                            totalDismissal += 1
                        }
                        totalBallsFaced += Int(value["BallsFaced"] as! String)!
                        totalRuns += Int(value["RunsTaken"] as! String)!
                    }
                    
                    //second innings
                    if value["RunsTaken2"] != nil && value["RunsTaken2"] as! String != "-" {
                        toatalBattingmatches += 1
                        let dismissal2 = value["Dismissal2"] as? String
                        if dismissal2 == "Not out" || dismissal2 == "Retired hurt" {
                            totalDismissal += 1
                        }
                        totalBallsFaced += Int(value["BallsFaced2"] as! String)!
                        totalRuns += Int(value["RunsTaken2"] as! String)!
                    }
 
                    if value["OversBowled"] as! String != "-" {
                       toatalBowlingMatches += 1
                        totalOvers += Float(value["OversBowled"] as! String)!
                        totalRunsGiven += Int(value["RunsGiven"] as! String)!
                        TotalWicketsTaken += Int(value["WicketsTaken"] as! String)!
                    }
                    
                    //second innings
                    if value["OversBowled2"] != nil && value["OversBowled2"] as! String != "-" {
                        toatalBowlingMatches += 1
                        totalOvers += Float(value["OversBowled2"] as! String)!
                        totalRunsGiven += Int(value["RunsGiven2"] as! String)!
                        TotalWicketsTaken += Int(value["WicketsTaken2"] as! String)!
                    }
                }
            }
                
        else {
            if ageGroupDropdown.text != "Age Group"   && levelDropdown.text != "Level" {
                if ageGroupDropdown.text == value["AgeGroup"] as? String && levelDropdown.text == value["Level"] as? String {
                    self.matchDataSource.append(value)
                    self.matches.append(makeSummaryCell(value))
                
                    if value["RunsTaken"] as! String != "-" {
                        toatalBattingmatches += 1
                        let dismissal = value["Dismissal"] as? String
                        if  dismissal == "Not out" || dismissal == "Retired hurt" {
                            totalDismissal += 1
                        }
                        totalBallsFaced += Int(value["BallsFaced"] as! String)!
                        totalRuns += Int(value["RunsTaken"] as! String)!
                    }
                        
                    //second innings
                    if value["RunsTaken2"] != nil && value["RunsTaken2"] as! String != "-" {
                        toatalBattingmatches += 1
                        let dismissal2 = value["Dismissal2"] as? String
                        if  dismissal2 == "Not out" || dismissal2 == "Retired hurt" {
                            totalDismissal += 1
                        }
                        totalBallsFaced += Int(value["BallsFaced2"] as! String)!
                        totalRuns += Int(value["RunsTaken2"] as! String)!
                    }
                
                    if value["OversBowled"] as! String != "-" {
                        toatalBowlingMatches += 1
                        totalOvers += Float(value["OversBowled"] as! String)!
                        totalRunsGiven += Int(value["RunsGiven"] as! String)!
                        TotalWicketsTaken += Int(value["WicketsTaken"] as! String)!
                    }
                    
                    //second innings
                    if value["OversBowled2"] != nil && value["OversBowled2"] as! String != "-" {
                        toatalBowlingMatches += 1
                        totalOvers += Float(value["OversBowled2"] as! String)!
                        totalRunsGiven += Int(value["RunsGiven2"] as! String)!
                        TotalWicketsTaken += Int(value["WicketsTaken2"] as! String)!
                    }
                }
            }
            
        else if ageGroupDropdown.text != "Age Group"  && yearDropdown.text != "Year" {
                if ageGroupDropdown.text == value["AgeGroup"] as? String && yearDropdown.text == String(matchYear) {
                    self.matchDataSource.append(value)
                    self.matches.append(makeSummaryCell(value))
                    
                    if value["RunsTaken"] as! String != "-" {
                        toatalBattingmatches += 1
                        let dismissal = value["Dismissal"] as? String
                        if  dismissal == "Not out" || dismissal == "Retired hurt" {
                            totalDismissal += 1
                        }
                        totalBallsFaced += Int(value["BallsFaced"] as! String)!
                        totalRuns += Int(value["RunsTaken"] as! String)!
                    }
                    
                    //second innings
                    if value["RunsTaken2"] != nil && value["RunsTaken2"] as! String != "-" {
                        toatalBattingmatches += 1
                        let dismissal2 = value["Dismissal2"] as? String
                        if  dismissal2 == "Not out" || dismissal2 == "Retired hurt" {
                            totalDismissal += 1
                        }
                        totalBallsFaced += Int(value["BallsFaced2"] as! String)!
                        totalRuns += Int(value["RunsTaken2"] as! String)!
                    }
                    
                    if value["OversBowled"] as! String != "-" {
                        toatalBowlingMatches += 1
                        totalOvers += Float(value["OversBowled"] as! String)!
                        totalRunsGiven += Int(value["RunsGiven"] as! String)!
                        TotalWicketsTaken += Int(value["WicketsTaken"] as! String)!
                    }
                    
                    //second innings
                    if value["OversBowled2"] != nil && value["OversBowled2"] as! String != "-" {
                        toatalBowlingMatches += 1
                        totalOvers += Float(value["OversBowled2"] as! String)!
                        totalRunsGiven += Int(value["RunsGiven2"] as! String)!
                        TotalWicketsTaken += Int(value["WicketsTaken2"] as! String)!
                    }
                }
            }
            
        else if levelDropdown.text != "Level" && yearDropdown.text != "Year" {
            if levelDropdown.text == value["Level"] as? String && yearDropdown.text == String(matchYear) {
                self.matchDataSource.append(value)
                self.matches.append(makeSummaryCell(value))
                
                if value["RunsTaken"] as! String != "-" {
                    toatalBattingmatches += 1
                    let dismissal = value["Dismissal"] as? String
                    if  dismissal == "Not out" || dismissal == "Retired hurt" {
                        totalDismissal += 1
                    }
                    totalBallsFaced += Int(value["BallsFaced"] as! String)!
                    totalRuns += Int(value["RunsTaken"] as! String)!
                }
                
                //second innings
                if value["RunsTaken2"] != nil && value["RunsTaken2"] as! String != "-" {
                    toatalBattingmatches += 1
                    let dismissal2 = value["Dismissal2"] as? String
                    if  dismissal2 == "Not out" || dismissal2 == "Retired hurt" {
                        totalDismissal += 1
                    }
                    totalBallsFaced += Int(value["BallsFaced2"] as! String)!
                    totalRuns += Int(value["RunsTaken2"] as! String)!
                }
                
                if value["OversBowled"] as! String != "-" {
                    toatalBowlingMatches += 1
                    totalOvers += Float(value["OversBowled"] as! String)!
                    totalRunsGiven += Int(value["RunsGiven"] as! String)!
                    TotalWicketsTaken += Int(value["WicketsTaken"] as! String)!
                }
                
                //second innings
                if value["OversBowled2"] != nil && value["OversBowled2"] as! String != "-" {
                    toatalBowlingMatches += 1
                    totalOvers += Float(value["OversBowled2"] as! String)!
                    totalRunsGiven += Int(value["RunsGiven2"] as! String)!
                    TotalWicketsTaken += Int(value["WicketsTaken2"] as! String)!
                }
            }
        }
                
        else if ageGroupDropdown.text != "Age Group" {
            if ageGroupDropdown.text == value["AgeGroup"] as? String {
                self.matchDataSource.append(value)
                self.matches.append(makeSummaryCell(value))
               
                if value["RunsTaken"] as! String != "-" {
                    toatalBattingmatches += 1
                    let dismissal = value["Dismissal"] as? String
                    if  dismissal == "Not out" || dismissal == "Retired hurt" {
                        totalDismissal += 1
                    }
                     totalBallsFaced += Int(value["BallsFaced"] as! String)!
                     totalRuns += Int(value["RunsTaken"] as! String)!
                }
                
                //second innings
                if value["RunsTaken2"] != nil && value["RunsTaken2"] as! String != "-" {
                    toatalBattingmatches += 1
                    let dismissal2 = value["Dismissal2"] as? String
                    if  dismissal2 == "Not out" || dismissal2 == "Retired hurt" {
                        totalDismissal += 1
                    }
                    totalBallsFaced += Int(value["BallsFaced2"] as! String)!
                    totalRuns += Int(value["RunsTaken2"] as! String)!
                }

                if value["OversBowled"] as! String != "-" {
                    toatalBowlingMatches += 1
                    totalOvers += Float(value["OversBowled"] as! String)!
                    totalRunsGiven += Int(value["RunsGiven"] as! String)!
                    TotalWicketsTaken += Int(value["WicketsTaken"] as! String)!
                }
                
                //second innings
                if value["OversBowled2"] != nil && value["OversBowled2"] as! String != "-" {
                    toatalBowlingMatches += 1
                    totalOvers += Float(value["OversBowled2"] as! String)!
                    totalRunsGiven += Int(value["RunsGiven2"] as! String)!
                    TotalWicketsTaken += Int(value["WicketsTaken2"] as! String)!
                }
            }
        }
            
        else if levelDropdown.text != "Level" {
          if levelDropdown.text == value["Level"] as? String {
            self.matchDataSource.append(value)
            self.matches.append(makeSummaryCell(value))
            
            if value["RunsTaken"] as! String != "-" {
                toatalBattingmatches += 1
                let dismissal = value["Dismissal"] as? String
              if dismissal == "Not out" || dismissal == "Retired hurt" {
                    totalDismissal += 1
                }
                totalBallsFaced += Int(value["BallsFaced"] as! String)!
                totalRuns += Int(value["RunsTaken"] as! String)!
            }
            
            //second innings
            if value["RunsTaken2"] != nil && value["RunsTaken2"] as! String != "-" {
                toatalBattingmatches += 1
                let dismissal2 = value["Dismissal2"] as? String
                if  dismissal2 == "Not out" || dismissal2 == "Retired hurt" {
                    totalDismissal += 1
                }
                totalBallsFaced += Int(value["BallsFaced2"] as! String)!
                totalRuns += Int(value["RunsTaken2"] as! String)!
            }
            
            if value["OversBowled"] as! String != "-" {
                toatalBowlingMatches += 1
                totalOvers += Float(value["OversBowled"] as! String)!
                totalRunsGiven += Int(value["RunsGiven"] as! String)!
                TotalWicketsTaken += Int(value["WicketsTaken"] as! String)!
            }
            
            //second innings
            if value["OversBowled2"] != nil && value["OversBowled2"] as! String != "-" {
                toatalBowlingMatches += 1
                totalOvers += Float(value["OversBowled2"] as! String)!
                totalRunsGiven += Int(value["RunsGiven2"] as! String)!
                TotalWicketsTaken += Int(value["WicketsTaken2"] as! String)!
            }
        }
    }
            
        else if yearDropdown.text != "Year" {
          if yearDropdown.text == String(matchYear) {
            self.matchDataSource.append(value)
            self.matches.append(makeSummaryCell(value))
            
            if value["RunsTaken"] as! String != "-" {
                toatalBattingmatches += 1
                let dismissal = value["Dismissal"] as? String
                if  dismissal == "Not out" || dismissal == "Retired hurt" {
                    totalDismissal += 1
                }
                totalBallsFaced += Int(value["BallsFaced"] as! String)!
                totalRuns += Int(value["RunsTaken"] as! String)!
            }
            
            //second innings
            if value["RunsTaken2"] != nil && value["RunsTaken2"] as! String != "-" {
                toatalBattingmatches += 1
                let dismissal2 = value["Dismissal2"] as? String
                if  dismissal2 == "Not out" || dismissal2 == "Retired hurt" {
                    totalDismissal += 1
                }
                totalBallsFaced += Int(value["BallsFaced2"] as! String)!
                totalRuns += Int(value["RunsTaken2"] as! String)!
            }
            
            if value["OversBowled"] as! String != "-" {
                toatalBowlingMatches += 1
                totalOvers += Float(value["OversBowled"] as! String)!
                totalRunsGiven += Int(value["RunsGiven"] as! String)!
                TotalWicketsTaken += Int(value["WicketsTaken"] as! String)!
            }
            
            //second innings
            if value["OversBowled2"] != nil && value["OversBowled2"] as! String != "-" {
                toatalBowlingMatches += 1
                totalOvers += Float(value["OversBowled2"] as! String)!
                totalRunsGiven += Int(value["RunsGiven2"] as! String)!
                TotalWicketsTaken += Int(value["WicketsTaken2"] as! String)!
            }
        }
        }
        }
      }
    }
        self.matches.sortInPlace({ $0.matchDate.compare($1.matchDate) == NSComparisonResult.OrderedDescending })
               self.matchSummaryTable.reloadData()
}
    
    func makeSummaryCell(value: [String : AnyObject]) -> MatchSummaryData {
        let battingBowlingScore = NSMutableAttributedString()
        var matchVenueAndDate = ""
        var opponentName = ""
        var ageGroupName = ""
        var levelName = ""
        
        let mData = MatchSummaryData()
        mData.matchId = value["key"] as! String
        mData.result = value["Result"] as! String
        
        //code added by Sajith for Double Innings
        var matchFormat = ""
        var batting1 = false
        var batting2 = false
        var bowling1 = false
        var bowling2 = false
        
        if value["MatchFormat"] as? String != "" && value["MatchFormat"] != nil {
            matchFormat = value["MatchFormat"] as! String
        }
        
        if matchFormat == "Double Innings" {
            //data for first innings
            if let runsTaken = value["RunsTaken"]{
                mData.BattingSectionHidden = (runsTaken as! String == "-")
                if mData.BattingSectionHidden == false {
                    batting1 = true
                    if let dismissal = value["Dismissal"] as? String where dismissal == "Not out"{
                        battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: sizeThree).bold("*", fontName: appFont_black, fontSize: sizeThree)
                    }
                    else{
                        battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: sizeThree)
                    }
                }
            }
            //data for second innings
            if let runsTaken2 = value["RunsTaken2"]{
                mData.BattingSectionHidden = (runsTaken2 as! String == "-")
                if mData.BattingSectionHidden == false {
                    if batting1 == true {
                        battingBowlingScore.bold(", ", fontName: appFont_black, fontSize: sizeTwo)
                    }
                    else {
                        battingBowlingScore.bold("DNB, ", fontName: appFont_black, fontSize: sizeTwo)
                    }
                    batting2 = true
                    if let dismissal2 = value["Dismissal2"] as? String where dismissal2 == "Not out"{
                        battingBowlingScore.bold(runsTaken2 as! String, fontName: appFont_black, fontSize: sizeThree).bold("*", fontName: appFont_black, fontSize: sizeThree)
                    }
                    else{
                        battingBowlingScore.bold(runsTaken2 as! String, fontName: appFont_black, fontSize: sizeThree)
                    }
                }
            }
            
            if batting1 == true || batting2 == true {
                mData.BattingSectionHidden = false
                battingBowlingScore.bold("\nRUNS", fontName: appFont_black, fontSize: sizeOne)
            }
        }
        else {
            if let runsTaken = value["RunsTaken"]{
                mData.BattingSectionHidden = (runsTaken as! String == "-")
                if mData.BattingSectionHidden == false {
                    if let dismissal = value["Dismissal"] as? String where dismissal == "Not out"{
                        battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: sizeFive).bold("*", fontName: appFont_black, fontSize: sizeFive).bold("\nRUNS", fontName: appFont_black, fontSize: sizeOne)
                    }
                    else{
                        battingBowlingScore.bold(runsTaken as! String, fontName: appFont_black, fontSize: sizeFive).bold("\nRUNS", fontName: appFont_black, fontSize: sizeOne)
                    }
                }
            }
        }
        
        
        if matchFormat == "Double Innings" {
            //data for first innings
            if let wicketsTaken = value["WicketsTaken"], let runsGiven = value["RunsGiven"] {
                mData.BowlingSectionHidden = (runsGiven as! String == "-")
                if mData.BowlingSectionHidden == false {
                    bowling1 = true
                    if battingBowlingScore.length > 0 {
                        battingBowlingScore.bold("\n\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: sizeThree)
                    }
                    else{
                        battingBowlingScore.bold("\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: sizeThree)
                    }
                }
            }
            //data for second innings
            if let wicketsTaken2 = value["WicketsTaken2"], let runsGiven2 = value["RunsGiven2"] {
                mData.BowlingSectionHidden = (runsGiven2 as! String == "-")
                if mData.BowlingSectionHidden == false {
                    if bowling1 == true {
                        battingBowlingScore.bold(", ", fontName: appFont_black, fontSize: sizeTwo)
                    }
                    else {
                        battingBowlingScore.bold("\nDNB, ", fontName: appFont_black, fontSize: sizeTwo)
                    }
                    bowling2 = true
                    if battingBowlingScore.length > 0 {
                        battingBowlingScore.bold("\n\(wicketsTaken2)-\(runsGiven2)", fontName: appFont_black, fontSize: sizeThree)
                    }
                    else{
                        battingBowlingScore.bold("\(wicketsTaken2)-\(runsGiven2)", fontName: appFont_black, fontSize: sizeThree)
                    }
                }
            }
            
            if bowling1 == true || bowling2 == true {
                mData.BowlingSectionHidden = false
            }
            
            if bowling1 == false && bowling2 == false {
            }
            else if bowling1 == true || bowling2 == true {
                    battingBowlingScore.bold("\nWICKETS", fontName: appFont_black, fontSize: sizeOne)
            }
            else if batting1 == false && batting2 == false {
                    battingBowlingScore.bold("\nWICKETS", fontName: appFont_black, fontSize: sizeOne)
            }
        }
        else {
            if let wicketsTaken = value["WicketsTaken"], let runsGiven = value["RunsGiven"] {
                mData.BowlingSectionHidden = (runsGiven as! String == "-")
                if mData.BowlingSectionHidden == false {
                    if battingBowlingScore.length > 0 {
                        battingBowlingScore.bold("\n\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: sizeFive).bold("\nWICKETS", fontName: appFont_black, fontSize: sizeOne)
                    }
                    else{
                        battingBowlingScore.bold("\(wicketsTaken)-\(runsGiven)", fontName: appFont_black, fontSize: sizeFive).bold("\nWICKETS", fontName: appFont_black, fontSize: sizeOne)
                    }
                }
            }
        }
        
        if battingBowlingScore.length == 0 {
            battingBowlingScore.bold("DNB", fontName: appFont_black, fontSize: sizeFive)
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
        
        var ballsFaced1 = 0
        var runsScored1 = 0
        
        if let ballsFaced = value["BallsFaced"] as? String where ballsFaced != "-", let runsScored = value["RunsTaken"] as? String where runsScored != "-" && mData.BattingSectionHidden == false {
            
            ballsFaced1 = Int(ballsFaced)!
            runsScored1 = Int(runsScored)!
            
            if ballsFaced == "0" {
                mData.strikerate = Float("0.00")
            }
            else {
                let strikeRate = String(format: "%.1f",(Float(runsScored)!)*100/Float(ballsFaced)!)
                mData.strikerate = Float(strikeRate)
            }
        }
        
        //second innings
        if let ballsFaced2 = value["BallsFaced2"] as? String where ballsFaced2 != "-", let runsScored2 = value["RunsTaken2"] as? String where runsScored2 != "-" && mData.BattingSectionHidden == false {
            
            if ballsFaced2 == "0" {
                if mData.strikerate != nil {
                    mData.strikerate = mData.strikerate + Float("0.00")!
                }
                else {
                    mData.strikerate = Float("0.00")
                }
            }
            else {
                let totalBallsFaced = ballsFaced1 + Int(ballsFaced2)!
                let totalRunsScored = runsScored1 + Int(runsScored2)!
                let strikeRate2 = String(format: "%.1f",Float(totalRunsScored)*100/Float(totalBallsFaced))
                if totalBallsFaced == 0 {
                    mData.strikerate = Float("0.00")
                }
                else {
                    mData.strikerate = Float(strikeRate2)
                }
            }
        }
        
        if let oversBowled = value["OversBowled"] as? String where oversBowled != "-", let runsGiven = value["RunsGiven"] as? String where runsGiven != "-" && mData.BowlingSectionHidden == false {
            
            let economy = String(format: "%.2f",(Float(runsGiven)!)/Float(oversBowled)!)
            mData.economy = Float(economy)
            //matchVenueAndDate.appendContentsOf("\n Economy: \(economy)")
        }
        
        //second innings
        if let oversBowled2 = value["OversBowled2"] as? String where oversBowled2 != "-", let runsGiven2 = value["RunsGiven2"] as? String where runsGiven2 != "-" && mData.BowlingSectionHidden == false {
            
            let economy2 = String(format: "%.2f",(Float(runsGiven2)!)/Float(oversBowled2)!)
            if mData.economy != nil {
                mData.economy = (mData.economy + Float(economy2)!)/2
            }
            else {
                mData.economy = Float(economy2)
            }
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
            
            let currentMatch = self.matches[indexPath.row - 1]
           
            aCell.BattingOrBowlingScore.attributedText = currentMatch.battingBowlingScore
            
            let formattedStringName = NSMutableAttributedString()
            let formattedOpponentName = formattedStringName.bold(currentMatch.opponentName, fontName: appFont_black, fontSize: self.sizeThree)
            
            let formattedStringDate = NSMutableAttributedString()
            let formattedDate = formattedStringDate.bold(currentMatch.matchDateAndVenue, fontName: appFont_black, fontSize: self.sizeTwo)
            
            let formattedStringGround = NSMutableAttributedString()
            let formattedGround = formattedStringGround.bold(currentMatch.ground, fontName: appFont_black, fontSize: self.sizeTwo)
            
            aCell.oponentName.attributedText = formattedOpponentName
            aCell.matchDateAndVenue.attributedText = formattedDate
            aCell.stadiumLabel.attributedText = formattedGround
            if currentMatch.result == "Won" {
                aCell.vsImageView.image = UIImage(named: "thumbsup")
            }
            else if currentMatch.result == "Lost" {
                aCell.vsImageView.image = UIImage(named: "thumbsdown")
            }
            else {
                aCell.vsImageView.image = UIImage(named: "match-tie")
            }
            
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
                    aCell.strikeRateLabel.text = "Strike Rate: \(sRate)"
                }
                
                if let economy = currentMatch.economy {
                    aCell.economyLabel.hidden = false
                    aCell.economyLabel.text = "Economy: \(economy)"
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
           
            return filterAgeGroup.count
        }
        
        if tableView == tableview2 {
            return filterLevel.count
        }
        
        if tableView == tableView3 {
            return filterYear.count
        }
   
        if self.matchDataSource.count == 0 {
            noMatchesHeightConstraint.constant = 21
            self.noMatchesLabel.text = "No Matches"
            if self.matchData.count == 0 {
                self.filterViewHeightConstarint.constant = 0
                self.matchFilterView.hidden = true
                self.matchSummaryTable.hidden = true
            }
        }
        else {
            self.filterViewHeightConstarint.constant = 34
            self.matchFilterView.hidden = false
            self.matchSummaryTable.hidden = false
 
             noMatchesHeightConstraint.constant = 0
            self.noMatchesLabel.text = ""
            
        }
       
        return self.matchDataSource.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentTheme = cricTracTheme.currentTheme
        
        if tableView == tableView1 {
            let cell = tableView1.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            
            cell.backgroundColor = currentTheme.topColor
            filterAgeGroup = filterAgeGroup.sort{ $0 < $1 }
            
            if filterAgeGroup[indexPath.row] == "Age Group"{
                cell.textLabel?.text = "Age Group"
                cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 15)
                cell.textLabel?.textColor = UIColor.blackColor()
                cell.textLabel?.alpha = 0.3
            }
            else {
                cell.textLabel?.text = filterAgeGroup[indexPath.row]
                cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 16)
                cell.textLabel?.textColor = UIColor.blackColor()
                cell.textLabel?.sizeToFit()
                
            }
           
            return cell
        }
        
        if tableView == tableview2 {
            let cell = tableview2.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.backgroundColor = currentTheme.topColor
            
            if filterLevel[indexPath.row] == "Level"{
                cell.textLabel?.text = "Level"
                cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 15)
                cell.textLabel?.textColor = UIColor.blackColor()
                cell.textLabel?.alpha = 0.3
            }
            else {
                cell.textLabel?.text = filterLevel[indexPath.row]
                cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 16)
                cell.textLabel?.textColor = UIColor.blackColor()
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
                cell.textLabel?.alpha = 0.3
            }
            else  {
                cell.textLabel?.text = filterYear[indexPath.row]
                cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 16)
                cell.textLabel?.textColor = UIColor.blackColor()
            }
            
            return cell
        }
        
        if tableView == matchSummaryTable {
            if indexPath.row == 0 {
                let aCell = matchSummaryTable.dequeueReusableCellWithIdentifier("cell") as! MatchFilterCell
                 aCell.baseView.backgroundColor = currentTheme.bottomColor
                 aCell.baseView.layer.cornerRadius = 10
                 aCell.baseView.clipsToBounds = true
                
                 aCell.totalMatchesLabel.text = String(self.matchDataSource.count)
                 aCell.battingMatches.text = String(toatalBattingmatches)
                 aCell.bowlingMatches.text = String(toatalBowlingMatches)
                 aCell.runs.text = String(totalRuns)
                 aCell.wickets.text = String(TotalWicketsTaken)
                
                
                // TotalBattingAvg
                if (toatalBattingmatches - totalDismissal) > 0 {
                     aCell.battingAvg.text = String(format: "%.1f",(Float(totalRuns))/Float(toatalBattingmatches - totalDismissal))
                    }
                    else{
                     aCell.battingAvg.text = "-"
                    }
                
                //Total Economy & TotalBowlingAvg
                if totalRunsGiven != 0 {
                    if TotalWicketsTaken == 0 {
                        aCell.bowlingAvg.text = "0.0"
                    }
                    else {
                        aCell.bowlingAvg.text = String(format: "%.1f",Float(totalRunsGiven) / Float(TotalWicketsTaken))
                    }
                    aCell.economy.text = String(format: "%.1f",Float(totalRunsGiven) / Float(totalOvers))
                }
                else{
                    aCell.bowlingAvg.text = "-"
                    aCell.economy.text = "-"
                }
                // TotalStrikeRate
                if totalBallsFaced != 0 {
                    let strikeRate = String(format: "%.1f",(Float(totalRuns))*100/Float(totalBallsFaced))
                     aCell.strikeRate.text = strikeRate
                    }
                    else{
                        aCell.strikeRate.text = "-"
                    }
              // for expanding matchfilter views
                
                    if toatalBowlingMatches == 0 && toatalBattingmatches != 0 {
                                        aCell.baseViewHeightConstraint.constant = 40
                                        aCell.subView3.hidden = true
                                        aCell.subView4.hidden = true
                                        aCell.subView1.hidden = false
                                        aCell.subView2.hidden = false
                                        aCell.view1HeightConstraint.constant = 36
                                        aCell.view2HeightConstraint.constant = 36
                                        aCell.view3HeightConstraint.constant = 0
                                        aCell.view4heightConstraint.constant = 0
                                        aCell.horizontalDividerView.constant = 0
                        
                    }
                    else if toatalBattingmatches == 0 && toatalBowlingMatches != 0 {
                                        aCell.baseViewHeightConstraint.constant = 40
                        
                                        aCell.subView1.hidden = true
                                        aCell.subView2.hidden = true
                                        aCell.subView3.hidden = false
                                        aCell.subView4.hidden = false
                                        aCell.view1HeightConstraint.constant = 0
                                        aCell.view2HeightConstraint.constant = 0
                                        aCell.view3HeightConstraint.constant = 36
                                        aCell.view4heightConstraint.constant = 36
                                        aCell.horizontalDividerView.constant = 0
                        
                    }
                    else if toatalBowlingMatches == 0 && toatalBattingmatches == 0 {
                         aCell.baseViewHeightConstraint.constant = 0
                        
                        }
                        else {
                                        aCell.baseViewHeightConstraint.constant = 80
                                        aCell.subView1.hidden = false
                                        aCell.subView2.hidden = false
                                        aCell.subView3.hidden = false
                                        aCell.subView4.hidden = false
                        
                                        aCell.view1HeightConstraint.constant = 36
                                        aCell.view2HeightConstraint.constant = 36
                                        aCell.view3HeightConstraint.constant = 36
                                        aCell.view4heightConstraint.constant = 36
                        
                                        aCell.horizontalDividerView.constant = 1
                        
                    }
                
                return aCell
            }
            else{
                 return getCellForRow(indexPath)
            }
        }
  
       return getCellForRow(indexPath)
    }
    

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        if tableView == tableView1 || tableView == tableview2 || tableView == tableView3
        {
              return 30
        }
        
        
        if tableView == matchSummaryTable {
            if indexPath.row == 0 {
                if toatalBowlingMatches == 0 && toatalBattingmatches == 0{
                    return 25
                }
                else if toatalBowlingMatches != 0 && toatalBattingmatches == 0{
                    return 80
                }
                else if toatalBowlingMatches == 0 && toatalBattingmatches != 0{
                    return 80
                }
                return 115
            }
            else{
                let currentMatch = self.matches[indexPath.row - 1]
                
                if currentMatch.BattingSectionHidden == false && currentMatch.BowlingSectionHidden == false {
                    return 120
                }
                else if currentMatch.BattingSectionHidden == false {
                    return 105
                }
                else if currentMatch.BowlingSectionHidden == false {
                    return 105
                }
            }
        }
        return 90
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == tableView1 {
            let cell = tableView1.cellForRowAtIndexPath(indexPath)
            ageGroupDropdown.text = cell?.textLabel?.text
            
            getMatchData()
            self.matchSummaryTable.reloadData()
            tableView1.hidden = true
        }
            
        else if tableView == tableview2 {
            let cell = tableview2.cellForRowAtIndexPath(indexPath)
            levelDropdown.text = cell?.textLabel?.text
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
        
        if indexPath.row != 0 {
            
            let summaryDetailsVC = viewControllerFrom("Main", vcid: "SummaryMatchDetailsViewController") as! SummaryMatchDetailsViewController
        
            summaryDetailsVC.battingViewHidden = matches[indexPath.row - 1].BattingSectionHidden
            summaryDetailsVC.bowlingViewHidden = matches[indexPath.row - 1].BowlingSectionHidden
        
            let selectedDataSource = self.matchDataSource.filter { (dat) -> Bool in
            return dat["MatchId"]! as! String == matches[indexPath.row - 1].matchId
                
            }
            
            if isCoach == true {
                summaryDetailsVC.isCoach = true
                summaryDetailsVC.playerDob = playerDob
            }
            summaryDetailsVC.matchDetailsData = selectedDataSource.first
            self.navigationController?.pushViewController(summaryDetailsVC, animated: true)
            CFRunLoopWakeUp(CFRunLoopGetCurrent())
            }
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
                //print("Product: \(product.localizedDescription), price: \(priceString)")
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
            let message =  "\n\n\n\n\n"
            
            let refreshAlert = UIAlertController(title: "Premium Account", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
            let rect  = CGRect(x: 0, y: 50, width: 270, height: 100)
            let textView    = UITextView(frame: rect)
            
            textView.font               = UIFont(name: "SourceSansPro-Bold", size: 16)
            textView.textColor          = UIColor.blackColor()
            textView.backgroundColor    = UIColor.clearColor()
            textView.layer.borderColor  = UIColor.clearColor().CGColor
            textView.layer.borderWidth  = 1.0
           // textView.text               = "Free version allows only maximum 5 matches. Add unlimited matches by upgrading to premium by paying:\(msg) \n \nYou can also upgrade from CricTrac.com website with multiple payment options."
            
            let attributedString = NSMutableAttributedString(string:"Free version allows only maximum 5 matches. Add unlimited matches by upgrading to premium by paying:\(msg) \n \nYou can also upgrade from CricTrac.com website with multiple payment options.")
            
            textView.delegate = self as? UITextViewDelegate
            textView.editable = false
            textView.dataDetectorTypes = UIDataDetectorTypes.Link
            refreshAlert.view.addSubview(textView)
            
            textView.attributedText = attributedString
            
            refreshAlert.addAction(UIAlertAction(title: "Upgrade", style: .Default, handler: { (action: UIAlertAction!) in
                self.doPurchase()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Later", style: .Default, handler: { (action: UIAlertAction!) in
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
        if sender.tag == 1 {
            if tableView1.hidden == true {
            tableView3.hidden = true
            tableview2.hidden = true
            self.tableView1.reloadData()
               tableView1HeightConstraint.constant = CGFloat(filterAgeGroup.count * 30)
            tableView1.hidden = false
            }
            else {
            tableView1HeightConstraint.constant = 0
            tableView1.hidden = true

            }
        }
        
        if sender.tag == 2 {
            if tableview2.hidden == true {
                tableView1.hidden = true
                tableView3.hidden = true
                self.tableview2.reloadData()
                tableView2HeightConstraint.constant = CGFloat(filterLevel.count * 30)
                tableview2.hidden = false

            }
            else {
                tableView2HeightConstraint.constant = 0
                tableview2.hidden = true
            }
        }
        
        if sender.tag == 3 {
            if tableView3.hidden == true {
                tableView1.hidden = true
                tableview2.hidden = true
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








