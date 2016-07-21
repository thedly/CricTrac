//
//  DashboardViewController.swift
//  CricTrac
//
//  Created by Renjith on 7/20/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController,UITabBarDelegate,UITableViewDataSource {

    @IBOutlet weak var battingBtn: UIButton!
    @IBOutlet weak var bowlingBtn: UIButton!
    @IBOutlet weak var battingSelectedIndicator: UIView!
    @IBOutlet weak var bowlingSelectedIndicator: UIView!
    
    @IBOutlet weak var performanceTable: UITableView!
    // Variables And Constants
    
    var battingDetails: Dictionary<String,String>!
    var bowlingDetails: Dictionary<String,String>!
    
    // MARK: View controller Delegates and related methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarProperties()
        initializeView()
        getPerformanceDetails()
        
        // Do any additional setup after loading the view.
    }
    
    func initializeView() {
        bowlingSelectedIndicator.hidden = true
        battingSelectedIndicator.hidden = false
        
        battingBtn.setTitleColor(UIColor(hex:"D8D8D8"), forState: UIControlState.Normal)
        bowlingBtn.setTitleColor(UIColor(hex:"D8D8D8"), forState: UIControlState.Normal)
        
        battingBtn.tintColor = UIColor.clearColor()
        bowlingBtn.tintColor = UIColor.clearColor()
        
        bowlingBtn.setTitleColor(UIColor(hex:"6D9447"), forState: UIControlState.Selected)
        battingBtn.setTitleColor(UIColor(hex:"6D9447"), forState: UIControlState.Selected)
        
        battingBtn.selected = true
    }
    
    //Sets button for Slide menu, Title and Navigationbar Color
    func setNavigationBarProperties(){
        let button: UIButton = UIButton(type:.Custom)
        button.setImage(UIImage(named: "menu-icon"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        button.frame = CGRectMake(0, 0, 40, 40)
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        navigationItem.leftBarButtonItem = barButton
        navigationController!.navigationBar.barTintColor = UIColor(hex:"B12420")
        title = "Dashboard"
        let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    
    // MARK: Button Actions
    
    @IBAction func BattingTabSelected(sender: UIButton) {
        
        bowlingSelectedIndicator.hidden = true
        battingSelectedIndicator.hidden = false
        battingBtn.selected = true
        bowlingBtn.selected = false
        performanceTable.reloadData()
        
    }
    @IBAction func BowlingTabSelected(sender: UIButton) {
        
        bowlingSelectedIndicator.hidden = false
        battingSelectedIndicator.hidden = true
        battingBtn.selected = false
        bowlingBtn.selected = true
        performanceTable.reloadData()
    }
    
    func didMenuButtonTapp(){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
      // MARK: TableView DataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("performanceCell", forIndexPath: indexPath) as? performanceCell {
            
            var currentKey :String?
            var currentvalue :String?
            
            if battingBtn.selected {
                let index = battingDetails.startIndex.advancedBy(indexPath.row) as DictionaryIndex<String,String>
                currentKey = battingDetails.keys[index]
                currentvalue = battingDetails[currentKey!]!
            }
            else
            {
                let index = bowlingDetails.startIndex.advancedBy(indexPath.row) as DictionaryIndex<String,String>
                currentKey = bowlingDetails.keys[index]
                currentvalue = bowlingDetails[currentKey!]!
            }
            
            cell.configureCell(currentKey!, pValue: currentvalue!)
            return cell
        }
        else
        {
            return UITableViewCell()
        }
        
//        let cell =  UITableViewCell()
//        cell.textLabel?.text = "data"
//        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return battingBtn.selected ? battingDetails.count : bowlingDetails.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
            case 2:return "Recent Matches"
            default :return "hi"
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    
    
    // MARK: Service Calls
    
    func getPerformanceDetails() {
        battingDetails = [
            "Matches": "123",
            "Innings": "116",
            "Not_Out": "12",
            "Runs": "1028",
            "High_Score": "80",
            "Average": "32",
            "Balls_Faced": "-",
            "SR": "-",
            "100s": "0",
            "50s": "1",
            "4s": "25",
            "6s": "15"
        ]
        
        bowlingDetails = [
            "Overs": "12",
            "Wickets": "5",
            "Runs_Given": "36",
            "Bowling_Average": "24.16"
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
