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
    
    var teamNames = [""]
    
    var pastTeamNames = [""]
    
    
    var nextVC: UIViewController!
    
    var data:[String:AnyObject]{
        
        return ["PlayingRole":playingRole.textVal,"BattingStyle":battingStyle.textVal,"BowlingStyle":bowlingStyle.textVal,"PlayerCurrentTeams":teamNames, "PlayerPastTeams": pastTeamNames]
    }
    
    let transitionManager = TransitionManager.sharedInstance
    
    
    @IBAction func goPreviousPage(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func goNextPage(sender: AnyObject) {
        
        
        profileData.PlayingRole = self.data["PlayingRole"] as! String
        profileData.BattingStyle = self.data["BattingStyle"] as! String
        profileData.BowlingStyle = self.data["BowlingStyle"] as! String
        profileData.PlayerCurrentTeams = self.data["PlayerCurrentTeams"] as! [String]
        profileData.PlayerPastTeams = self.data["PlayerPastTeams"] as! [String]
        profileData.UserProfile = userProfileType.Player.rawValue
        
        addUserProfileData(profileData.ProfileObject) { (data: [String: AnyObject]) in
            
            profileData = Profile(usrObj: data)
            
            
//            var vc: UIViewController = self.presentingViewController!;
//            
            var SplashScreenVC = viewControllerFrom("Main", vcid: "SplashScreenViewController") as! SplashScreenViewController
            
            
            self.presentViewController(SplashScreenVC, animated: true, completion: nil)
            
//            while ((vc.presentingViewController) != nil) {
//                
//                vc = vc.presentingViewController!;
//                if ((vc.presentingViewController?.isEqual(viewControllerFrom("Main", vcid: "ProfileBaseViewController") as! ProfileBaseViewController)) != nil){
//                    break;
//                }
//            }
//            
//            vc.presentingViewController!.dismissViewControllerAnimated(true, completion: { 
//                
//            })
            
            
            

        }
        
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
                self.teamNames.removeAtIndex((indexPath?.row)!)
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
        
        
            if profileData.FirstName.length > 0 {
                self.playingRole.text = profileData.PlayingRole
                self.battingStyle.text = profileData.BattingStyle
                self.bowlingStyle.text = profileData.BowlingStyle
                self.teamNames = profileData.PlayerCurrentTeams
                self.pastTeamNames = profileData.PlayerPastTeams
                currentTeams.reloadData()
                pastTeams.reloadData()
            }
        
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
