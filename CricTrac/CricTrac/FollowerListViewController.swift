//
//  FollowerListViewController.swift
//  CricTrac
//
//  Created by Arjun Innovations on 09/01/18.
//  Copyright © 2018 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import GoogleMobileAds

class FollowerListViewController: UIViewController,IndicatorInfoProvider,ThemeChangeable,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var followersTableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noFollowersListLabel: UILabel!
    
    let currentTheme = cricTracTheme.currentTheme
    
     var followerId = [String]()
    
    var followingId = [String]()
    
    var followerNodeId = [String]()
    var followerNodeIdOther = [String]()
    var blockedList = [Int]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        initializeView()
        loadBannerAds()
        
        // Do any additional setup after loading the view.
    }
    
    func loadBannerAds() {
        if showAds == "1" {
            self.bannerViewHeightConstraint.constant = 50
            bannerView.adUnitID = adUnitId
            bannerView.rootViewController = self
            bannerView.loadRequest(GADRequest())
        }
        else {
            self.bannerViewHeightConstraint.constant = 0
        }
    }
    
    func initializeView() {
        followersTableView.registerNib(UINib.init(nibName:"FriendRequestsCell", bundle: nil), forCellReuseIdentifier: "FriendRequestsCell")
        
        followersTableView.allowsSelection = false
        followersTableView.separatorStyle = .None
        followersTableView.dataSource = self
        followersTableView.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        setBackgroundColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        getFollowersList()
    }
    
    func changeThemeSettigs() {
        self.view.backgroundColor = cricTracTheme.currentTheme.topColor
        self.followersTableView.backgroundColor = UIColor.clearColor()
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "FOLLOWERS")
    }
    
    func getFollowersList() {
        
        getMyFollowingList { (data) in
            
            self.followingId.removeAll()
            
            
            for(_,req) in data {
                let id = req["FollowingId"] as? String
                self.followingId.append(id!)
            }
        }

        getMyFollowersList{ (data) in
             self.followerId.removeAll()
            self.followerNodeId.removeAll()
            self.followerNodeIdOther.removeAll()
            self.blockedList.removeAll()
            
            for(_,req) in data {
                let id = req["FollowerId"] as? String
                
                self.followerId.append(id!)
                self.followerNodeId.append(req["FollowerNodeId"] as! String)
                self.followerNodeIdOther.append(req["FollowerNodeIdOther"] as! String)
                self.blockedList.append(req["isBlocked"] as! Int)
                
            }
            
            self.followersTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if followerId.count == 0 {
            self.noFollowersListLabel.text = "You don't have any followers. \nWhen someone follows you, you will see them here."
            noFollowersListLabel.hidden = false
        }
        else {
            
            noFollowersListLabel.hidden = true
        }
        
        return followerId.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let aCell = followersTableView.dequeueReusableCellWithIdentifier("FriendRequestsCell", forIndexPath: indexPath) as! FriendRequestsCell
        aCell.friendId = followerId[indexPath.row]
        
        fetchBasicProfile(followerId[indexPath.row], sucess: { (result) in
            let proPic = result["proPic"]
            let city =   result["city"]
            let userProfile = result["userProfile"]
            let playingRole = result["playingRole"]
            let followerName = "\(result["firstname"]!) \(result["lastname"]!)"
            let celebrity = result["celebrity"]
            
            aCell.FriendName.text = followerName
            
            aCell.FriendCity.text = city
            
            if celebrity != "-" {
                aCell.FriendRole.text = celebrity
            }
            else {
                if userProfile == "Player" {
                    aCell.FriendRole.text = playingRole
                }
                    
                else if userProfile == "Coach" {
                    aCell.FriendRole.text = "Coach"
                }
                else if userProfile == "Cricket Fan" {
                    aCell.FriendRole.text = "Cricket Fan"
                }
            }
            
            if proPic! == "-"{
                let imageName = defaultProfileImage
                let image = UIImage(named: imageName)
                aCell.FriendProfileImage.image = image
            }else{
                if let imageURL = NSURL(string:proPic!){
                    aCell.FriendProfileImage.kf_setImageWithURL(imageURL)
                }
            }
            
            if self.followingId.contains(self.followerId[indexPath.row]) {
               
                aCell.confirmBtn.setTitle("FOLLOWING", forState: .Normal)
                aCell.confirmBtn.userInteractionEnabled = false
                aCell.confirmBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)

            }
                
            else {
                
                aCell.confirmBtn.setTitle("FOLLOW", forState: .Normal)
                aCell.confirmBtn.userInteractionEnabled = true
                
                aCell.confirmBtn.setTitleColor(UIColor(red: 104/255, green: 187/255, blue: 2/255, alpha: 1.0), forState: .Normal)
                
                 aCell.confirmBtn.addTarget(self, action: #selector(self.followBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
                aCell.confirmBtn.accessibilityIdentifier = self.followerId[indexPath.row]
                aCell.confirmBtn.tag = indexPath.row
            }
            
            if self.blockedList[indexPath.row] == 0 {
               
                aCell.rejectBtn.addTarget(self, action: #selector(self.blockButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
 
                aCell.rejectBtn.setTitle("BLOCK", forState: .Normal)
                aCell.rejectBtn.restorationIdentifier = "BLOCK"
                //aCell.rejectBtn.tag = indexPath.row

            }
                
            else {
                
                aCell.rejectBtn.addTarget(self, action: #selector(self.unBlockBtnTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//
                
                aCell.rejectBtn.setTitle("UNBLOCK", forState: .Normal)
                aCell.rejectBtn.restorationIdentifier = "UNBLOCK"
                aCell.rejectBtn.setTitleColor(UIColor(red: 34/255, green: 54/255, blue: 221/255, alpha: 1.0), forState: .Normal)
                //aCell.rejectBtn.tag = indexPath.row

            }
            
        })
        
        aCell.rejectBtn.accessibilityIdentifier = self.followerId[indexPath.row]
        aCell.rejectBtn.accessibilityValue = self.followerNodeId[indexPath.row]
        aCell.rejectBtn.accessibilityHint = self.followerNodeIdOther[indexPath.row]
        
        aCell.cancelBtn.hidden = true
       // aCell.confirmBtn.setTitle("FOLLOW", forState: .Normal)
        
        aCell.baseView.alpha = 1
        aCell.baseView.backgroundColor = cricTracTheme.currentTheme.bottomColor
        aCell.backgroundColor = UIColor.clearColor()
        
        
        return aCell
    }

    func followBtnPressed(sender: UIButton) {
        
        let indexP = NSIndexPath(forRow: sender.tag, inSection: 0)
        let cell = followersTableView.cellForRowAtIndexPath(indexP) as! FriendRequestsCell
        
        if !followingId.contains(sender.accessibilityIdentifier!) {
            
            createFollowingAndFollowers(sender.accessibilityIdentifier!)
            cell.confirmBtn.setTitle("FOLLOWING", forState: .Normal)
            cell.confirmBtn.userInteractionEnabled = false
            cell.confirmBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
            
            //call the follow notification api
            followNotification(sender.accessibilityIdentifier!)
        }
        
    }
    
    func blockButtonTapped(sender:UIButton) {
 
    if sender.restorationIdentifier == "BLOCK" {
        
            let actionSheetController = UIAlertController(title: "", message: "Are you sure you want to Block this user?", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
                // Just dismiss the action sheet
                actionSheetController.dismissViewControllerAnimated(true, completion: nil)
            }
            actionSheetController.addAction(cancelAction)
            
            let removeAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
                
                let followerId = sender.accessibilityIdentifier
                let followerNodeId = sender.accessibilityValue
                let followerOtherNodeId = sender.accessibilityHint
                
            
            fireBaseRef.child("Users").child((currentUser?.uid)!).child("Followers").child(followerNodeId!).child("isBlocked").setValue(1)
                
            fireBaseRef.child("Users").child(followerId!).child("Following").child(followerOtherNodeId!).child("isBlocked").setValue(1)
                
                self.getFollowersList()
                
            }
            
            actionSheetController.addAction(removeAction)
            
            self.presentViewController(actionSheetController, animated: false, completion: nil)
      }
      
    }
    
    func unBlockBtnTapped(sender: UIButton) {
    
        if sender.restorationIdentifier == "UNBLOCK" {
            let actionSheetController = UIAlertController(title: "", message: "Are you sure you want to Unblock this user?", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
                // Just dismiss the action sheet
                actionSheetController.dismissViewControllerAnimated(true, completion: nil)
            }
            actionSheetController.addAction(cancelAction)
            
            let removeAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
                
                let followerId = sender.accessibilityIdentifier
                let followerNodeId = sender.accessibilityValue
                let followerOtherNodeId = sender.accessibilityHint
                
                fireBaseRef.child("Users").child((currentUser?.uid)!).child("Followers").child(followerNodeId!).child("isBlocked").setValue(0)
                
                fireBaseRef.child("Users").child(followerId!).child("Following").child(followerOtherNodeId!).child("isBlocked").setValue(0)
                
                 self.getFollowersList()
            }
            
            actionSheetController.addAction(removeAction)
            
            self.presentViewController(actionSheetController, animated: false, completion: nil)
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
