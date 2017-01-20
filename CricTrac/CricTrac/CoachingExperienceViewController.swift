//
//  CoachingExperienceViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 13/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class CoachingExperienceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ThemeChangeable {

    @IBOutlet weak var teamName: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var teamsPlayedForTxt: UITextField!
    @IBOutlet weak var pastTeamName: UITextField!
    
    @IBOutlet weak var currentTeams: UITableView!
    
    
    @IBOutlet weak var CertificationsTbl: UITableView!
    
    @IBOutlet weak var CoachPlayedForTbl: UITableView!

    @IBOutlet weak var pastTeams: UITableView!
    
    @IBOutlet weak var CoachingLevel: UITextField!
    
    @IBOutlet weak var Certifications: UITextField!
    
    @IBOutlet weak var Experience: UITextField!
    
    var selectedText: UITextField!
    
    var data:[String:AnyObject]{
        
        return ["Certifications":CertificationsList,"Experience":Experience.textVal.trim(),"CoachingLevel":CoachingLevel.textVal.trim(),"CoachCurrentTeams":teamNames, "CoachPastTeams": pastTeamNames, "CoachPlayedFor": CoachPlayedFor]
    }
    var scrollViewTop:CGFloat!

    
    var teamNames = [""]
    
    var CertificationsList = [""]
    
    var CoachPlayedFor = [""]
    
    var pastTeamNames = [""]
    
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.boxColor
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        
        //setUIBackgroundTheme(self.view)
        // Do any additional setup after loading the view.
        
        currentTeams.allowsSelection = false
        currentTeams.separatorStyle = .None
        currentTeams.dataSource = self
        currentTeams.delegate = self
        
        pastTeams.allowsSelection = false
        pastTeams.separatorStyle = .None
        pastTeams.dataSource = self
        pastTeams.delegate = self
        
        CoachPlayedForTbl.allowsSelection = false
        CoachPlayedForTbl.separatorStyle = .None
        CoachPlayedForTbl.dataSource = self
        CoachPlayedForTbl.delegate = self
        
        CertificationsTbl.allowsSelection = false
        CertificationsTbl.separatorStyle = .None
        CertificationsTbl.dataSource = self
        CertificationsTbl.delegate = self

        Experience.delegate = self
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserInfoViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        scrollView.setContentOffset(CGPointZero, animated: true)
        scrollViewTop = scrollView.frame.origin.y

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if profileData.FirstName.length > 0 {
            self.CoachingLevel.text = profileData.CoachingLevel
            self.CertificationsList = profileData.Certifications
            self.Experience.text = profileData.Experience
            self.teamNames = profileData.CoachCurrentTeams
            self.CoachPlayedFor = profileData.CoachPlayedFor
            self.pastTeamNames = profileData.CoachPastTeams
            
            currentTeams.reloadData()
            pastTeams.reloadData()
            CoachPlayedForTbl.reloadData()
            CertificationsTbl.reloadData()
        }
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CreateCoachingProfileBtnPressed(sender: AnyObject) {
        
        profileData.Certifications = self.data["Certifications"] as! [String]
        profileData.Experience = self.data["Experience"] as! String
        profileData.CoachingLevel = self.data["CoachingLevel"] as! String
        profileData.CoachCurrentTeams = self.data["CoachCurrentTeams"] as! [String]
        profileData.CoachPastTeams = self.data["CoachPastTeams"] as! [String]
        profileData.CoachPlayedFor = self.data["CoachPlayedFor"] as! [String]
        profileData.UserProfile = userProfileType.Coach.rawValue
        
        addUserProfileData(profileData.ProfileObject) { (data: [String: AnyObject]) in
            
            profileData = Profile(usrObj: data)
            
            updateMetaData(userImageMetaData)
            
            var window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let currentwindow = app.window {
                
                window = currentwindow
            }
            
            
            if window.rootViewController == sliderMenu {
                window.rootViewController?.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
            else
            {
                let rootViewController: UIViewController = getRootViewController()
                window.rootViewController = rootViewController
            }
        }

        
        
        
    }
    
    func keyboardWillShow(sender: NSNotification){
        
        if let userInfo = sender.userInfo {
            if  let  keyboardframe = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue{
                let keyboardHeight = keyboardframe.CGRectValue().height
                
                var contentInset:UIEdgeInsets = self.scrollView.contentInset
                contentInset.bottom = keyboardHeight + 10
                self.scrollView.contentInset = contentInset
            }
        }
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
            else if tblView.isEqual(self.CoachPlayedForTbl){
                
                let indexPath = CoachPlayedForTbl.indexPathForCell(cell)
                CoachPlayedFor.removeAtIndex((indexPath?.row)!)
                CoachPlayedForTbl.reloadData()
                
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
            pastTeamNames.append(pastTeamName.textVal.trim())
            pastTeamName.text = ""
            pastTeams.reloadData()
        }
    }
    
    
    @IBAction func addTeamsPressed(sender: AnyObject) {
        if teamName.text?.trimWhiteSpace != "" && teamName.text?.trimWhiteSpace != "-" {
            teamNames.append(teamName.textVal.trim())
            teamName.text = ""
            
            currentTeams.reloadData()
        }
        
        
    }
    
    @IBAction func addTeamsPlayedForPressed(sender: AnyObject) {
        if teamsPlayedForTxt.text?.trimWhiteSpace != "" && teamsPlayedForTxt.text?.trimWhiteSpace != "-" {
            CoachPlayedFor.append(teamsPlayedForTxt.textVal.trim())
            teamsPlayedForTxt.text = ""
            
            CoachPlayedForTbl.reloadData()
        }
        
        
    }

    @IBAction func addCertificationsPressed(sender: AnyObject) {
        if Certifications.text?.trimWhiteSpace != "" && Certifications.text?.trimWhiteSpace != "-" {
            CertificationsList.append(Certifications.textVal.trim())
            Certifications.text = ""
            
            CertificationsTbl.reloadData()
        }
        
        
    }

    
    
    func getCellForCertifications(indexPath:NSIndexPath)->UITableViewCell{
        if let aCell =  CertificationsTbl.dequeueReusableCellWithIdentifier("CurrentTeamsTableViewCell", forIndexPath: indexPath) as? CurrentTeamsTableViewCell {
            
            aCell.backgroundColor = UIColor.clearColor()
            
            
            
            aCell.teamName.text = CertificationsList[indexPath.row]
            
            aCell.deleteTeamBtn.addTarget(self, action: "deleteTeamFromCurrentTeams:", forControlEvents: .TouchUpInside)
            return aCell
        }
        else
        {
            return UITableViewCell()
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
    
    func getCellForPlayedTeamsRow(indexPath:NSIndexPath)->UITableViewCell{
        if let aCell =  CoachPlayedForTbl.dequeueReusableCellWithIdentifier("CurrentTeamsTableViewCell", forIndexPath: indexPath) as? CurrentTeamsTableViewCell {
            
            aCell.backgroundColor = UIColor.clearColor()
            
            aCell.teamName.text = CoachPlayedFor[indexPath.row]
            
            aCell.deleteTeamBtn.addTarget(self, action: "deleteTeamFromCurrentTeams:", forControlEvents: .TouchUpInside)
            return aCell
        }
        else
        {
            return UITableViewCell()
        }
        
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(currentTeams) {
            return teamNames.count
        }
        else if tableView.isEqual(CoachPlayedForTbl) {
            return CoachPlayedFor.count
        }
        else if tableView.isEqual(CertificationsTbl){
            return CertificationsList.count
        }
        return pastTeamNames.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 20
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.selectedText = textField
        AddDoneButtonTo(textField)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.isEqual(currentTeams) {
            return getCellForRow(indexPath)
        }
        else if tableView.isEqual(CoachPlayedForTbl) {
            return getCellForPlayedTeamsRow(indexPath)
        }
        else if tableView.isEqual(CertificationsTbl) {
            return getCellForCertifications(indexPath)
        }

        return getCellForPastTeamsRow(indexPath)
    }

    func AddDoneButtonTo(inputText:UITextField) {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(hex: "B12420")
        toolBar.backgroundColor = UIColor.whiteColor()
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(CoachingExperienceViewController.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(CoachingExperienceViewController.donePressed))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        inputText.inputAccessoryView = toolBar
    }

    func donePressed() {
        selectedText.resignFirstResponder()
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
