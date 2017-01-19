//
//  CricketFanViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 14/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class CricketFanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
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
    
    
    var data:[String:AnyObject]{
        
        return ["FavoritePlayers":favouritePlayerList,"Hobbies":HobbiesList, "InterestedSports":InterestedSportsNamesList,"SupportingTeams": supportingTeamNamesList]
    }
    
    var supportingTeamNamesList = [""]
    
    var InterestedSportsNamesList = [""]
    
    var HobbiesList = [""]
    
    var favouritePlayerList = [""]
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIBackgroundTheme(self.view)
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
    }

    @IBAction func CreateFanBtnPressed(sender: AnyObject) {
        
        
        profileData.FavoritePlayers =  self.data["FavoritePlayers"] as! [String]
        profileData.SupportingTeams = self.data["SupportingTeams"] as! [String]
        profileData.InterestedSports = self.data["InterestedSports"] as! [String]
        profileData.Hobbies =  self.data["Hobbies"] as! [String]
        profileData.UserProfile = userProfileType.Fan.rawValue
        
        
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
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    @IBAction func addInterestedSportsPressed(sender: AnyObject) {
        
        if InterestedSportsNames.text?.trimWhiteSpace != "" && InterestedSportsNames.text?.trimWhiteSpace != "-" {
            InterestedSportsNamesList.append(InterestedSportsNames.textVal.trim())
            InterestedSportsNames.text = ""
            InterestedSports.reloadData()
        }
    }
    
    
    @IBAction func addSupportingTeamsPressed(sender: AnyObject) {
        
        if SupportingTeamNames.text?.trimWhiteSpace != "" && SupportingTeamNames.text?.trimWhiteSpace != "-" {
            supportingTeamNamesList.append(SupportingTeamNames.textVal.trim())
            SupportingTeamNames.text = ""
            
            SupportingTeams.reloadData()
        }
        
        
    }

    
    @IBAction func addHobbiesPressed(sender: AnyObject) {
        
        if HobbiesNames.text?.trimWhiteSpace != "" && HobbiesNames.text?.trimWhiteSpace != "-" {
            HobbiesList.append(HobbiesNames.textVal.trim())
            HobbiesNames.text = ""
            
            Hobies.reloadData()
        }
        
        
    }
    
    @IBAction func addFavouritePlayerPressed(sender: AnyObject) {
        
        if favouritePlayer.text?.trimWhiteSpace != "" && favouritePlayer.text?.trimWhiteSpace != "-" {
            favouritePlayerList.append(favouritePlayer.textVal.trim())
            favouritePlayer.text = ""
            
            FavouritePlayerTbl.reloadData()
        }
        
        
    }

    
    func getCellSupportingTeamsRow(indexPath:NSIndexPath)->UITableViewCell{
        if let aCell =  SupportingTeams.dequeueReusableCellWithIdentifier("CurrentTeamsTableViewCell", forIndexPath: indexPath) as? CurrentTeamsTableViewCell {
            
            aCell.backgroundColor = UIColor.clearColor()
            
            
            
            aCell.teamName.text = supportingTeamNamesList[indexPath.row]
            
            aCell.deleteTeamBtn.addTarget(self, action: "deleteTeamFromCurrentTeams:", forControlEvents: .TouchUpInside)
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
        return 20
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.isEqual(SupportingTeams) {
            return getCellSupportingTeamsRow(indexPath)
        }
        else if tableView.isEqual(InterestedSports) {
            return getCellForInterestedTeams(indexPath)
        }
        else if tableView.isEqual(FavouritePlayerTbl) {
            return getCellForFavouritePlayersRow(indexPath)
        }
        return getCellForHobbiesRow(indexPath)
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
