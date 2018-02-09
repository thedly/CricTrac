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
    
    @IBOutlet weak var sortedByAgeHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sortedByAgeLbl: UILabel!
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
    
    var followingIds = [String]()
    var followingNodeId = [String]()
    var followingNodeIdOther = [String]()
    
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
        
        getMyPlayersSplit(friendID,playingRole: playingRole) { (data) in
            self.myPlayers = data
            self.CoachPlayersTableView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(animated)
        //let currentTheme = cricTracTheme.currentTheme
       // self.view.backgroundColor = currentTheme.topColor
        setBackgroundColor()
        setNavigationProperties()
        self.sortedByAgeLbl.text = "Sorted by Age"
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
        setPlainShadow(topBarView, color: currentTheme.bottomColor.CGColor)
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
            topBarViewHeightConstraint.constant = 0
           // title = "MY PLAYERS"
        }
    }
    
    func deletebuttonTapped() {
        
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
            //let city =   playerData["City"]! as! String
            let name = "\(playerData["FirstName"]!) \(playerData["LastName"]!)"
            let userProfile = playerData["UserProfile"]! as! String
            let playingRole = playerData["PlayingRole"]! as! String
            
            //aCell.userCity.text = city
            aCell.userName.text = name
            //aCell.userCity.text = playerData["DOB"]! as? String
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
            
            //calculating age
            let  dob = playerData["DOB"]! as? String
            let dateFormater = NSDateFormatter()
            dateFormater.dateFormat = "dd-MM-yyyy"
            let birthdayDate = dateFormater.dateFromString(dob!)
            
            let date = NSDate()
            let calender:NSCalendar  = NSCalendar.currentCalendar()
            
            let currentMonth = calender.component(.Month, fromDate: date)
            let birthmonth = calender.component(.Month, fromDate: birthdayDate!)
            var years = calender.component(.Year, fromDate: date) - calender.component(.Year, fromDate: birthdayDate!)
            var months = currentMonth - birthmonth
            
            if months < 0 {
                years = years - 1
                months = 12 - birthmonth + currentMonth
                if calender.component(.Day, fromDate: date) < calender.component(.Day, fromDate: birthdayDate!){
                    months = months - 1
                }
            }
            else if months == 0 && calender.component(.Day, fromDate: date) < calender.component(.Day, fromDate: birthdayDate!)
            {
                years = years - 1
                months = 11
            }
            let ageString = "\(years)y \(months)m)"
            let playerDOB = playerData["DOB"]! as? String
            
            let formattedString = NSMutableAttributedString()
            let citytext = formattedString.normal("\(playerDOB!)", fontName: appFont_regular, fontSize: 13).normal("  (Age:\(ageString)", fontName: appFont_regular, fontSize: 13)
            
            
            aCell.userCity.attributedText = citytext
            
            playerReqId = playerData["playerId"]! as! String
            coachNodeId = playerData["playerNodeIdOther"]! as! String
            playerNodeIdOther = playerData["coachNodeId"]! as! String
            
//                if followingIds.contains(playerData["playerId"]! as! String) {
//                    
//                    aCell.FollowBtn.setTitle("FOLLOWING", forState: .Normal)
//                    let indexNub = followingIds.indexOf(playerData["playerId"]! as! String)
//                    print(indexNub)
//                    aCell.FollowBtn.accessibilityValue = followingNodeId[indexNub!]
//                    aCell.FollowBtn.accessibilityHint = followingNodeIdOther[indexNub!]
//                    aCell.FollowBtn.accessibilityLabel = aCell.FollowBtn.titleLabel?.text
//                    aCell.FollowBtn.userInteractionEnabled = false
//                    aCell.FollowBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
//                    // aCell.FollowBtn.alpha = 0.2
//                    
//                }
//                    
//                else {
//                    aCell.FollowBtn.setTitle("FOLLOW", forState: .Normal)
//                    aCell.FollowBtn.userInteractionEnabled = true
//                    aCell.FollowBtn.alpha = 1
//                    // aCell.FollowBtn.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
//                    aCell.FollowBtn.setTitleColor(UIColor(red: 104/255, green: 187/255, blue: 2/255, alpha: 1.0), forState: .Normal)
//                    
//                    aCell.FollowBtn.accessibilityLabel = aCell.FollowBtn.titleLabel?.text
//                    
//                    aCell.FollowBtn.addTarget(self, action: #selector(followBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//                }
//                
//                aCell.FollowBtn.accessibilityIdentifier = playerData["playerId"]! as? String
//                aCell.FollowBtn.tag = indexPath.row
            

            
//                aCell.friendId = playerReqId
//                aCell.AddFriendBtn.accessibilityIdentifier = coachNodeId
//                aCell.AddFriendBtn.restorationIdentifier = playerNodeIdOther
//                aCell.AddFriendBtn.accessibilityValue = playerReqId
//                aCell.AddFriendBtn.setTitle("REMOVE", forState: .Normal)
//                aCell.AddFriendBtn.setTitleColor(UIColor(red: 0.76, green: 0.18, blue: 0.25, alpha: 1.0), forState: .Normal)
//                aCell.AddFriendBtn.titleLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 12)
//                
//                aCell.AddFriendBtn.addTarget(self, action: #selector(CoachPlayersListViewController.removePlayer(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            aCell.friendId = playerReqId
            aCell.FollowBtn.accessibilityIdentifier = coachNodeId
            aCell.FollowBtn.restorationIdentifier = playerNodeIdOther
            aCell.FollowBtn.accessibilityValue = playerReqId
            aCell.FollowBtn.setTitle("REMOVE", forState: .Normal)
            aCell.FollowBtn.setTitleColor(UIColor(red: 0.76, green: 0.18, blue: 0.25, alpha: 1.0), forState: .Normal)
            aCell.FollowBtn.titleLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 12)
            
            aCell.FollowBtn.addTarget(self, action: #selector(CoachPlayersListViewController.removePlayer(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            aCell.backgroundColor = UIColor.clearColor()
            aCell.baseView.backgroundColor = currentTheme.bottomColor
            aCell.baseView.alpha = 1
            CoachPlayersTableView.backgroundColor = currentTheme.topColor
        }
         return aCell
    }
    
    // sravani - mark for follow
    
//    func followBtnPressed(sender: UIButton) {
//        
//        let indexP = NSIndexPath(forRow: sender.tag, inSection: 0)
//        let cell = CoachPlayersTableView.cellForRowAtIndexPath(indexP) as! FriendSuggestionsCell
//        
//        let newStr = sender.accessibilityLabel
//        if newStr == "FOLLOW" {
//            createFollowingAndFollowers(sender.accessibilityIdentifier!)
//            cell.FollowBtn.setTitle("FOLLOWING", forState: .Normal)
//            cell.FollowBtn.userInteractionEnabled = false
//            cell.FollowBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
//            //cell.FollowBtn.alpha = 0.2
//            
//        }
//        
//    }
    
    
    func removePlayer(sender:UIButton) {
        
//        let coachNodeId = sender.restorationIdentifier
//        let playerNodeId = sender.accessibilityIdentifier
        let playerNodeId = sender.restorationIdentifier
        let coachNodeId = sender.accessibilityIdentifier

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
