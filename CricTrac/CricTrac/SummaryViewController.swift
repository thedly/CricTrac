//
//  SummaryViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 23/07/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import SCLAlertView

class SummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var summaryTbl: UITableView!
    
    var summaryData : Dictionary<String,Dictionary<String,String>>!
    
    var matchData:[String:AnyObject]!
    var matchDataSource = [[String:String]]()
    
    
    
    @IBAction func backBtnPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeView(){
        summaryTbl.dataSource = self
        summaryTbl.delegate = self
        getMatchData()
    }
    
    // Mark: - Table delegates
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("summaryTableViewCell", forIndexPath: indexPath) as! summaryTableViewCell
            
            let data = matchDataSource[indexPath.row]
            
            cell.configureCell(data["Date"]!, _runs: data["Runs"]!, _fours: data["Fours"]!, _sixes: data["Sixes"]!, _overs: data["Overs"]!, _results:"Not Implemented", _wickets: data["Wickets"]!)
            return cell
    
    }
        
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { action, index in
            print("delete button tapped")
            
            
        }
        edit.backgroundColor = UIColor.lightGrayColor()
        
        let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
            let popup = SCLAlertView()
            
            let viewFrame = UIView.loadFromNibNamed("Share")!
            viewFrame.frame.size.width = 220
            viewFrame.frame.size.height = 220
            
            popup.customSubview = viewFrame
            popup.showCustom("SHARE", subTitle: "your story", color: UIColor.darkGrayColor(), icon: UIImage(named: "ShareFilled")!)
            
            return
            
        }
        share.backgroundColor = UIColor.blueColor()
        
        return [share, edit]
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : SummaryMatchDetailsViewController = storyboard.instantiateViewControllerWithIdentifier("SummaryMatchDetailsViewController") as! SummaryMatchDetailsViewController
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: - Service Call
    
    
    func getMatchData(){
        
        getAllMatchData { (data) in
            
            self.matchData = data
            self.matchDataSource.removeAll()
            for (key,val) in data{
                
                var dataDict = val as! [String:String]
                dataDict["key"] = key
                self.matchDataSource.append(dataDict)
                self.summaryTbl.reloadData()
            }
        }
    }
    
    
    func getSummaryData() {
        summaryData =
            [
                "Feb14" : [
                    "Runs" : "21",
                    "Fours" : "2",
                    "Sixes" : "1",
                    "Overs" : "2",
                    "Wickets" : "2",
                    "Results" : "Won"
                ],
                "Mar14" : [
                    "Runs" : "44",
                    "Fours" : "4",
                    "Sixes" : "2",
                    "Overs" : "5",
                    "Wickets" : "1",
                    "Results" : "Lost"
                ],
                "Apr14" : [
                    "Runs" : "30",
                    "Fours" : "2",
                    "Sixes" : "1",
                    "Overs" : "7",
                    "Wickets" : "1",
                    "Results" : "Won"
                ],
                "May14" : [
                    "Runs" : "12",
                    "Fours" : "1",
                    "Sixes" : "0",
                    "Overs" : "2",
                    "Wickets" : "0",
                    "Results" : "Lost"
                ],
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
