//
//  DashboardBattingDetailsViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 08/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import AnimatedTextInput

class DashboardBowlingDetailsViewController: UIViewController,IndicatorInfoProvider ,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var performanceTable: UITableView!
    var bowlingDetails: [String:String]!
    var recentMatches: [String:String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPerformanceDetails()
        
        performanceTable.dataSource = self
        performanceTable.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "BOWLING")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("performanceCell", forIndexPath: indexPath) as? performanceCell {
            
            //print(battingDetails)
            
            var currentKey :String?
            var currentvalue :String?
            
            if indexPath.section == 0
            {
                
                let index = bowlingDetails.startIndex.advancedBy(indexPath.row) as DictionaryIndex<String,String>
                currentKey = bowlingDetails.keys[index]
                currentvalue = bowlingDetails[currentKey!]!
            }
            else
            {
                let index = recentMatches.startIndex.advancedBy(indexPath.row) as DictionaryIndex<String,String>
                currentKey = recentMatches.keys[index]
                currentvalue = recentMatches[currentKey!]!
                
            }
            
            cell.configureCell(currentKey!, pValue: currentvalue!)
            return cell
        }
        else
        {
            return UITableViewCell()
            
            
            
        }
        
        
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Recent Matches"
        }
        else
        {
            return ""
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let vw = UIView()
            let headerLbl = UILabel(frame: CGRectMake(20, 10, UIScreen.mainScreen().bounds.size.width, 30))
            headerLbl.textColor = UIColor(hex: "6D9447")
            headerLbl.backgroundColor = UIColor.whiteColor()
            headerLbl.font = UIFont(name: "SFUIText-Bold", size: 20)
            //headerLbl.font = UIFont.boldSystemFontOfSize(20)
            headerLbl.text = "Recent Matches"
            vw.addSubview(headerLbl)
            
            vw.backgroundColor = UIColor.clearColor()
            return vw
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.min
        }
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return section == 0 ? bowlingDetails.count : 3
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    // MARK: Service Calls
    
    func getPerformanceDetails() {
        
        
        
        // Make API call
        
        bowlingDetails = [
            "Overs": "12",
            "Wickets": "5",
            "Runs Given": "36",
            "Bowling Average": "24.16"
        ]
        
        recentMatches = [
            "Against DPS South": "46",
            "Against ISB" : "41",
            "Against JOJO Mysore": "30"
        ]
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


