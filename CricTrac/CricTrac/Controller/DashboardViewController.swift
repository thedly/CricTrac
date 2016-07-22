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
    var recentMatches: Dictionary<String,String>!
    
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
            
            if indexPath.section == 0
            {
            
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
        return section == 0 ? battingBtn.selected ? battingDetails.count : bowlingDetails.count : 3
    }
 
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
        
    // MARK: Service Calls
    
    func getPerformanceDetails() {
        
        // Make API call
        
        battingDetails = [
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
