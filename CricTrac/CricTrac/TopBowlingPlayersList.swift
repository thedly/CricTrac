//
//  TopBowlingPlayersList.swift
//  CricTrac
//
//  Created by AIPL on 13/09/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class TopBowlingPlayersList: UIViewController,UITableViewDelegate,UITableViewDataSource,ThemeChangeable {
    
     @IBOutlet weak var topBarView: UIView!
     @IBOutlet weak var tableView: UITableView!
    
    var bowlingMatches = [PlayerMatchesData]()
   
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
        title = "TOP BOWLING"
    }
    
    func didMenuButtonTapp() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return bowlingMatches.count
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
       
        self.bowlingMatches.sortInPlace({ $0.totalWicketsTaken > $1.totalWicketsTaken })
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CoachTopBattingBowlingTableViewCell
        
        fetchBasicProfile(self.bowlingMatches[indexPath.section].playerId, sucess: { (result) in
            let name = "\(result["firstname"]!) \(result["lastname"]!)"
            cell.topBowlingPlayerName.text = name
        })
        
        cell.bowlingMatches.text = String(bowlingMatches[indexPath.section].totalBowlInnings)
        cell.wickets.text = String(bowlingMatches[indexPath.section].totalWicketsTaken)
        cell.bestBowling.text = String(bowlingMatches[indexPath.section].dispBB)
        cell.bowlingAve.text = String(format:"%.1f",bowlingMatches[indexPath.section].bowlAverage)
        cell.economy.text = String(format:"%.2f",bowlingMatches[indexPath.section].economy)
        
        cell.backgroundColor = cricTracTheme.currentTheme.bottomColor
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        return cell
     
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CoachTopBattingBowlingTableViewCell
        
                let summaryDetailsVC = viewControllerFrom("Main", vcid: "MatchSummaryViewController") as! MatchSummaryViewController
                summaryDetailsVC.isCoach = true
                summaryDetailsVC.playerID = bowlingMatches[indexPath.section].playerId
                summaryDetailsVC.coachTappedPlayerName = cell.topBowlingPlayerName.text!
                self.navigationController?.pushViewController(summaryDetailsVC, animated: false)
       
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
}
