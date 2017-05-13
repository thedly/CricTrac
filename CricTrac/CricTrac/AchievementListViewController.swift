//
//  AchievementListViewController.swift
//  CricTrac
//
//  Created by Sajith Kumar on 13/05/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class AchievementListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ThemeChangeable {
    
    @IBOutlet weak var barView: UIView!
    var dataSource = [String]()
     var currentTheme:CTTheme!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        changeThemeSettigs()
        self.setBackgroundColor()
       
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
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AchievementCell", forIndexPath: indexPath) as! AchievementTableViewCell
        cell.achievementNames.text = dataSource[indexPath.row]
        
        if cell.selected {
            cell.selected = false
            
            if cell.accessoryType == UITableViewCellAccessoryType.None {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            else {
                 cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
        
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
       
        if cell!.selected {
            cell!.selected = false
            
            if cell!.accessoryType == UITableViewCellAccessoryType.None {
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            else {
                cell!.accessoryType = UITableViewCellAccessoryType.None
            }
        }
    }
}
