//
//  AchievementListViewController.swift
//  CricTrac
//
//  Created by Sajith Kumar on 13/05/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

protocol AchievementsTextProtocol {
    func setValueFromMultiSelectAchievements(valueSent: String)
}

class AchievementListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ThemeChangeable {
    
    var delegate: AchievementsTextProtocol?
    var achievementData = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var barView: UIView!
    var dataSource = [String]()
     var currentTheme:CTTheme!
    var selectedRows = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        changeThemeSettigs()
        self.setBackgroundColor()
        
       tableView.tableFooterView = UIView()
       
        // Do any additional setup after loading the view.
        dataSource = Achievements
    }
   
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        self.barView.backgroundColor =  currentTheme.topColor
        // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    @IBAction func doneButtonTapped(sender: UIButton) {
        delegate!.setValueFromMultiSelectAchievements(selectedRows.joinWithSeparator(","))
        
//        let resultVC = viewControllerFrom("Main", vcid: "MatchResultsViewController") as! MatchResultsViewController
//        resultVC.AchievementsText?.text = selectedRows.joinWithSeparator("\n")
//        resultVC.achievementText = selectedRows
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let limit = 3

        if !selectedRows.contains(dataSource[indexPath.row]){ // about to unselect
            if selectedRows.count >= limit {
                let alertController = UIAlertController(title: "Max Limit ", message:
                    "You are limited to \(limit) selections", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
                
                return nil
                
            }
        }
        return indexPath
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("AchievementCell", forIndexPath: indexPath) as! AchievementTableViewCell
            cell.achievementNames.text = dataSource[indexPath.row]
        
            if selectedRows.contains(dataSource[indexPath.row]){
                cell.accessoryType = .Checkmark
                self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
            }
        
            return cell
        }

     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                if cell.selected {
                    cell.accessoryType = .Checkmark
                    selectedRows.append(dataSource[indexPath.row])
                }
            }
        }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            cell.accessoryType = .None
            selectedRows = selectedRows.filter() { $0 != dataSource[indexPath.row] }
            cell.backgroundColor = UIColor.clearColor()
        }
    }
}
