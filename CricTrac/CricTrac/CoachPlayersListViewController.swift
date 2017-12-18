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
    @IBOutlet weak var topBarViewHeightConstraint: NSLayoutConstraint!
    let currentTheme = cricTracTheme.currentTheme
    
   // var myPlayers = [String]()
    var batsmen = [String]()
    var bowlers = [String]()
    var wicketsKeepers = [String]()
    var allrounders = [String]()
    
    var playerReqId = ""
    var playingRole = ""
    var friendID = ""
    
    var playerNodeIdOthers = [String]()
    var coachNodeIds = [String]()
    var myPlayers = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initializeView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        reloadData()
       // self.CoachPlayersTableView.reloadData()
    }
    
    func reloadData() {
        myPlayers.removeAll()
        coachNodeIds.removeAll()
        playerNodeIdOthers.removeAll()
       // dataSource.removeAll()
        
        if friendID == "" {
            friendID = (currentUser?.uid)!
        }
        
        getMyPlayers1(friendID,playingRole: playingRole) { (data) in
            self.myPlayers = data
            self.CoachPlayersTableView.reloadData()

        }
    
    
        
//        getMyPlayers(friendID) { (data) in
//            for(_,req) in data {
//                let pendingReq = req 
//                let isAcceptVal = pendingReq["isAccepted"]!
//                if isAcceptVal as! NSObject == 1 {
//                    let pendingReqs = pendingReq["PlayerID"]!
////                    self.coachNodeIds.append(pendingReq["PlayerNodeIdOther"]! as! String)
////                    self.playerNodeIdOthers.append(pendingReq["CoachNodeID"]! as! String)
//                    self.myPlayers.append(pendingReqs as! String)
//                }
//            }
//        }
    }
    
    // for parent class
    func deletebuttonTapped(){
        
    }
    
    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(animated)
        //let currentTheme = cricTracTheme.currentTheme
       // self.view.backgroundColor = currentTheme.topColor
        setBackgroundColor()
        setNavigationProperties()
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func initializeView() {
        CoachPlayersTableView.registerNib(UINib.init(nibName: "FriendSuggestionsCell", bundle: nil), forCellReuseIdentifier: "FriendSuggestionsCell")
        
        CoachPlayersTableView.allowsSelection = false
        CoachPlayersTableView.separatorStyle = .None
    }
    
    func changeThemeSettigs() {
        self.view.backgroundColor = currentTheme.topColor
        self.CoachPlayersTableView.backgroundColor = currentTheme.topColor
        
    }
    
    func setNavigationProperties() {
        
        if friendID != (currentUser?.uid)! && friendID != ""{
             topBarView.hidden = false
            topBarViewHeightConstraint.constant = 56
            self.topBarView.backgroundColor = currentTheme.topColor

        }
        else{
            topBarView.hidden = true
            var currentTheme:CTTheme!
            currentTheme = cricTracTheme.currentTheme
            let menuButton: UIButton = UIButton(type:.Custom)
            menuButton.setImage(UIImage(named: "Back-100"), forState: UIControlState.Normal)
            menuButton.addTarget(self, action: #selector(backButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
            menuButton.frame = CGRectMake(0, 0, 40, 40)
            let leftbarButton = UIBarButtonItem(customView: menuButton)
            navigationItem.leftBarButtonItem = leftbarButton
            navigationController!.navigationBar.barTintColor = currentTheme.topColor
            self.view.backgroundColor = currentTheme.topColor
           // title = "MY PLAYERS"
        }
    }
    
    func backButtonTapp() {
        self.navigationController?.popViewControllerAnimated(false)
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch playingRole {
            
        case  "AllPlayers" :
            
            topBarTitle.text = "ALL PLAYERS"
            title = "ALL PLAYERS"
            return myPlayers.count

        case  "Batsmen" :
            
            topBarTitle.text = "BATSMEN"
            title = "BATSMEN"
            return myPlayers.count
            
        case  "Bowlers" :
            
            topBarTitle.text = "BOWLERS"
            title = "BOWLERS"
            return myPlayers.count
        case "WicketKeeper" :
           
            topBarTitle.text = "WICKET KEEPERS"
            title = "WICKET KEEPERS"
            return myPlayers.count
            
        case  "AllRounder" :
            
            topBarTitle.text = "ALL-ROUNDERS"
            title = "ALL-ROUNDERS"
            return myPlayers.count
            
        default:
            
             topBarTitle.text = "MY PLAYERS"
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
        
        var coachNodeId = ""
        var playerNodeIdOther = ""
        tableView.backgroundColor = currentTheme.topColor
        let aCell = tableView.dequeueReusableCellWithIdentifier("FriendSuggestionsCell", forIndexPath: indexPath) as! FriendSuggestionsCell
        aCell.parent = self
        
       
        switch playingRole {
        
            case "AllPlayers" :
                
                aCell.AddFriendBtn.hidden = true
                break
        
            case "Batsmen" :
                
                aCell.AddFriendBtn.hidden = true
                break
            
            case "Bowlers" :
                
                aCell.AddFriendBtn.hidden = true
                break
                
             case "WicketKeeper" :
                
                aCell.AddFriendBtn.hidden = true
                break
            
            case  "AllRounder" :
                
                 aCell.AddFriendBtn.hidden = true
                break
            
            default:
               
                break
        }
        
            if myPlayers.count != 0 {
                
                let playerData = myPlayers[indexPath.row]
                
                let proPic = playerData["ProfilePic"]! as! String
                let city =   playerData["City"]! as! String
                let name = "\(playerData["FirstName"]!) \(playerData["LastName"]!)"
                let userProfile = playerData["UserProfile"]! as! String
                let playingRole = playerData["PlayingRole"]! as! String
                
                aCell.userCity.text = city
                aCell.userName.text = name
                aCell.userCity.text = playerData["DOB"]! as? String
                if userProfile == "Player" {
                    aCell.userRole.text = playingRole
                }
                else{
                    fireBaseRef.child("Users").child(self.playerReqId).child("MyCoaches").child(coachNodeId).removeValue()
                    fireBaseRef.child("Users").child(currentUser!.uid).child("MyPlayers").child(playerNodeIdOther).removeValue()
                }
                
                if proPic == "-"{
                    let imageName = defaultProfileImage
                    let image = UIImage(named: imageName)
                    aCell.userProfileView.image = image
                }else{
                    if let imageURL = NSURL(string:proPic){
                        aCell.userProfileView.kf_setImageWithURL(imageURL)
                    }
                }
                
                
                playerReqId = playerData["playerId"]! as! String
                coachNodeId = playerData["playerNodeIdOther"]! as! String
                playerNodeIdOther = playerData["coachNodeId"]! as! String
                
                aCell.friendId = playerReqId
                aCell.AddFriendBtn.accessibilityIdentifier = coachNodeId
                aCell.AddFriendBtn.restorationIdentifier = playerNodeIdOther
                aCell.AddFriendBtn.accessibilityValue = playerReqId
                aCell.AddFriendBtn.setTitle("REMOVE", forState: .Normal)
                aCell.AddFriendBtn.setTitleColor(UIColor(red: 0.76, green: 0.18, blue: 0.25, alpha: 1.0), forState: .Normal)
                aCell.AddFriendBtn.titleLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 12)
                
                aCell.AddFriendBtn.addTarget(self, action: #selector(CoachPlayersListViewController.removePlayer(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
                aCell.backgroundColor = UIColor.clearColor()
                aCell.baseView.backgroundColor = currentTheme.bottomColor
                aCell.baseView.alpha = 1
                CoachPlayersTableView.backgroundColor = currentTheme.topColor
                
            }

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