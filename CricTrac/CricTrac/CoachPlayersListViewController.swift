//
//  CoachPlayersListViewController.swift
//  CricTrac
//
//  Created by AIPL on 30/08/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class CoachPlayersListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ThemeChangeable {
    
    
    @IBOutlet weak var CoachPlayersTableView: UITableView!
    
    let currentTheme = cricTracTheme.currentTheme
    
    var myPlayers = [String]()
    
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
                    self.playerNodeIdOthers.append(pendingReq["PlayerNodeIdOther"]! as! String)
                    self.coachNodeIds.append(pendingReq["CoachNodeID"]! as! String)
                    self.myPlayers.append(pendingReqs as! String)
                }
            }
            self.CoachPlayersTableView.reloadData()
        }
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
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPlayers.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCellWithIdentifier("FriendSuggestionsCell", forIndexPath: indexPath) as! FriendSuggestionsCell
        
        if myPlayers.count != 0 {
            let pendingReqId = myPlayers[indexPath.row]
            
            fetchBasicProfile(pendingReqId) { (result) in
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
        }
        
        aCell.backgroundColor = UIColor.clearColor()
        aCell.baseView.backgroundColor = currentTheme.bottomColor
        aCell.baseView.alpha = 1
        aCell.AddFriendBtn.setTitle("Remove", forState: .Normal)
        aCell.AddFriendBtn.setTitleColor(UIColor.redColor(), forState: .Normal)
        
        aCell.AddFriendBtn.accessibilityIdentifier = playerNodeIdOthers[indexPath.row]
        aCell.AddFriendBtn.restorationIdentifier = coachNodeIds[indexPath.row]
        aCell.AddFriendBtn.accessibilityValue = myPlayers[indexPath.row]
        
        aCell.AddFriendBtn.addTarget(self, action: #selector(CoachPlayersListViewController.removePlayer(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
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
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    
    
}