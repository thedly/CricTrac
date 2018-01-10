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
    
    let currentTheme = cricTracTheme.currentTheme
    
     var followerId = [String]()
    
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
             self.followerId.removeAll()
            
            for(_,req) in data {
                let id = req["FollowerId"] as? String
                
                self.followerId.append(id!)
            }
            self.followersTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
            
            aCell.FriendName.text = followerName
            
            aCell.FriendCity.text = city
            
            if userProfile == "Player" {
                aCell.FriendRole.text = playingRole
            }
                
            else if userProfile == "Coach" {
                aCell.FriendRole.text = "Coach"
            }
            else if userProfile == "Cricket Fan" {
                aCell.FriendRole.text = "Cricket Fan"
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
                
//                let indexNub = self.followingId.indexOf(self.followerId[indexPath.row])
//                print(indexNub)
//                aCell.confirmBtn.accessibilityValue = self.followingNodeId[indexNub!]
//                aCell.confirmBtn.accessibilityHint = self.followingNodeIdOther[indexNub!]
                
            }
                
            else {
                
                aCell.confirmBtn.setTitle("FOLLOW", forState: .Normal)
                aCell.confirmBtn.userInteractionEnabled = true
                
                 aCell.confirmBtn.addTarget(self, action: #selector(self.followBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
                aCell.confirmBtn.accessibilityIdentifier = self.followerId[indexPath.row]
                aCell.confirmBtn.tag = indexPath.row
            }
            
        })
        
        aCell.rejectBtn.addTarget(self, action: #selector(self.blockButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        aCell.rejectBtn.accessibilityIdentifier = self.followerId[indexPath.row]
        aCell.rejectBtn.accessibilityValue = self.followingNodeId[indexPath.row]
        aCell.rejectBtn.accessibilityHint = self.followingNodeIdOther[indexPath.row]
        
        
        
        
        aCell.cancelBtn.hidden = true
        aCell.rejectBtn.setTitle("BLOCK", forState: .Normal)
       // aCell.confirmBtn.setTitle("FOLLOW", forState: .Normal)
        
        aCell.baseView.alpha = 1
        aCell.baseView.backgroundColor = cricTracTheme.currentTheme.bottomColor
        aCell.backgroundColor = UIColor.clearColor()
        
        
        return aCell
    }

    func followBtnPressed(sender: UIButton) {
        
        let indexP = NSIndexPath(forRow: sender.tag, inSection: 0)
        let cell = followersTableView.cellForRowAtIndexPath(indexP) as! FriendRequestsCell
        
        if followingId.contains(sender.accessibilityIdentifier!) {
            
        }
        else {
            createFollowingAndFollowers(sender.accessibilityIdentifier!)
            cell.confirmBtn.setTitle("FOLLOWING", forState: .Normal)
            cell.confirmBtn.userInteractionEnabled = false
            cell.confirmBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
        }
        
    }
    
    func blockButtonTapped(sender:UIButton) {
        
//        let indexP = NSIndexPath(forRow: sender.tag, inSection: 0)
//        let cell = followersTableView.cellForRowAtIndexPath(indexP) as! FriendRequestsCell
        
        let followerId = sender.accessibilityIdentifier
        let followerNodeId = sender.accessibilityHint
        let followerOtherNodeId = sender.accessibilityValue
        
        fireBaseRef.child("Users").child((currentUser?.uid)!).child("Followers").child(followerNodeId!).child("isBlocked").setValue(1)
        
        fireBaseRef.child("Users").child(followerId!).child("Following").child(followerOtherNodeId!).child("isBlocked").setValue(1)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
