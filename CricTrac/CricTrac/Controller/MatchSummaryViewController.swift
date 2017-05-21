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

class MatchSummaryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ThemeChangeable {

    @IBOutlet weak var upgradeBtnHeight: NSLayoutConstraint!
    @IBOutlet var matchSummaryTable:UITableView!
    
    var matchData = [String:AnyObject]()
    var matches = [MatchSummaryData]()
    var matchDataSource = [[String:AnyObject]]()
    
    var userProfileData:Profile!
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    var inAppProductPrice : String?
    @IBOutlet var upgradeButton : UIButton!
    
    override func viewWillAppear(animated: Bool) {
        getMatchData()
        setBackgroundColor()
        self.matchSummaryTable.reloadData()
        setNavigationBarProperties()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upgradeButton.setTitle("Upgrade", forState: UIControlState.Normal)
        
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
            self.makeCells(data)
            //KRProgressHUD.dismiss()
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
        
        if let ground = value["Ground"]{
            mData.ground = ground as! String
            
            if let venue = value["Venue"] as? String where venue != "-" {
                mData.ground = "\(ground), \(venue)"
            }
        }
        
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
        
        mData.battingBowlingScore = battingBowlingScore
        mData.matchDateAndVenue = matchVenueAndDate
        mData.opponentName = opponentName
        
        return mData
    }
    
    func getCellForRow(indexPath:NSIndexPath)->SummaryDetailsCell{
        if let aCell =  matchSummaryTable.dequeueReusableCellWithIdentifier("SummaryDetailsCell", forIndexPath: indexPath) as? SummaryDetailsCell {
            
            aCell.backgroundColor = UIColor.clearColor()
            aCell.baseView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: UIColor().hexFromUIColor(cricTracTheme.currentTheme.bottomColor)))
            
            aCell.baseView.alpha = 0.8
            
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
        
        return self.matchDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return getCellForRow(indexPath)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 120
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
            
            let message = "Free version allows only maximum 5 matches. Upgrade to premium by paying: \(msg)"
            
            let refreshAlert = UIAlertController(title: "Premium Account", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Upgrade", style: .Default, handler: { (action: UIAlertAction!) in
                self.doPurchase()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Later", style: .Cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
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
                let refreshAlert = UIAlertController(title: "Success", message: "Congratulations for upgrading your account", preferredStyle: UIAlertControllerStyle.Alert)
                refreshAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction!) in
                    self.upgradeBtnHeight.constant = 0
                }))
                self.presentViewController(refreshAlert, animated: true, completion: nil)
                
            case .Error(let error):
                print("Purchase Failed: \(error)")
            }
        }
    }

}
