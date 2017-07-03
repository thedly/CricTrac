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
    
    
    var matchData = [String:AnyObject]()
    var matches = [MatchSummaryData]()
    var matchDataSource = [[String:AnyObject]]()
    
    var filterYear = [String]()
    var filterLevel = [String]()
    var filterAgeGroup = [String]()
    
    var filterCurrentMatch = [[String:AnyObject]]()
    
    var userProfileData:Profile!
    
    
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        
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
        setBackgroundColor()
        self.matchSummaryTable.reloadData()
        self.tableView1.reloadData()
        setNavigationBarProperties()
        
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
        
        //var matchsf = ""
        
        
        
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

            }
            else if ageGroupDropdown.text != "Age Group" && levelDropdown.text != "Level" && yearDropdown.text != "Year"{
                
                if ageGroupDropdown.text == value["AgeGroup"] as? String && levelDropdown.text == value["Level"] as? String && yearDropdown.text == String(matchYear) {
                self.matchDataSource.append(value)
                self.matches.append(makeSummaryCell(value))
                }

            }
                
        else {
                if ageGroupDropdown.text != "Age Group"   && levelDropdown.text != "Level" {
            
            if ageGroupDropdown.text == value["AgeGroup"] as? String && levelDropdown.text == value["Level"] as? String {
                self.matchDataSource.append(value)
                self.matches.append(makeSummaryCell(value))
            }
        }
            
        else if ageGroupDropdown.text != "Age Group"  && yearDropdown.text != "Year" {
                if ageGroupDropdown.text == value["AgeGroup"] as? String && yearDropdown.text == String(matchYear) {
                    self.matchDataSource.append(value)
                    self.matches.append(makeSummaryCell(value))

                }
        }
            
        else if levelDropdown.text != "Level" && yearDropdown.text != "Year" {
            if levelDropdown.text == value["Level"] as? String && yearDropdown.text == String(matchYear) {
            self.matchDataSource.append(value)
            self.matches.append(makeSummaryCell(value))
            }
            
        }
        else if ageGroupDropdown.text != "Age Group" {
            if ageGroupDropdown.text == value["AgeGroup"] as? String {
            self.matchDataSource.append(value)
            self.matches.append(makeSummaryCell(value))
            
            }

        }
            
        else if levelDropdown.text != "Level" {
          if levelDropdown.text == value["Level"] as? String {
            self.matchDataSource.append(value)
            self.matches.append(makeSummaryCell(value))

            }
        }
            
        else if yearDropdown.text != "Year" {
          if yearDropdown.text == String(matchYear) {
            self.matchDataSource.append(value)
            self.matches.append(makeSummaryCell(value))
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
        
       // let matchData1 = MatchSummaryData()
        
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
        }
        else {
            noMatchesHeightConstraint.constant = 0
        }
        
//        if ageGroupDropdown.text != "Age Group" {
//       
//            return self.filterCurrentMatch.count
//         
//        }
        
        return self.matchDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == tableView1 {
            let cell = tableView1.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.textLabel?.text = filterLevel[indexPath.row]
            if filterLevel[indexPath.row] == "Level"{
                cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 15)
                cell.textLabel?.textColor = UIColor.grayColor()
            }
            else {
                cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 15)
                cell.textLabel?.textColor = UIColor.whiteColor()
            }
            
            return cell
        }
        
        if tableView == tableview2 {
            let cell = tableview2.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.textLabel?.text = filterAgeGroup[indexPath.row]
            
            if filterAgeGroup[indexPath.row] == "Age Group"{
                cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 15)
                cell.textLabel?.textColor = UIColor.grayColor()
            }
            else {
                cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 15)
                cell.textLabel?.textColor = UIColor.whiteColor()
            }
            return cell
        }
        
        if tableView == tableView3 {
            let cell = tableView3.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.textLabel?.text = filterYear[indexPath.row]
            if filterYear[indexPath.row] == "Year" {
                cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 15)
                cell.textLabel?.textColor = UIColor.grayColor()
            }
            else {
                cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 15)
                cell.textLabel?.textColor = UIColor.whiteColor()
            }
            
            return cell
        }
        
        
        
        return getCellForRow(indexPath)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if tableView == tableView1 || tableView == tableview2 || tableView == tableView3
        {
              return 20
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
        
//        if ageGroupDropdown.text  != "Age Group" {
//            if ageGroupDropdown.text == currentMatch.ageGroup {
        

        
        
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
            
            let message = "Free version allows only maximum 5 matches. Add unlimited matches by upgrading to premium by paying: \(msg)"
            
            let refreshAlert = UIAlertController(title: "Premium Account", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
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

            tableView1HeightConstraint.constant = 100
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
                tableView2HeightConstraint.constant = 100
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
                tableView3HeightConstraint.constant = 100
                tableView3.hidden = false
            }
            else {
                tableView3HeightConstraint.constant = 0
                tableView3.hidden = true
            }
        }
        
    }
    
    
}








