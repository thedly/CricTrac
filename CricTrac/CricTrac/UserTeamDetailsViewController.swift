//
//  UserTeamDetailsViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 10/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class UserTeamDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,IndicatorInfoProvider {

    var teamdata: [String]!
    
    @IBOutlet weak var userTeamDetailsTbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        userTeamDetailsTbl.delegate = self
        userTeamDetailsTbl.dataSource = self
        getMiscDetails()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "TEAM")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    // MARK: - Table delegate functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return teamdata.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = teamdata[indexPath.row]
        return cell
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
    
    
    // MARK: - Service calls
    func getMiscDetails() {
        teamdata = ["JOJO", "DPS", "INHS"]
    }

}
