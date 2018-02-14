//
//  MasterDataListViewController.swift
//  CricTrac
//
//  Created by AIPL on 06/06/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class MasterDataListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ThemeChangeable {

    @IBOutlet weak var tableView: UITableView!
    var currentTheme:CTTheme!
    var valueNames = [String]()
    var vcName = ""
    var dataSource = [String:AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationProperties()
        setBackgroundColor()
        tableView.tableFooterView = UIView()
        
        if vcName == "Teams" {
            title = "TEAMS"
            getAllTeams() { (teamData) in
                if let teams = teamData as? [String:String]{
                    teamNames = teams.map({ (key,value) in value })
                    self.valueNames = teams.map({ (key,value) in key })
                    self.tableView.reloadData()
                }
            }
        }
        if vcName == "Opponents" {
            title = "OPPONENTS"
            getAllOpponents() { (teamData) in
                if let teams = teamData as? [String:String]{
                    teamNames = teams.map({ (key,value) in value })
                    self.valueNames = teams.map({ (key,value) in key })
                    self.tableView.reloadData()
                }
            }
        }
        if vcName == "Venue" {
            title = "VENUE"
            getAllVenue() { (teamData) in
                if let teams = teamData as? [String:String]{
                    teamNames = teams.map({ (key,value) in value })
                    self.valueNames = teams.map({ (key,value) in key })
                    self.tableView.reloadData()
                    
                }
            }
        }
        if vcName == "Tournaments" {
            title = "TOURNAMENTS"
            getAllTournaments() { (teamData) in
                if let teams = teamData as? [String:String]{
                    teamNames = teams.map({ (key,value) in value })
                    self.valueNames = teams.map({ (key,value) in key })
                    self.tableView.reloadData()
                }
            }
        }
        if vcName == "Grounds" {
           title = "GROUNDS"
            getAllGrounds() { (teamData) in
                if let teams = teamData as? [String:String]{
                    teamNames = teams.map({ (key,value) in value })
                    self.valueNames = teams.map({ (key,value) in key })
                    self.tableView.reloadData()
                }
            }
        }
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigationProperties() {
        
        currentTheme = cricTracTheme.currentTheme
        
        let menuButton:UIButton = UIButton(type: .Custom)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        menuButton.setImage(UIImage(named: "Back-100"), forState: UIControlState.Normal)
        menuButton.imageEdgeInsets = UIEdgeInsetsMake(1, 1, 1, 1)
        menuButton.addTarget(self, action: #selector(CloseBtnPressed), forControlEvents: UIControlEvents.TouchUpInside)
        let leftBarButton = UIBarButtonItem(customView:menuButton)
        navigationItem.leftBarButtonItem = leftBarButton
        navigationController?.navigationBar.barTintColor = currentTheme.topColor
       // title = ""
        
        
    }
    
    func CloseBtnPressed(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
       
            return teamNames.count
       
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        if indexPath.section == 0 {
            if teamNames.count == 0 {
                 cell.textLabel?.text = "No data."
                cell.textLabel?.textAlignment = .Center
            }
            else {
               cell.textLabel?.text = "Swipe to delete the auto-suggestions data. This will not impact your match data."
            }
            
            cell.textLabel?.numberOfLines = 3
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 15)
        }
        else {
        
        cell.textLabel?.text = teamNames[indexPath.row]
       
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 17)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
         if indexPath.section == 0 {
            return false
        }
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        deleteTeamNames(self.vcName, teamName: valueNames[indexPath.row])
        self.tableView.reloadData()
    }

}





