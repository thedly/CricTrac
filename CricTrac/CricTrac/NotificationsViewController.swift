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
    
    var currentTheme:CTTheme!
    var dataSource = [[String:AnyObject]]()
    var notificationId:String = ""

    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    override func viewWillAppear(animated: Bool) {
        setNavigationBarProperties()
        setBackgroundColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        
        getAllNotifications() { (data) in
            self.dataSource = data
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didMenuButtonTapp(){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    func setNavigationBarProperties(){
        currentTheme = cricTracTheme.currentTheme
        let menuButton: UIButton = UIButton(type:.Custom)
        menuButton.setImage(UIImage(named: "menu-icon"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        
        navigationItem.leftBarButtonItem = leftbarButton
        self.view.backgroundColor =  currentTheme.topColor
        navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
        title = "NOTIFICATIONS"
    }
    
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
        if let cell = tableView.dequeueReusableCellWithIdentifier("SliderMenuViewCell", forIndexPath: indexPath) as? SliderMenuViewCell {
            notificationId = data["notificationId"]! as! String
            let message = data["Message"] as? String
            let ownerId = data["FromID"] as? String
            
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
            
            cell.menuIcon.frame.size.width = 30
            cell.menuIcon.frame.size.height = 30
            cell.menuIcon.layer.borderWidth = 1
            cell.menuIcon.layer.masksToBounds = false
            cell.menuIcon.layer.borderColor = UIColor.clearColor().CGColor
            cell.menuIcon.layer.cornerRadius = cell.menuIcon.frame.width/2
            cell.menuIcon.clipsToBounds = true

            cell.menuName.text = message

            cell.menuIcon.contentMode = UIViewContentMode.ScaleAspectFit;

            return cell
        }
        return SliderMenuViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.notificationId = self.dataSource[indexPath.row]["notificationId"]! as! String
        let topic = self.dataSource[indexPath.row]["Topic"]! as! String
        let topicId = self.dataSource[indexPath.row]["TopicID"]! as! String
        let fromId = self.dataSource[indexPath.row]["FromID"]! as! String
        
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView,
                            editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let markRead = UITableViewRowAction(style: .Normal, title: "Mark as read") { action, index in
            self.notificationId = self.dataSource[indexPath.row]["notificationId"]! as! String
            //print("hide")
            markNotificationAsRead(self.notificationId)
        }
        
        let delete = UITableViewRowAction(style: .Default, title: "Delete") { action, index in
            self.notificationId = self.dataSource[indexPath.row]["notificationId"]! as! String
            deleteNotification(self.notificationId)
        }
        
        return [delete, markRead]
    }

    
}