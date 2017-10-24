//
//  TopBattingPlayersList.swift
//  CricTrac
//
//  Created by AIPL on 13/09/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class TopBattingPlayersList: UIViewController,UITableViewDelegate,UITableViewDataSource,ThemeChangeable {

    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var battingMatches = [PlayerMatchesData]()
   
    let currentTheme = cricTracTheme.currentTheme
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        setBackgroundColor()
        setNavigationProperties()
    }
    
    func changeThemeSettigs() {
        self.view.backgroundColor = currentTheme.topColor
        self.topBarView.backgroundColor = currentTheme.topColor
        topBarView.hidden = true
    }
    
    
    func setNavigationProperties() {
        var currentTheme:CTTheme!
        currentTheme = cricTracTheme.currentTheme
        let menuButton: UIButton = UIButton(type:.Custom)
        menuButton.setImage(UIImage(named: "Back-100"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        navigationItem.leftBarButtonItem = leftbarButton
        navigationController!.navigationBar.barTintColor = currentTheme.topColor
        title = "TOP BATTING"
    }
    
        
    func didMenuButtonTapp() {
      self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        return battingMatches.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let aView = UIView()
        aView.backgroundColor = UIColor.clearColor()
        return aView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        self.battingMatches.sortInPlace({ $0.totalRunsTaken > $1.totalRunsTaken })

        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CoachTopBattingBowlingTableViewCell
        
        fetchBasicProfile(self.battingMatches[indexPath.section].playerId, sucess: { (result) in
            let name = "\(result["firstname"]!) \(result["lastname"]!)"
            cell.topBattingPlayerName.text = name
        })
        
        cell.battingMatches.text = String(self.battingMatches[indexPath.section].totalBatInnings)
        cell.battingRuns.text = String(self.battingMatches[indexPath.section].totalRunsTaken)
        cell.battingHS.text = String(self.battingMatches[indexPath.section].dispHS)
        cell.battingStrikeRate.text = String(format:"%.1f",self.battingMatches[indexPath.section].strikeRate)
        cell.battingAvg.text = String(format:"%.1f",self.battingMatches[indexPath.section].batAverage)
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = cricTracTheme.currentTheme.bottomColor
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CoachTopBattingBowlingTableViewCell

        let summaryDetailsVC = viewControllerFrom("Main", vcid: "MatchSummaryViewController") as! MatchSummaryViewController
        
        summaryDetailsVC.playerID = battingMatches[indexPath.section].playerId
        summaryDetailsVC.isCoach = true
        summaryDetailsVC.coachTappedPlayerName = cell.topBattingPlayerName.text!
       self.navigationController?.pushViewController(summaryDetailsVC, animated: false)
       // self.presentViewController(summaryDetailsVC, animated: false, completion: nil)
        
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
}
