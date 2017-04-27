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
    
    
    
    @IBOutlet weak var currentTeamsTableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var playedForTableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pastTeamsTableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var certificationsTableHeightConstraint: NSLayoutConstraint!
   
    @IBOutlet weak var addCurrentTeamBtn: UIButton!
    @IBOutlet weak var addPastTeamBtn: UIButton!
    @IBOutlet weak var addCoachPlayedForBtn: UIButton!
    @IBOutlet weak var addCertificationsBtn: UIButton!
   
    
    var selectedText: UITextField!
    
    var profileChanged: Bool! = false
    var modProfileCoach = ""
    
    var data:[String:AnyObject]{
        
        return ["Certifications":CertificationsList,"Experience":Experience.textVal.trim(),"CoachingLevel":CoachingLevel.textVal.trim(),"CoachCurrentTeams":teamNames, "CoachPastTeams": pastTeamNames, "CoachPlayedFor": CoachPlayedFor]
    }
    var scrollViewTop:CGFloat!
    var window = UIWindow(frame: UIScreen.mainScreen().bounds)

    
    var teamNames = [""]
    
    var CertificationsList = [""]
    
    var CoachPlayedFor = [""]
    
    var pastTeamNames = [""]
    
    var currentwindow = UIWindow()
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    func adjustTblHeight(constratintType: NSLayoutConstraint, collectionType: [String], cellHeight: CGFloat){
        constratintType.constant = CGFloat(collectionType.count * Int(cellHeight))
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
        teamName.delegate = self
        teamsPlayedForTxt.delegate = self
        pastTeamName.delegate = self
        Certifications.delegate = self
        CoachingLevel.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserInfoViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        scrollView.setContentOffset(CGPointZero, animated: true)
        scrollViewTop = scrollView.frame.origin.y
        
        if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let currentwindow = app.window {
            
            window = currentwindow
        }
        setNavigationBarProperties()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
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
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    func setNavigationBarProperties(){
        var currentTheme:CTTheme!
        currentTheme = cricTracTheme.currentTheme
        let menuButton: UIButton = UIButton(type:.Custom)
        menuButton.setImage(UIImage(named: "Back-100"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: #selector(backBtnPressed), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        let addNewMatchButton: UIButton = UIButton(type:.Custom)
        addNewMatchButton.frame = CGRectMake(0, 0, 40, 40)
        addNewMatchButton.setTitle("SAVE", forState:.Normal)
        addNewMatchButton.titleLabel?.font = UIFont(name: appFont_bold, size: 15)
        addNewMatchButton.addTarget(self, action: #selector(CreateCoachingProfileBtnPressed), forControlEvents: UIControlEvents.TouchUpInside)
        let righttbarButton = UIBarButtonItem(customView: addNewMatchButton)
        
        //assign button to navigationbar
        
        navigationItem.leftBarButtonItem = leftbarButton
        navigationItem.rightBarButtonItem = righttbarButton
        navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
        if self.window.rootViewController == sliderMenu {
            title = "EDIT PROFILE"
            
        }
        else
        {
            title = "CREATE PROFILE"
        }
        //title = "COACHING EXPERIENCE"
       // let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
       // navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    @IBAction func backBtnPressed(sender: AnyObject) {
       // dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
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
        //  profileData.UserProfile = userProfileType.Coach.rawValue
        profileData.UserProfile = modProfileCoach
        
        addUserProfileData(profileData.ProfileObject) { (data: [String: AnyObject]) in
        
            profileData = Profile(usrObj: data)
            updateMetaData(userImageMetaData)
            
            if self.window.rootViewController == sliderMenu {
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            }
            else
            {
                let rootViewController: UIViewController = getRootViewController()
                self.window.rootViewController = rootViewController
            // sliderMenu.mainViewController = rootViewController
            }
            
            if (self.profileChanged == true) {
                logout(self)
            }
        }
    }
    
            
//            if (self.profileChanged == true) {
//                logout(self)
//            }
//            else
//            {
//                profileData = Profile(usrObj: data)
//                
//                updateMetaData(userImageMetaData)
//                
//                
//                if self.window.rootViewController == sliderMenu {
//                    
//                    
//                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
//                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
//                }
//                else
//                {
//                    let rootViewController: UIViewController = getRootViewController()
//                    self.window.rootViewController = rootViewController
//                   // sliderMenu.mainViewController = rootViewController
//
//                    
//                }
//                
//            }
//        }
  
        
//    }
    
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
                
            else if tblView.isEqual(self.CertificationsTbl){
                
                let indexPath = CertificationsTbl.indexPathForCell(cell)
                CertificationsList.removeAtIndex((indexPath?.row)!)
                CertificationsTbl.reloadData()
                
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
            pastTeamNames.append(pastTeamName.textVal.trim().condenseWhitespace())
            pastTeamName.text = ""
            pastTeams.reloadData()
        }
    }
    
    
    @IBAction func addTeamsPressed(sender: AnyObject) {
        if teamName.text?.trimWhiteSpace != "" && teamName.text?.trimWhiteSpace != "-" {
            teamNames.append(teamName.textVal.trim().condenseWhitespace())
            teamName.text = ""
            
            currentTeams.reloadData()
        }
        
        
    }
    
    @IBAction func addTeamsPlayedForPressed(sender: AnyObject) {
        if teamsPlayedForTxt.text?.trimWhiteSpace != "" && teamsPlayedForTxt.text?.trimWhiteSpace != "-" {
            CoachPlayedFor.append(teamsPlayedForTxt.textVal.trim().condenseWhitespace())
            teamsPlayedForTxt.text = ""
            
            CoachPlayedForTbl.reloadData()
        }
        
        
    }

    @IBAction func addCertificationsPressed(sender: AnyObject) {
        if Certifications.text?.trimWhiteSpace != "" && Certifications.text?.trimWhiteSpace != "-" {
            CertificationsList.append(Certifications.textVal.trim().condenseWhitespace())
            Certifications.text = ""
            
            CertificationsTbl.reloadData()
        }
        
        
    }

    
    
    func getCellForCertifications(indexPath:NSIndexPath)->UITableViewCell{
        if let aCell =  CertificationsTbl.dequeueReusableCellWithIdentifier("CurrentTeamsTableViewCell", forIndexPath: indexPath) as? CurrentTeamsTableViewCell {
            
            aCell.backgroundColor = UIColor.clearColor()
            
            
            
            aCell.teamName.text = CertificationsList[indexPath.row]
            
            aCell.deleteTeamBtn.addTarget(self, action: #selector(CoachingExperienceViewController.deleteTeamFromCurrentTeams(_:)), forControlEvents: .TouchUpInside)
           
            
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
            
            aCell.deleteTeamBtn.addTarget(self, action: #selector(CoachingExperienceViewController.deleteTeamFromCurrentTeams(_:)), forControlEvents: .TouchUpInside)
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
            
            aCell.deleteTeamBtn.addTarget(self, action: #selector(CoachingExperienceViewController.deleteTeamFromCurrentTeams(_:)), forControlEvents: .TouchUpInside)
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
            
            aCell.deleteTeamBtn.addTarget(self, action: #selector(CoachingExperienceViewController.deleteTeamFromCurrentTeams(_:)), forControlEvents: .TouchUpInside)
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
        return 40
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.selectedText = textField
        AddDoneButtonTo(textField)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.rectForRowAtIndexPath(indexPath)
        
        if tableView.isEqual(currentTeams) {
            adjustTblHeight(currentTeamsTableHeightConstraint, collectionType: teamNames, cellHeight: cell.size.height)
            return getCellForRow(indexPath)
        }
        else if tableView.isEqual(CoachPlayedForTbl) {
            adjustTblHeight(playedForTableHeightConstraint, collectionType: CoachPlayedFor, cellHeight: cell.size.height)
            return getCellForPlayedTeamsRow(indexPath)
        }
        else if tableView.isEqual(CertificationsTbl) {
            
            adjustTblHeight(certificationsTableHeightConstraint, collectionType: CertificationsList, cellHeight: cell.size.height)
            return getCellForCertifications(indexPath)
        }
        
        adjustTblHeight(pastTeamsTableHeightConstraint, collectionType: pastTeamNames, cellHeight: cell.size.height)
        
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
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == pastTeamName {
            addPastTeamsPressed(textField)
        }else if textField == teamName {
            addTeamsPressed(textField)
        }else if textField == teamsPlayedForTxt {
            addTeamsPlayedForPressed(textField)
        }else {
            addCertificationsPressed(textField)
        }
        //[textField resignFirstResponder];
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newlength = (textField.text!.characters.count + string.characters.count) - range.length
        if textField == teamName {
            if teamNames.count >= 5 {
                addCurrentTeamBtn.enabled = false
                return newlength <= 0
            }
            else {
                 addCurrentTeamBtn.enabled = true
                return newlength <= 30
            }
        }
        else if textField == pastTeamName {
            if pastTeamNames.count >= 20 {
                addPastTeamBtn.enabled = false
                return newlength <= 0
            }
            else{
                addPastTeamBtn.enabled = true
                return newlength <= 30
            }
        }
        else if textField == teamsPlayedForTxt {
            if CoachPlayedFor.count >= 20 {
                addCoachPlayedForBtn.enabled = false
               return newlength <= 0
            }
            else {
                addCoachPlayedForBtn.enabled = true
                return newlength <= 30
            }
        }
        else if textField == Certifications {
            if CertificationsList.count >= 5 {
                addCertificationsBtn.enabled = false
                return newlength <= 0
                    
                }
            else {
                addCertificationsBtn.enabled = true
                return newlength <= 30
            }
        }
       
        else if textField == Experience {
            return newlength <= 2
        }
        else if textField == CoachingLevel {
            return newlength <= 30
        }
        
        
        return true
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
