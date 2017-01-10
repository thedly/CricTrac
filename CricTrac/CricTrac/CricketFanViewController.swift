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
    
    
    var data:[String:AnyObject]{
        
        return ["FavouritePlayers":favouritePlayer.textVal,"Hobbies":HobbiesList, "InterestedSports":InterestedSportsNamesList,"SupportingTeams": supportingTeamNamesList]
    }
    
    var supportingTeamNamesList = [""]
    
    var InterestedSportsNamesList = [""]
    
    var HobbiesList = [""]
    
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
    }

    @IBAction func CreateFanBtnPressed(sender: AnyObject) {
        
        
        profileData.FavouritePlayers =  self.data["FavouritePlayers"] as! String
        profileData.SupportingTeams = self.data["SupportingTeams"] as! [String]
        profileData.InterestedSports = self.data["InterestedSports"] as! [String]
        profileData.Hobbies =  self.data["Hobbies"] as! [String]
        
        addUserProfileData(profileData.ProfileObject) { (data: [String: AnyObject]) in
            
            profileData = Profile(usrObj: data)

            var SplashScreenVC = viewControllerFrom("Main", vcid: "SplashScreenViewController") as! SplashScreenViewController
            
            
            self.presentViewController(SplashScreenVC, animated: true, completion: nil)

            
//            var vc: UIViewController = self.presentingViewController!;
//            while ((vc.presentingViewController) != nil) {
//                
//                vc = vc.presentingViewController!;
//                if ((vc.presentingViewController?.isEqual(viewControllerFrom("Main", vcid: "ProfileBaseViewController") as! ProfileBaseViewController)) != nil){
//                    break;
//                }
//            }
//            
//            vc.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)

           
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
            else {
                let indexPath = Hobies.indexPathForCell(cell)
                HobbiesList.removeAtIndex((indexPath?.row)!)
                Hobies.reloadData()
            }
        }
        
        
    }
    
    
    @IBAction func addInterestedSportsPressed(sender: AnyObject) {
        
        if InterestedSportsNames.text?.trimWhiteSpace != "" && InterestedSportsNames.text?.trimWhiteSpace != "-" {
            InterestedSportsNamesList.append(InterestedSportsNames.textVal)
            InterestedSportsNames.text = ""
            InterestedSports.reloadData()
        }
    }
    
    
    @IBAction func addSupportingTeamsPressed(sender: AnyObject) {
        
        if SupportingTeamNames.text?.trimWhiteSpace != "" && SupportingTeamNames.text?.trimWhiteSpace != "-" {
            supportingTeamNamesList.append(SupportingTeamNames.textVal)
            SupportingTeamNames.text = ""
            
            SupportingTeams.reloadData()
        }
        
        
    }

    
    @IBAction func addHobbiesPressed(sender: AnyObject) {
        
        if HobbiesNames.text?.trimWhiteSpace != "" && HobbiesNames.text?.trimWhiteSpace != "-" {
            HobbiesList.append(HobbiesNames.textVal)
            HobbiesNames.text = ""
            
            Hobies.reloadData()
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
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(SupportingTeams) {
            return supportingTeamNamesList.count
        }
        else if tableView.isEqual(InterestedSports) {
            return InterestedSportsNamesList.count
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
