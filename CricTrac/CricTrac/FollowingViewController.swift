//
//  FollowingViewController.swift
//  CricTrac
//
//  Created by Arjun Innovations on 09/01/18.
//  Copyright © 2018 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import GoogleMobileAds

class FollowingViewController: UIViewController,IndicatorInfoProvider,ThemeChangeable,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var followingTableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerViewHeightConstraint: NSLayoutConstraint!
    
    let currentTheme = cricTracTheme.currentTheme
    
     var followingId = [String]()
     var followingNodeId = [String]()
     var followingNodeIdOther = [String]()


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
        followingTableView.registerNib(UINib.init(nibName:"FriendsCell", bundle: nil), forCellReuseIdentifier: "FriendsCell")
        
        followingTableView.allowsSelection = false
        followingTableView.separatorStyle = .None
        followingTableView.dataSource = self
        followingTableView.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        setBackgroundColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        getFollowingList()
    }
    
    func changeThemeSettigs() {
        self.view.backgroundColor = cricTracTheme.currentTheme.topColor
        self.followingTableView.backgroundColor = UIColor.clearColor()
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "FOLLOWING")
    }
    
    func getFollowingList() {
        
        getMyFollowingList { (data) in
            
            self.followingId.removeAll()
            self.followingNodeId.removeAll()
            self.followingNodeIdOther.removeAll()
            
            for(_,req) in data {
                let id = req["FollowingId"] as? String
                self.followingNodeId.append(req["FollowingNodeId"] as! String)
                self.followingNodeIdOther.append(req["FollowingNodeIdOther"] as! String)
                self.followingId.append(id!)
            }
            self.followingTableView.reloadData()
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return followingId.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let aCell = followingTableView.dequeueReusableCellWithIdentifier("FriendsCell", forIndexPath: indexPath) as! FriendsCell
        aCell.friendId = followingId[indexPath.row]
        
        fetchBasicProfile(followingId[indexPath.row], sucess: { (result) in
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
        aCell.UnfriendBtn.accessibilityIdentifier = followingId[indexPath.row]
        aCell.UnfriendBtn.accessibilityValue = followingNodeId[indexPath.row]
        aCell.UnfriendBtn.accessibilityHint = followingNodeIdOther[indexPath.row]
        
        aCell.UnfriendBtn.addTarget(self, action: #selector(unfollowBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        
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
            
            self.getFollowingList()
            
        }
        
        actionSheetController.addAction(removeAction)
        
        self.presentViewController(actionSheetController, animated: false, completion: nil)
        
        
    }


    

}
