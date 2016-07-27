//
//  SummaryViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 23/07/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var summaryTbl: UITableView!
    
    var summaryData : Dictionary<String,Dictionary<String,String>>!
    
    
    
    
    
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
        getSummaryData()
    }
    
    // Mark: - Table delegates
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaryData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var dateKey :String!
        var dateValue: Dictionary<String,String>
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("summaryTableViewCell", forIndexPath: indexPath) as? summaryTableViewCell{
           
            let index = summaryData.startIndex.advancedBy(indexPath.row)
            
                print(indexPath.row)
                print(summaryData.count)
                
                dateKey = summaryData.keys[index]
                dateValue = summaryData[dateKey!]!
                
                cell.configureCell(dateKey, _runs: dateValue["Runs"]!, _fours: dateValue["Fours"]!, _sixes: dateValue["Sixes"]!, _overs: dateValue["Overs"]!, _results: dateValue["Results"]!, _wickets: dateValue["Wickets"]!)
                return cell
        }
        else
        {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { action, index in
            print("edit button tapped")
        }
        edit.backgroundColor = UIColor.lightGrayColor()
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            print("delete button tapped")
        }
        delete.backgroundColor = UIColor.redColor()
        
        return [delete, edit]

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : SummaryMatchDetailsViewController = storyboard.instantiateViewControllerWithIdentifier("SummaryMatchDetailsViewController") as! SummaryMatchDetailsViewController
        
        self.presentViewController(vc, animated: true, completion: nil)
        }
    
    // MARK: - Service Call
    
    
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
