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
        
        setBackgroundColor()
        tableView.tableFooterView = UIView()
    }
    
    func changeThemeSettigs() {
        self.view.backgroundColor = currentTheme.topColor
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
        
        self.battingMatches.sortInPlace({ $0.batAverage > $1.batAverage })

        
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
        
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
