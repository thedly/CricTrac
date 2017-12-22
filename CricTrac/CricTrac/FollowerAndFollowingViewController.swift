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

    
    let currentTheme = cricTracTheme.currentTheme

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        initializeView()
        loadBannerAds()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        getFollowingList()
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
    
    
    func getFollowingList() {
        self.followingId.removeAll()
        self.followerId.removeAll()
        
        let myGroup = dispatch_group_create()
        dispatch_group_enter(myGroup)


        getMyFollowingList { (data) in
            
            print(data)
            for(_,req) in data {
                let id = req["FollowingId"] as? String
                self.followingId.append(id!)
            }
           
        }
        getMyFollowersList{ (data) in
            
            for(_,req) in data {
                let id = req["FollowerId"] as? String
                self.followerId.append(id!)
            }
            dispatch_group_leave(myGroup)
        }
        dispatch_group_notify(myGroup, dispatch_get_main_queue(), {
            
            self.followingTableView.reloadData()
        })
    }
    
    func getFollowerList() {
        self.followerId.removeAll()
        
        getMyFollowersList{ (data) in
          
            for(_,req) in data {
                    let id = req["FollowerId"] as? String
                    self.followerId.append(id!)
            }
        }
        dispatch_async(dispatch_get_main_queue(),{
            
            self.followingTableView.reloadData()
        })
        
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
        
        if indexPath.section == 0 {
            self.followerAndFollowingId = followingId[indexPath.row]
        }
        else {
            self.followerAndFollowingId = followerId[indexPath.row]
        }
        
        let aCell = followingTableView.dequeueReusableCellWithIdentifier("FriendsCell", forIndexPath: indexPath) as! FriendsCell
        
        
        fetchBasicProfile(followerAndFollowingId, sucess: { (result) in
            let proPic = result["proPic"]
            let city =   result["city"]
            let userProfile = result["userProfile"]
            let playingRole = result["playingRole"]
            let name = "\(result["firstname"]!) \(result["lastname"]!)"
            
            aCell.FriendName.text = name
            
            
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
        //aCell.FollowBtn.hidden = true
        
        return aCell
    }
}
