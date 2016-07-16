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
    @IBOutlet weak var battingView: UIView!
    @IBOutlet weak var bowlingView: UIView!
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
        
        
        
        _battingDetails = ["key1": "value1", "key2": "value2", "key3": "value3", "key4": "value4"]
        
        _bowlingDetails = ["bowlingkey1": "value1", "bowlingkey2": "value2", "bowlingkey3": "value3", "bowlingkey4": "value4"]
        
    }
    
    
    
    
}
