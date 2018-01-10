//
//  FollowerAndFollowingViewController.swift
//  CricTrac
//
//  Created by AIPL on 20/12/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import GoogleMobileAds


class FollowerAndFollowingViewController: UIViewController,IndicatorInfoProvider,ThemeChangeable,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var followingTableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerViewHeightConstraint: NSLayoutConstraint!
    
    var followingId = [String]()
    var followerId = [String]()
     var followerAndFollowingId = ""
    
    var followingNodeId = [String]()
    var followingNodeIdOther = [String]()
    
    let currentTheme = cricTracTheme.currentTheme

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        initializeView()
        loadBannerAds()
        //getFollowingAndFollowerList()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        getFollowingAndFollowerList()
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
        followingTableView.registerNib(UINib.init(nibName:"FriendsCell", bundle: nil), forCellReuseIdentifier: "FriendsCell")
        
        followingTableView.allowsSelection = false
        followingTableView.separatorStyle = .None
        followingTableView.dataSource = self
        followingTableView.delegate = self
        
    }
    
    
    func getFollowingAndFollowerList() {
        self.followingId.removeAll()
        self.followerId.removeAll()
        self.followingNodeId.removeAll()
        self.followingNodeIdOther.removeAll()
        
//        let myGroup = dispatch_group_create()
//        dispatch_group_enter(myGroup)


        getMyFollowingList { (data) in
            
            print(data)
             self.followingId.removeAll()
            self.followingNodeId.removeAll()
            self.followingNodeIdOther.removeAll()
            
            for(_,req) in data {
                let id = req["FollowingId"] as? String
                self.followingNodeId.append(req["FollowingNodeId"] as! String)
                self.followingNodeIdOther.append(req["FollowingNodeIdOther"] as! String)
                self.followingId.append(id!)
            }
           
        }
        
        getMyFollowersList{ (data) in
            // self.followerId.removeAll()
            for(_,req) in data {
                let id = req["FollowerId"] as? String
                
                self.followerId.append(id!)
            }
            self.followingTableView.reloadData()

            //dispatch_group_leave(myGroup)
        }
       // dispatch_group_notify(myGroup, dispatch_get_main_queue(), {
            
                   // })
    }
    
    override func viewWillAppear(animated: Bool) {
        setBackgroundColor()
    }
    
    func changeThemeSettigs() {
        self.view.backgroundColor = currentTheme.topColor
        self.followingTableView.backgroundColor = UIColor.clearColor()
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "FOLLOW")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && followingId.count != 0 {
            return "Following"
        }
        else if section == 1 && followerId.count != 0 {
           return "Followers"
        }
        return ""
    }
    
   
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clearColor()
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel!.textColor = UIColor.blackColor()
        header.textLabel!.font = UIFont(name: "SourceSansPro-Bold", size: 18)!
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return followingId.count
        }
        else {
            return followerId.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        if indexPath.section == 0 {
        return getCellForFollowingRow(indexPath)
        }
        else {
            return getCellForFollowingRow(indexPath)
        }
    }
    
    func getCellForFollowingRow(indexPath:NSIndexPath) -> FriendsCell {
       
        let aCell = followingTableView.dequeueReusableCellWithIdentifier("FriendsCell", forIndexPath: indexPath) as! FriendsCell
        
       var FollowingNodeId = ""
        var FollowingNodeIdOther = ""
        
        if indexPath.section == 0 {
            aCell.UnfriendBtn.hidden = false
            self.followerAndFollowingId = followingId[indexPath.row]
            FollowingNodeId = followingNodeId[indexPath.row]
            FollowingNodeIdOther = followingNodeIdOther[indexPath.row]
        }
        else {
            aCell.UnfriendBtn.hidden = true
            self.followerAndFollowingId = followerId[indexPath.row]
        }
        
        fetchBasicProfile(followerAndFollowingId, sucess: { (result) in
            let proPic = result["proPic"]
            let city =   result["city"]
            let userProfile = result["userProfile"]
            let playingRole = result["playingRole"]
            let followerName = "\(result["firstname"]!) \(result["lastname"]!)"
            
            aCell.FriendName.text = followerName
            
            aCell.FriendCity.text = city
            
            if userProfile == "Player" {
                aCell.friendRole.text = playingRole
            }
                
            else if userProfile == "Coach" {
                aCell.friendRole.text = "Coach"
            }
            else if userProfile == "Cricket Fan" {
                aCell.friendRole.text = "Cricket Fan"
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
            
         })
        aCell.baseView.alpha = 1
        aCell.baseView.backgroundColor = cricTracTheme.currentTheme.bottomColor
        aCell.backgroundColor = UIColor.clearColor()
        
            aCell.UnfriendBtn.setTitle("UNFOLLOW", forState: .Normal)
            aCell.UnfriendBtn.accessibilityIdentifier = followerAndFollowingId
            aCell.UnfriendBtn.accessibilityValue = FollowingNodeId
            aCell.UnfriendBtn.accessibilityHint = FollowingNodeIdOther
            aCell.UnfriendBtn.tag = indexPath.section
        
            aCell.UnfriendBtn.addTarget(self, action: #selector(unfollowBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
       
        //aCell.FollowBtn.hidden = true
        
        return aCell
    }
    
    func unfollowBtnPressed(sender: UIButton) {
        
        let followerId = sender.accessibilityIdentifier
        let followingNodeId = sender.accessibilityValue
        let followingNodeIdOther = sender.accessibilityHint
        
        
        let actionSheetController = UIAlertController(title: "", message: "Are you sure you want to Unfollow this user?", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
                // Just dismiss the action sheet
                actionSheetController.dismissViewControllerAnimated(true, completion: nil)
            }
            actionSheetController.addAction(cancelAction)
            
            let removeAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
                
                fireBaseRef.child("Users").child(followerId!).child("Followers").child(followingNodeIdOther!).removeValue()
                fireBaseRef.child("Users").child((currentUser?.uid)!).child("Following").child(followingNodeId!).removeValue()
                
                self.getFollowingAndFollowerList()
                
            }
        
            actionSheetController.addAction(removeAction)
            
            self.presentViewController(actionSheetController, animated: false, completion: nil)
      
        
    }
}
