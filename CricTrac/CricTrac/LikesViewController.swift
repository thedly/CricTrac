//
//  LikesViewController.swift
//  CricTrac
//
//  Created by AIPL on 03/05/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit
import GoogleMobileAds


class LikesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ThemeChangeable,DeleteComment {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var bannerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var currentTheme:CTTheme!
    var postID: String = ""
     var dataSource = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllLikes(postID) { (data) in
           self.dataSource = data
             self.tableView.reloadData()
        }
        self.setBackgroundColor()
       
       loadBannerAds()
        tableView.tableFooterView = UIView()
      
    }
    override func viewWillAppear(animated: Bool) {
        setBackgroundColor()
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
    func deletebuttonTapped() {
        //lines
    }
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        self.barView.backgroundColor =  currentTheme.topColor
        setPlainShadow(barView, color: currentTheme.bottomColor.CGColor)
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
        func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
            return 5
        }
    
        func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
            let aView = UIView()
            aView.backgroundColor = UIColor.clearColor()
            return aView
        }


//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        
//        let aView = UIView(frame: CGRectMake(0, 0, view.frame.width, 0) )
//        aView.backgroundColor = UIColor.clearColor()
//        
//        return aView
//    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = dataSource[indexPath.section]

        let cell = tableView.dequeueReusableCellWithIdentifier("LikesTableViewCell", forIndexPath:
            indexPath) as! LikesTableViewCell
        
        cell.name.text = data["OwnerName"] as? String
        let friendUserId = data["OwnerID"] as? String
        cell.parent = self
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.clearColor().CGColor
        
        cell.friendUserId = friendUserId!
        
        cell.userImage.layer.borderWidth = 1
        cell.userImage.layer.masksToBounds = false
        cell.userImage.layer.borderColor = UIColor.clearColor().CGColor
        cell.userImage.layer.cornerRadius = cell.userImage.frame.width/2
        cell.userImage.clipsToBounds = true
        
        fetchFriendDetail(friendUserId!, sucess: { (result) in
            let proPic = result["proPic"]
            let city = result["city"]
            cell.city.text = city
            
            if proPic! == "-"{
                let imageName = defaultProfileImage
                let image = UIImage(named: imageName)
                cell.userImage.image = image
            }else{
                if let imageURL = NSURL(string:proPic!){
                   cell.userImage.kf_setImageWithURL(imageURL)
                }
            }
        })
       
        cell.friendButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        //check if user record exist in Friends
        let ref1 = fireBaseRef.child("Users").child(currentUser!.uid).child("Friends")
        ref1.queryOrderedByChild("UserId").queryEqualToValue(friendUserId).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if snapshot.childrenCount > 0 {
                cell.friendButton.setTitle("Friend", forState: .Normal)
                cell.friendButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            }
        })
        
        //check if user record exist in SentRequest
        let ref2 = fireBaseRef.child("Users").child(currentUser!.uid).child("SentRequest")
        ref2.queryOrderedByChild("SentTo").queryEqualToValue(friendUserId).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if snapshot.childrenCount > 0 {
                cell.friendButton.setTitle("Pending", forState: .Normal)
                cell.friendButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            }
        })
        
        //check if user record exist in ReceivedRequest
        let ref3 = fireBaseRef.child("Users").child(currentUser!.uid).child("ReceivedRequest")
        ref3.queryOrderedByChild("ReceivedFrom").queryEqualToValue(friendUserId).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if snapshot.childrenCount > 0 {
                cell.friendButton.setTitle("Pending", forState: .Normal)
               cell.friendButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            }
        })
        
        //hide friend button for self
        if friendUserId == currentUser?.uid {
            cell.friendButton.hidden = true
        }
       
        cell.selectionStyle = UITableViewCellSelectionStyle.None
       
        let currentTheme = cricTracTheme.currentTheme
        cell.contentView.backgroundColor = currentTheme.bottomColor
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }

}
