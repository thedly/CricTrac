//
//  CoachPlayersListViewController.swift
//  CricTrac
//
//  Created by AIPL on 30/08/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class CoachPlayersListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ThemeChangeable,DeleteComment{
    
    @IBOutlet weak var CoachPlayersTableView: UITableView!
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var noPlayersLbl: UILabel!
    @IBOutlet weak var topBarTitle: UILabel!
    let currentTheme = cricTracTheme.currentTheme
    
    var myPlayers = [String]()
    var batsmen = [String]()
    var bowlers = [String]()
    var wicketsKeepers = [String]()
    var allrounders = [String]()
    
     var playerReqId = ""
    
    
    
    var playingRole = ""
    
    var playerNodeIdOthers = [String]()
    var coachNodeIds = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initializeView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        reloadData()
        self.CoachPlayersTableView.reloadData()
    }
    
    func reloadData() {
        myPlayers.removeAll()
        coachNodeIds.removeAll()
        playerNodeIdOthers.removeAll()
        
        getMyPlayers { (data) in
            for(_,req) in data {
                let pendingReq = req as! [String : AnyObject]
                let isAcceptVal = pendingReq["isAccepted"]!
                if isAcceptVal as! NSObject == 1 {
                    let pendingReqs = pendingReq["PlayerID"]!
                    self.coachNodeIds.append(pendingReq["PlayerNodeIdOther"]! as! String)
                    self.playerNodeIdOthers.append(pendingReq["CoachNodeID"]! as! String)
                    self.myPlayers.append(pendingReqs as! String)
                }
            }
            self.CoachPlayersTableView.reloadData()
        }
    }
    
    // for parent class
    func deletebuttonTapped(){
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        setBackgroundColor()
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func initializeView() {
        CoachPlayersTableView.registerNib(UINib.init(nibName: "FriendSuggestionsCell", bundle: nil), forCellReuseIdentifier: "FriendSuggestionsCell")
        
        CoachPlayersTableView.allowsSelection = false
        CoachPlayersTableView.separatorStyle = .None
    }
    
    func changeThemeSettigs() {
        self.view.backgroundColor = currentTheme.topColor
        self.topBarView.backgroundColor = currentTheme.topColor
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch playingRole {
            
        case  "AllPlayers" :
            
            topBarTitle.text = "All Players"
            return myPlayers.count

        case  "Batsmen" :
            
            topBarTitle.text = "Batsmen"
            return batsmen.count
            
        case  "Bowlers" :
            
            topBarTitle.text = "Bowlers"
            return bowlers.count
        case "WicketKeeper" :
           
            topBarTitle.text = "Wicket Keepers"
            return wicketsKeepers.count
            
        case  "AllRounder" :
            
            topBarTitle.text = "All-Rounders"
            return allrounders.count
            
        default:
            
             topBarTitle.text = "My Players"
            if myPlayers.count == 0 {
                noPlayersLbl.text = "No Players"
            }
            else{
                noPlayersLbl.text = ""
            }
            return myPlayers.count
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCellWithIdentifier("FriendSuggestionsCell", forIndexPath: indexPath) as! FriendSuggestionsCell
        aCell.parent = self
        
       
        switch playingRole {
        
        case "AllPlayers" :
            
            if myPlayers.count != 0 {
                playerReqId = myPlayers[indexPath.row]
                aCell.friendId = playerReqId
            }
            aCell.AddFriendBtn.hidden = true
            break
    
            
        case "Batsmen" :
            
               if batsmen.count != 0 {
                     playerReqId = batsmen[indexPath.row]
                    aCell.friendId = playerReqId
                }
               aCell.AddFriendBtn.hidden = true
            break
        
        case "Bowlers" :
            
            if bowlers.count != 0 {
                playerReqId = bowlers[indexPath.row]
                 aCell.friendId = playerReqId
            }
             aCell.AddFriendBtn.hidden = true
            break
            
         case "WicketKeeper" :
            
            if wicketsKeepers.count != 0 {
                playerReqId = wicketsKeepers[indexPath.row]
                 aCell.friendId = playerReqId
            }
             aCell.AddFriendBtn.hidden = true
            break
        case  "AllRounder" :
            
            if allrounders.count != 0 {
                playerReqId = allrounders[indexPath.row]
                 aCell.friendId = playerReqId
            }
             aCell.AddFriendBtn.hidden = true
            break
        default:
            
                if myPlayers.count != 0 {
                     playerReqId = myPlayers[indexPath.row]
                     aCell.friendId = playerReqId
                    
                    aCell.AddFriendBtn.accessibilityIdentifier = playerNodeIdOthers[indexPath.row]
                    aCell.AddFriendBtn.restorationIdentifier = coachNodeIds[indexPath.row]
                    aCell.AddFriendBtn.accessibilityValue = myPlayers[indexPath.row]
                    
                    aCell.AddFriendBtn.setTitle("Remove", forState: .Normal)
                    aCell.AddFriendBtn.setTitleColor(UIColor.redColor(), forState: .Normal)
                    
                    aCell.AddFriendBtn.addTarget(self, action: #selector(CoachPlayersListViewController.removePlayer(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                }
            break
        }
        
        fetchBasicProfile(playerReqId) { (result) in
            let proPic = result["proPic"]
            let city =   result["city"]
            let name = "\(result["firstname"]!) \(result["lastname"]!)"
            let userProfile = result["userProfile"]
            let playingRole = result["playingRole"]
            
            aCell.userCity.text = city
            aCell.userName.text = name
            
            if userProfile == "Player" {
                aCell.userRole.text = playingRole
            }
                
            else if userProfile == "Coach" {
                aCell.userRole.text = "Coach"
            }
            else if userProfile == "Cricket Fan" {
                aCell.userRole.text = "Cricket Fan"
            }
            
            if proPic! == "-"{
                let imageName = defaultProfileImage
                let image = UIImage(named: imageName)
                aCell.userProfileView.image = image
            }else{
                if let imageURL = NSURL(string:proPic!){
                    aCell.userProfileView.kf_setImageWithURL(imageURL)
                }
            }
        }

        aCell.backgroundColor = UIColor.clearColor()
        aCell.baseView.backgroundColor = currentTheme.bottomColor
        aCell.baseView.alpha = 1
        
        return aCell
    }
    
    func removePlayer(sender:UIButton) {
        
        let coachNodeId = sender.restorationIdentifier
        let playerNodeId = sender.accessibilityIdentifier
        let playerId = sender.accessibilityValue
        
        let actionSheetController = UIAlertController(title: "", message: "Are you sure you want to Remove this player?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
            // Just dismiss the action sheet
            actionSheetController.dismissViewControllerAnimated(true, completion: nil)
        }
        actionSheetController.addAction(cancelAction)
        
        let removeAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
            
            fireBaseRef.child("Users").child(playerId!).child("MyCoaches").child(coachNodeId!).removeValue()
            
            fireBaseRef.child("Users").child((currentUser?.uid)!).child("MyPlayers").child(playerNodeId!).removeValue()
            
            self.reloadData()
        }
        actionSheetController.addAction(removeAction)
        
        self.presentViewController(actionSheetController, animated: false, completion: nil)
        
        
    }
    
    
    
    
    
    
}