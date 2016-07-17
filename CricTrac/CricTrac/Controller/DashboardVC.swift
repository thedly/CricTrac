//
//  DashboardVC.swift
//  CricTrac
//
//  Created by Tejas Hedly on 15/07/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
class DashboardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var _battingDetails = [String: String]()
    var _bowlingDetails = [String: String]()
    
    
    @IBOutlet weak var userPerformanceTable: UITableView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var tabs: UISegmentedControl!
    @IBAction func tabIndexChanged(sender: UISegmentedControl) {
        userPerformanceTable.reloadData()
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabs.selectedSegmentIndex == 0 ? _battingDetails.count : _bowlingDetails.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("performanceCell", forIndexPath: indexPath) as? performanceCell {
            
            var currentKey = ""
            var currentvalue = ""
            
            if tabs.selectedSegmentIndex == 0 {
                let index = _battingDetails.startIndex.advancedBy(indexPath.row) // index 1
                currentKey = _battingDetails.keys[index]
                currentvalue = _battingDetails[currentKey]!
            }
            else
            {
                let index = _bowlingDetails.startIndex.advancedBy(indexPath.row) // index 1
                currentKey = _bowlingDetails.keys[index]
                currentvalue = _bowlingDetails[currentKey]!
            }
            
            cell.configureCell(currentKey, pValue: currentvalue)
            
            return cell
        }
        else
        {
            return performanceCell()
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPerformanceTable.delegate = self
        userPerformanceTable.dataSource = self
        userProfileImage.layer.cornerRadius = userProfileImage.frame.size.width / 2
        
               
        _battingDetails = [
            "Matches": "123",
            "Innings": "116",
            "Not Out": "12",
            "Runs": "1028",
            "High Score": "80",
            "Average": "32",
            "Balls Faced": "-",
            "SR": "-",
            "100s": "0",
            "50s": "1",
            "4s": "25",
            "6s": "15"
        ]
        
        _bowlingDetails = [
            "Overs": "12",
            "Wickets": "5",
            "Runs Given": "36",
            "Bowling Average": "24.16"
        ]
        
    }
    
    
    
    
}
