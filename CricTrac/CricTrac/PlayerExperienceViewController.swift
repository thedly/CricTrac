//
//  PlayerExperienceViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 13/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import KRProgressHUD

class PlayerExperienceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,ThemeChangeable {

    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var playingRole: UITextField!
    @IBOutlet weak var battingStyle: UITextField!
    @IBOutlet weak var bowlingStyle: UITextField!
    @IBOutlet weak var teamName: UITextField!
    
    @IBOutlet weak var pastTeamName: UITextField!
    
    var selectedText: UITextField!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var teamNamesTableHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var pastTeamNamesTableHeightConstraint: NSLayoutConstraint!
    
    
    
    
    @IBOutlet weak var currentTeams: UITableView!
    
    @IBOutlet weak var pastTeams: UITableView!
    
    lazy var ctDataPicker = DataPicker()
    
    var teamNames = [""]
    
    var scrollViewTop:CGFloat!
  
    var profileChanged: Bool! = false
    
    var pastTeamNames = [""]
    
    var window = UIWindow(frame: UIScreen.mainScreen().bounds)
    
   
    var nextVC: UIViewController!
    
    var data:[String:AnyObject]{
        
        return ["PlayingRole":playingRole.textVal,"BattingStyle":battingStyle.textVal,"BowlingStyle":bowlingStyle.textVal,"PlayerCurrentTeams":teamNames, "PlayerPastTeams": pastTeamNames]
    }
    
    let transitionManager = TransitionManager.sharedInstance
    
    
    @IBAction func goPreviousPage(sender: AnyObject) {
       // dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    func setNavigationBarProperties(){
        var currentTheme:CTTheme!
        currentTheme = cricTracTheme.currentTheme
        let menuButton: UIButton = UIButton(type:.Custom)
        menuButton.setImage(UIImage(named: "Back-100"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: #selector(goPreviousPage), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        let addNewMatchButton: UIButton = UIButton(type:.Custom)
        addNewMatchButton.frame = CGRectMake(0, 0, 40, 40)
        addNewMatchButton.setTitle("SAVE", forState:.Normal)
        addNewMatchButton.titleLabel?.font = UIFont(name: appFont_bold, size: 15)
        addNewMatchButton.addTarget(self, action: #selector(goNextPage), forControlEvents: UIControlEvents.TouchUpInside)
        let righttbarButton = UIBarButtonItem(customView: addNewMatchButton)
        
        //assign button to navigationbar
        
        navigationItem.leftBarButtonItem = leftbarButton
        navigationItem.rightBarButtonItem = righttbarButton
        navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
        title = "PLAYER EXPERIENCE"
        let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    @IBAction func goNextPage(sender: AnyObject) {
        
        profileData.PlayingRole = self.data["PlayingRole"] as! String
        profileData.BattingStyle = self.data["BattingStyle"] as! String
        profileData.BowlingStyle = self.data["BowlingStyle"] as! String
        profileData.PlayerCurrentTeams = self.data["PlayerCurrentTeams"] as! [String]
        profileData.PlayerPastTeams = self.data["PlayerPastTeams"] as! [String]
        profileData.UserProfile = userProfileType.Player.rawValue
        
        addUserProfileData(profileData.ProfileObject) { (data: [String: AnyObject]) in

            
            
            if (self.profileChanged == true) {
                
                
                logout(self)
                
                
            }
            else
            {
                            profileData = Profile(usrObj: data)
                
                            updateMetaData(userImageMetaData)
                
                
                            if self.window.rootViewController == sliderMenu {
                
                                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                                
//                                self.window.rootViewController?.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
                            }
                            else
                            {
                                let rootViewController: UIViewController = getRootViewController()
                                self.window.rootViewController = rootViewController
                               // sliderMenu.mainViewController = rootViewController
                
                            }
                
                }
            
            
//            self.presentViewController(loginBaseViewController, animated: true) {
////                SCLAlertView().showInfo("Logout",subTitle: "Data saved is cleared, Kill the app and relaunch for now")
//            }
//            

            
            

            
            
            

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
        pastTeamName.delegate = self
        
        
        if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let currentwindow = app.window {
            
            window = currentwindow
        }
        

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserInfoViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        ScrollView.setContentOffset(CGPointZero, animated: true)
        scrollViewTop = ScrollView.frame.origin.y

        
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
    
    func keyboardWillShow(sender: NSNotification){
        
        if let userInfo = sender.userInfo {
            if  let  keyboardframe = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue{
                let keyboardHeight = keyboardframe.CGRectValue().height
                
                var contentInset:UIEdgeInsets = self.ScrollView.contentInset
                contentInset.bottom = keyboardHeight + 10
                self.ScrollView.contentInset = contentInset
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
   
    func getCellForRow(indexPath:NSIndexPath)->UITableViewCell{
        if let aCell =  currentTeams.dequeueReusableCellWithIdentifier("CurrentTeamsTableViewCell", forIndexPath: indexPath) as? CurrentTeamsTableViewCell {
            
            aCell.backgroundColor = UIColor.clearColor()
            
            
            aCell.teamName.font = UIFont(name: "SourceSansPro-Bold", size: 15)
            aCell.teamName.text = teamNames[indexPath.row]
            
            aCell.deleteTeamBtn.addTarget(self, action: #selector(PlayerExperienceViewController.deleteTeamFromCurrentTeams(_:)), forControlEvents: .TouchUpInside)
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
            
            aCell.deleteTeamBtn.addTarget(self, action: #selector(PlayerExperienceViewController.deleteTeamFromCurrentTeams(_:)), forControlEvents: .TouchUpInside)
            return aCell
        }
        else
        {
            return UITableViewCell()
        }
        
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if profileData.FirstName.length > 0  {
            self.playingRole.text = profileData.PlayingRole
            self.battingStyle.text = profileData.BattingStyle
            self.bowlingStyle.text = profileData.BowlingStyle
            self.teamNames = profileData.PlayerCurrentTeams
            self.pastTeamNames = profileData.PlayerPastTeams
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                    CGRect frame = self.currentTeams.frame;
            //                    frame.size.height = self.tableView.contentSize.height;
            //                    self.tableView.frame = frame;
            //                    });
            
            currentTeams.reloadData()
            pastTeams.reloadData()
        }
        setBackgroundColor()

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
        
        
    }
    func fixTableHeight()  {
        
    }
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.boxColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //setUIBackgroundTheme(self.view)
        initializeView()
        setNavigationBarProperties()
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
        return 40
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func adjustTblHeight(constratintType: NSLayoutConstraint, collectionType: [String], cellHeight: CGFloat){
        constratintType.constant = CGFloat(collectionType.count * Int(cellHeight))
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.rectForRowAtIndexPath(indexPath)
        
        if tableView.isEqual(currentTeams) {
            
            adjustTblHeight(teamNamesTableHeightConstraint, collectionType: teamNames, cellHeight: cell.size.height)
            
            return getCellForRow(indexPath)
        }
        
        adjustTblHeight(pastTeamNamesTableHeightConstraint, collectionType: pastTeamNames, cellHeight: cell.size.height)
        
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
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(PlayerExperienceViewController.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(PlayerExperienceViewController.donePressed))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        inputText.inputAccessoryView = toolBar
    }

    func donePressed() {
        selectedText.resignFirstResponder()
    }
}

extension PlayerExperienceViewController:UITextFieldDelegate{
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
    
        self.selectedText = textField
        AddDoneButtonTo(textField)
        
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
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == pastTeamName {
            addPastTeamsPressed(textField)
        }else if textField == teamName {
            addTeamsPressed(textField)
        }else {
            
        }
        //[textField resignFirstResponder];
       
    }
//    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
//        if textField == pastTeamName {
//            addPastTeamsPressed(textField)
//        }
//        return true
//    }
    
}
