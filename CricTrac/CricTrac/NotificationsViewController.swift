//
//  NotificationsViewController.swift
//  CricTrac
//
//  Created by Sajith Kumar on 29/04/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, ThemeChangeable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barView: UIView!
    
    var currentTheme:CTTheme!
    var dataSource = [[String:AnyObject]]()
    var NotificationID:String = ""

    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
       self.barView.backgroundColor = currentTheme.topColor
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    override func viewWillAppear(animated: Bool) {
       // setNavigationBarProperties()
        setBackgroundColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        
        getAllNotifications() { (data) in
            self.dataSource = data
            self.tableView.reloadData()
        }
        
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        self.barView.backgroundColor = currentTheme.topColor

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didMenuButtonTapp(){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    @IBAction func menuButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
  //  func setNavigationBarProperties(){
//        currentTheme = cricTracTheme.currentTheme
//        let menuButton: UIButton = UIButton(type:.Custom)
//        menuButton.setImage(UIImage(named: "menu-icon"), forState: UIControlState.Normal)
//        menuButton.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
//        menuButton.frame = CGRectMake(0, 0, 40, 40)
//        let leftbarButton = UIBarButtonItem(customView: menuButton)
//        
//        navigationItem.leftBarButtonItem = leftbarButton
//        self.view.backgroundColor =  currentTheme.topColor
//        navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
//        title = "NOTIFICATIONS"
// }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = dataSource[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("NotificationTableViewCell", forIndexPath: indexPath) as? NotificationTableViewCell {
            
            NotificationID = data["NotificationID"]! as! String
            let message = data["Message"] as? String
            let ownerId = data["FromID"] as? String
            let isRead = data["isRead"] as? Int
            var notificationDateTime = ""
            
            if let notiDateTS = data["AddedTimeDisp"] as? Double{
                let date = NSDate(timeIntervalSince1970:notiDateTS/1000.0)
                let date2 = NSDate(timeIntervalSince1970:notiDateTS/1000.0)
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeZone = NSTimeZone.localTimeZone()
                dateFormatter.timeStyle = .ShortStyle
                dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                
                let cmtDate = offsetFrom(date2)
                if cmtDate == "" {
                    notificationDateTime = dateFormatter.stringFromDate(date)
                }
                else {
                    notificationDateTime = cmtDate
                }
            }
            
            cell.menuIcon.layer.borderWidth = 1
            cell.menuIcon.layer.masksToBounds = false
            cell.menuIcon.layer.borderColor = UIColor.clearColor().CGColor
            cell.menuIcon.layer.cornerRadius = cell.menuIcon.frame.width/2
            cell.menuIcon.clipsToBounds = true
            cell.backgroundColor = UIColor.clearColor()
            
            fetchFriendDetail(ownerId!, sucess: { (result) in
                let proPic = result["proPic"]
                if proPic! == "-"{
                    let imageName = defaultProfileImage
                    let image = UIImage(named: imageName)
                    cell.menuIcon.image = image
                }else
                {
                    if let imageURL = NSURL(string:proPic!){
                        cell.menuIcon.kf_setImageWithURL(imageURL)
                    }
                }
            })
            
            cell.menuName.text = message! + "\n" + notificationDateTime
            
            if isRead == 0 {
                cell.backgroundColor = cricTracTheme.currentTheme.bottomColor
            }
            else {
                cell.backgroundColor = cricTracTheme.currentTheme.topColor
            }

           // cell.menuIcon.contentMode = UIViewContentMode.ScaleAspectFit;
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        return NotificationTableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.NotificationID = self.dataSource[indexPath.row]["NotificationID"]! as! String
        
        //on select, mark as Read
        markNotificationAsRead(self.NotificationID)
        
        let topic = self.dataSource[indexPath.row]["Topic"]! as! String
        let topicId = self.dataSource[indexPath.row]["TopicID"]! as! String
        let fromId = self.dataSource[indexPath.row]["FromID"]! as! String
        
        switch topic{
            case "FRR": self.moveToFRR(topicId)
            case "FRA": self.moveToFRA(topicId)
            case "NMA": self.moveToNMA(topicId, userId: fromId)
            case "NPA": self.moveToNPA(topicId)
            case "NCA": self.moveToNCA(topicId)
            case "NLA": self.moveToNLA(topicId)
            default: break
        }
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView,
                            editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let markRead = UITableViewRowAction(style: .Normal, title: "Mark as read") { action, index in
            self.NotificationID = self.dataSource[indexPath.row]["NotificationID"]! as! String
            markNotificationAsRead(self.NotificationID)
        }
        
        let delete = UITableViewRowAction(style: .Default, title: "Delete") { action, index in
            self.NotificationID = self.dataSource[indexPath.row]["NotificationID"]! as! String
            deleteNotification(self.NotificationID)
            
            if self.dataSource.count == 1 {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        let isRead = self.dataSource[indexPath.row]["isRead"] as? Int
        if isRead == 0 {
            return [delete, markRead]
        }
        else {
            return [delete]
        }
    }
    
    func moveToFRR(topicId:String) {
        let friendRequest = viewControllerFrom("Main", vcid: "FriendBaseViewController") as! FriendBaseViewController
        friendRequest.topicId = topicId
        //friendRequest.topic = "FRR"
       // self.navigationController?.pushViewController(friendRequest, animated: true)
          self.presentViewController(friendRequest, animated: true) {}
    }
    
    func moveToFRA(topicId:String) {
        let friendRequest = viewControllerFrom("Main", vcid: "FriendBaseViewController") as! FriendBaseViewController
        friendRequest.topicId = topicId
        self.presentViewController(friendRequest, animated: true) {}
    }
    
    func moveToNMA(topicId:String, userId:String) {
        let matchId:String = topicId
        let userId:String = userId
        
        fireBaseRef.child("Users").child(userId).child("Matches").child(matchId).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let data = snapshot.value! as? [String:AnyObject]{
                let summaryDetailsVC = viewControllerFrom("Main", vcid: "SummaryMatchDetailsViewController") as! SummaryMatchDetailsViewController
                summaryDetailsVC.matchDetailsData = data
                summaryDetailsVC.isFriendDashboard = true
                //if let _ = self.friendProfile {
                  //  summaryDetailsVC.friendProfile = true
                    self.presentViewController(summaryDetailsVC, animated: true, completion: nil)
                //}
                //else {
                //    self.navigationController?.pushViewController(summaryDetailsVC, animated: true)
                //}
            }
        })
    }
    
    func moveToNPA(topicId:String) {
        let timelinePost = viewControllerFrom("Main", vcid: "CommentsViewController") as! CommentsViewController
        timelinePost.postId = topicId
        self.presentViewController(timelinePost, animated: true) {}
    }
    
    func moveToNCA(topicId:String) {
        let timelinePost = viewControllerFrom("Main", vcid: "CommentsViewController") as! CommentsViewController
        timelinePost.postId = topicId
        self.presentViewController(timelinePost, animated: true) {}
    }
    
    func moveToNLA(topicId:String) {
        let timelinePost = viewControllerFrom("Main", vcid: "CommentsViewController") as! CommentsViewController
        timelinePost.postId = topicId
        self.presentViewController(timelinePost, animated: true) {}
    }

    func offsetFrom(date:NSDate) -> String {
        let now = NSDate()
        
        let dayHourMinuteSecond: NSCalendarUnit = [.Day, .Hour, .Minute, .Second]
        let difference = NSCalendar.currentCalendar().components(dayHourMinuteSecond, fromDate: date, toDate: now, options: [])
        
        //        let seconds = "\(difference.second)s"
        //        let minutes = "\(difference.minute)m" + " " + seconds
        //        let hours = "\(difference.hour)h" + " " + minutes
        //        let days = "\(difference.day)d" + " " + hours
        
        if difference.day == 1 {
            return "\(difference.day) day ago"
        }
        else if difference.day < 1 && difference.hour == 1 {
            return "\(difference.hour) hour ago"
        }
        else if difference.day < 1 && difference.hour > 1 && difference.hour < 24 {
            return "\(difference.hour) hours ago"
        }
        else if difference.day < 1 && difference.hour < 1 && difference.minute == 1 {
            return "\(difference.minute) minute ago"
        }
        else if difference.day < 1 && difference.hour < 1 && difference.minute > 1 && difference.minute < 60 {
            return "\(difference.minute) minutes ago"
        }
        else if difference.day < 1 && difference.hour < 1 && difference.minute < 1 && difference.second == 1 {
            return "\(difference.second) second ago"
        }
        else if difference.day < 1 && difference.hour < 1 && difference.minute < 1 && difference.second > 1 && difference.second < 60 {
            return "\(difference.second) seconds ago"
        }
        else {
            return ""
        }
        
        //        if difference.day    > 0 { return days }
        //        if difference.hour   > 0 { return hours }
        //        if difference.minute > 0 { return minutes }
        //        if difference.second > 0 { return seconds }
        //        return ""
    }

    
}