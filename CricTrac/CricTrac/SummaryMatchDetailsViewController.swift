//
//  SummaryMatchDetailsViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 23/07/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class SummaryMatchDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var matchDetailsTbl: UITableView!
    
    @IBAction func backBtnPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    // MARK: - Variables and constants
    
    @IBOutlet weak var batRuns: UILabel!
    @IBOutlet weak var ballsFaced: UILabel!
    @IBOutlet weak var sixes: UILabel!
    
    @IBOutlet weak var tournamentName: UILabel!
    @IBOutlet weak var overs: UILabel!
    @IBOutlet weak var totalWickets: UILabel!
    
    @IBOutlet weak var fours: UILabel!
    @IBOutlet weak var result: UILabel!
    
    var _batRuns = String()
    var _ballsFaced = String()
    var _sixes = String()
    var _fours = String()
    var _tournamentName = String()
    var _overs = String()
    var _result = String()
    var _totalWickets = String()
    var _matchMonth = String()
    
    var matchDetailsData : Dictionary<String,[Dictionary<String,String>]>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeView() {
        
        batRuns.text = _batRuns
        fours.text = _fours
        sixes.text = _sixes
        overs.text = _overs
        tournamentName.text = _tournamentName
        totalWickets.text = _totalWickets
        
        //matchDetailsTbl.dataSource = self
        //matchDetailsTbl.delegate = self
        //getMatchDetails()
    }
    
    // MARK: - Table Delegate methods
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Array(matchDetailsData.values).count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(matchDetailsData.values)[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("performanceCell", forIndexPath: indexPath) as? performanceCell {
            
            let dict: Dictionary<String,String> = Array(matchDetailsData.values)[indexPath.section][indexPath.row]
            let value = dict.values.first
            let key = dict.keys.first
            cell.configureCell(key!, pValue: value!)
            return cell
        }
        else
        {
            return UITableViewCell()
        }
        
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, 200, 20))
        headerView.backgroundColor = UIColor.whiteColor()
        
        let headerBaseLine = UIView(frame: CGRectMake(10, 50, UIScreen.mainScreen().bounds.size.width - 50, 1.0))
        headerBaseLine.backgroundColor = UIColor(hex: "D8D8D8")
        
        let headerLbl = UILabel(frame: CGRectMake(20, 10, UIScreen.mainScreen().bounds.size.width, 30))
        headerLbl.textColor = UIColor(hex: "6D9447")
        headerLbl.font = UIFont(name: "SFUIText-Regular", size: 20)
        //headerLbl.font = UIFont.boldSystemFontOfSize(20)
        headerLbl.text = Array(matchDetailsData.keys)[section]

        headerView.addSubview(headerLbl)
        headerView.addSubview(headerBaseLine)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, 200, 20))
        footerView.backgroundColor = UIColor(hex: "D8D8D8")
        
        return footerView
    }
    
    //MARK: - Service Calls 
    
    
    func getMatchDetails() {
        matchDetailsData = [
            "Schedule" : [
                ["Date" : "21st July 2016"],
                ["Teams": "DPS vs JOJO"],
                ["Venue": "INHS, Indiranagar"],
                ["Overs": "20 overs"],
                ["Tournament": "Under 14 cricket championship"]
            ],
            "Batting" : [
                ["Runs" : "11"],
                ["Balls": "12"],
                ["Six": "1 six"],
                ["Four": "3 fours"]
            ],
            "Bowling" : [
                ["Overs" : "3 overs"],
                ["Wickets": "2 wickets"],
                ["Runs Given": "12 runs"]
            ],
            "Summary" : [
                ["Toss" : "JOJO"],
                ["Summary": "JOJO Beat DPS by 12 runs"]
            ]
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
