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
    }
    
    func changeThemeSettigs() {
        
        self.view.backgroundColor = currentTheme.topColor
        self.topBarView.backgroundColor = currentTheme.topColor
        
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
       
        self.bowlingMatches.sortInPlace({ $0.bowlAverage > $1.bowlAverage })
        
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
                
                summaryDetailsVC.playerID = bowlingMatches[indexPath.section].playerId
                summaryDetailsVC.coachVal = 1
                summaryDetailsVC.coachTappedPlayerName = cell.topBowlingPlayerName.text!
                //self.navigationController?.pushViewController(summaryDetailsVC, animated: false)
                self.presentViewController(summaryDetailsVC, animated: false, completion: nil)
       
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
