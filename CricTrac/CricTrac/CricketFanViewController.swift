//
//  CricketFanViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 14/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import KRProgressHUD


class CricketFanViewController: UIViewController, UITableViewDelegate,UITextFieldDelegate, UITableViewDataSource,ThemeChangeable {
    
    @IBOutlet weak var currentTeamsTblViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var interestedSportsTblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var favouritePlayersTblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hobbiesTblViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
//    var data:[String:String]{
//        
//        return ["PlayingRole":playingRole.textVal,"BattingStyle":battingStyle.textVal,"BowlingStyle":bowlingStyle.textVal,"TeamName":teamName.textVal]
//    }
    

    
    @IBOutlet weak var favouritePlayer: UITextField!
    
    @IBOutlet weak var SupportingTeamNames: UITextField!
    
    @IBOutlet weak var InterestedSportsNames: UITextField!
    
     @IBOutlet weak var HobbiesNames: UITextField!
    
    @IBOutlet weak var SupportingTeams: UITableView!
    
    @IBOutlet weak var InterestedSports: UITableView!
    
    @IBOutlet weak var Hobies: UITableView!
    
    @IBOutlet weak var FavouritePlayerTbl: UITableView!
    
    @IBOutlet weak var supportingTeamsBtn: UIButton!
    
    @IBOutlet weak var interestedSportsteamBtn: UIButton!
    
    @IBOutlet weak var favouritePlayerBtn: UIButton!
    
    @IBOutlet weak var hobbiesBtn: UIButton!
    
    
    
    
    var profileChanged: Bool! = false
    
    var selectedText: UITextField!
    
    var window = UIWindow(frame: UIScreen.mainScreen().bounds)
    
    var data:[String:AnyObject]{
        
        return ["FavoritePlayers":favouritePlayerList,"Hobbies":HobbiesList, "InterestedSports":InterestedSportsNamesList,"SupportingTeams": supportingTeamNamesList]
    }
    
    var supportingTeamNamesList = [""]
    
    var InterestedSportsNamesList = [""]
    
    var HobbiesList = [""]
    
    var favouritePlayerList = [""]
    
    var scrollViewTop:CGFloat!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if profileData.FirstName.length > 0 {
            
            self.favouritePlayerList = profileData.FavoritePlayers
            self.HobbiesList = profileData.Hobbies
            self.InterestedSportsNamesList = profileData.InterestedSports
            self.supportingTeamNamesList = profileData.SupportingTeams
            
            self.FavouritePlayerTbl.reloadData()
            self.Hobies.reloadData()
            self.InterestedSports.reloadData()
            self.SupportingTeams.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
    }

    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        //setUIBackgroundTheme(self.view)
        // Do any additional setup after loading the view.
        
        SupportingTeams.allowsSelection = false
        SupportingTeams.separatorStyle = .None
        SupportingTeams.dataSource = self
        SupportingTeams.delegate = self
        
        InterestedSports.allowsSelection = false
        InterestedSports.separatorStyle = .None
        InterestedSports.dataSource = self
        InterestedSports.delegate = self
        
        Hobies.allowsSelection = false
        Hobies.separatorStyle = .None
        Hobies.dataSource = self
        Hobies.delegate = self
        
        
        FavouritePlayerTbl.allowsSelection = false
        FavouritePlayerTbl.separatorStyle = .None
        FavouritePlayerTbl.dataSource = self
        FavouritePlayerTbl.delegate = self
        
        favouritePlayer.delegate = self
        SupportingTeamNames.delegate = self
        InterestedSportsNames.delegate = self
        HobbiesNames.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserInfoViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        scrollView.setContentOffset(CGPointZero, animated: true)
        scrollViewTop = scrollView.frame.origin.y

        if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let currentwindow = app.window {
            
            window = currentwindow
        }
        setNavigationBarProperties()
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
        addNewMatchButton.addTarget(self, action: #selector(CreateFanBtnPressed), forControlEvents: UIControlEvents.TouchUpInside)
        let righttbarButton = UIBarButtonItem(customView: addNewMatchButton)
        
        //assign button to navigationbar
        
        self.navigationItem.leftBarButtonItem = leftbarButton
        self.navigationItem.rightBarButtonItem = righttbarButton
        self.navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
        if self.window.rootViewController == sliderMenu {
            title = "EDIT PROFILE"
            
        }
        else
        {
            title = "CREATE PROFILE"
        }
        //self.title = "PERSONAL INTERESTS"
        //let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
       // self.navigationController!.navigationBar.titleTextAttributes = titleDict
    }

    @IBAction func CreateFanBtnPressed(sender: AnyObject) {
        
        KRProgressHUD.showText("Updating ...")
        profileData.FavoritePlayers =  self.data["FavoritePlayers"] as! [String]
        profileData.SupportingTeams = self.data["SupportingTeams"] as! [String]
        profileData.InterestedSports = self.data["InterestedSports"] as! [String]
        profileData.Hobbies =  self.data["Hobbies"] as! [String]
        profileData.UserProfile = userProfileType.Fan.rawValue
        
        
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
            
            
//            
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
//                }
//                
//            }
            
        }
        
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        //dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adjustTblHeight(constratintType: NSLayoutConstraint, collectionType: [String], cellHeight: CGFloat){
        constratintType.constant = CGFloat(collectionType.count * Int(cellHeight))
    }
    
    func deleteTeamFromCurrentTeams(sender: UIButton) {
        let but = sender
        let view = but.superview!
        let cell = view.superview as! CurrentTeamsTableViewCell
        
        if let tblView = cell.superview?.superview as? UITableView {
            
            if tblView.isEqual(self.SupportingTeams) {
                let indexPath = SupportingTeams.indexPathForCell(cell)
                supportingTeamNamesList.removeAtIndex((indexPath?.row)!)
                SupportingTeams.reloadData()
            }
            else if tblView.isEqual(self.InterestedSports) {
                let indexPath = InterestedSports.indexPathForCell(cell)
                InterestedSportsNamesList.removeAtIndex((indexPath?.row)!)
                
                InterestedSports.reloadData()
            }
            else if tblView.isEqual(self.FavouritePlayerTbl) {
                let indexPath = FavouritePlayerTbl.indexPathForCell(cell)
                favouritePlayerList.removeAtIndex((indexPath?.row)!)
                FavouritePlayerTbl.reloadData()
            }
            else {
                let indexPath = Hobies.indexPathForCell(cell)
                HobbiesList.removeAtIndex((indexPath?.row)!)
                
                Hobies.reloadData()
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

    
    @IBAction func addInterestedSportsPressed(sender: AnyObject) {
        
        if InterestedSportsNames.text?.trimWhiteSpace != "" && InterestedSportsNames.text?.trimWhiteSpace != "-" {
            InterestedSportsNamesList.append(InterestedSportsNames.textVal.trim().condenseWhitespace())
            InterestedSportsNames.text = ""
            
            
            
            
            InterestedSports.reloadData()
        }
    }
    
    
    @IBAction func addSupportingTeamsPressed(sender: AnyObject) {
        
        if SupportingTeamNames.text?.trimWhiteSpace != "" && SupportingTeamNames.text?.trimWhiteSpace != "-" {
            supportingTeamNamesList.append(SupportingTeamNames.textVal.trim().condenseWhitespace())
            SupportingTeamNames.text = ""
            
            SupportingTeams.reloadData()
        }
        
        
    }

    
    @IBAction func addHobbiesPressed(sender: AnyObject) {
        
        if HobbiesNames.text?.trimWhiteSpace != "" && HobbiesNames.text?.trimWhiteSpace != "-" {
            HobbiesList.append(HobbiesNames.textVal.trim().condenseWhitespace())
            HobbiesNames.text = ""
            
            Hobies.reloadData()
        }
        
        
    }
    
    @IBAction func addFavouritePlayerPressed(sender: AnyObject) {
        
        if favouritePlayer.text?.trimWhiteSpace != "" && favouritePlayer.text?.trimWhiteSpace != "-" {
            favouritePlayerList.append(favouritePlayer.textVal.trim().condenseWhitespace())
            favouritePlayer.text = ""
            
            FavouritePlayerTbl.reloadData()
        }
        
        
    }

    
    func getCellSupportingTeamsRow(indexPath:NSIndexPath)->UITableViewCell{
        if let aCell =  SupportingTeams.dequeueReusableCellWithIdentifier("CurrentTeamsTableViewCell", forIndexPath: indexPath) as? CurrentTeamsTableViewCell {
            
            aCell.backgroundColor = UIColor.clearColor()
            
            
            
            aCell.teamName.text = supportingTeamNamesList[indexPath.row]
            
            aCell.deleteTeamBtn.addTarget(self, action: #selector(CricketFanViewController.deleteTeamFromCurrentTeams(_:)), forControlEvents: .TouchUpInside)
            return aCell
        }
        else
        {
            return UITableViewCell()
        }
        
        
    }
    
    func getCellForInterestedTeams(indexPath:NSIndexPath)->UITableViewCell{
        if let aCell =  InterestedSports.dequeueReusableCellWithIdentifier("CurrentTeamsTableViewCell", forIndexPath: indexPath) as? CurrentTeamsTableViewCell {
            
            aCell.backgroundColor = UIColor.clearColor()
            
            
            
            aCell.teamName.text = InterestedSportsNamesList[indexPath.row]
            
            aCell.deleteTeamBtn.addTarget(self, action: "deleteTeamFromCurrentTeams:", forControlEvents: .TouchUpInside)
            return aCell
        }
        else
        {
            return UITableViewCell()
        }
        
        
    }
    
    func getCellForHobbiesRow(indexPath:NSIndexPath)->UITableViewCell{
        if let aCell =  Hobies.dequeueReusableCellWithIdentifier("CurrentTeamsTableViewCell", forIndexPath: indexPath) as? CurrentTeamsTableViewCell {
            
            aCell.backgroundColor = UIColor.clearColor()
            
            aCell.teamName.text = HobbiesList[indexPath.row]
            
            aCell.deleteTeamBtn.addTarget(self, action: #selector(CricketFanViewController.deleteTeamFromCurrentTeams(_:)), forControlEvents: .TouchUpInside)
            return aCell
        }
        else
        {
            return UITableViewCell()
        }
        
        
    }
    
    func getCellForFavouritePlayersRow(indexPath:NSIndexPath)->UITableViewCell{
        if let aCell =  FavouritePlayerTbl.dequeueReusableCellWithIdentifier("CurrentTeamsTableViewCell", forIndexPath: indexPath) as? CurrentTeamsTableViewCell {
            
            aCell.backgroundColor = UIColor.clearColor()
            
            aCell.teamName.text = favouritePlayerList[indexPath.row]
            
            aCell.deleteTeamBtn.addTarget(self, action: #selector(CricketFanViewController.deleteTeamFromCurrentTeams(_:)), forControlEvents: .TouchUpInside)
            return aCell
        }
        else
        {
            return UITableViewCell()
        }
        
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(SupportingTeams) {
            return supportingTeamNamesList.count
        }
        else if tableView.isEqual(InterestedSports) {
            return InterestedSportsNamesList.count
        }
        else if tableView.isEqual(FavouritePlayerTbl) {
            return favouritePlayerList.count
        }
        return HobbiesList.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.rectForRowAtIndexPath(indexPath)
        
        if tableView.isEqual(SupportingTeams) {
            adjustTblHeight(currentTeamsTblViewHeightConstraint, collectionType: supportingTeamNamesList, cellHeight: cell.size.height)
            return getCellSupportingTeamsRow(indexPath)
        }
        else if tableView.isEqual(InterestedSports) {
            adjustTblHeight(interestedSportsTblViewHeightConstraint, collectionType: InterestedSportsNamesList, cellHeight: cell.size.height)
            return getCellForInterestedTeams(indexPath)
        }
        else if tableView.isEqual(FavouritePlayerTbl) {
            adjustTblHeight(favouritePlayersTblViewHeightConstraint, collectionType: favouritePlayerList, cellHeight: cell.size.height)
            return getCellForFavouritePlayersRow(indexPath)
        }
        adjustTblHeight(hobbiesTblViewHeightConstraint, collectionType: HobbiesList, cellHeight: cell.size.height)
        return getCellForHobbiesRow(indexPath)
    }

    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.selectedText = textField
        AddDoneButtonTo(textField)
    }
    
    func AddDoneButtonTo(inputText:UITextField) {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(hex: "B12420")
        toolBar.backgroundColor = UIColor.whiteColor()
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(CricketFanViewController.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(CricketFanViewController.donePressed))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        inputText.inputAccessoryView = toolBar
    }
    
    func donePressed() {
        selectedText.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField == favouritePlayer {
            addFavouritePlayerPressed(textField)
        }else if textField == SupportingTeamNames {
            addSupportingTeamsPressed(textField)
        }else if  textField == InterestedSportsNames {
            addInterestedSportsPressed(textField)
        }else {
            addHobbiesPressed(textField)
        }
        //[textField resignFirstResponder];
        
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        if textField == SupportingTeamNames {
          if supportingTeamNamesList.count >= 10 {
                supportingTeamsBtn.enabled = false
                return newLength <= 0
            }else {
                supportingTeamsBtn.enabled = true
                return newLength <= 30
            }
        }
        else if textField == InterestedSportsNames {
            if InterestedSportsNamesList.count >= 10 {
                interestedSportsteamBtn.enabled = false
                return newLength <= 0
            }
            else {
                interestedSportsteamBtn.enabled = true
                return newLength <= 30
            }
        }
        else if textField == favouritePlayer {
            if favouritePlayerList.count >= 10 {
                favouritePlayerBtn.enabled = false
                return newLength <= 0
            }
            else {
                favouritePlayerBtn.enabled = true
                return newLength <= 30
            }
        }
        else if textField == HobbiesNames {
            if HobbiesList.count >= 10 {
                hobbiesBtn.enabled = false
                return newLength <= 0
            }
            else {
                hobbiesBtn.enabled = true
                return newLength <= 30
            }
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
