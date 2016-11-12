//
//  PlayerExperienceViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 13/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class PlayerExperienceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var playingRole: UITextField!
    @IBOutlet weak var battingStyle: UITextField!
    @IBOutlet weak var bowlingStyle: UITextField!
    @IBOutlet weak var teamName: UITextField!
    
    @IBOutlet weak var pastTeamName: UITextField!
    
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var currentTeams: UITableView!
    
    @IBOutlet weak var pastTeams: UITableView!
    
    lazy var ctDataPicker = DataPicker()
    
    var teamNames = ["New Horizon public school", "National public school", "Delhi public school"]
    
    var pastTeamNames = ["Bangalore public school", "Ryan International school"]
    
    var data:[String:String]{
        
        return ["PlayingRole":playingRole.textVal,"BattingStyle":battingStyle.textVal,"BowlingStyle":bowlingStyle.textVal,"TeamName":teamName.textVal]
    }
    
    let transitionManager = TransitionManager.sharedInstance
    
    
    @IBAction func goPreviousPage(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func goNextPage(sender: AnyObject) {
        let toViewController = viewControllerFrom("Main", vcid: "PlayerExperienceViewController")
        toViewController.transitioningDelegate = self.transitionManager
        presentViewController(toViewController, animated: true, completion: nil)
    }
    
    func initializeView() {
        playingRole.delegate = self
        battingStyle.delegate = self
        bowlingStyle.delegate = self
        teamName.delegate = self
        
        
        currentTeams.allowsSelection = false
        currentTeams.separatorStyle = .None
        currentTeams.dataSource = self
        currentTeams.delegate = self
        
        pastTeams.allowsSelection = false
        pastTeams.separatorStyle = .None
        pastTeams.dataSource = self
        pastTeams.delegate = self
        
        
    }
    
    func deleteTeamFromCurrentTeams(sender: UIButton) {
        let but = sender
        let view = but.superview!
        let cell = view.superview as! CurrentTeamsTableViewCell
        
        if let tblView = cell.superview?.superview as? UITableView {
            
            if tblView.isEqual(self.currentTeams) {
                let indexPath = currentTeams.indexPathForCell(cell)
                teamNames.removeAtIndex((indexPath?.row)!)
                currentTeams.reloadData()
            }
            else {
                let indexPath = pastTeams.indexPathForCell(cell)
                pastTeamNames.removeAtIndex((indexPath?.row)!)
                pastTeams.reloadData()
            }
        }
        
        
    }
    
    
    @IBAction func addPastTeamsPressed(sender: AnyObject) {
        
        if pastTeamName.text?.trimWhiteSpace != "" && pastTeamName.text?.trimWhiteSpace != "-" {
            pastTeamNames.append(pastTeamName.textVal)
            pastTeamName.text = ""
            pastTeams.reloadData()
        }
    }
    
    
    @IBAction func addTeamsPressed(sender: AnyObject) {
        if teamName.text?.trimWhiteSpace != "" && teamName.text?.trimWhiteSpace != "-" {
            teamNames.append(teamName.textVal)
            teamName.text = ""
            
            currentTeams.reloadData()
        }
        
        
    }
   
    func getCellForRow(indexPath:NSIndexPath)->UITableViewCell{
        if let aCell =  currentTeams.dequeueReusableCellWithIdentifier("CurrentTeamsTableViewCell", forIndexPath: indexPath) as? CurrentTeamsTableViewCell {
            
            aCell.backgroundColor = UIColor.clearColor()
            
            
            
            aCell.teamName.text = teamNames[indexPath.row]
            
            aCell.deleteTeamBtn.addTarget(self, action: "deleteTeamFromCurrentTeams:", forControlEvents: .TouchUpInside)
            return aCell
        }
        else
        {
            return UITableViewCell()
        }
        
        
    }

    func getCellForPastTeamsRow(indexPath:NSIndexPath)->UITableViewCell{
        if let aCell =  pastTeams.dequeueReusableCellWithIdentifier("CurrentTeamsTableViewCell", forIndexPath: indexPath) as? CurrentTeamsTableViewCell {
            
            aCell.backgroundColor = UIColor.clearColor()
            
            aCell.teamName.text = pastTeamNames[indexPath.row]
            
            aCell.deleteTeamBtn.addTarget(self, action: "deleteTeamFromCurrentTeams:", forControlEvents: .TouchUpInside)
            return aCell
        }
        else
        {
            return UITableViewCell()
        }
        
        
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
//        
//        getAllProfileData { (data) in
//            
//            profileData = data as! [String:String]
//            
//            if profileData.count > 0 {
//                self.playingRole.text = profileData["PlayingRole"]
//                self.battingStyle.text = profileData["BattingStyle"]
//                self.bowlingStyle.text = profileData["BowlingStyle"]
//                self.teamName.text = profileData["TeamName"]
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIBackgroundTheme(self.view)
        initializeView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(currentTeams) {
            return teamNames.count
        }
        return pastTeamNames.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 20
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.isEqual(currentTeams) {
            return getCellForRow(indexPath)
        }
        return getCellForPastTeamsRow(indexPath)
    }
}

extension PlayerExperienceViewController:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if  textField == playingRole{
            ctDataPicker = DataPicker()
            let indexPos = PlayingRoles.indexOf(playingRole.text!) ?? 0
            ctDataPicker.showPicker(self, inputText: textField, data: PlayingRoles, selectedValueIndex: indexPos)
        }
        else if  textField == battingStyle{
            ctDataPicker = DataPicker()
            let indexPos = BattingStyles.indexOf(battingStyle.text!) ?? 0
            ctDataPicker.showPicker(self, inputText: textField, data: BattingStyles,selectedValueIndex: indexPos)
        }
        else if  textField == bowlingStyle{
            ctDataPicker = DataPicker()
            let indexPos = BowlingStyles.indexOf(bowlingStyle.text!) ?? 0
            ctDataPicker.showPicker(self, inputText: textField, data: BowlingStyles, selectedValueIndex: indexPos)
        }
    }
}