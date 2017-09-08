//
//  PlayerCoachesListVC.swift
//  CricTrac
//
//  Created by AIPL on 08/09/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class PlayerCoachesListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,ThemeChangeable {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noCoachesLabel: UILabel!
    @IBOutlet weak var topBarView: UIView!
    
    let currentTheme = cricTracTheme.currentTheme
    
    var myCoaches = [String]()
    
    var coachNodeIdOthers = [String]()
    var playerNodeIds = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        reloadData()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        setBackgroundColor()
    }
    
    func initializeView() {
        tableView.registerNib(UINib.init(nibName: "FriendSuggestionsCell", bundle: nil), forCellReuseIdentifier: "FriendSuggestionsCell")
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .None
    }

    
    func reloadData() {
        myCoaches.removeAll()
        playerNodeIds.removeAll()
        coachNodeIdOthers.removeAll()
        
        getMyCoaches { (data) in
            for(_,req) in data {
                let acceptedData = req as! [String : AnyObject]
                let isAcceptVal = acceptedData["isAccepted"]!
                if isAcceptVal as! NSObject == 1 {
                    let acceptedIds = acceptedData["CoachID"]!
                    self.coachNodeIdOthers.append(acceptedData["CoachNodeIdOther"]! as! String)
                    self.playerNodeIds.append(acceptedData["PlayerNodeID"]! as! String)
                    self.myCoaches.append(acceptedIds as! String)
                }
            }
            self.tableView.reloadData()
        }
    }

    func changeThemeSettigs() {
        self.view.backgroundColor = currentTheme.topColor
        self.topBarView.backgroundColor = currentTheme.topColor
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if myCoaches.count == 0 {
            self.noCoachesLabel.text = "No Coaches"
        }
        else{
            self.noCoachesLabel.text = ""
        }
        return myCoaches.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCellWithIdentifier("FriendSuggestionsCell", forIndexPath: indexPath) as! FriendSuggestionsCell
    
        if myCoaches.count != 0 {
            let acceptedId = myCoaches[indexPath.row]
            
            fetchBasicProfile(acceptedId) { (result) in
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
        
        aCell.AddFriendBtn.accessibilityIdentifier = coachNodeIdOthers[indexPath.row]
        aCell.AddFriendBtn.restorationIdentifier = playerNodeIds[indexPath.row]
        aCell.AddFriendBtn.accessibilityValue = myCoaches[indexPath.row]
        
        aCell.AddFriendBtn.addTarget(self, action: #selector(PlayerCoachesListVC.removeCoach(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return aCell

    }
    
    func removeCoach(sender: UIButton){
        
        let coachNodeId = sender.accessibilityIdentifier
        let playerNodeId = sender.restorationIdentifier
        let coachId = sender.accessibilityValue
        
        let actionSheetController = UIAlertController(title: "", message: "Are you sure you want to Remove this Coach?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
            // Just dismiss the action sheet
            actionSheetController.dismissViewControllerAnimated(true, completion: nil)
        }
        actionSheetController.addAction(cancelAction)
        
        let removeAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
            
            fireBaseRef.child("Users").child(coachId!).child("MyPlayers").child(playerNodeId!).removeValue()
            
            fireBaseRef.child("Users").child((currentUser?.uid)!).child("MyCoaches").child(coachNodeId!).removeValue()
            
            self.reloadData()
        }
        actionSheetController.addAction(removeAction)
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        

    }
    
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
